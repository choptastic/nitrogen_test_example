-module(db_collection).
-export([
	list/0,
	get/1,
	save/2,
	delete/1
]).

id() -> crypto:rand_uniform(0,99999999).

sort_list(List) ->
	lists:sort(fun({_, A}, {_, B}) -> A =< B end, List).

list() ->
	sort_list(do(fun() -> dets:foldr(fun(X, Acc) -> [X|Acc] end, [], games) end)).

save(new, Name) ->
	save(id(), Name);
save(ID, Name) ->
	do(fun() -> dets:insert(games, {ID, Name}) end).

delete(ID) ->
	do(fun() -> ok = dets:delete(games, ID) end).

get(ID) ->
	[Rec] = do(fun() -> dets:lookup(games, ID) end),
	Rec.

do(Fun) ->
	{ok, games} = dets:open_file(games, [{type, set}, {keypos, 1}]),
	Result = Fun(),
	dets:close(games),
	Result.
