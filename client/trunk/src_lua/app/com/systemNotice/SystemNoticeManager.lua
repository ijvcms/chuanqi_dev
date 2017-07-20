--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-25 17:19:11
-- 系统通知管理器
local SystemNoticeManager = SystemNoticeManager or class("SystemNoticeManager",BaseManager)
SystemNoticeEvent ={
	ICON_NOTICE = "",--中间图标提示

}
--由上而下显示的tips(用于提示经验增加,金币增加等)
BPTIPS_TYPE_EXP = 1
BPTIPS_TYPE_COIN = 2
BPTIPS_TYPE_FEAT = 3 -- 功勋
BPTIPS_TYPE_CREDIT = 4 --声望 
BPTIPS_TYPE_JADE = 5 --元宝
BPTIPS_TYPE_GIFT = 6 --礼卷
BPTIPS_TYPE_MARK1 = 7 --生命印记
BPTIPS_TYPE_MARK2 = 8 --攻击印记
BPTIPS_TYPE_MARK3 = 9 --物理防御印记
BPTIPS_TYPE_MARK4 = 10 --魔法防御印记


SystemNoticeViewKey ={
	NEW_MAIL = "newMailView",
	NEW_FRIEND = "newFriendView",
	WOELD_NOTICE = "worldNoticeView",
	ANNOUNCEMENT = "AnnouncementView",
	NEW_TEAM = "newTeamView",
	NEW_TRADE = "newTradeView",
	NEW_UNION = "newUnionView",
	NEW_INVITEGUILD = "inviteGuildView",
	NEW_GUILDWAR = "guildWarView",
	TEXT_TIPS = "textTipsView",
}

function SystemNoticeManager:ctor()	
	SystemNoticeManager.Instance=self
	self.sysTextTipsList = {}
	self.worldNoticeList = {}
	self.getItemsList = {}
	self.attValueTipsList = {}
	self.teamNoticeList = {}
	self.tradeNoticeList = {}
	self.unionNoticeList = {}
	self.inviteGuildNoticeList = {}
	self.guildWarNoticeList = {}

	local function onPopTextTips(data)
       	self:popTextTips(data.data)
    end
    if self.popTextTipEventId == nil then
	    self.popTextTipEventId = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_SYSTIPS, onPopTextTips)
	end
	 --切换场景时清掉tips队列
    local function onSwitchScene()
        self.getItemsList = {}
		self.sysTextTipsList = {}
		self.attValueTipsList = {}
    end
    if self.switchSceneEventId == nil then
	    self.switchSceneEventId = GlobalEventSystem:addEventListener(GlobalEvent.SCENE_SWITCH, onSwitchScene)
	end
	
	--属性值  提示  缓存
	self.attValueTipsCache = {1, 1, 1}
	self.attValueTipsNum = 0
	local attValueTips = require("app.com.systemNotice.view.AttValueTips")
	for i = 1, 3 do
		local node = attValueTips.new(self)
	    node:retain()
	    self.attValueTipsCache[i] = node
	end
end

function SystemNoticeManager:getInstance()
	if SystemNoticeManager.Instance==nil then
		SystemNoticeManager.new()
	end
	return SystemNoticeManager.Instance
end


