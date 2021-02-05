# syntax=docker/dockerfile:experimental
FROM ubuntu:18.04 AS build

ENV MIX_ENV=prod \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget gnupg2 git \
    && wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang-solutions_2.0_all.deb \
    && apt-get update \
    && apt-get install -y openssl \
    && apt-get install -y esl-erlang \
    && apt-get install -y elixir \
    && mix local.hex --force \
    && mix local.rebar --force

ENV GOTH_CREDENTIALS=/app/gcp-credentials.json

RUN mkdir /app

WORKDIR /app

COPY . .

# Fetch the application dependencies and build the application
RUN --mount=type=secret,id=prod_secret,dst=/app/config/prod.secret.exs \
    --mount=type=secret,id=gcp_credentials,dst=/app/gcp-credentials.json \
    --mount=type=secret,id=hex_key,dst=/app/hex_key \
    export HEX_KEY=$(cat /app/hex_key) && \
    mix hex.organization auth cariq --key $HEX_KEY && \
    mix deps.get && mix release


# ------------------------------------------------------------------------------
# Application container
# ------------------------------------------------------------------------------

FROM ubuntu:18.04

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget openssl \
 && mkdir -p /opt/app/etc

WORKDIR /opt/app

COPY --from=build /app/_build/prod/rel/cariq_fuel/ .
COPY ./bin ./bin
COPY ./entrypoint.sh /

RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s \
    CMD ./bin/healthz || exit 1

EXPOSE 50051
EXPOSE 8443

ENTRYPOINT ["/entrypoint.sh"]
