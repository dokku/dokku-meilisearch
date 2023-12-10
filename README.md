# dokku meilisearch [![Build Status](https://img.shields.io/github/actions/workflow/status/dokku/dokku-meilisearch/ci.yml?branch=master&style=flat-square "Build Status")](https://github.com/dokku/dokku-meilisearch/actions/workflows/ci.yml?query=branch%3Amaster) [![IRC Network](https://img.shields.io/badge/irc-libera-blue.svg?style=flat-square "IRC Libera")](https://webchat.libera.chat/?channels=dokku)

Official meilisearch plugin for dokku. Currently defaults to installing [getmeili/meilisearch v1.5.0](https://hub.docker.com/r/getmeili/meilisearch/).

## Requirements

- dokku 0.19.x+
- docker 1.8.x

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-meilisearch.git meilisearch
```

## Commands

```
meilisearch:app-links <app>                        # list all meilisearch service links for a given app
meilisearch:create <service> [--create-flags...]   # create a meilisearch service
meilisearch:destroy <service> [-f|--force]         # delete the meilisearch service/data/container if there are no links left
meilisearch:enter <service>                        # enter or run a command in a running meilisearch service container
meilisearch:exists <service>                       # check if the meilisearch service exists
meilisearch:expose <service> <ports...>            # expose a meilisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
meilisearch:info <service> [--single-info-flag]    # print the service information
meilisearch:link <service> <app> [--link-flags...] # link the meilisearch service to the app
meilisearch:linked <service> <app>                 # check if the meilisearch service is linked to an app
meilisearch:links <service>                        # list all apps linked to the meilisearch service
meilisearch:list                                   # list all meilisearch services
meilisearch:logs <service> [-t|--tail] <tail-num-optional> # print the most recent log(s) for this service
meilisearch:pause <service>                        # pause a running meilisearch service
meilisearch:promote <service> <app>                # promote service <service> as MEILISEARCH_URL in <app>
meilisearch:restart <service>                      # graceful shutdown and restart of the meilisearch service container
meilisearch:set <service> <key> <value>            # set or clear a property for a service
meilisearch:start <service>                        # start a previously stopped meilisearch service
meilisearch:stop <service>                         # stop a running meilisearch service
meilisearch:unexpose <service>                     # unexpose a previously exposed meilisearch service
meilisearch:unlink <service> <app>                 # unlink the meilisearch service from the app
meilisearch:upgrade <service> [--upgrade-flags...] # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to meilisearch:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `meilisearch:help` command for any undocumented commands.

### Basic Usage

### create a meilisearch service

```shell
# usage
dokku meilisearch:create <service> [--create-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit in megabytes (default: unlimited)
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-p|--password PASSWORD`: override the user-level service password
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-r|--root-password PASSWORD`: override the root-level service password
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for meilisearch docker container

Create a meilisearch service named lollipop:

```shell
dokku meilisearch:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the getmeili/meilisearch image.

```shell
export MEILISEARCH_IMAGE="getmeili/meilisearch"
export MEILISEARCH_IMAGE_VERSION="${PLUGIN_IMAGE_VERSION}"
dokku meilisearch:create lollipop
```

You can also specify custom environment variables to start the meilisearch service in semicolon-separated form.

```shell
export MEILISEARCH_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku meilisearch:create lollipop
```

### print the service information

```shell
# usage
dokku meilisearch:info <service> [--single-info-flag]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--internal-ip`: show the service internal ip
- `--initial-network`: show the initial network being connected to
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

### list all meilisearch services

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
dokku meilisearch:logs <service> [-t|--tail] <tail-num-optional>
```

flags:

- `-t|--tail [<tail-num>]`: do not stop when end of the logs are reached and wait for additional output

You can tail logs for a particular service:

```shell
dokku meilisearch:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku meilisearch:logs lollipop --tail
```

The default tail setting is to show all logs, but an initial count can also be specified:

```shell
dokku meilisearch:logs lollipop --tail 5
```

### link the meilisearch service to the app

```shell
# usage
dokku meilisearch:link <service> <app> [--link-flags...]
```

flags:

- `-a|--alias "BLUE_DATABASE"`: an alternative alias to use for linking to an app via environment variable
- `-q|--querystring "pool=5"`: ampersand delimited querystring arguments to append to the service link
- `-n|--no-restart "false"`: whether or not to restart the app on link (default: true)

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

### unlink the meilisearch service from the app

```shell
# usage
dokku meilisearch:unlink <service> <app>
```

flags:

- `-n|--no-restart "false"`: whether or not to restart the app on unlink (default: true)

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

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### enter or run a command in a running meilisearch service container

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

### expose a meilisearch service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku meilisearch:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku meilisearch:expose lollipop 7700
```

Expose the service on the service's normal ports, with the first on a specified ip adddress (127.0.0.1):

```shell
dokku meilisearch:expose lollipop 127.0.0.1:7700
```

### unexpose a previously exposed meilisearch service

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
dokku meilisearch:promote <service> <app>
```

If you have a meilisearch service linked to an app and try to link another meilisearch service another link environment variable will be generated automatically:

```
DOKKU_MEILISEARCH_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku meilisearch:promote other_service playground
```

This will replace `MEILISEARCH_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
MEILISEARCH_URL=http://other_service:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
DOKKU_MEILISEARCH_BLUE_URL=http://other_service:ANOTHER_PASSWORD@dokku-meilisearch-other-service:7700/other_service
DOKKU_MEILISEARCH_SILVER_URL=http://lollipop:SOME_PASSWORD@dokku-meilisearch-lollipop:7700/lollipop
```

### start a previously stopped meilisearch service

```shell
# usage
dokku meilisearch:start <service>
```

Start the service:

```shell
dokku meilisearch:start lollipop
```

### stop a running meilisearch service

```shell
# usage
dokku meilisearch:stop <service>
```

Stop the service and removes the running container:

```shell
dokku meilisearch:stop lollipop
```

### pause a running meilisearch service

```shell
# usage
dokku meilisearch:pause <service>
```

Pause the running container for the service:

```shell
dokku meilisearch:pause lollipop
```

### graceful shutdown and restart of the meilisearch service container

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

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-R|--restart-apps "true"`: whether or not to force an app restart (default: false)
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for meilisearch docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku meilisearch:upgrade lollipop
```

### Service Automation

Service scripting can be executed using the following commands:

### list all meilisearch service links for a given app

```shell
# usage
dokku meilisearch:app-links <app>
```

List all meilisearch services that are linked to the `playground` app.

```shell
dokku meilisearch:app-links playground
```

### check if the meilisearch service exists

```shell
# usage
dokku meilisearch:exists <service>
```

Here we check if the lollipop meilisearch service exists.

```shell
dokku meilisearch:exists lollipop
```

### check if the meilisearch service is linked to an app

```shell
# usage
dokku meilisearch:linked <service> <app>
```

Here we check if the lollipop meilisearch service is linked to the `playground` app.

```shell
dokku meilisearch:linked lollipop playground
```

### list all apps linked to the meilisearch service

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
