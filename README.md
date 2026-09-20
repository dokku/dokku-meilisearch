# dokku meilisearch [![Build Status](https://img.shields.io/github/actions/workflow/status/dokku/dokku-meilisearch/ci.yml?branch=master&style=flat-square "Build Status")](https://github.com/dokku/dokku-meilisearch/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Official meilisearch plugin for dokku. Currently defaults to installing [getmeili/meilisearch v1.53.2](https://hub.docker.com/r/getmeili/meilisearch/).

## Requirements

- dokku 0.35.x+
- docker 1.8.x

## Installation

```shell
# on 0.35.x+
sudo dokku plugin:install https://github.com/dokku/dokku-meilisearch.git --name meilisearch
```

## Commands

```
meilisearch:app-links [<app>]                      # list all Meilisearch service links for a given app
meilisearch:create <service> [--create-flags...]   # create a Meilisearch service
meilisearch:destroy <service> [-f|--force]         # delete the Meilisearch service/data/container if there are no links left
meilisearch:enter <service>                        # enter or run a command in a running Meilisearch service container
meilisearch:exists <service>                       # check if the Meilisearch service exists
meilisearch:expose <service> <ports...>            # expose a Meilisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
meilisearch:info <service> [--info-flags...]       # print the service information
meilisearch:link <service> [<app>] [--link-flags...] # link the Meilisearch service to the app
meilisearch:linked <service> [<app>]               # check if the Meilisearch service is linked to an app
meilisearch:links <service>                        # list all apps linked to the Meilisearch service
meilisearch:list                                   # list all Meilisearch services
meilisearch:logs <service> [-t|--tail [<tail-num>]] # print the most recent log(s) for this service
meilisearch:pause <service>                        # pause a running Meilisearch service
meilisearch:promote <service> [<app>]              # promote service <service> as MEILISEARCH_URL in <app>
meilisearch:restart <service>                      # graceful shutdown and restart of the Meilisearch service container
meilisearch:set <service> <key> <value>            # set or clear a property for a service
meilisearch:start <service>                        # start a previously stopped Meilisearch service
meilisearch:stop <service>                         # stop a running Meilisearch service
meilisearch:unexpose <service>                     # unexpose a previously exposed Meilisearch service
meilisearch:unlink <service> [<app>] [-n|--no-restart] # unlink the Meilisearch service from the app
meilisearch:upgrade <service> [--upgrade-flags...] # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to meilisearch:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `meilisearch:help` command for any undocumented commands.

### Basic Usage

### create a Meilisearch service

```shell
# usage
dokku meilisearch:create <service> [--create-flags...]
```

flags:

- `-c|--config-options <string>`: extra arguments to pass to the container create command
- `-C|--custom-env <string>`: semi-colon delimited environment variables to start the service with
- `-i|--image <string>`: the image name to start the service with
- `-I|--image-version <string>`: the image version to start the service with
- `-N|--initial-network <string>`: the initial network to attach the service to
- `-m|--memory <int>`: container memory limit in megabytes (default: unlimited)
- `-p|--password <string>`: override the user-level service password
- `-P|--post-create-network <strings>`: a comma-separated list of networks to attach the service container to after service creation
- `-S|--post-start-network <strings>`: a comma-separated list of networks to attach the service container to after service start
- `-r|--root-password <string>`: override the root-level service password
- `-s|--shm-size <string>`: override shared memory size for the service docker container

Create a meilisearch service named lollipop:

```shell
dokku meilisearch:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the getmeili/meilisearch image.

```shell
export MEILISEARCH_IMAGE="getmeili/meilisearch"
export MEILISEARCH_IMAGE_VERSION="v1.53.2"
dokku meilisearch:create lollipop
```

You can also specify custom environment variables to start the meilisearch service in semicolon-separated form.

```shell
export MEILISEARCH_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku meilisearch:create lollipop
```

### delete the Meilisearch service/data/container if there are no links left

```shell
# usage
dokku meilisearch:destroy <service> [-f|--force]
```

flags:

- `-f|--force`: force the destruction of the service

Destroy the service, it's data, and the running container:

```shell
dokku meilisearch:destroy lollipop
```

### print the service information

```shell
# usage
dokku meilisearch:info <service> [--info-flags...]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--initial-network`: show the initial network being connected to
- `--internal-ip`: show the service internal ip
- `--links`: show the service app links
- `--post-create-network`: show the networks to attach to after service container creation
- `--post-start-network`: show the networks to attach to after service container start
- `--service-root`: show the service root directory
- `--status`: show the service running status
- `--version`: show the service image version

