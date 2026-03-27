# ci_tooling

Shared actions used by various akrherz repos and anybody else, if you like
brittle things that are horribly engineered by daryl.

## iemwebfarm action

1. Setups micromamba in a default manner
2. Runs iemwebfarm.sh to setup Apache, mod_wsgi, and other things.

An example repo can reuse this like so:

```yaml
- uses: akrherz/ci_tooling/actions/iemwebfarm@main
  with:
    environment-file: environment.yml
    python-version: ${{ matrix.PYTHON_VERSION }}
    environment-name: prod
```

## iem-web-services action

1. Assumes that iemwebfarm action was run previously
2. Sets up akrherz/iem-web-services (FastAPI) to run on port 8080.

```yaml
- uses: akrherz/ci_tooling/actions/iem-web-services
  with:
    port: 8080

```
