-module(test_index).
-include_lib("nitrogen_core/include/wf.hrl").
-compile(export_all).

main() ->
	wf_test:start_other(index, fun tests/0).

tests() ->
	ok.
