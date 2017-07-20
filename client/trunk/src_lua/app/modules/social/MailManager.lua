--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-10-11 
-- 邮件数据管理器
MailManager = MailManager or class("MailManager",BaseManager)

--构造
function MailManager:ctor()	
	MailManager.Instance=self
	self.mailInfo = MailInfo.new()	--主角相关信息
	self.showingMailWin = false
	local function onMailWin(data)
		if data.data then
			self.showingMailWin = true
		else
			self.showingMailWin = false
		end
	end
	self.mailWinEvent = GlobalEventSystem:addEventListener(MailEvent.MAIL_WIN_STATE_CHANGE,onMailWin)
end

function MailManager:getInstance()
	if MailManager.Instance==nil then
		MailManager.new()
	end
	return MailManager.Instance
end

