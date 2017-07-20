%% Author: ming
%% Created: 2012-6-7
%% Description: TODO: 协议数据封装

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 协议说明
%% 整型有符号
%% 8位，1字节，最大整数为127
%% 16位，2字节，最大整数为32767
%% 32位，4字节，最大整数为2147483647
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(pt).

-define(ENDING, little).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

%%
%% Exported Functions
%%
-export([
	read_string/1,
	pack/2,
	write_string/1,
	read_cmd/2,
	client_read_cmd/2,
	write_cmd/2,
	client_write_cmd/2
]).

%%
%% API Functions
%%
read_string(Bin) ->
	case Bin of
		<<Len:16/?ENDING-unsigned, Bin1/?ENDING-binary>> ->
			case Bin1 of
				<<Str:Len/?ENDING-binary-unit:8, Rest/?ENDING-binary>> ->
					{util_data:to_binary(Str), Rest};
				_R1 ->
					{<<>>, <<>>}
			end;
		R3 ->
			?WARNING("r3 : ~p", [R3]),
			{<<>>, <<>>}
	end.

pack(Cmd, Data) ->
	L = byte_size(Data) + 3,
	case L > 65536 of
		true ->
			?ERR("!!!!!!!! lage cmd: ~p", [Cmd]);
		_ ->
			skip
	end,
	<<L:16/?ENDING-unsigned, 0:8/?ENDING-unsigned, Cmd:16/?ENDING-unsigned, Data/?ENDING-binary>>.

write_string(Str) ->
	StrBin = util_data:to_binary(Str),
	StrLen = byte_size(StrBin),
	StrBin1 = <<StrLen:16/?ENDING-unsigned, StrBin/?ENDING-binary>>,
	{ok, StrBin1}.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 读取协议数据内部实现
%% 返回格式示例 对应于config_record.hrl文件里面的record
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_cmd(CMD, Bin) ->
	case proto_config:read(CMD) of
		{RecordName, ReadList} ->
			{_Bin1, InfoList} = read_proto(ReadList, Bin, []),
			{ok, util_list:list_to_record(RecordName, InfoList)};
		_ ->
			{ok, {}}
	end.

client_read_cmd(CMD, Bin) ->
	{RecordName, ReadList} = proto_config:write(CMD),
	{_Bin1, InfoList} = read_proto(ReadList, Bin, []),
	{ok, util_list:list_to_record(RecordName, InfoList)}.

read_type(Type, Bin) ->
	ReadList = proto_config:type(Type),
	{Bin1, InfoList} = read_proto(ReadList, Bin, []),
	{Bin1, util_list:list_to_record(Type, InfoList)}.

read_proto([], Bin, List) ->
	{Bin, List};
read_proto([H | T], Bin, List) ->
	{Data1, Bin1} = read_element(H, Bin),
	read_proto(T, Bin1, List ++ [Data1]).

read_element(Type, Bin) when is_number(Type) ->
	case Type =:= 64 of
		true ->
			{Data1, Bin1} = read_string(Bin),
			{util_data:to_integer(Data1), Bin1};
		_ ->
			<<Data1:Type/?ENDING, Bin1/?ENDING-binary>> = Bin,
			{Data1, Bin1}
	end;
read_element(Type, Bin) when Type == string ->
	{Data1, Bin1} = read_string(Bin),
	{Data1, Bin1};
read_element(Type, Bin) when Type == bytes ->
	{Bin, <<>>};
read_element(Type, Bin) when is_list(Type) ->
	{Bin1, Data1} = read_pro_list(Type, Bin),
	{Data1, Bin1};
read_element(Type, Bin) ->
	{Bin1, Data1} = read_type(Type, Bin),
	{Data1, Bin1}.

read_pro_list(ListTemplate, Bin) ->
	<<Len:16/?ENDING-unsigned, Bin1/?ENDING-binary>> = Bin,
	read_pro_list_1(Len, ListTemplate, Bin1, []).

