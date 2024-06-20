FROM elixir:1.17-alpine

# install build deps
RUN apk update && \
    apk add --no-cache build-base git ffmpeg python3 py3-pip && \
    wget -q https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/bin/yt-dlp && \
    chmod a+rx /usr/bin/yt-dlp

WORKDIR /app

# elixir build tools
RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./

# install deps
RUN mix deps.get

# copy the rest of the code to the container
COPY . .


RUN mix compile

# default cmd on startup
CMD ["mix", "run", "--no-halt"]
#CMD ["iex", "-S", "mix"]