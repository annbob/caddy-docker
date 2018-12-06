FROM arm64v8/debian:stretch-slim as builder
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    openssl \
    ca-certificates \
    wget \
 && mkdir /opt/golang \
 && cd /opt/golang \
 && wget https://golang.org/dl/go1.10.1.linux-arm64.tar.gz \
 && tar -xvf go1.10.1.linux-arm64.tar.gz \
 && mv go /usr/local
ENV GOPATH="/opt/gocode" 
ENV GOROOT="/usr/local/go" 
ENV PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
RUN go version \
 && go get github.com/mholt/caddy/caddy \
 && go get github.com/caddyserver/builds \
 && cd $GOPATH/src/github.com/mholt/caddy/caddy \
 && go run build.go

#production image
FROM arm64v8/debian:stretch-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/gocode/src/github.com/mholt/caddy/caddy/caddy /usr/bin/
ENTRYPOINT ["caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=false", "-disabled-metrics=false"]
