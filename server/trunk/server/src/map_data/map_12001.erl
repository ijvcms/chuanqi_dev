-module(map_12001).
-export([
	range/0,
	data/0
]).
range() -> {20, 12}.
data() ->
{
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,1},
	{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}.
