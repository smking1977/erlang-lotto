-module(lotto_application).
-behaviour(application).

-export([start/2]).
-export([stop/1]).


start(_Type, _Args) ->
    io:fwrite('Started Lotto_applcation.erl  ...\n '),
    Dispatch = cowboy_router:compile([
				       {'_', [
					     {"/lotto/ticket/:id", lotto_ticket_resource_handler, []},
					     {"/lotto/stream/:id", lotto_ticket_resource_sse_handler, []}

					     ]}
				      ]),
    io:fwrite('Cowboy routed  \n '),

    {ok, _} = cowboy:start_http(http, 100, [{port, 8282}],[{env, [{dispatch, Dispatch}]}]),
    io:fwrite('Cowboy started \n '),
    lotto_sup:start_link().

stop(_State) ->
    ok.
