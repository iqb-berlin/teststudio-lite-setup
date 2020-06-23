# Teststudio-Lite

Docker-Setup for the teststudio-lite (formally known as itemdb).

**This compose-file is for development/showcase purposes. Not for deployment.**

# run

```
git clone --recurse-submodules https://github.com/iqb-berlin/iqb-tba-docker-setup.git
cd iqb-tba-docker-setup
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