read_pro_list_1(0, _ListTemplate, Bin, List) ->
	{Bin, List};
read_pro_list_1(Len, ListTemplate, Bin, List) ->
	{Bin1, DataList1} = read_template(ListTemplate, Bin),
	read_pro_list_1(Len - 1, ListTemplate, Bin1, List ++ [DataList1]).

read_template([], Bin) ->
	{Bin, []};
read_template([Type], Bin) ->
	{Data1, Bin1} = read_element(Type, Bin),
	{Bin1, Data1}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 打包写协议数据内部实现
%% 返回一个组装好的binary，格式：{ok, Binary}
%% 注意格式要与模版相匹配
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_cmd(CMD, DataRecord) ->
	{RecordName, WriteTemplateList} = proto_config:write(CMD),
	case is_record(DataRecord, RecordName) of
		true ->
			DataList = util_list:record_to_list(DataRecord),
			{ok, write_pro(WriteTemplateList, DataList, <<>>)};
		_ ->
			?ERR("write proto wrong cmd is ~p, data record is ~p, template is ~p", [CMD, DataRecord, WriteTemplateList])
	end.

client_write_cmd(CMD, DataRecord) ->
	{RecordName, WriteTemplateList} = proto_config:read(CMD),
	case is_record(DataRecord, RecordName) of
		true ->
			DataList = util_list:record_to_list(DataRecord),
			{ok, write_pro(WriteTemplateList, DataList, <<>>)};
		_ ->
			?ERR("write proto wrong cmd is ~p, data record is ~p, template is ~p", [CMD, DataRecord, WriteTemplateList])
	end.

write_type(Type, DataRecord) ->
	WriteTemplateList = proto_config:type(Type),
	case is_record(DataRecord, Type) of
		true ->
			DataList = util_list:record_to_list(DataRecord),
			write_pro(WriteTemplateList, DataList, <<>>);
		_ ->
			?ERR("write type wrong type is ~p, data record is ~p, template is ~p", [Type, DataRecord, WriteTemplateList])
	end.

write_pro(_TemplateList, [], Bin) ->
	Bin;
write_pro([Th | TT], [H | T], Bin) ->
	DataBin = write_element(Th, H),
	write_pro(TT, T, <<Bin/?ENDING-binary, DataBin/?ENDING-binary>>).

write_element(Type, Element) when is_number(Type) ->
	case Type =:= 64 of
		true ->
			Element1 = util_data:to_list(Element),
			{ok, DataBin} = write_string(Element1),
			DataBin;
		_ ->
			case Element =:= undefined of
				true ->
					<<0:Type/?ENDING>>;
				_ ->
					<<Element:Type/?ENDING>>
			end
	end;
write_element(Type, Element) when Type == string ->
	{ok, DataBin} =
		case Element =:= undefined of
			true ->
				write_string("");
			_ ->
				write_string(Element)
		end,
	DataBin;
write_element(Type, Element) when Type == bytes ->
	case Element =:= undefined of
		true ->
			<<>>;
		_ ->
			Element
	end;
write_element(Type, Element) when is_list(Type) ->
	case Element =:= undefined of
		true ->
			write_pro_list(Type, []);
		_ ->
			write_pro_list(Type, Element)
	end;
write_element(Type, Element) ->
	write_type(Type, Element).

write_pro_list(TemplateList, DataList) ->
	Len = length(DataList),
	write_pro_list_1(TemplateList, Len, DataList).

write_pro_list_1(TemplateList, Len, DataList) ->
	F = fun(Tuple) ->
		write_single_list(TemplateList, Tuple)
	end,
	DataListBin = list_to_binary([F(X) || X <- DataList]),
	<<Len:16/?ENDING-unsigned, DataListBin/?ENDING-binary>>.

write_single_list(_, []) ->
	<<>>;
write_single_list([Type], Info) ->
	DataBin = write_element(Type, Info),
	<<DataBin/?ENDING-binary>>.