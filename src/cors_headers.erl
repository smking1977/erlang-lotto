-module(cors_headers).

-export([
    allow_origin/1,
    options/3
]).

allow_origin(Req1) ->
    {Headers, Req2} = cowboy_req:headers(Req1),
    case proplists:get_value(<<"origin">>, Headers, undefined) of
        undefined ->
            Req2;
        Origin ->
            cowboy_req:set_resp_header(<<"Access-Control-Allow-Origin">>, Origin, Req2)
    end.

options(Req, State, Allowed) ->
    {Headers, Req1} = headers(Req),
    case {orddict:find(<<"origin">>, Headers), orddict:find(<<"access-control-request-method">>, Headers), orddict:find(<<"access-control-request-headers">>, Headers)} of
        {{ok, Origin}, {ok, RequestMethod}, {ok, RequestHeaders}} ->
            case ordsets:is_element(RequestMethod, Allowed) of
                true ->
                    Req2 = cowboy_req:set_resp_header(<<"Access-Control-Allow-Methods">>, methods(Allowed), Req1),
                    Req3 = cowboy_req:set_resp_header(<<"Access-Control-Allow-Origin">>, Origin, Req2),
                    Req4 = cowboy_req:set_resp_header(<<"Access-Control-Allow-Headers">>, RequestHeaders, Req3),
                    {ok, Req4, State};
                false ->
                    {ok, Req1, State}
            end;
        _ ->
            {ok, Req1, State}
    end.

headers(Req) ->
    {Headers, Req1} = cowboy_req:headers(Req),
    {orddict:from_list(Headers), Req1}.

methods(Allowed) ->
    list_to_binary(lists:foldr(fun(Method, <<>>) -> [Method]; (Method, A) ->
        [Method, <<", ">> | A] end, <<>>, Allowed)).
