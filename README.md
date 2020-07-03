[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

# Teststudio-Lite

Docker-Setup for the Teststudio-Lite (formally known as itemdb).

**This compose-file is for development/showcase purposes. Not for deployment.**

# run

```
git clone --recurse-submodules https://github.com/iqb-berlin/teststudio-lite-setup.git
cd teststudio-lite-setup
docker-compose up
```

*Hint*: If you get timeouts while building fresh images build them separately or increase docker-compose
timeout: `export COMPOSE_HTTP_TIMEOUT=300`.

# Prerequisites
- docker version 19.03.1
- docker-compose version 1.24.1

# ports:services

- 4210: teststudio-lite frontend
- 4210: teststudio-lite backend
- 9097: postgres database
--
.
