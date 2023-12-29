{application, 'likaproject', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['likaproject_app','likaproject_auth_handler','likaproject_auth_server','likaproject_sup']},
	{registered, [likaproject_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{optional_applications, []},
	{mod, {likaproject_app, []}},
	{env, []}
]}.