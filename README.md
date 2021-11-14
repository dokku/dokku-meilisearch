# dokku meillisearch [![Build Status](https://img.shields.io/github/workflow/status/dokku/dokku-meillisearch/CI/master?style=flat-square "Build Status")](https://github.com/dokku/dokku-meillisearch/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Official meillisearch plugin for dokku. Currently defaults to installing [getmeili/meilisearch v0.23.1](https://hub.docker.com/r/getmeili/meilisearch/).

## Requirements

- dokku 0.19.x+
- docker 1.8.x

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-meillisearch.git meillisearch
```

## Commands

```
meillisearch:app-links <app>                       # list all meillisearch service links for a given app
meillisearch:create <service> [--create-flags...]  # create a meillisearch service
meillisearch:destroy <service> [-f|--force]        # delete the meillisearch service/data/container if there are no links left
meillisearch:enter <service>                       # enter or run a command in a running meillisearch service container
meillisearch:exists <service>                      # check if the meillisearch service exists
meillisearch:expose <service> <ports...>           # expose a meillisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
meillisearch:info <service> [--single-info-flag]   # print the service information
meillisearch:link <service> <app> [--link-flags...] # link the meillisearch service to the app
meillisearch:linked <service> <app>                # check if the meillisearch service is linked to an app
meillisearch:links <service>                       # list all apps linked to the meillisearch service
meillisearch:list                                  # list all meillisearch services
meillisearch:logs <service> [-t|--tail] <tail-num-optional> # print the most recent log(s) for this service
meillisearch:promote <service> <app>               # promote service <service> as MEILLISEARCH_URL in <app>
meillisearch:restart <service>                     # graceful shutdown and restart of the meillisearch service container
meillisearch:start <service>                       # start a previously stopped meillisearch service
meillisearch:stop <service>                        # stop a running meillisearch service
meillisearch:unexpose <service>                    # unexpose a previously exposed meillisearch service
meillisearch:unlink <service> <app>                # unlink the meillisearch service from the app
meillisearch:upgrade <service> [--upgrade-flags...] # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to meillisearch:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `meillisearch:help` command for any undocumented commands.

### Basic Usage

### create a meillisearch service

```shell
# usage
dokku meillisearch:create <service> [--create-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit (default: unlimited)
- `-p|--password PASSWORD`: override the user-level service password
- `-r|--root-password PASSWORD`: override the root-level service password
- `-s|--shm-size SHM_SIZE`: override shared memory size for meillisearch docker container

Create a meillisearch service named lollipop:

```shell
dokku meillisearch:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the getmeili/meilisearch image.

```shell
export MEILLISEARCH_IMAGE="getmeili/meilisearch"
export MEILLISEARCH_IMAGE_VERSION="${PLUGIN_IMAGE_VERSION}"
dokku meillisearch:create lollipop
```

You can also specify custom environment variables to start the meillisearch service in semi-colon separated form.

```shell
export MEILLISEARCH_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku meillisearch:create lollipop
```

### print the service information

```shell
# usage
dokku meillisearch:info <service> [--single-info-flag]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--internal-ip`: show the service internal ip
- `--links`: show the service app links
- `--service-root`: show the service root directory
- `--status`: show the service running status
- `--version`: show the service image version

Get connection information as follows:

```shell
dokku meillisearch:info lollipop
```

You can also retrieve a specific piece of service info via flags:

```shell
dokku meillisearch:info lollipop --config-dir
dokku meillisearch:info lollipop --data-dir
dokku meillisearch:info lollipop --dsn
dokku meillisearch:info lollipop --exposed-ports
dokku meillisearch:info lollipop --id
dokku meillisearch:info lollipop --internal-ip
dokku meillisearch:info lollipop --links
dokku meillisearch:info lollipop --service-root
dokku meillisearch:info lollipop --status
dokku meillisearch:info lollipop --version
```

### list all meillisearch services

```shell
# usage
dokku meillisearch:list 
```

List all services:

```shell
dokku meillisearch:list
```

### print the most recent log(s) for this service

```shell
# usage
dokku meillisearch:logs <service> [-t|--tail] <tail-num-optional>
```

flags:

- `-t|--tail [<tail-num>]`: do not stop when end of the logs are reached and wait for additional output

You can tail logs for a particular service:

```shell
dokku meillisearch:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku meillisearch:logs lollipop --tail
```

The default tail setting is to show all logs, but an initial count can also be specified:

```shell
dokku meillisearch:logs lollipop --tail 5
```

### link the meillisearch service to the app

```shell
# usage
dokku meillisearch:link <service> <app> [--link-flags...]
```

flags:

- `-a|--alias "BLUE_DATABASE"`: an alternative alias to use for linking to an app via environment variable
- `-q|--querystring "pool=5"`: ampersand delimited querystring arguments to append to the service link

A meillisearch service can be linked to a container. This will use native docker links via the docker-options plugin. Here we link it to our `playground` app.

> NOTE: this will restart your app

```shell
dokku meillisearch:link lollipop playground
```

The following environment variables will be set automatically by docker (not on the app itself, so they won’t be listed when calling dokku config):

