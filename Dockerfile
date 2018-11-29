FROM arm64v8/debian:stretch-slim

ENV ACME_AGREE="false"

RUN apt-get update 
RUN apt-get install -y golang-go git open-ssl
RUN go get github.com/mholt/caddy/caddy 
RUN go get github.com/caddyserver/builds 
RUN cd $GOPATH/src/github.com/mholt/caddy/caddy 
RUN go run build.go 
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
RUN rm -rf /var/lib/apt/lists/*
RUN cp caddy /usr/bin/
 
ENTRYPOINT ["caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE", "-disabled-metrics"]
