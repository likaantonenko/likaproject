-module(likaproject_auth_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
init(_Args) ->
    likaproject_session_storage:create(),
    likaproject_user_storage:create_table(),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", likaproject_auth_handler, []},
            {"/user", likaproject_user_handler, []}
        ]}
    ]),
    {ok, _State} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch, cookies => true}}
    ),
    {ok, _State}.
    

handle_cast(_Request, State) ->
    {noreply, State}.
    
handle_call(_Request, _From, State) -> 
    {reply, ok, State}.

handle_info(_Info, State) -> 
    {noreply, State}.

terminate(_Reason, State) -> 
    {ok, State}.

code_change(_OldVsn, State, _Extra) -> 
    {ok, State}.
    
    