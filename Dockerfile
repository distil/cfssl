FROM golang:1.6

RUN apt-get update
RUN apt-get --yes install build-essential debhelper devscripts fakeroot

ENV USER root

WORKDIR /go/src/github.com/cloudflare/cfssl
COPY . .

# restore all deps and build
RUN go get github.com/GeertJohan/go.rice/rice && rice embed-go -i=./cli/serve && \
	cp -R /go/src/github.com/cloudflare/cfssl/vendor/github.com/cloudflare/cfssl_trust /etc/cfssl && \
	go install ./cmd/...

EXPOSE 8888

ENTRYPOINT ["cfssl"]

VOLUME ["/build"]
