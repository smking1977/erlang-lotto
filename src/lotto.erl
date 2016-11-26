-module(lotto).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([start/0]).


start() ->
    application:ensure_all_started(?MODULE).

start(_Type, _Args) ->
    lotto_sup:start_link().

stop(_State) ->
    ok.
