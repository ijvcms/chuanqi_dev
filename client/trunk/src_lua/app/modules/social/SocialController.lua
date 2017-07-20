--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-10-11 
-- 社交系统控制器
require("app.modules.social.MailInfo")
require("app.modules.social.MailManager")
require("app.modules.social.FriendManager")
SocialController = SocialController or class("SocialController",BaseController)

function SocialController:ctor()	
	SocialController.Instance = self
	self:initProtocal()
end

function SocialController:getInstance()
	if SocialController.Instance==nil then
		SocialController.new()
	end
	return SocialController.Instance
end

function SocialController:initProtocal( )

	--取得邮件信息列表
	self:registerProtocal(15001,handler(self,self.onHandle15001))
	--邮件信息改变
	self:registerProtocal(15002,handler(self,self.onHandle15002))
	--领取邮件奖励
	self:registerProtocal(15003,handler(self,self.onHandle15003))
	--删除邮件
	self:registerProtocal(15004,handler(self,self.onHandle15004))

	--我的好友
	self:registerProtocal(24000,handler(self,self.onHandle24000))
	--
	self:registerProtocal(24001,handler(self,self.onHandle24001))
	--
	self:registerProtocal(24002,handler(self,self.onHandle24002))
	--
	self:registerProtocal(24003,handler(self,self.onHandle24003))

	self:registerProtocal(24004,handler(self,self.onHandle24004))

	self:registerProtocal(24005,handler(self,self.onHandle24005))

	self:registerProtocal(24006,handler(self,self.onHandle24006))

	self:registerProtocal(24007,handler(self,self.onHandle24007))

	self:registerProtocal(24008,handler(self,self.onHandle24008))
 
 	self:registerProtocal(24009,handler(self,self.onHandle24009))
end

function SocialController:onHandle15001(data)
	print("onHandle15001")
	local mailManager = MailManager:getInstance()
	mailManager.mailInfo:initMails(data.mail_list)
	for i=1,#data.mail_list do
		if(data.mail_list[i].state == 0) then
			if GlobalController.fight:getScene() then
				if GlobalController.fight:getScene().loading then 			--如果loading界面正在显示,那么等loading完再显示
					self.eventFor15001 = nil 
					local function onShow()
						SystemNotice:newMailNotice()
						GlobalEventSystem:removeEventListenerByHandle(self.eventFor15001)
						self.eventFor15001 = nil 
					end
					self.eventFor15001 = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
				else
					SystemNotice:newMailNotice()
				end
			else
				-- print("no no no no no no no no no ")
			end
			break
		end
	end
end

function SocialController:onHandle15002(data)
	print("onHandle15002")
	dump(data)
	local mailManager = MailManager:getInstance()
	mailManager.mailInfo:changeMail(data.mail_info)
	GlobalEventSystem:dispatchEvent(MailEvent.MAIL_CHANGE,data.mail_info)
end

function SocialController:onHandle15003(data)
	print("onHandle15003")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"附件领取成功!"))
		--GlobalEventSystem:dispatchEvent(MailEvent.MAIL_PICK_SUCCESS,data.id)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function SocialController:onHandle15004(data)
	print("onHandle15004")
	if data.result == ERR_COMMON_SUCCESS then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,"删除邮件成功!"))
		local mailManager = MailManager:getInstance()
		mailManager.mailInfo:deleteMail({id = data.id})
		GlobalEventSystem:dispatchEvent(MailEvent.MAIL_DEL_SUCCESS,data.id)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end
--获取好友、黑名单、仇人列表
function SocialController:onHandle24000(data)
	print("onHandle24000")
 	--dump(data)
	if data ~= nil then
		FriendManager:getInstance():handlerInfo(data)
	end
end
--移除
function SocialController:onHandle24001(data)
	print("onHandle24001")

	if data.result == 0 then
		FriendManager:getInstance():handlerUpdate(data,0)
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"移除失败!")
	end
end
--拉黑
function SocialController:sendBlackList(player_id)
	GameNet:sendMsgToSocket(24002,{tplayer_id = player_id})
end
function SocialController:onHandle24002(data)
	print("onHandle24002")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"拉黑成功！")
	else
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"申请添加好友失败!")
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end
--申请添加好友
function SocialController:sendApplyFriend(player_id)
	GameNet:sendMsgToSocket(24003, {tplayerId = player_id})
end

function SocialController:onHandle24003(data)

	print("onHandle24003")

	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_APPLYFRIEND,data)
	else
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"申请添加好友失败!")
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end

end
--通过玩家id获取玩家信息
function SocialController:onHandle24004(data)
	print("onHandle24004")
end
--通过玩家名字获取玩家信息
function SocialController:onHandle24005(data)
	print("onHandle24005")

	if data.tplayer_id == "0" then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有该玩家!")
	else
		GlobalEventSystem:dispatchEvent(FriendEvent.FRIEND_RESEARCH,data)
	end
end
--刷新好友、黑名单、仇人列表
function SocialController:onHandle24006(data)
	print("onHandle24006")
	FriendManager:getInstance():handlerUpdate(data, 1)
end
--好友申请推送
function SocialController:onHandle24007(data)
	print("onHandle24007")

	FriendManager:getInstance():handlerApplyList(data)
		
end
--
function SocialController:onHandle24008(data)
	print("onHandle24008")
 
end

function SocialController:onHandle24009(data)
	print("onHandle24009")
	if data.result == 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"添加成功！")
		GameNet:sendMsgToSocket(24000,{type = 4})
	else
		--GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"申请添加好友失败!")
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end