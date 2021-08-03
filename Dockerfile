#=================
# Build
#=================
FROM elixir:latest as build

COPY lib ./lib
COPY pages ./pages
COPY templates ./templates
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force

RUN export MIX_ENV=prod && mix deps.get && mix release

RUN APP_NAME="servo" && RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && mkdir /export && tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#=================
# Deployment
#=================
FROM erlang:latest

EXPOSE 4000
ENV REPLACE_OS_VARS=true PORT=4000

COPY --from=build /export/ .

USER default

ENTRYPOINT ["/opt/app/bin/servo"]
CMD ["foreground"]
