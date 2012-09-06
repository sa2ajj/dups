all: dups

get-deps:
	@rebar get-deps

dups: compile
	@rebar escriptize

compile:
	@rebar compile
