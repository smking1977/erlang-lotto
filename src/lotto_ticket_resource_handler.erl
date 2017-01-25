-module(lotto_ticket_resource_handler).
-export([init/3, handle/2, terminate/3]).


init(_Type, Req, _Opts) ->
    io:fwrite('state resource handler called...\n '),
    {ok, Req, no_state}.
   

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req) ,
    {ID, Req3} = cowboy_req:binding(id, Req2),
    io:fwrite('state resource handler method: ~s, binding ~s  ~n ', [Method, ID]),


    case Method of
	<<"POST">> ->  
	    {ok, Req4} = cowboy_req:reply(200,Req3),
	    {ok, Req4, State};
	    
	<<"GET">> ->
	    io:fwrite('state resource - handle processing GET \n '),
	    Headers = [{<<"content-type">>, <<"application/json">>}],
	    
	    Msg = jsx:encode(lotto_ticket_server:details(1)),
	    {ok, Req4} = cowboy_req:reply(200, Headers, [Msg, "\n\n"] ,  Req3),
	    {ok, Req4, State}
	
    end.


terminate(_Reason, _Req, _State) ->
        io:fwrite('state resource handler terminate.\n '),

    ok.
