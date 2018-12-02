FROM arm32v7/debian:stretch-slim

ENV ACME_AGREE="false"
ENV GOPATH="/opt/gocode"

RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
    golang-go \
    git \
    openssl \
    ca-certificates
RUN go get github.com/mholt/caddy/caddy 
RUN go get github.com/caddyserver/builds 
RUN cd $GOPATH/src/github.com/mholt/caddy/caddy 
RUN go run build.go 
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
RUN rm -rf /var/lib/apt/lists/*
RUN cp caddy /usr/bin/
 
ENTRYPOINT ["caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE", "-disabled-metrics"]
