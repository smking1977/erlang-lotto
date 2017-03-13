-module(lotto_ticket_server).
-behaviour(gen_server).

%% API.
-export([start_link/2, details/1]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).


%% API.
start_link(ID, Ticket) ->
    gen_server:start_link({global, ID} , ?MODULE, {ID, Ticket}, []).

details(ID) ->
    gen_server:call({global, ID}, {ticket_details}).



%% gen_server.
init({ID, [One, Two , Three, Four, Five]}) ->
    self() ! {setup, ID},
    {ok, #{ id => ID, one => One, two => Two, three => Three, four => Four, five => Five, status=> possible_winner}}.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Return State of ticket 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_call({ticket_details},_From,  State) ->
    {reply, State, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({setup, ID}, State) ->
    gproc_ps:subscribe(l, {result}),
    lotto_api:publish_new_ticket(ID),
    {noreply, State};
%%%% Matching numbers
handle_info({gproc_ps_event, {result},{result, [One]}},  #{one := One} = State) ->
    io:fwrite('One Res - ~p  ~n ', [One]),
    {noreply, State};
handle_info({gproc_ps_event, {result}, {result, [One, Two]}},  #{one := One, two := Two} = State) ->
    io:fwrite('Two Num - ~p - ~p  ~n ', [One, Two]),
    {noreply, State};
handle_info({gproc_ps_event, {result}, {result, [One, Two, Three]}},  #{one := One, two := Two, three := Three } = State) ->
    io:fwrite('Three  Num - ~p - ~p - ~p  ~n ', [One, Two, Three]),
    {noreply,  State};
handle_info({gproc_ps_event, {result}, {result, [One, Two, Three, Four]}},  #{one := One, two := Two, three := Three, four := Four } = State) ->
    io:fwrite('Four  Num - ~p - ~p - ~p - ~p  ~n ', [One, Two, Three, Four]),
    {noreply,  State};

%%%% Winning tickets
handle_info({gproc_ps_event, {result}, {result, [One, Two, Three, Four, Five]}},  #{one := One, two := Two, three := Three, four := Four, five := Five,  status := winner } = State) ->
    %io:fwrite('Still a winner ~n '),
    {noreply,  State};
handle_info({gproc_ps_event, {result}, {result, [One, Two, Three, Four, Five]}},  #{one := One, two := Two, three := Three, four := Four, five := Five,  id := ID } = State) ->
    %io:fwrite('WINNER ~n '),
    lotto_api:publish_winning_ticket(ID),
    {noreply,  State#{status => winner}};

%% Loosing tickets
handle_info({gproc_ps_event,  {result} , {result, _}},  #{status := loser} = State) ->
  %  io:fwrite('STILL A LOSER!!!!! ~n'),
    {noreply, State};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loosing Message received for first time 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_info({gproc_ps_event,  {result} , {result, _}},  #{id := ID} =State) ->
 %  io:fwrite('LOSER!!!!! ~n'),
    lotto_api:publish_loosing_ticket(ID),
    lotto_api:publish_to_ticket_monitor(ID),

    {noreply,  State#{status => loser}};
handle_info({gproc_ps_event, {mon}, _},  State) ->
    io:fwrite('MSG in lotto ticket ERROR ~n'),  %%%%% TEMP
    {noreply, State};
handle_info(_, State) ->
    io:fwrite('Bollox ~n'),
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
