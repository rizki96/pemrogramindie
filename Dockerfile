# Build Stage
FROM lacion/docker-alpine:gobuildimage:1.10.3 AS build-stage

LABEL app="build-pemrogramindie"
LABEL REPO="https://github.com/rizki96/pemrogramindie"

ENV PROJPATH=/go/src/github.com/rizki96/pemrogramindie

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/rizki96/pemrogramindie
WORKDIR /go/src/github.com/rizki96/pemrogramindie

RUN make build-alpine

# Final Stage
FROM lacion/docker-alpine:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/rizki96/pemrogramindie"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/pemrogramindie/bin

WORKDIR /opt/pemrogramindie/bin

COPY --from=build-stage /go/src/github.com/rizki96/pemrogramindie/bin/pemrogramindie /opt/pemrogramindie/bin/
RUN chmod +x /opt/pemrogramindie/bin/pemrogramindie

CMD /opt/pemrogramindie/bin/pemrogramindie
