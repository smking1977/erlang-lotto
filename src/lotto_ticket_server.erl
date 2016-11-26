-module(lotto_ticket_server).
-behaviour(gen_server).

%% API.
-export([start_link/2]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).


%% API.
start_link(ID, Ticket) ->
	gen_server:start_link({global, ID} , ?MODULE, Ticket, []).

%% gen_server.

init([One, Two , Three, Four, Five]) ->
	{ok, #{ one => One, two => Two, three => Three, four => Four, five => Five}}.

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.