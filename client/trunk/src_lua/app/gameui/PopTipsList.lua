--更多操作列表
local PopTipsList = class("PopTipsList", function()
	return display.newNode()
end)

local PTL_OP={
	[SceneRoleType.PLAYER] = {
		[1] = {name = "私聊",index = 1},
		[2] = {name = "信息查看",index = 2},
		[3] = {name ="邀请组队",index = 3},
		[4] = {name ="邀请行会",index = 4},
		[5] = {name ="添加好友",index = 5},
		[6] = {name ="交易",index = 6},
		[7] = {name ="拉黑",index = 7},
	},
	[SceneRoleType.MONSTER] = {
		
	},
	[SceneRoleType.BOSS] = {
		
	},
	[SceneRoleType.ITEM] = {
		
	},
	[SceneRoleType.PET] = {
		
	},
	[SceneRoleType.FIREWALL] = {
		
	},
	[SceneRoleType.BABY] = {
		
	},
	[SceneRoleType.NPC] = {
		
	}
}
local MPL_GAP = 10
function PopTipsList:ctor(popTipsType,itemOpenTable,voData,modifyFunc)

	if not popTipsType then return end
	self.data = voData
	local delTeam = false
	if not itemOpenTable then
		--voData = {id=eventParams.player_id,teamId = eventParams.teamId, guildId = eventParams.guild_id,name=eventParams.player_name}
		itemOpenTable = {}
		if popTipsType == SceneRoleType.PLAYER then

			PTL_OP[popTipsType] = {
			[1] = {name = "私聊",index = 1},
			[2] = {name = "信息查看",index = 2},
			[3] = {name ="邀请组队",index = 3},
			[4] = {name ="邀请行会",index = 4},
			[5] = {name ="邀请结盟",index = 8},
			[6] = {name ="添加好友",index = 5},
			[7] = {name ="交易",index = 6},
			[8] = {name ="拉黑",index = 7},
			}
			if RoleManager:getInstance():getCanSetUnion(self.data.guildId) then
				--监听玩家帮会信息
				if self.getplayInfoEventId == nil then
			         self.getplayInfoEventId = GlobalEventSystem:addEventListener(UnionEvent.PLAYER_INFO,handler(self,self.updatePlayerInfo))
			    end
				GameNet:sendMsgToSocket(17094,{guild_id=self.data.guildId})
				if RoleManager:getInstance():getHasUnion(self.data.guildId) then
					PTL_OP[popTipsType][5].name = "解除结盟"
				else
					PTL_OP[popTipsType][5].name = "邀请结盟"
				end
			else
				table.remove(PTL_OP[popTipsType],5)
			end
	
			if tonumber(voData.teamId) == 0 and  tonumber(RoleManager:getInstance().roleInfo.teamId) == 0 then
				PTL_OP[popTipsType][3].name = "邀请组队"
			elseif tonumber(voData.teamId) > 0 and tonumber(RoleManager:getInstance().roleInfo.teamId) == 0 then
				PTL_OP[popTipsType][3].name = "申请组队"
			elseif tonumber(voData.teamId) == 0 and tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 then
				PTL_OP[popTipsType][3].name = "邀请组队"
			elseif tonumber(voData.teamId) > 0 and tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 then
				table.remove(PTL_OP[popTipsType],3) 
				delTeam = true
			end
 			
			if delTeam then
				if tonumber(voData.guildId) > 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) == 0 then
					PTL_OP[popTipsType][3].name = "申请行会"
				elseif tonumber(voData.guildId) == 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
					PTL_OP[popTipsType][3].name = "邀请行会"
				elseif tonumber(voData.guildId) > 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
					table.remove(PTL_OP[popTipsType],3) 
				elseif tonumber(voData.guildId) == 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) == 0 then
					table.remove(PTL_OP[popTipsType],3) 
				end
			else
				if tonumber(voData.guildId) > 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) == 0 then
					PTL_OP[popTipsType][4].name = "申请行会"
				elseif tonumber(voData.guildId) == 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
					PTL_OP[popTipsType][4].name = "邀请行会"
				elseif tonumber(voData.guildId) > 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) > 0 then
					table.remove(PTL_OP[popTipsType],4) 
				elseif tonumber(voData.guildId) == 0 and tonumber(RoleManager:getInstance().guildInfo.guild_id) == 0 then
					table.remove(PTL_OP[popTipsType],4) 
				end
			end
			

		end

		for i=1,#PTL_OP[popTipsType] do
			table.insert(itemOpenTable,i)
		end
	end
	local height = #itemOpenTable*44+(#itemOpenTable-1)*MPL_GAP
	self:setContentSize(140,height)
	self:setAnchorPoint(0,0)
	if height<0 then
		return 
	end

	--吞噬页
	local maskbg = display.newLayer()
	-- local maskbg = cc.LayerColor:create(cc.c4b(0,0,0,100))
	maskbg:setAnchorPoint(0,0)
	maskbg:setContentSize(display.width,display.height)
    self:addChild(maskbg)
    maskbg:setTouchEnabled(true)
    maskbg:setPosition((-display.width)/2,(-display.height)/2)
    maskbg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeSelf()
        end     
        return true
    end)
	--背景
	local bg = display.newScale9Sprite("#scene/scene_btnListBg.png", 0, 0, cc.size(140,height))
	bg:setAnchorPoint(0.5,0)
	bg:setPosition(0,0)
	self:addChild(bg)

	--操作项
	for i=1,#itemOpenTable do
		local btn = display.newSprite("#scene/scene_tabBtn.png")
		btn:setTouchEnabled(true)
	    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            self:onBtnClick(popTipsType,PTL_OP[popTipsType][itemOpenTable[i]].index)
	        end     
	        return true
	    end)
	    btn:setPosition(0,(#itemOpenTable-i+1)*(btn:getContentSize().height+MPL_GAP))
	    local label = display.newTTFLabel({
	    	text = PTL_OP[popTipsType][itemOpenTable[i]].name,
	    	size = 18,
	    	color = UiColorType.BTN_LAB1
		})
		label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
		btn:addChild(label)
		--display.setLabelFilter(label)
		self:addChild(btn) 
	end
	--自定义按钮点击回调
	self.modifyFunc = modifyFunc
end

function PopTipsList:updatePlayerInfo(data)
	if self.getplayInfoEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getplayInfoEventId)
        self.getplayInfoEventId = nil
    end
	self.data.server_name = data.data.server_id;
	self.data.guildName = data.data.guild_name
end

--[[
		[1] = "私聊",
		[2] = "信息查看",
		[3] = "邀请组队",
		[4] = "邀请行会",
		[5] = "添加好友",
		[6] = "交易",
		[7] = "拉黑"
--]]
function PopTipsList:onBtnClick(popTipsType,index)
	if popTipsType==SceneRoleType.PLAYER then --玩家
		if GameSceneModel.isInterService and (index >= 4) and index ~= 8 then
			GlobalMessage:show("跨服中，不能使用该功能")
			self:removeSelfSafety()
			return
		end
		if index == 1 then
			if GlobalWinManger:getWin(WinName.CHAT) then
				GlobalEventSystem:dispatchEvent(ChatEvent.SET_PRIVATE_CHAT,self.data)
			else
				GlobalWinManger:openWin(WinName.CHAT,{tabIndex = ChatChannelType.PRIVATE,data = self.data})
			end
		elseif index == 2 then
			GameNet:sendMsgToSocket(10011, {player_id = self.data.id})
		elseif index == 3 then
			if (tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 and tonumber(self.data.teamId) == 0) or (tonumber(RoleManager:getInstance().roleInfo.teamId) == 0 and tonumber(self.data.teamId) == 0) then
				GlobalController.team:InvitePlayer(self.data.id)
			elseif tonumber(RoleManager:getInstance().roleInfo.teamId) == 0 and tonumber(self.data.teamId) > 0 then
				GlobalController.team:RequestJoinTeam(self.data.teamId)
			end
			
		elseif index == 4 then

			if tonumber(self.data.guildId) > 0 then
				GameNet:sendMsgToSocket(17006, {guild_id = self.data.guildId})
			elseif  RoleManager:getInstance().guildInfo.position == 1 or  RoleManager:getInstance().guildInfo.position == 2 then
          		GameNet:sendMsgToSocket(17054, {tplayer_id = self.data.id})
        	elseif RoleManager:getInstance().guildInfo.position ~= 0 then
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您的职位不够!")
        	else
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您还没有行会!")
        	end

		elseif index == 5 then
			GameNet:sendMsgToSocket(24003, {tplayerId = self.data.id})
		elseif index == 6 then
			local data = {
			    player_id = self.data.id,
			}
			GameNet:sendMsgToSocket(20001,data)
		elseif index == 7 then
			GameNet:sendMsgToSocket(24002,{tplayer_id = self.data.id})
		elseif index == 8 then
			if RoleManager:getInstance():getHasUnion(self.data.guildId) then
				--print("解除结盟") 解除结盟将会使对方行会失去与我方所有同盟行会的结盟关系，是否与xx服 xx行会解除结盟状态？
				--GameNet:sendMsgToSocket(17089,{server_id_b="",guild_id_b = self.data.guildId})
				local param = {server_id_b=self.data.server_name,guild_id_b = self.data.guildId}
				local function enterFun() --同意
	                GameNet:sendMsgToSocket(17090,param)
	            end
	            local tipsStr = ""
	            if RoleManager:getInstance():isInterServer() then
			        tipsStr =  "解除结盟将会使对方行会失去与我方所有同盟行会的结盟关系，是否与[" ..self.data.server_name.."]服["..self.data.guildName.."]行会解除结盟状态？"
			    else
			        tipsStr =  "解除结盟将会使对方行会失去与我方所有同盟行会的结盟关系，是否与["..self.data.guildName.."]行会解除结盟状态？"
			    end
	            GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipsStr,
	                enterFun = handler(self, enterFun),
	                tipShowMid = true,
	            })
			else
				local param = {server_id_b = self.data.server_name, player_id_b= self.data.id, guild_id_b = self.data.guildId}
				local function enterFun() --同意
	                GameNet:sendMsgToSocket(17085,param)
	            end
	            local tipsStr = ""
	            if RoleManager:getInstance():isInterServer() then
			        tipsStr =  "邀请结盟后，在跨服活动中双方的PK模式为行会模式时，将不会对结盟行会的所有成员造成伤害。是否确认向["..self.data.server_name.."]服["..self.data.guildName.."]行会发起结盟？"
			    else
			        tipsStr =  "邀请结盟后，在本服活动中双方的PK模式为联盟模式时，将不会对结盟行会的所有成员造成伤害。是否确认向["..self.data.guildName.."]行会发起结盟？"
			    end
	       
	            GlobalMessage:alert({
	                enterTxt = "确定",
	                backTxt= "取消",
	                tipTxt = tipsStr,
	                enterFun = handler(self, enterFun),
	                tipShowMid = true,
	            })
				
			end
		end	
	end
	self:removeSelfSafety()

	if self.getplayInfoEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.getplayInfoEventId)
        self.getplayInfoEventId = nil
    end
end

return PopTipsList