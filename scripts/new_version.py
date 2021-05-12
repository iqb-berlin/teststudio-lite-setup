#!/usr/bin/python3
"""Update and create new tagged version.

This script does (in order):
- (check if git master branch is checked out and up to date)
- update git submodules
- extract version strings of components (submodules)
- update docker-compose files with new version strings
- git:
    - create commit with updated submodules and compose files
    - create tag with updated versions
      (in form: <frontend_version>@<backend_version>>)
    - push commit and tag

The path to the necessary files and the regex to extract the version string
can be updated easily using the constant variables on top the script.

Author: Richard Henck
Email: richard.henck@iqb.hu-berlin.de
"""

import sys
import subprocess
import re
import os
import tarfile

DIST_PACKAGE_NAME = 'teststudio-lite'

BACKEND_VERSION_FILE_PATH = 'teststudio-lite-backend/VERSION'
BACKEND_VERSION_REGEX = '[^\n\r].*'
FRONTEND_VERSION_FILE_PATH = 'teststudio-lite-frontend/package.json'
FRONTEND_VERSION_REGEX = '(?<=version": ")(.*)(?=")'

COMPOSE_FILE_PATHS = ['docker-compose.prod.yml']

backend_version = ''
frontend_version = ''


def check_prerequisites():
    """Check a couple of things to make sure one is ready to commit."""
    # on branch master?
    result = subprocess.run("git rev-parse --abbrev-ref HEAD",
                            text=True, shell=True, check=True, capture_output=True)
    if result.stdout.rstrip() != 'master':
        sys.exit('ERROR: Not on master branch!')
    # pulled?
    result = subprocess.run("git fetch origin --dry-run",
                            text=True, shell=True, check=True, capture_output=True)
    if result.stderr.rstrip() != '':
        sys.exit('ERROR: Not up to date with remote branch!')


def update_submodules():
    subprocess.run('make update-submodules', shell=True, check=True)


def get_version_from_file(file_path, regex):
    pattern = re.compile(regex)
    with open(file_path, 'r') as f:
        match = pattern.search(f.read())
        if match:
            return match.group()
        else:
            sys.exit('Version pattern not found in file. Check your regex!')


def update_compose_file_versions(backend_version, frontend_version):
    backend_pattern = re.compile('(?<=iqbberlin\\/teststudio-lite-backend:)(.*)')
    frontend_pattern = re.compile('(?<=iqbberlin\\/teststudio-lite-frontend:)(.*)')
    for compose_file in COMPOSE_FILE_PATHS:
        with open(compose_file, 'r') as f:
            file_content = f.read()
        new_file_content = backend_pattern.sub(backend_version, file_content)
        new_file_content = frontend_pattern.sub(frontend_version, new_file_content)
        with open(compose_file, 'w') as f:
            f.write(new_file_content)


def run_tests():
    """Run end to end tests via make target."""
    subprocess.run('make test-e2e', shell=True, check=True)


def git_tag_commit_and_push(backend_version, frontend_version):
    """Add updated compose files and submodules hashes and commit them to repo."""
    new_version_string = f"{frontend_version}@{backend_version}"
    print(f"Creating git tag for version {new_version_string}")
    subprocess.run("git add teststudio-lite-backend", shell=True, check=True)
    subprocess.run("git add teststudio-lite-frontend", shell=True, check=True)
    # remove old release package from git
    subprocess.run("git ls-files --deleted | xargs git add", shell=True, check=True)
    # Add files to commit: compose files and release package
    for compose_file in COMPOSE_FILE_PATHS:
        subprocess.run(f"git add {compose_file}", shell=True, check=True)
    subprocess.run("git add dist/*", shell=True, check=True)

    subprocess.run(f"git commit -m \"Update version to {new_version_string}\"", shell=True, check=True)
    subprocess.run("git push origin master", shell=True, check=True)

    subprocess.run(f"git tag {new_version_string}", shell=True, check=True)
    subprocess.run(f"git push origin {new_version_string}", shell=True, check=True)


def create_release_package(backend_version, frontend_version):
    """Create dist tar file from compose files, config and makefile template."""
    subprocess.run('rm -rf dist/*', shell=True, check=True)
    subprocess.run('cp -r config dist/config', shell=True, check=True)
    subprocess.run('cp docker-compose.yml dist/docker-compose.yml', shell=True, check=True)
    subprocess.run('cp docker-compose.prod.yml dist/docker-compose.prod.yml',
                   shell=True, check=True)
    subprocess.run('cp docker-compose.prod.tls.yml dist/docker-compose.prod.tls.yml', shell=True, check=True)
    subprocess.run('cp .env dist/.env', shell=True, check=True)
    # Load update script from scripts repo
    subprocess.run('wget -P dist https://raw.githubusercontent.com/iqb-berlin/iqb-scripts/master/update.sh',
                   shell=True, check=True)

    filename = f"dist/{DIST_PACKAGE_NAME}-{frontend_version}-{backend_version}.tar"
    with tarfile.open(filename, "w") as tar:
        for file in os.listdir('dist'):
            tar.add('dist/' + file, file)

    subprocess.run('rm dist/*.yml', shell=True, check=True)
    subprocess.run('rm dist/Makefile-template', shell=True, check=True)
    subprocess.run('rm -rf dist/config', shell=True, check=True)
    subprocess.run('rm dist/.env', shell=True, check=True)
    subprocess.run('rm dist/update.sh', shell=True, check=True)


check_prerequisites()
update_submodules()
backend_version = get_version_from_file(BACKEND_VERSION_FILE_PATH, BACKEND_VERSION_REGEX)
frontend_version = get_version_from_file(FRONTEND_VERSION_FILE_PATH, FRONTEND_VERSION_REGEX)
update_compose_file_versions(backend_version, frontend_version)
create_release_package(backend_version, frontend_version)
git_tag_commit_and_push(backend_version, frontend_version)
