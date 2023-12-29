-module(likaproject_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Children = [
		#{
			id      => likaproject_auth_server,
			start   => {likaproject_auth_server, start_link, []},
			restart => permanent,
			type    => worker,
			modules => [likaproject_auth_server]
		}
	],
	SupFlags = #{
		strategy    => one_for_one,
		intensity   => 3000,
		period      => 1
	},
	{ok, {SupFlags, Children}}.