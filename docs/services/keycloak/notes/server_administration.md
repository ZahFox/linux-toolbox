# Keycloak Server Administration

> Make sure $KEYCLOAK_HOME is set to the root directory of your Keycloak installation

## Starting, Stopping, and Restarting WildFly

### Start

`$ $KEYCLOAK_HOME/bin/standalone.sh`

### Stop

`$ $KEYCLOAK_HOME/bin/jboss-cli.sh --connect command=:shutdown`

### Restart

`$ $KEYCLOAK_HOME/bin/jboss-cli.sh --connect command=:reload`

## Adding Users to Keycloak

## CLI

`$ $KEYCLOAK_HOME/bin/add-user-keycloak.sh -r <REALM> -u <USERNAME> -p <PASSWORD>`
