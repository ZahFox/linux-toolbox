# AWS

## CLI

### Install CLI

- Arch Linux

```bash
sudo pacman -Syu aws-cli
```

### Configure CLI User

```bash
$ aws configure
AWS Access Key ID [None]: <ACCESS_KEY_ID>
AWS Secret Access Key [None]: <ACCESS_KEY_SECRET>
Default region name [None]: <REGION:e:"us-east-1">
Default output format [None]: <FORMAT:e:"json">
```

This will create the following files: `$HOME/.aws/credentials $HOME/.aws/config`

- config

```toml
[default]
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <ACCESS_KEY_SECRET>
```

- credentials

```toml
[default]
region = <REGION>
output = <FORMAT>
```

You can also configure separate CLI profiles

```bash
configure --profile <POFILE_NAME>
```