--SystemNotice:popAttValueTips(info)
--属性值提示面板
function SystemNoticeManager:popAttValueTips(value,valueType,isNext)
	if GlobalController.curScene ~= SCENE_MAIN then return end
	if isNext then
		if #self.attValueTipsList > 0 and #self.attValueTipsCache > 0 then
			local data = table.remove(self.attValueTipsList,1)
			local view = self:getAttTips()
			if view then
				view:show(data.value, data.valueType,#self.attValueTipsCache)
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
				view:release()
			end
		end
	elseif #self.attValueTipsCache > 0 then
		local data = table.remove(self.attValueTipsList,1)
		local view = self:getAttTips()
		if view then 
			view:show(value, valueType,#self.attValueTipsCache)
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
			view:release()
		end
	elseif value then
		table.insert(self.attValueTipsList,{value = value, valueType = valueType})
	end
end
function SystemNoticeManager:getAttTips()
	if #self.attValueTipsCache > 0 then
		local view = table.remove(self.attValueTipsCache,1)
		view:retain()
		return view
	end
	return nil
end
function SystemNoticeManager:addAttTips(view)
	view:retain()
	table.insert(self.attValueTipsCache,view)
end




--SystemNotice:popTextTips({text = "",color=cc})
--系统文本提示
function SystemNoticeManager:popTextTips(param)
	if param then
		table.insert(self.sysTextTipsList,param)
	end
	if #self.sysTextTipsList == 1 or (param == nil and #self.sysTextTipsList >= 1) then
		local view = require("app.com.systemNotice.view.TextTipsView").new(self)
		--self[SystemNoticeViewKey.TEXT_TIPS] = view
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
		view:show(SystemNoticeViewKey.TEXT_TIPS,table.remove(self.sysTextTipsList,1))
	end
end


--SystemNotice:getItemsTips({text = "",color=cc})
--获取物品提示
function SystemNoticeManager:popGetItemsTips(param)
	if GlobalController.curScene ~= SCENE_MAIN then return end
	if param then
		table.insert(self.getItemsList,param)
	end
	if #self.getItemsList == 1 or (param == nil and #self.getItemsList >= 1) then
		local itemData = table.remove(self.getItemsList,1)
		local view = require("app.com.systemNotice.view.ItemNoticeView").new(self,itemData)
		--self[SystemNoticeViewKey.TEXT_TIPS] = view
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
		-- 在系统消息中增加获得物品消息
		local name = configHelper:getGoodNameByGoodId(itemData.goods_id)
		local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
		--容错
		local strData = serialize(itemData)
		if strData then
			local goodsContent = GlobalController.chat:getMetaDataUtil().FormatEqui(quality, name, strData)
		    GlobalController.chat:pushSystemMsg("<font color='0xff7633'>获得物品:" .. goodsContent .. "x" .. (itemData.num or 1).."</font>")
		end
	end
end


--世界公告
--SystemNotice:showWorldNotice(info)
--世界通知
function SystemNoticeManager:showWorldNotice(noticeData)
	if (noticeData ~= nil and #self.worldNoticeList == 0 and self[SystemNoticeViewKey.WOELD_NOTICE] == nil) or (noticeData == nil and #self.worldNoticeList >= 1) then
		if noticeData == nil then
			noticeData = table.remove(self.worldNoticeList,1)
		end
		local view = self[SystemNoticeViewKey.WOELD_NOTICE]
		if view == nil then
			local view = require("app.com.systemNotice.view.WorldNotice").new(self,SystemNoticeViewKey.WOELD_NOTICE,noticeData.content)
			self[SystemNoticeViewKey.WOELD_NOTICE] = view
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
		else
			view:reuse(noticeData.content)
		end
	elseif noticeData ~= nil then
		if #self.worldNoticeList == 0 then 
			table.insert(self.worldNoticeList,noticeData)
		else
			local insertOk = false
			if self.worldNoticeList[#self.worldNoticeList].priority ~= noticeData.priority then
				for i=2,#self.worldNoticeList do
					if self.worldNoticeList[i].priority == noticeData.priority then
						for j=i+1,#self.worldNoticeList,1 do
							if self.worldNoticeList[j] then
								if self.worldNoticeList[j].priority < noticeData.priority then
									table.insert(self.worldNoticeList,j,noticeData)
									insertOk = true
									break
								end
							end
						end
						if insertOk then
							break
						end
					end
				end
			end
			if not insertOk then
				table.insert(self.worldNoticeList,noticeData)
			end
		end
	else
		if self[SystemNoticeViewKey.WOELD_NOTICE] then
			self[SystemNoticeViewKey.WOELD_NOTICE]:destory()
			self[SystemNoticeViewKey.WOELD_NOTICE] = nil
		end
	end
	return #self.worldNoticeList
end

--SystemNotice:newTeamNotice({type = 1,player_name = "ffff",player_id = 1234})
--新组队通知
function SystemNoticeManager:newTeamNotice(data)
	if self[SystemNoticeViewKey.NEW_TEAM] then
		table.insert(self.teamNoticeList,data)
	elseif data ~= nil or (data == nil and #self.teamNoticeList >0) then
		data = data or table.remove(self.teamNoticeList,1)
		local view = self[SystemNoticeViewKey.NEW_TEAM]
		if view == nil then
			view = require("app.com.systemNotice.view.IconNoticeView").new(self)
			self[SystemNoticeViewKey.NEW_TEAM] = view
		end
		local function backFun()
	        if data.type == 1 then
	        	local accept = function()
	        		self:newTeamNotice()
					GlobalController.team:HandleRequest(data.player_id, true)
				end
				local cancel = function()
					self:newTeamNotice()
					GlobalController.team:HandleRequest(data.player_id, false)
				end
				local param = {
					enterTxt = "同意",
					backTxt  = "取消",
					tipTxt   = string.format("玩家【%s】申请加入您的队伍，是否同意？", data.player_name),
					enterFun = accept,
					backFun  = cancel
				}
				GlobalMessage:alert(param)
			else
	            local accept = function()
	            	self:newTeamNotice()
					GlobalController.team:HandleInvite(data.team_id, data.player_id, true)
				end
				local cancel = function()
					self:newTeamNotice()
					GlobalController.team:HandleInvite(data.team_id, data.player_id, false)
				end
				local param = {
					enterTxt = "同意",
					backTxt  = "取消",
					tipTxt   = string.format("玩家【%s】邀请您加入队伍，是否同意？", data.player_name),
					enterFun = accept,
					backFun  = cancel
				}
				GlobalMessage:alert(param)
	        end
	    end
		view:show("scene/scene_noticeTeam.png",SystemNoticeViewKey.NEW_TEAM,handler(self,backFun))
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
	end
end


--SystemNotice:newTradeNotice({peerPlayerId = 1,peerPlayerName = "ffff",peerPlayerLv = 1234})
--新交易通知
function SystemNoticeManager:newTradeNotice(data)
	if self[SystemNoticeViewKey.NEW_TRADE] then
		table.insert(self.tradeNoticeList,data)
	elseif data ~= nil or (data == nil and #self.tradeNoticeList >0) then
		data = data or table.remove(self.tradeNoticeList,1)
		local view = self[SystemNoticeViewKey.NEW_TRADE]
		if view == nil then
			view = require("app.com.systemNotice.view.IconNoticeView").new(self)
			self[SystemNoticeViewKey.NEW_TRADE] = view
		end
		local function backFun()
	        local function enterFun() --同意
	        	self:newTradeNotice()
                local data2 = {
                    player_id = data.peerPlayerId,
                    player_name = data.peerPlayerName,
                    player_lv = data.peerPlayerLv,
                    ["type"] = 1
                }
                GameNet:sendMsgToSocket(20003, data2)
            end
            local function backFunction()  --拒绝
            	self:newTradeNotice()
                local data2 = {
                    player_id = data.peerPlayerId,
                    player_name = data.peerPlayerName,
                    player_lv = data.peerPlayerLv,
                    ["type"] = 0
                }
                GameNet:sendMsgToSocket(20003, data2)
            end
            GlobalMessage:alert({
                enterTxt = "同意",
                backTxt= "拒绝",
                tipTxt = "玩家"..data.peerPlayerName.."向你发起了交易邀请",
                enterFun = handler(self, enterFun),
                backFun = handler(self, backFunction),
                tipShowMid = true,
            })
	    end
		view:show("scene/scene_noticeTrade.png",SystemNoticeViewKey.NEW_TRADE,handler(self,backFun))
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
	end
end

--SystemNotice:inviteGuildNotice({GuildName = 1,PlayerName = "ffff",GuildId = 1234})
--邀请加入帮会通知
function SystemNoticeManager:inviteGuildNotice(data)
	if self[SystemNoticeViewKey.NEW_INVITEGUILD] then
		table.insert(self.inviteGuildNoticeList,data)
	elseif data ~= nil or (data == nil and #self.inviteGuildNoticeList >0) then
		data = data or table.remove(self.inviteGuildNoticeList,1)
		local view = self[SystemNoticeViewKey.NEW_INVITEGUILD]
		if view == nil then
			view = require("app.com.systemNotice.view.IconNoticeView").new(self)
			self[SystemNoticeViewKey.NEW_INVITEGUILD] = view
		end
		local function backFun()
	         local function enterFun() --同意
	         	self:inviteGuildNotice()
                local data2 = {
                    guild_id = data.GuildId,
                }
                GameNet:sendMsgToSocket(17056, data2) 
            end
            local function backFun()  --拒绝
                self:inviteGuildNotice()
            end
            GlobalMessage:alert({
                enterTxt = "同意",
                backTxt= "拒绝",
                tipTxt = "玩家"..data.PlayerName.."邀请您加入行会"..data.GuildName.."，是否同意加入？",
                enterFun = handler(self, enterFun),
                backFun = handler(self, backFun),
                tipShowMid = true,
            })
	    end
		view:show("scene/scene_noticeFriend.png",SystemNoticeViewKey.NEW_INVITEGUILD,handler(self,backFun))
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
	end
end

--SystemNotice:newGuildWarNotice(data)
--帮会战通知
function SystemNoticeManager:newGuildWarNotice(data)
	if self[SystemNoticeViewKey.NEW_GUILDWAR] then
		table.insert(self.guildWarNoticeList,data)
	elseif data ~= nil or (data == nil and #self.guildWarNoticeList >0) then
		data = data or table.remove(self.guildWarNoticeList,1)
		local view = self[SystemNoticeViewKey.NEW_GUILDWAR]
		if view == nil then
			view = require("app.com.systemNotice.view.IconNoticeView").new(self)
			self[SystemNoticeViewKey.NEW_GUILDWAR] = view
		end
		local function backFun()
	        local accept = function()
	        	self:newGuildWarNotice()
				GlobalController.guild:requestGuildWarAnswer(data.guild_id_a, 1)
			end
			local cancel = function()
				self:newGuildWarNotice()
				GlobalController.guild:requestGuildWarAnswer(data.guild_id_a, 0)
			end
			local param = {
				enterTxt = "接受",
				backTxt  = "拒绝",
				tipTxt   = string.format("【%s】行会对你们行会宣战，是否有胆量接受挑战？\n(行会宣战不会有任何损失，这只是一场荣誉之战)", data.guild_name_a),
				enterFun = accept,
				backFun  = cancel
			}
			GlobalMessage:alert(param)
	    end
		view:show("scene/scene_noticeFriend.png",SystemNoticeViewKey.NEW_GUILDWAR,handler(self,backFun))
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
	end
end

--SystemNotice:newUnionNotice({server_id_a = 1,guild_id_a = "ffff",player_id_a = 1234})
--新同盟通知
function SystemNoticeManager:newUnionNotice(data)
	if self[SystemNoticeViewKey.NEW_UNION] then
		table.insert(self.unionNoticeList,data)
	elseif data ~= nil or (data == nil and #self.unionNoticeList >0) then
		data = data or table.remove(self.unionNoticeList,1)
		local view = self[SystemNoticeViewKey.NEW_UNION]
		if view == nil then
			view = require("app.com.systemNotice.view.IconNoticeView").new(self)
			self[SystemNoticeViewKey.NEW_UNION] = view
		end
		local function backFun()
	        local function enterFun() --同意
	        	self:newUnionNotice()
                GameNet:sendMsgToSocket(17087,{type = 1,server_id_a = data.server_id_a,guild_id_a= data.guild_id_a,player_id_a= data.player_id_a})
            end
            local function backFun()  --拒绝
            	self:newUnionNotice()
                GameNet:sendMsgToSocket(17087,{type = 0,server_id_a = data.server_id_a,guild_id_a= data.guild_id_a,player_id_a= data.player_id_a})
            end
            -- <Param name="server_id_a" type="int32" describe="发起方区服id"/>
			-- <Param name="guild_id_a" type="int64" describe="发起方帮派id"/>
			-- <Param name="guild_name_a" type="string" describe="发起方帮派名称"/>
			-- <Param name="player_id_a" type="int64" describe="发起的玩家id"/>
			-- <Param name="player_name_a" type="string" describe="发起的玩家姓名"/>
            local tipsStr = ""
            if RoleManager:getInstance():isInterServer() then
                tipsStr = "["..data.server_id_a.."]服["..data.guild_name_a .."]行会向我方行会发送了结盟邀请。同意后，在跨服活动中双方的PK模式为结盟模式时，将不会对结盟行会的所有成员造成伤害。"
            else
                tipsStr = "["..data.guild_name_a.."]行会向我方行会发送了结盟邀请。同意后，在本服活动中双方的PK模式为结盟模式时，将不会对结盟行会的所有成员造成伤害。"
            end
            GlobalMessage:alert({
                enterTxt = "同意",
                backTxt= "拒绝",
                tipTxt = tipsStr,
                enterFun = handler(self, enterFun),
                backFun = handler(self, backFun),
                tipShowMid = true,
            })
	    end
		view:show("scene/scene_noticeUnion.png",SystemNoticeViewKey.NEW_UNION,handler(self,backFun))
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
	end
end


--SystemNotice:newMailNotice()
--新邮件通知
function SystemNoticeManager:newMailNotice()
	if self[SystemNoticeViewKey.NEW_MAIL] then
	else
		local view = require("app.com.systemNotice.view.IconNoticeView").new(self)
		self[SystemNoticeViewKey.NEW_MAIL] = view
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
		local function backFun()
	        GlobalWinManger:openWin(WinName.MAILWIN)
	    end
		view:show("scene/scene_noticeMail.png",SystemNoticeViewKey.NEW_MAIL,handler(self,backFun))
	end
end

--SystemNotice:newFriendNotice()
--好友通知
function SystemNoticeManager:newFriendNotice(PlayerId,PlayerName)
	if self[SystemNoticeViewKey.NEW_FRIEND] then
	else
		local view = require("app.com.systemNotice.view.IconNoticeView").new(self)
		self[SystemNoticeViewKey.NEW_FRIEND] = view
		FriendManager:getInstance().hasApply = 1
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
		local function backFun()
			local function enterFun() --同意
                local data = {
                    tplayer_id = PlayerId,
                }
                GameNet:sendMsgToSocket(24008, data) 
            end
            GlobalMessage:alert({
                enterTxt = "同意",
                backTxt= "拒绝",
                tipTxt = "玩家"..PlayerName.."请求添加好友",
                enterFun = handler(self, enterFun),
                --backFun = handler(self, backFun),
                tipShowMid = true,
            })

	        GlobalWinManger:openWin(WinName.MAILWIN)

	        FriendManager:getInstance().hasApply = 0
    		FriendManager:getInstance():getOneApply()
	    end
		view:show("scene/scene_noticeFriend.png",SystemNoticeViewKey.NEW_FRIEND,handler(self,backFun))
	end
end


--SystemNotice:showAnnouncement(info)
--公告面板
function SystemNoticeManager:showAnnouncement(info)
	if self[SystemNoticeViewKey.ANNOUNCEMENT] then
	else
		local noticeView = import("app.com.systemNotice.view.NoticeView")
        local view = noticeView.new(self,SystemNoticeViewKey.ANNOUNCEMENT,info)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_NOTICE_BOX, view)
        self[SystemNoticeViewKey.ANNOUNCEMENT] = view
	end
end

--SystemNotice:showPowerChangTips(value)
--战力改变提示
function SystemNoticeManager:showPowerChangTips(value)
	--还没进入主场景时不显示战力改变的动画
    if GlobalController.curScene == SCENE_MAIN then
    	local PowerView = require("app.com.systemNotice.view.PowerView")
		if PowerView.isShowing() then
			PowerView.showPower(value)
		else
			local node = PowerView.showPower(value)
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
		end
    end
end

--SystemNotice:showEquipAttChangTips(list)
--装备属性改变提示
function SystemNoticeManager:showEquipAttChangTips(list)
	--还没进入主场景时不显示属性改变的动画
    if GlobalController.curScene == SCENE_MAIN then
    	local attrChangeView = require("app.com.systemNotice.view.AttrChangeView")
		local node = attrChangeView.new(list)
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
    end
end



--清除面板
function SystemNoticeManager:clearNoticeViewKey(key)
	if self[key] then
		self[key] = nil
	end
end
--清理
function SystemNoticeManager:clear()
	self.sysTextTipsLis = {}
	self.worldNoticeList = {}
	self.getItemsList = {}
	self.attValueTipsList = {}
	self.teamNoticeList = {}
	self.tradeNoticeList = {}
	self.attValueTipsNum = 0
	for k,v in pairs(SystemNoticeViewKey) do
		if self[k] then
			self[k]:destory()
			self[k] = nil
		end
	end
end

--销毁
function SystemNoticeManager:destory()
	if self.popTextTipEventId then 
		GlobalEventSystem:removeEventListenerByHandle(self.popTextTipEventId)
		self.popTextTipEventId = nil
	end

	if self.switchSceneEventId then 
		GlobalEventSystem:removeEventListenerByHandle(self.switchSceneEventId)
		self.switchSceneEventId = nil
	end
	
end

return SystemNoticeManager



