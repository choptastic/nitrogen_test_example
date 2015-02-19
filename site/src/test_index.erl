-module(test_index).
-include_lib("nitrogen_core/include/wf.hrl").
-compile(export_all).

main() ->
	wf_test:start(fun tests/0),
	index:main().

title() -> index:title().

body() -> index:body().

tests() ->
	ok.

event(E) -> index:event(E).
