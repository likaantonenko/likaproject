-module(likaproject_user_storage).

-export([create_table/0, create/2, read/1, update/2, delete/1]).

-define(ETS_TABLE, user_table).
-record(user, {username, password}).

create_table() ->
    ets:new(?ETS_TABLE, [public, named_table, set, {keypos, #user.username}]).

create(Key, Value) ->
    ets:insert(?ETS_TABLE, #user{username = Key, password = Value}).

read(Key) ->
    case ets:lookup(?ETS_TABLE, Key) of
        [User] -> 
            {ok, User};
        [] -> 
            not_found
    end.

update(Key, Value) ->
    ets:insert(?ETS_TABLE, #user{username = Key, password = Value}).

delete(Key) ->
    ets:delete(?ETS_TABLE, Key).