Get connection information as follows:

```shell
dokku meilisearch:info lollipop
```

You can also retrieve a specific piece of service info via flags:

```shell
dokku meilisearch:info lollipop --config-dir
dokku meilisearch:info lollipop --data-dir
dokku meilisearch:info lollipop --dsn
dokku meilisearch:info lollipop --exposed-ports
dokku meilisearch:info lollipop --id
dokku meilisearch:info lollipop --internal-ip
dokku meilisearch:info lollipop --initial-network
dokku meilisearch:info lollipop --links
dokku meilisearch:info lollipop --post-create-network
dokku meilisearch:info lollipop --post-start-network
dokku meilisearch:info lollipop --service-root
dokku meilisearch:info lollipop --status
dokku meilisearch:info lollipop --version
```

### list all Meilisearch services

```shell
# usage
dokku meilisearch:list
```

List all services:

```shell
dokku meilisearch:list
```

### print the most recent log(s) for this service

```shell
# usage
dokku meilisearch:logs <service> [-t|--tail [<tail-num>]]
```

flags:

- `-t|--tail <int>`: tail the logs, optionally showing this many lines

You can tail logs for a particular service:

```shell
dokku meilisearch:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku meilisearch:logs lollipop --tail
```

By default the last 100 lines are shown, but a different count can be specified:

```shell
dokku meilisearch:logs lollipop --tail=5
```

### link the Meilisearch service to the app

```shell
# usage
dokku meilisearch:link <service> [<app>] [--link-flags...]
```

flags:

- `-a|--alias <string>`: an alternative alias to use for the config url exported to the app
- `-n|--no-restart`: whether to skip restarting the app
- `-q|--querystring <string>`: ampersand delimited querystring arguments to append to the service url

A meilisearch service can be linked to a container. This will use native docker links via the docker-options plugin. Here we link it to our `playground` app.

> NOTE: this will restart your app

```shell
dokku meilisearch:link lollipop playground
```

The following environment variables will be set automatically by docker (not on the app itself, so they won’t be listed when calling dokku config):

```
DOKKU_MEILISEARCH_LOLLIPOP_NAME=/lollipop/DATABASE
DOKKU_MEILISEARCH_LOLLIPOP_PORT=tcp://172.17.0.1:7700
DOKKU_MEILISEARCH_LOLLIPOP_PORT_7700_TCP=tcp://172.17.0.1:7700
DOKKU_MEILISEARCH_LOLLIPOP_PORT_7700_TCP_PROTO=tcp
DOKKU_MEILISEARCH_LOLLIPOP_PORT_7700_TCP_PORT=7700
DOKKU_MEILISEARCH_LOLLIPOP_PORT_7700_TCP_ADDR=172.17.0.1
```

The following will be set on the linked application by default:

```
MEILISEARCH_URL=http://:SOME_PASSWORD@dokku-meilisearch-lollipop:7700
```

The host exposed here only works internally in docker containers. If you want your container to be reachable from outside, you should use the `expose` subcommand. Another service can be linked to your app:

```shell
dokku meilisearch:link other_service playground
```

It is possible to change the protocol for `MEILISEARCH_URL` by setting the environment variable `MEILISEARCH_DATABASE_SCHEME` on the app. Doing so will after linking will cause the plugin to think the service is not linked, and we advise you to unlink before proceeding.

```shell
dokku config:set playground MEILISEARCH_DATABASE_SCHEME=http2
dokku meilisearch:link lollipop playground
```

This will cause `MEILISEARCH_URL` to be set as:

```
http2://:SOME_PASSWORD@dokku-meilisearch-lollipop:7700
```

### unlink the Meilisearch service from the app

```shell
# usage
dokku meilisearch:unlink <service> [<app>] [-n|--no-restart]
```

flags:

- `-n|--no-restart`: whether to skip restarting the app

You can unlink a meilisearch service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku meilisearch:unlink lollipop playground
```

### set or clear a property for a service

```shell
# usage
dokku meilisearch:set <service> <key> <value>
```

Set the network to attach after the service container is started:

```shell
dokku meilisearch:set lollipop post-create-network custom-network
```

Set multiple networks:

```shell
dokku meilisearch:set lollipop post-create-network custom-network,other-network
```

Unset the post-create-network value:

```shell
dokku meilisearch:set lollipop post-create-network
```

Set the keyserver a public key for backup encryption is fetched from:

```shell
dokku meilisearch:set lollipop backup-keyserver hkp://keys.example.com
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### enter or run a command in a running Meilisearch service container

