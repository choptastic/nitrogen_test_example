-module(index).
-include_lib("nitrogen_core/include/wf.hrl").
-compile(export_all).

main() -> #template{file="site/templates/bare.html"}.

title() -> "My Board Game Collection".

body() ->
	[
		#h1{text="My Board Game Manager"},
		#panel{id=wrapper, body=my_games()}
	].

my_games() ->
	Games = db_collection:list(),
	[
		#h3{text="My games"},
		#button{id=add, text="Add Game to Collection", postback=add},
		draw_games(Games)
	].

draw_games([]) ->
	#panel{text="No games added to your collection yet"};
draw_games(Games) ->
	#table{rows=[
		draw_list_header(),
		[draw_game(G) || G <- Games]
	]}.

draw_list_header() ->
	#tablerow{cells=[
		#tableheader{text="Game Name"},
		#tableheader{},
		#tableheader{}
	]}.

draw_game({ID, Name}) ->
	#tablerow{cells=[
		#tablecell{text=Name},
		#tablecell{body=#button{text="Edit", postback={edit, ID}}},
		#tablecell{body=#button{text="Delete", postback={delete, ID}}}
	]}.

open_edit_form(new) ->
	open_edit_form(new, "");
open_edit_form(ID) ->
	{ID, Game} = db_collection:get(ID),
	open_edit_form(ID, Game).

open_edit_form(ID, Game) ->
	wf:update(wrapper, draw_edit_form(ID, Game)).

draw_edit_form(ID, Game) ->
	Action = ?WF_IF(ID==new, "Add", "Edit"),
	[
		#h3{text=[Action," a Game"]},
		#label{text="Game Name"},
		#textbox{id=name, text=Game},
		#br{},
		#button{id=save, text="Save", postback={save, ID}},
		#link{text="Cancel", postback=redraw_list}
	].

save(ID) ->
	Name = wf:q(name),
	db_collection:save(ID, Name),
	redraw_list().


redraw_list() ->
	wf:update(wrapper, my_games()).

delete(ID) ->
	db_collection:delete(ID),
	redraw_list().

event({delete, ID}) ->
	delete(ID);
event(add) ->
	open_edit_form(new);
event({edit, ID}) ->
	open_edit_form(ID);
event({save, ID}) ->
	save(ID),
	?wf_test_event(save);
event(redraw_list) ->
	redraw_list().
	


%%%%%%%% TESTS %%%%%%%%%%%%

test_main() ->
	wf_test:start(fun tests/0),
	main().

tests() ->
	SampleName = "My Test " ++ wf:to_list(crypto:rand_uniform(1, 9999999)),
	?wf_test_auto(open_add, test_add_open()),
	?wf_test_auto(test_set_name,test_set_name(SampleName)),
	?wf_test_manual(save, test_save(SampleName)),
	?wf_test_js(test_save_exists, test_save_exists(SampleName)),
	?wf_test_js(test_delete, test_delete(SampleName)),
 	ok.

test_add_open() ->
	{
		fun() -> wf:wire(add, #click{}) end, %%setup
		fun() -> wf:q(name) == "" end,%% Assertion
		[{delay, 200}] %% We delay because the click takes some time to use
	}.

test_set_name(SampleName) ->
	{
		fun() -> wf:set(name, SampleName) end,
		fun() -> wf:q(name) == SampleName end
	}.

test_save(SampleName) ->
	{
		fun() -> wf:wire(save, #click{}) end,
		fun() -> SampleName == wf:q(name) end
	}.

test_save_exists(SampleName) ->
	{
		undefined, %% Nothing needed to setup
		"return $(\".tablecell:contains('" ++ SampleName ++ "')\").text()",
		fun([FoundName]) -> SampleName == FoundName end
	}.

test_delete(SampleName) ->
	MainSelector = "\".tablecell:contains('" ++ SampleName ++ "')\"",
	JS = wf:f("$(~s).siblings().find('input[value=Delete]').click()", [MainSelector]),
	{
		fun() -> wf:wire(JS) end,
		"return $(" ++ MainSelector ++ ").text()",
		fun([""]) -> true end,
		[{delay, 200}]
	}.
