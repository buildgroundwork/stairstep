# Stairstep

Deploying

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Configuration

You may add an optional `stairstep.yml` file in the application's config directory.

### Pipeline name
You may optionally specify the name of the pipeline for deploys (see example).  This will default to the name of the GitHub repository.

### Command line options
You may optionally provide a list of command line options that will always be set.  These may be in the form you would provide on the command line (e.g. `--no-tag`) or you may elide the initial dashes (e.g. `no-tag`).

NB: these will overwrite any options you explicitly list in the actual command line command.

### App names
You may optionally specify app names per remote (see example).  This will default to the hyphenated combination of the pipeline name and the remote name (e.g. syrup-demo).

### Hooks
Top level config keys may be the name of a Heroku deploy hook. Each key within a hook is a Heroku CLI command. Each value is an array of parameters for that command.

- `before_deploy` Runs right before the deploy (during maintenance mode)
- `after_deploy` Runs at the very end (after maintenance mode)

### Example

```yaml
---
pipeline: wibble-wobble

command_line:
  - no-tag
  - no-downtime
  - --debug

app:
  demo: wib-wob-demo
  production: wibble-wobble-prod

before_deploy:
  config:unset:
    - MINOR_VERSION
after_deploy:
  run:
    - rails pusher:new_release rollbar:source_maps
```


## Code of Conduct

Everyone interacting in the Stairstep project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](./CODE_OF_CONDUCT.md).

