-module(email_misc).
-export([index/2, split_binary_by_digit/2, basename/1]).

%% 取出二进制或列表里对应下标(从0开始)的值
index(Data, Index) when is_binary(Data) ->
    index(binary_to_list(Data), Index);
index(Data, Index)
    when is_list(Data), is_integer(Index),
    Index >= 0, Index < length(Data) ->
    index(Data, Index, 0).

index([D0 | _DRest], GivenIndex, CurrIndex)
    when GivenIndex =:= CurrIndex ->
    D0;
index([_D0 | DRest], GivenIndex, CurrIndex) ->
    index(DRest, GivenIndex, CurrIndex + 1).

%% 将二进制Bin按数字Digit分隔成左右两个二进制数
split_binary_by_digit(Bin, Digit)
    when is_binary(Bin),is_integer(Digit) ->
    split_binary_by_digit(Bin, Digit, <<>>).

split_binary_by_digit(<<>>, _Digit, _Left) ->
    {error, unmatched};
split_binary_by_digit(<<N, Rest/binary>>, Digit, Left) when N =/= Digit ->
    split_binary_by_digit(Rest, Digit, <<Left/binary, N>>);
split_binary_by_digit(<<_N, Rest/binary>>, _Digit, Left) ->
    {ok, Left, Rest}.

%% 取出文件路径中的文件名
basename(FilePath) when is_list(FilePath) ->
    case lists:member($/, FilePath) of
        false -> FilePath;
        true  -> basename(lists:reverse(FilePath), [])
    end.

basename([C | _Rest], BaseName) when C =:= $/ ->
    BaseName;
basename([C | Rest], BaseName) ->
    basename(Rest, [C | BaseName]).
