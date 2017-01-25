-module(lotto).

-export([start/0]).


start() ->

    io:fwrite('Started Lotto.erl ..\n '),
    application:ensure_all_started(?MODULE).

  







