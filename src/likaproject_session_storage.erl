-module(likaproject_session_storage).

-export([create/0, lookup/1, insert/2]).

-define(ETS_TABLE, table).

create() ->
    ets:new(?ETS_TABLE, [public, named_table, set]).

lookup(Key) ->
    case ets:lookup(?ETS_TABLE,Key) of
        [{_, Value}] ->
            Value;
        [] ->
            undefined
        end.
    
insert(Key, Value) ->
    ets:insert(?ETS_TABLE, {Key, Value}).

