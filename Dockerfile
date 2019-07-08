FROM elixir:1.9

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get

COPY config ./config
COPY lib ./lib

RUN mix escript.build
ENTRYPOINT ["./elevio"]