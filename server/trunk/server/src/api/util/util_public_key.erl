%% @author qhb
%% @doc @todo Add description to util_public_key.


-module(util_public_key).
-include_lib("public_key/include/public_key.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	enc_pri/1,
	dec_pri/1,
	test/0
]).

enc_pri(Data) ->
	{ok, PriKeyBin} = file:read_file("wewars_server/pri/private_key.pem"),
	[PrivEntry] = public_key:pem_decode(PriKeyBin),
	Priv = public_key:pem_entry_decode(PrivEntry, "134711"),

	%%BinData = base64:decode(Data),
	Priv0 = private_key(Priv),

	Result = public_key:encrypt_private(Data, Priv0),
	Result.

dec_pri(Data) ->
	{ok, PriKeyBin} = file:read_file("wewars_server/pri/private_key.pem"),
	[PrivEntry] = public_key:pem_decode(PriKeyBin),
	Priv = public_key:pem_entry_decode(PrivEntry, "134711"),

	%%BinData = base64:decode(Data),
	Priv0 = private_key(Priv),

	Result = public_key:decrypt_private(Data, Priv0),
	Result.

test() ->
	Result = test_enc_pub(<<"aaaa">>),
	Result.

test_enc_pub(Data) ->
	{ok, PubKeyBin} = file:read_file("wewars_server/pri/rsa_public_key.pem"),
	[Entry] = public_key:pem_decode(PubKeyBin),
	Pub = public_key:pem_entry_decode(Entry),

	%%BinData = base64:decode(Data),

	Result = public_key:encrypt_public(Data, Pub),
	base64:encode_to_string(Result).

test_enc_pri(Data) ->
	{ok, PriKeyBin} = file:read_file("wewars_server/pri/private_key.pem"),
	[PrivEntry] = public_key:pem_decode(PriKeyBin),
	Priv = public_key:pem_entry_decode(PrivEntry, "134711"),

	%%BinData = base64:decode(Data),
	Priv0 = private_key(Priv),

	Result = public_key:encrypt_private(Data, Priv0),
	Result.


%% ====================================================================
%% Internal functions
%% ====================================================================

private_key(#'PrivateKeyInfo'{privateKeyAlgorithm =
#'PrivateKeyInfo_privateKeyAlgorithm'{algorithm = ?'rsaEncryption'},
	privateKey = Key}) ->
	public_key:der_decode('RSAPrivateKey', iolist_to_binary(Key));

private_key(#'PrivateKeyInfo'{privateKeyAlgorithm =
#'PrivateKeyInfo_privateKeyAlgorithm'{algorithm = ?'id-dsa'},
	privateKey = Key}) ->
	public_key:der_decode('DSAPrivateKey', iolist_to_binary(Key));
private_key(Key) ->
	Key.
