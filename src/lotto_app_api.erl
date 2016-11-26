-module(lotto_app_api).

-export([create_ticket/2]).


create_ticket(User_id, [One, Two, _Three, _Four, _Five]= Ticket) when is_integer(One) andalso is_integer(Two) ->
    lotto_ticket_server:start_link(User_id, Ticket).




