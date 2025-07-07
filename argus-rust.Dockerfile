# as per https://hub.docker.com/_/rust
FROM rust:1.88-alpine AS builder
RUN apk add --no-cache musl-dev gcc
WORKDIR /usr/src/argus
# there is a change that this is quite wasteful as i'm copying db shit as well
COPY . . 
RUN cargo build --release

FROM alpine:3.20
RUN adduser -D -u 1000 argus
COPY --from=builder /usr/src/argus/target/release/argus /usr/local/bin/argus
RUN chown argus:argus /usr/local/bin/argus
USER argus
CMD ["argus"]
