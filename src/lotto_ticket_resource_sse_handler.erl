-module(lotto_ticket_resource_sse_handler).

-export([
	 init/3,
	 info/3,
	 terminate/3
	]).

init(_Type, Req, _Opts) ->
    io:fwrite('sse resource handler called...\n '),
    {ID, Req2} = cowboy_req:binding(id, Req),
    gproc_ps:subscribe(l, {monitor}),

    io:fwrite('sse resource handler subscribed to GPROC...\n '),

    Headers = [{<<"content-type">>, <<"text/event-stream">>}],
    Ticket_details = lotto_ticket_server:details(list_to_integer(binary_to_list(ID))),
    {ok, Req3} = cowboy_req:chunked_reply(200, Headers,  cors_headers:allow_origin(Req2)),
     chunk(Req3, { Ticket_details, 1}),
    {loop, Req3, #{counter => 2}}.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Recieve notificatino of a winning ticket 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
info({gproc_ps_event, {monitor}, {_, ID}}, Req, #{counter := Counter} = S) ->
    io:fwrite('resource monitor recieved msg...\n '),
    Ticket_details = lotto_ticket_server:details(ID),
    case chunk(Req, { Ticket_details, Counter}) of
	ok ->
	    {loop, Req, S#{counter => Counter + 1}};        
	{error, _} ->
	    {ok, Req, S}
    end;

info({gproc_ps_event, {monitor}, {_, _}}, _Req,  _S) ->
    ok.

 chunk(Req, { Message, _Counter}) ->
    cowboy_req:chunk([jsx:encode(Message), "\n\n"], Req).

terminate(_Reason, _Req, _State) ->
    gproc:goodbye().
