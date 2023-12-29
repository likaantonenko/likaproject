-module(likaproject_auth_handler).
-behavior(cowboy_handler).

-export([init/2]).
-export([content_types_provided/2]).
-export([is_authorized/2]).
-export([to_text/2]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
	{[
		{<<"text/plain">>, to_text}
	], Req, State}.

is_authorized(Req, State) ->
	case cowboy_req:match_cookies([{session_id, [], undefined}], Req) of
		#{session_id := undefined} ->
			case cowboy_req:parse_header(<<"authorization">>, Req) of
				{basic, User = <<"lika">>, <<"password">>} ->
					SessionId = integer_to_binary(erlang:unique_integer([monotonic])),
					likaproject_session_storage:insert(SessionId, User),
					Req1 = cowboy_req:set_resp_cookie(<<"session_id">>, SessionId, Req),
					State1 = [{session_id, SessionId} | State],
					{true, Req1, State1};
				_ ->
					{{false, <<"Basic realm=\"cowboy\"">>}, Req, State}
			end;
		#{session_id := SessionId} ->
			State1 = [{session_id, SessionId} | State],
			{true, Req, State1}	
	end.

to_text(Req, State) ->
	SessionId = proplists:get_value(session_id, State),
	User = likaproject_session_storage:lookup(SessionId),
	io:format("~p~n",[User]),
	{<< "Hello, ", User/binary, "!\n" >>, Req, undefined}.

