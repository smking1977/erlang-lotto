-module(lotto_app_api).

-export([create_ticket/2,
	 submit_result/1]).


create_ticket(User_id, [One, Two, _Three, _Four, _Five]= Ticket) when is_integer(One) andalso is_integer(Two) ->
    lotto_sup:start_ticket(User_id, Ticket).

submit_result(Result) ->
    gproc_ps:publish(l, all, {result, Result}).

  

