%%%-------------------------------------------------------------------
%%% @author qhb
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 五月 2016 下午3:09
%%%-------------------------------------------------------------------
-module(email_lib).
-include("common.hrl").
-include("email.hrl").

-define(EMAIL_SMTP, "smtp.qq.com").
-define(EMAIL_SENDER, "3032229047@qq.com").
-define(EMAIL_PWD, "xktmystlbfevdcif").

%% API
-export([
	send/3,
	send_and_log/4,
	test/0
]).

test() ->
	Data = "通过测试",
	email:send(#email{server_ip   = "smtp.qq.com",
		account     = "3041386976@qq.com",
		password    = "xktmystlbfevdcif",
		subject     = "smtp邮件测试",
		text        = Data,
		%%attachment  = ["testfiles/test.doc", "testfiles/test.html", "testfiles/test.tar", "testfiles/test.txt"],
		to_emails   = ["3041386976@qq.com"]}).

send_and_log(Title, Content, EmailGroup, _Type) ->
	case config:get_server_no() > 0 of
		true ->
			%% log
			send(Title, Content, EmailGroup);
		false ->
			skip
	end,
	ok.

send(Title, Content, EmailGroup) ->
	ServerId = config:get_server_no(),
	NewTitle = lists:concat([util_data:to_list(Title), "(", util_data:to_list(ServerId), ")"]),
	Data = util_data:to_binary(Content),
	EmailList = case email_cfg:get(EmailGroup) of
					[] -> email_cfg:get_all();
					EList -> EList
				end,
	email:send(#email{server_ip = ?EMAIL_SMTP,
		account = ?EMAIL_SENDER,
		password = ?EMAIL_PWD,
		subject = NewTitle,
		text = Data,
		to_emails = EmailList
	}).
