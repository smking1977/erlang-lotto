-module(lotto_api).

-export([create_ticket/2,
	 submit_result/1,
	 publish_new_ticket/1,
	 publish_loosing_ticket/1,
	 publish_winning_ticket/1]).


create_ticket(User_id, [One, Two, _Three, _Four, _Five]= Ticket) when is_integer(One) andalso is_integer(Two) ->
    lotto_sup:start_ticket(User_id, Ticket).

submit_result(Result) ->
    gproc_ps:publish(l, {result}, {result, Result}).

  
publish_new_ticket(ID) ->
    gproc_ps:publish(l, {monitor}, {new, ID}).

publish_loosing_ticket(ID) ->
    gproc_ps:publish(l, {monitor}, {loser, ID}).

publish_winning_ticket(ID) ->
    gproc_ps:publish(l, {monitor}, {winner, ID}).
