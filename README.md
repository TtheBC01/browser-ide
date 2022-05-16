![Alt Text](/demo.gif)

# Browser IDE

This repo uses the open-source [Theia](https://theia-ide.org/) framework to build a browser-based IDE, similar to VSCode, that
can be served from Docker container and used as an alternative to traditional RDP tools, particularly 
when coupled with an [authentication layer](https://github.com/greenpau/caddy-security) and an 
[introspective tunnel](https://www.cloudflare.com/products/tunnel/) technology. 

This repo is intended to be self-contained in that a developer should be able to use it as a stand-alone tool. To that end,
the browser ide uses [Caddy Server](https://caddyserver.com/) to provide form-based authentication when accessing the ide 
from a public URL. Additionally, the project uses [supervisord](http://supervisord.org/) for process control and 
automatic restarts of the caddy and node processes. 

## Requirments

Do build this project you need the [Docker Engine](https://docs.docker.com/get-docker/) available on your machine.

## Building

To build the IDE environment, use the Docker cli:

```
docker build -t browser-ide .
```

## Pre-built Docker Image

A pre-built version of the browser-ide can be pulled from Docker Hub:

```
docker pull tthebc01/browser-ide
```

## Running the IDE

Once you have either built or pulled the ide container, you can run it locally by exposing port `8080` on the ide container:

```
docker run -p 8080:8080 --rm --name browser-ide -d browser-ide
```

To enable authentication, you'll need to expose port `8888` which is a reverse-proxy endpoint with authentication
provided by a caddy server plugin.

```
docker run -p 8888:8888 --rm --name browser-ide -d browser-ide
```