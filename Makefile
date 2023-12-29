PROJECT = likaproject
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

BUILD_DEPS += relx

DEPS = cowboy
dep_cowboy_commit = 2.8.0

DEP_PLUGINS = cowboy

include erlang.mk
