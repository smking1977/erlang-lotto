-module(lotto_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).
-export([start_ticket/2]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    io:fwrite("Hello  ~n ", []),

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    ChildSpec = #{id => mon,
	    start => {lotto_mon, start_link, []},
	    restart => permanent,
	    shutdown => 2000,
	    type => worker},
    _CounterSpec = {?MODULE, 
			   {counter,
			    {lotto_mon,  start_link, []},
			    Restart, 
			    Shutdown ,
			    Type ,
			    [sb_game]}},
    
			  
    
    io:fwrite("Hello2  ~n ", []),
    Procs = [ChildSpec],

    {ok, {{one_for_one, 1, 5}, Procs}}.

start_ticket(Id, Ticket) ->
    
    io:fwrite('supervisor- start_ticket '),

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    supervisor:start_child(?MODULE, 
			   {Id,
			    {lotto_ticket_server,  start_link, [Id,Ticket]},
			    Restart, 
			    Shutdown ,
			    Type ,
			    [sb_game]}
			  ).

