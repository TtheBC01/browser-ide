# See https://caddyserver.com/docs/ for info on Caddy Server
FROM caddy:builder as caddy-build

RUN xcaddy build --with github.com/greenpau/caddy-security

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y \
    && apt install -y software-properties-common gpg \ 
    && add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt update -y \
    && apt install -y vim \
                   tmux \
                   git \
                   curl \
                   gcc \
                   g++ \ 
                   make \ 
                   libsecret-1-dev \
                   libx11-dev \
                   libxkbfile-dev \
                   supervisor \
                   python3.9 \ 
                   python3-pip \
                   python3.9-dev \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs \
    && npm install --global yarn

RUN mkdir /.browser-ide
WORKDIR /.browser-ide

# Build the IDE
COPY package.json .
RUN yarn
RUN yarn build

# Get the caddy server executable
COPY --from=caddy-build /usr/bin/caddy /usr/bin/caddy

# Get auxiliary files for frontend server and process manager
COPY supervisor.conf /etc/
COPY Caddyfile /etc/

# Set some environment variables for the IDE
ENV THEIA_MINI_BROWSER_HOST_PATTERN={{hostname}}
ENV THEIA_WEBVIEW_EXTERNAL_ENDPOINT={{hostname}}
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/.browser-ide/plugins
    
# Set some environment files for authentication
# be sure to set these to something reasonble
ENV AUTHP_ADMIN_USER admin
ENV AUTHP_ADMIN_EMAIL admin@outlook.com
ENV AUTHP_ADMIN_SECRET adminpassword

# add a non-root user if you want
# RUN useradd -ms /bin/bash myuser
# USER myuser

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]