-module(lotto_mon).
-behaviour(gen_server).

%% API.
-export([start_link/0, count/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).



%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link({global, monitor}, ?MODULE, [], []).
count() ->
	gen_server:call({global, monitor}, {ticket_count}).

%% gen_server.

init([]) ->
    gproc_ps:subscribe(l, {monitor}),
    {ok, #{count => 0, winner => 0 , loser =>0, winning_numbers => [] }}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Return State of Ticket Statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_call({ticket_count},_From,  State) ->
    {reply, State, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Recieve notification of a  new ticket
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_info({gproc_ps_event, {monitor},{new, _ID}}, #{count := Count} = State) ->
    %io:fwrite('MON-COUNT  ~n '),

    {noreply, State#{count => Count+1}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Recieve notifictaion of a losing ticket 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_info({gproc_ps_event, {monitor} ,{loser, _ID}}, #{loser := Count} = State) ->
    {noreply, State#{loser => Count+1}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Recieve notificatino of a winning ticket 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_info({gproc_ps_event, {monitor} ,{winner, ID}}, #{winner := Count, winning_numbers := Winners} = State) ->
    {noreply, State#{winner => Count+1, winning_numbers => Winners ++ [ID]}};


handle_info(_Info, State) ->
    io:fwrite('MONITOR has recieved some bollox  ~n '),
    {noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
