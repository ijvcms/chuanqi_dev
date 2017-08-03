--
-- Author: 21102585@qq.com
-- Date: 2014-11-08 14:33:56
-- 游戏model

GameModel=GameModel or class("GameModel")

function GameModel:ctor()
	self:init()
end

function GameModel:init()
	self.clientVer = "" --客户端版本
	self.serverVer = "" --服务器版本

	self.imei = ""   --设备唯一标示

	self.isForeground = true --是否进入前台

	self.os_type = 0 --操作系统类型 1表示安卓，2表示ios

	self.platform = 1000 --平台名称 渠道编号
	self.open_id = ""    --平台id
	self.curServerId = 0 --服务器ID 1
	self.loginServerList = {} --登陆过的服务器列表
	self.selServerInfo = nil --当前选择的服务器信息 {1,"001服 外网服","121.40.240.112"}

	self.curServerRoleArr = {} --当前服务器角色列表

	self.platformUserID = 12345 --平台账号ID
	self.platformUserName = "username"--平台账号名

	self.ip = ""
	self.host = ""
	self.isConnect = false

	self.serverTime = 0 --服务器时间
	
    self.serverCount = 0 --服务器数量
    self.serverList = {} --服务器数据

	self.player_id = "1" --玩家角色ID
	self.name = "" --玩家角色昵称
	self.sex = 1--
	self.career = 1000
	self.lv = 1

	self.initDataOK = false --初始化数据是否完成GlobalModel
	self.initViewOK = false --初始化视图是否完成GlobalModel

	self.firstInitScene = true

	self.downPackageLv = 0  --下载分包等级

	self.isGaming = false -- 是否已经开始游戏(登陆进入游戏进度完毕之后应设置为true)
    --self.isLoginOp = false -- 打开游戏后是否已经登陆过，用于记录注销时候的界面切换情况

	self.isDebug = false
	if self.isDebug then
		self.ip = "192.168.10.2"--"192.168.10.3"
		self.port = 10011
	else
		--self.ip = "121.40.240.112"-- "192.168.10.3"
		self.ip = "192.168.10.2"-- "192.168.10.3"
		self.port = 10011
	end

	self.hideNavigation = false
    --self.version = "00.16.04.18"
	self.showDisconnectTip = true --是否显示断线提示
	self.systemNoticeURL = "http://123.206.225.144/chuanqi_mg/index.php?s=/Home/Index/post&istest="..DEBUG --获取登陆通知地址URL
	self.remotePackagePhpUrl = "http://127.0.0.1/chuanqi20170701/index.php/Home/Index/package"--"http://txsc.wewars.com/chuanqi/index.php/Home/Index/package" --获取分包地址URL
	--    "http://www.xiaoniaowan.com/cq_package/package.php"
	self.isPaying = false -- 是否在进入支付

	self.card_state = 0 --新手卡（兑换码）

	self.curLine = 0 --当前线路
	self.lineList = {}--线路列表
end

function GameModel:getServerName(id)
	local vo;
	for i=1,#self.serverList do
		vo = self.serverList[i]
		if vo.id == id then
			return vo.name
		end
	end
	return id
end

--GlobalModel:setIsConnect(b)
function GameModel:setIsConnect(b)
	self.isConnect = b
end

function GameModel:getIsConnect()
	return self.isConnect
end
