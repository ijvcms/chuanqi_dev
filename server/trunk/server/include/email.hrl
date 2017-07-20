-record(email, {
          server_ip   , % (必填) 邮件服务器ip(如: "smtp.qq.com")
          account     , % (必填) 你自己的邮箱名(如: "3041386976@qq.com")
          password    , % (必填) 密码
          to_emails   , % (必填) 要发往的邮箱(格式:["","",...])(如: ["3041386976@qq.com", "leptune@live.cn"])
          server_port , % (可选) 要传整数。如ssl为true，则默认端口为465, 否则默认端口为25，也可以手动指定
          ssl = true  , % (可选) 是否需要ssl加密(true 或 false)
          subject = "", % (可选) 邮件标题
          text        , % (可选) (正文)将文本内容发往邮箱，text的值为存放该内容的文件路径(路径以'/'分隔，不要以'\\'分隔)
          html        , % (可选) (正文)将网页内容发往邮箱，html值为该网页文件路径(注: 两个正文最多只能选一项。都选了只显示html)
          attachment    % (可选) (附件)要发往邮箱的文件路径(格式:["", "",...],如:["test.doc","test.tar"])(注意后缀名要对，否则不能预览)
}).

-record(socket, {type, sock}).

-define(SSL_SERV_PORT_DEF, 465).
-define(NOT_SSL_SERV_PORT_DEF, 25).