```
DOKKU_MEILLISEARCH_LOLLIPOP_NAME=/lollipop/DATABASE
DOKKU_MEILLISEARCH_LOLLIPOP_PORT=tcp://172.17.0.1:7700
DOKKU_MEILLISEARCH_LOLLIPOP_PORT_7700_TCP=tcp://172.17.0.1:7700
DOKKU_MEILLISEARCH_LOLLIPOP_PORT_7700_TCP_PROTO=tcp
DOKKU_MEILLISEARCH_LOLLIPOP_PORT_7700_TCP_PORT=7700
DOKKU_MEILLISEARCH_LOLLIPOP_PORT_7700_TCP_ADDR=172.17.0.1
```

The following will be set on the linked application by default:

```
MEILLISEARCH_URL=http://lollipop:SOME_PASSWORD@dokku-meillisearch-lollipop:7700/lollipop
```

The host exposed here only works internally in docker containers. If you want your container to be reachable from outside, you should use the `expose` subcommand. Another service can be linked to your app:

```shell
dokku meillisearch:link other_service playground
```

It is possible to change the protocol for `MEILLISEARCH_URL` by setting the environment variable `MEILLISEARCH_DATABASE_SCHEME` on the app. Doing so will after linking will cause the plugin to think the service is not linked, and we advise you to unlink before proceeding.

```shell
dokku config:set playground MEILLISEARCH_DATABASE_SCHEME=http2
dokku meillisearch:link lollipop playground
```

This will cause `MEILLISEARCH_URL` to be set as:

```
http2://lollipop:SOME_PASSWORD@dokku-meillisearch-lollipop:7700/lollipop
```

### unlink the meillisearch service from the app

```shell
# usage
dokku meillisearch:unlink <service> <app>
```

You can unlink a meillisearch service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku meillisearch:unlink lollipop playground
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### enter or run a command in a running meillisearch service container

```shell
# usage
dokku meillisearch:enter <service>
```

A bash prompt can be opened against a running service. Filesystem changes will not be saved to disk.

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku meillisearch:enter lollipop
```

You may also run a command directly against the service. Filesystem changes will not be saved to disk.

```shell
dokku meillisearch:enter lollipop touch /tmp/test
```

### expose a meillisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku meillisearch:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku meillisearch:expose lollipop 7700
```

Expose the service on the service's normal ports, with the first on a specified ip adddress (127.0.0.1):

```shell
dokku meillisearch:expose lollipop 127.0.0.1:7700
```

### unexpose a previously exposed meillisearch service

```shell
# usage
dokku meillisearch:unexpose <service>
```

Unexpose the service, removing access to it from the public interface (`0.0.0.0`):

```shell
dokku meillisearch:unexpose lollipop
```

### promote service <service> as MEILLISEARCH_URL in <app>

```shell
# usage
dokku meillisearch:promote <service> <app>
```

If you have a meillisearch service linked to an app and try to link another meillisearch service another link environment variable will be generated automatically:

```
DOKKU_MEILLISEARCH_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-meillisearch-other-service:7700/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku meillisearch:promote other_service playground
```

This will replace `MEILLISEARCH_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
MEILLISEARCH_URL=http://other_service:ANOTHER_PASSWORD@dokku-meillisearch-other-service:7700/other_service
DOKKU_MEILLISEARCH_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-meillisearch-other-service:7700/other_service
DOKKU_MEILLISEARCH_SILVER_URL=http://lollipop:SOME_PASSWORD@dokku-meillisearch-lollipop:7700/lollipop
```

### start a previously stopped meillisearch service

```shell
# usage
dokku meillisearch:start <service>
```

Start the service:

```shell
dokku meillisearch:start lollipop
```

### stop a running meillisearch service

```shell
# usage
dokku meillisearch:stop <service>
```

Stop the service and the running container:

```shell
dokku meillisearch:stop lollipop
```

### graceful shutdown and restart of the meillisearch service container

```shell
# usage
dokku meillisearch:restart <service>
```

Restart the service:

```shell
dokku meillisearch:restart lollipop
```

### upgrade service <service> to the specified versions

```shell
# usage
dokku meillisearch:upgrade <service> [--upgrade-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-R|--restart-apps "true"`: whether to force an app restart
- `-s|--shm-size SHM_SIZE`: override shared memory size for meillisearch docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku meillisearch:upgrade lollipop
```

### Service Automation

Service scripting can be executed using the following commands:

### list all meillisearch service links for a given app

```shell
# usage
dokku meillisearch:app-links <app>
```

List all meillisearch services that are linked to the `playground` app.

```shell
dokku meillisearch:app-links playground
```

### check if the meillisearch service exists

```shell
# usage
dokku meillisearch:exists <service>
```

Here we check if the lollipop meillisearch service exists.

```shell
dokku meillisearch:exists lollipop
```

### check if the meillisearch service is linked to an app

```shell
# usage
dokku meillisearch:linked <service> <app>
```

Here we check if the lollipop meillisearch service is linked to the `playground` app.

```shell
dokku meillisearch:linked lollipop playground
```

### list all apps linked to the meillisearch service

```shell
# usage
dokku meillisearch:links <service>
```

List all apps linked to the `lollipop` meillisearch service.

```shell
dokku meillisearch:links lollipop
```

### Disabling `docker pull` calls

If you wish to disable the `docker pull` calls that the plugin triggers, you may set the `MEILLISEARCH_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker pull` is disabled.
