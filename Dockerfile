FROM arm64v8/debian:stretch-slim

ENV ACME_AGREE="false"

RUN apt-get update \
 && apt-get install -y go git \
 && go get github.com/mholt/caddy/caddy \
 && go get github.com/caddyserver/builds \
 && cd $GOPATH/src/github.com/mholt/caddy/caddy \
 && go run build.go \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -rf /var/lib/apt/lists/* \
 && cp caddy /usr/bin/
 
ENTRYPOINT ["caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE", "-disabled-metrics"]