```shell
# usage
dokku meilisearch:enter <service>
```

A bash prompt can be opened against a running service. Filesystem changes will not be saved to disk.

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku meilisearch:enter lollipop
```

You may also run a command directly against the service. Filesystem changes will not be saved to disk.

```shell
dokku meilisearch:enter lollipop touch /tmp/test
```

### expose a Meilisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku meilisearch:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku meilisearch:expose lollipop 7700
```

Expose the service on the service's normal ports, with the first on a specified ip address (127.0.0.1):

```shell
dokku meilisearch:expose lollipop 127.0.0.1:7700
```

### unexpose a previously exposed Meilisearch service

```shell
# usage
dokku meilisearch:unexpose <service>
```

Unexpose the service, removing access to it from the public interface (`0.0.0.0`):

```shell
dokku meilisearch:unexpose lollipop
```

### promote service <service> as MEILISEARCH_URL in <app>

```shell
# usage
dokku meilisearch:promote <service> [<app>]
```

If you have a meilisearch service linked to an app and try to link another meilisearch service another link environment variable will be generated automatically:

```
DOKKU_MEILISEARCH_BLUE_URL=http://:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku meilisearch:promote other_service playground
```

This will replace `MEILISEARCH_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
MEILISEARCH_URL=http://:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
DOKKU_MEILISEARCH_BLUE_URL=http://:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
DOKKU_MEILISEARCH_SILVER_URL=http://:SOME_PASSWORD@dokku-meilisearch-lollipop:7700/lollipop
```

### start a previously stopped Meilisearch service

```shell
# usage
dokku meilisearch:start <service>
```

Start the service:

```shell
dokku meilisearch:start lollipop
```

### stop a running Meilisearch service

```shell
# usage
dokku meilisearch:stop <service>
```

Stop the service and removes the running container:

```shell
dokku meilisearch:stop lollipop
```

### pause a running Meilisearch service

```shell
# usage
dokku meilisearch:pause <service>
```

Pause the running container for the service:

```shell
dokku meilisearch:pause lollipop
```

### graceful shutdown and restart of the Meilisearch service container

```shell
# usage
dokku meilisearch:restart <service>
```

Restart the service:

```shell
dokku meilisearch:restart lollipop
```

### upgrade service <service> to the specified versions

```shell
# usage
dokku meilisearch:upgrade <service> [--upgrade-flags...]
```

flags:

- `-c|--config-options <string>`: extra arguments to pass to the container create command
- `-C|--custom-env <string>`: semi-colon delimited environment variables to start the service with
- `-i|--image <string>`: the image to upgrade the service to
- `-I|--image-version <string>`: the image version to upgrade the service to
- `-N|--initial-network <string>`: the initial network to attach the service to
- `-P|--post-create-network <strings>`: a comma-separated list of networks to attach the service container to after service creation
- `-S|--post-start-network <strings>`: a comma-separated list of networks to attach the service container to after service start
- `-R|--restart-apps`: whether to stop and start the linked apps around the upgrade
- `-s|--shm-size <string>`: override shared memory size for the service docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku meilisearch:upgrade lollipop
```

### Service Automation

Service scripting can be executed using the following commands:

### list all Meilisearch service links for a given app

```shell
# usage
dokku meilisearch:app-links [<app>]
```

List all meilisearch services that are linked to the `playground` app.

```shell
dokku meilisearch:app-links playground
```

### check if the Meilisearch service exists

```shell
# usage
dokku meilisearch:exists <service>
```

Here we check if the lollipop meilisearch service exists.

```shell
dokku meilisearch:exists lollipop
```

### check if the Meilisearch service is linked to an app

```shell
# usage
dokku meilisearch:linked <service> [<app>]
```

Here we check if the lollipop meilisearch service is linked to the `playground` app.

```shell
dokku meilisearch:linked lollipop playground
```

### list all apps linked to the Meilisearch service

```shell
# usage
dokku meilisearch:links <service>
```

List all apps linked to the `lollipop` meilisearch service.

```shell
dokku meilisearch:links lollipop
```

### Disabling `docker image pull` calls

If you wish to disable the `docker image pull` calls that the plugin triggers, you may set the `MEILISEARCH_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker image pull` is disabled.
