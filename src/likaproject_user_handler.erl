-module(likaproject_user_handler).
-behavior(cowboy_rest).

-export([init/2]).
-export([allowed_methods/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).
-export([resource_exists/2]).
-export([delete_resource/2]).
-export([to_json/2]).
-export([put_json/3]).
-export([post_json/3]).
-export([delete_json/3]).

init(Req, State) ->
    {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>, <<"POST">>, <<"DELETE">>],
    {Methods, Req, State}.

content_types_provided(Req, State) ->
{[
    {<<"application/json">>, to_json}
], Req, State}.
    
content_types_accepted(Req, State) ->
    case cowboy_req:method(Req) of
        {<<"POST">>, _ } ->
            {[{<<"application/json">>, put_json}], Req, State};
        {<<"PUT">>, _ } ->
            {[{<<"application/json">>, post_json}], Req, State};
        {<<"DELETE">>, _ } ->
            {[{<<"application/json">>, delete_json}], Req, State}
       end.
    
resource_exists(Req, State) ->
    {true, Req, State}.

delete_resource(Req, State) ->
    {true, Req, State}.

to_json(Req, State) ->
    #{username := Username} = cowboy_req:match_qs([username], Req),
    io:format("~p~n",[Username]),
    {ok, {user, Username, Password}} = likaproject_user_storage:read(Username),
    {Password, Req, State}.

put_json({Username, Password}, Req, State) ->
    case likaproject_user_storage:create(Username, Password) of
        ok ->
            {<<"Created">>, Req, State};
        {error, Reason} ->
            {Reason, Req, State}
    end.
    
post_json({Username, Password}, Req, State) ->
    case likaproject_user_storage:update(Username, Password) of
        ok ->
            {<<"Updated">>, Req, State};
        {error, Reason} ->
            {Reason, Req, State}
    end.

delete_json({Username}, Req, State) ->
    case likaproject_user_storage:delete(Username) of
        ok ->
            {<<"Deleted">>, Req, State};
        {error, Reason} ->
            {Reason, Req, State}
    end.
