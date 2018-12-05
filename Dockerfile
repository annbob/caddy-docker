FROM arm64v8/debian:stretch-slim as builder

ENV ACME_AGREE="false"
ENV GOPATH="/opt/gocode"

RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
    build-essential \
    git \
    openssl \
    ca-certificates \
    wget
#RUN wget https://golang.org/dl/go1.11.2.linux-armv6l.tar.gz \
# && tar -xvf go1.11.2.linux-armv6l.tar.gz \
RUN mkdir /opt/golang \
 && cd /opt/golang \
 && wget https://golang.org/dl/go1.10.1.linux-arm64.tar.gz \
 && tar -xvf go1.10.1.linux-arm64.tar.gz \
 && mv go /usr/local
ENV GOROOT="/usr/local/go"
ENV PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
RUN go version \
 && go get github.com/mholt/caddy/caddy \
 && go get github.com/caddyserver/builds \
 && cd $GOPATH/src/github.com/mholt/caddy/caddy \
 && go run build.go
# && apt-get remove -y \
#    wget \
#    git \
#    build-essential \
# && rm -rf /usr/local/go \
# && rm -rf /opt/golang \
# && apt-get autoremove -y \
# && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
# && rm -rf /var/lib/apt/lists/* \

#production image
FROM arm64v8/debian:stretch-slim

COPY --from=builder /opt/gocode/src/github.com/mholt/caddy/caddy/caddy /usr/bin/ \
# && caddy -version
 
ENTRYPOINT ["caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=false", "-disabled-metrics=false"]
