# mtproto-proxy-docker

Makefile and environment file in this repository helps you fast start and manage your mtproto-proxy in docker container.

## Getting Started

You need to have installed docker and firewalld on your machine. Docker full instaruction can be found [there](https://docs.docker.com/install/).

### Install Docker CE on CentOS 7

Uninstall old versions:

```
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

Install required packages:

```
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

Set up the stable repository:

```
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

Install the latest version of Docker CE and containerd:

```
$ sudo yum install docker-ce docker-ce-cli containerd.io
```

Enable docker service in system and start it:

```
$ systemctl enable docker --now
```

If you would like to use docker as a non-root user, you should now consider adding your user to the `docker` group with something like:

```
$ sudo usermod -aG docker [USER_NAME]
```

Remember to log out and back in for this to take effect!

### Start mtproto-proxy

You need to clone this repo and go to directory:

```
$ git clone https://github.com/SpyWSamara/mtproto-proxy-docker && cd mtproto-proxy-docker
```

Then copy `.env.dist` file to `.env` file:

```
$ cp .env.dist .env
```

And edit your `.env` file. For generate new secret use `make secret` or `make dd-secret` command. After that you can start proxy:

```
$ make up
```

For stop end remove container:

```
$ make down
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
