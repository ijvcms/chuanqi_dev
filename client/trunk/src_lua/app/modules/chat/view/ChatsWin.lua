--
-- Author: Allen    21102585@qq.com
-- Date: 2017-06-03 17:49:29
-- 聊天
local ChatInputWidget = import(".ChatInputWidget")
local ChatMetadata = import("..model.ChatMetadata")
local ChatListView = import(".ChatListView")
local ChatMenuView = import(".ChatMenuView")
--local ChatBagView = import(".ChatBagView")
local ChatRoleView = import(".ChatRoleView")
local ChatFaceView = import(".ChatFaceView")

local ChatsWin = class("ChatsWin", BaseView)

function ChatsWin:ctor(winTag,data,winconfig)
	ChatsWin.super.ctor(self,winTag,data,winconfig)
	self.canSay = true
	self.chatController = GlobalController.chat
	self.zhbtn = self:seekNodeByName("zhbtn")
	self.zhsel = self:seekNodeByName("zhsel")
	self.sjbtn = self:seekNodeByName("sjbtn")
	self.sjsel = self:seekNodeByName("sjsel")
	self.hhbtn = self:seekNodeByName("hhbtn")
	self.hhsel = self:seekNodeByName("hhsel")
	self.dwbtn = self:seekNodeByName("dwbtn")
	self.dwsel = self:seekNodeByName("dwsel")
	self.slbtn = self:seekNodeByName("slbtn")
	self.slsel = self:seekNodeByName("slsel")
	self.xtbtn = self:seekNodeByName("xtbtn")
	self.xtsel = self:seekNodeByName("xtsel")

	self.closeBtn = self:seekNodeByName("closeBtn")
	self.inputLay = self:seekNodeByName("inputLay")
	self.inputLab = self:seekNodeByName("inputLab")
	self.pingdanLab = self:seekNodeByName("pingdanLab")
	self.sendBtn = self:seekNodeByName("sendBtn")
	self.sendOtherBtn = self:seekNodeByName("sendOtherBtn")
	self.inputBg = self:seekNodeByName("inputBg")
	self.contentLay = self:seekNodeByName("contentLay")

	self.inputLay:setVisible(false)

	self.tagBtns = {
		[ChatChannelType.ALL] = {txt = "综 合", sort = 1,btn = self.zhbtn,btnSel = self.zhsel},
		[ChatChannelType.WORLD] = {txt = "世 界", sort = 2,btn = self.sjbtn,btnSel = self.sjsel},
		[ChatChannelType.GUILD] = {txt = "行 会", sort = 3,btn = self.hhbtn,btnSel = self.hhsel},
		--[7] = {txt = "军 团", sort = 4,btn = self.zhbtn,btnSel = self.zhsel},
		[ChatChannelType.TEAM] = {txt = "队 伍", sort = 4,btn = self.dwbtn,btnSel = self.dwsel},
		[ChatChannelType.PRIVATE] = {txt = "私 聊", sort = 5,btn = self.slbtn,btnSel = self.slsel},
		[ChatChannelType.SYSTEM] = {txt = "系 统", sort = 6,btn = self.xtbtn,btnSel = self.xtsel},
	}

    self.chatList ={}
    for k,v in pairs(self.tagBtns) do
    	self.chatList[k] = ChatListView.new(cc.size(366-6, 556-10))
	    self.chatList[k]:setPosition(3, 3)
	    self.chatList[k]:setVisible(false)
	    --self.chatList[i]:setChatData(self.chatChannelData[i])
	    self.chatList[k]:setChatData(self.chatController.chatChannelData[k])
	    self.contentLay:addChild(self.chatList[k])
    end
	
    self.playerId = RoleManager:getInstance().roleInfo.player_id


    for k,v in pairs(self.tagBtns) do
    	local v = self.tagBtns[k]
    	v.btnSel:setVisible(false)
    	v.btn:setTouchEnabled(true)
		v.btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()   
            elseif event.name == "ended" then
                self:onTagBtnClick(k)
            end     
            return true
        end)
		if k == ChatChannelType.PRIVATE then 
			self.innerRedPoint = display.newSprite("#scene/scene_redPointPic.png")
			self.innerRedPoint:setVisible(false)
			self.innerRedPoint:setPosition(v.btn:getContentSize().width-8, v.btn:getContentSize().height - 8)
			v.btn:addChild(self.innerRedPoint)
	    end
	end

	--输入框
	self.chatInput = ChatInputWidget.new(224, 42)
	self.chatInput:setPosition(212,30)
	self.chatInput:setMaxLength(40)
	self.inputLay:addChild(self.chatInput)
	--+号按钮
	self.sendOtherBtn:setTouchEnabled(true)
    self.sendOtherBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.sendOtherBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.sendOtherBtn:setScale(1.0)
            self:onMenuBtnClick()
        end     
        return true
    end)

    --发送按钮
	self.sendBtn:setTouchEnabled(true)
    self.sendBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.sendBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.sendBtn:setScale(1.0)
            self:onSendChat()
        end     
        return true
    end)

    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            if self.root then
            	self.root:stopAllActions()
            	transition.execute(self.root, cc.MoveTo:create(0.2, cc.p(-480, 0)), {
				    delay = 0,
				    easing = "exponentialIn",
				    onComplete = function()
				       GlobalWinManger:closeWin(self.winTag)
				    end,
				})

            end
        end     
        return true
    end)

    --self.curTagBtnIndex
end


--二级菜单
function ChatsWin:onMenuBtnClick()
 	--点击＋号菜单
 	if self.ChatMenuView == nil then
	    self.ChatMenuView = ChatMenuView.new(230, 68)
		self:addChild(self.ChatMenuView)
	end
	self.ChatMenuView:setVisible(true)
end


--标签按钮点击回调
--tagBtnIndex:标签按钮类型,1:综合 2:行会 3:组队 4:私聊 5：系统 6：世界 7：军团
function ChatsWin:onTagBtnClick(tagBtnIndex)
    if not self.tagBtns[tagBtnIndex] then return end
    if self.curTagBtnIndex and self.curTagBtnIndex == tagBtnIndex then
    	if self.curTagBtnIndex == ChatChannelType.PRIVATE then
    		self.chatController.chatRedPointIsOpen = false
    		self:hideRedPoint()
	    	if self.curPC then
	        	self.chatInput:setPrivateChatName("/"..self.curPC.name..":")
	        end
	        self.chatInput:clear()
	    end
        return
    else
        if self.curTagBtnIndex then
            self.tagBtns[self.curTagBtnIndex].btnSel:setVisible(false)
            self.chatList[self.curTagBtnIndex]:setVisible(false)
        end
        self.curTagBtnIndex = tagBtnIndex
        self.tagBtns[self.curTagBtnIndex].btnSel:setVisible(true)
        self.chatList[self.curTagBtnIndex]:setVisible(true)
    end
    self.pingdanLab:setString(self.tagBtns[self.curTagBtnIndex].txt)
    
    self.chatList[self.curTagBtnIndex]:refreshData()
    if self.curTagBtnIndex == ChatChannelType.ALL or self.curTagBtnIndex == ChatChannelType.SYSTEM then
    	self.inputLay:setVisible(false)
    else
    	self.inputLay:setVisible(true)
    end

    if ChatChannelType.PRIVATE == self.curTagBtnIndex then
    	self.chatController.chatRedPointIsOpen = false
        if self.curPC then
        	self.chatInput:setPrivateChatName("/"..self.curPC.name..":")
        end
    	self:hideRedPoint()
    else
    	self.chatInput:setPrivateChatName("")
    end
   	self.chatInput:clear()
end

function ChatsWin:showRedPoint()
	self.innerRedPoint:setVisible(true)
end

function ChatsWin:hideRedPoint()
	self.innerRedPoint:setVisible(false)
end

function ChatsWin:open()
	display.addSpriteFrames("resui/face0.plist", "resui/face0.png")
	if self.openFaceEventId == nil then
		local function onOpenFaceView(data)
	        if self.ChatFaceView == nil then
	       		self.ChatFaceView = ChatFaceView.new(self.sendOtherBtn:getPositionX(), self.sendOtherBtn:getPositionY()+14)
	       		self:addChild(self.ChatFaceView)
	       	else
	       		self.ChatFaceView:setVisible(true)
	        end

	        if self.ChatMenuView then
				self.ChatMenuView:setVisible(false)
			end
	    end
	    self.openFaceEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_OPEN_FACE, onOpenFaceView)
	end

	local function onOpenBagView(data)
    	GlobalWinManger:openWin(WinName.CHATBAGWIN)
       	if self.ChatMenuView then
			self.ChatMenuView:setVisible(false)
		end
    end
    if self.opeBagEventId == nil then
	    self.opeBagEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_OPEN_BAG, onOpenBagView)
	end

    local function onOpenRoleView(data)
       if self.ChatRoleView == nil then
       		self.ChatRoleView = ChatRoleView.new(self.sendOtherBtn:getPositionX(), self.sendOtherBtn:getPositionY())
       		self:addChild(self.ChatRoleView)
       	else
       		self.ChatRoleView:setVisible(true)
       end
       self.ChatRoleView:getEauipInfo()
       if self.ChatMenuView then
			self.ChatMenuView:setVisible(false)
		end
    end 
    if self.opeRoleEventId == nil then
	    self.opeRoleEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_OPEN_ROLE, onOpenRoleView)
	end

	if self.addGoodsEventId == nil then
	      local function onAddGoodsMessage(data)
	    	local info = data.data
	    	info.name = configHelper:getGoodNameByGoodId(info.goods_id)
	    	local goodType = configHelper:getGoodTypeByGoodId(info.goods_id)
	    	info.Quality  = configHelper:getGoodQualityByGoodId(info.goods_id)
	    	local strData =  serialize(info)
	    	if strData then--容错
	    		if goodType == 2 then
	        	    self.chatInput:setString("<"..info.name..">",ChatMetadata.FormatEqui(info.Quality,info.name, strData))
	            else
	        	    self.chatInput:setString("<"..info.name..">",ChatMetadata.FormatEqui(info.Quality,info.name, strData))
	            end
	    	end
	    end 
	    self.addGoodsEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_SEND_GOODS, onAddGoodsMessage)
	end
    if self.addFaceEventId == nil then
	    local function onAddFaceMessage(data)
	        local str = string.split(data.data, ".")
	        self.chatInput:setString("<"..str[1]..">",ChatMetadata.FormatFace(data.data))
	    end 
	    self.addFaceEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_SEND_FACE, onAddFaceMessage)
	end

    if self.md5TimeEventId == nil then
	    local function onMd5Time(data)
	    	self.md5 = data.data.md5
	    	self.timeStamp = data.data.timestamp
	    	-- if ChatAPI then
	    	-- 	ChatAPI:login(RoleManager:getInstance().roleInfo.player_id, self.timeStamp, self.md5, handler(self, self.loginServer))
	    	-- end
	    end
	    self.md5TimeEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_MD5_TIME, onMd5Time)
	end

    if self.chatUpdateEventId == nil then
    	self.chatUpdateEventId = GlobalEventSystem:addEventListener(ChatEvent.CHAT_UPDATE, handler(self,self.updateChatInfo))
    end

    if self.privateEventId == nil then 
    	local function onSetPrivateChat(data)
	    	self.curPC = data.data
			self:onTagBtnClick(ChatChannelType.PRIVATE)
	    end
	    self.privateEventId = GlobalEventSystem:addEventListener(ChatEvent.SET_PRIVATE_CHAT, onSetPrivateChat)
	end
    self.chatController.chatWinIsOpen = true

    if self.root then
    	self.root:setPosition(-480,0)
    	self.root:stopAllActions()

    	transition.execute(self.root, cc.MoveTo:create(0.2, cc.p(0, 0)), {
	    delay = 0,
	    easing = "exponentialOut",
	    onComplete = function()
	    	--GlobalWinManger:openWin(WinName.CHAT,{tabIndex = ChatChannelType.PRIVATE,data = self.data})
	    	if self.data.tabIndex == ChatChannelType.PRIVATE then
	    		self.curPC = self.data.data
			end
		    if self.data and self.data.tabIndex then
		    	self:onTagBtnClick(self.data.tabIndex)
		    else
				self:onTagBtnClick(ChatChannelType.WORLD)
			end
			
		end,
		})
    end
   -- self:onTagBtnClick(ChatChannelType.SYSTEM)
end

function ChatsWin:updateChatInfo(data)
	local info = data.data
	if self.curTagBtnIndex == info.channelId then
		local listview = self.chatList[self.curTagBtnIndex]
		if self.chatController.chatNeedRefresh[self.curTagBtnIndex] then 
			self.chatController.chatNeedRefresh[self.curTagBtnIndex] = false
			listview:needReload()
		end
		listview:syncData()
		local listViewIsBottom = listview:isScrollToBottom()

		 if listViewIsBottom or (info.data.chatData.player_id  == self.playerId and info.channelId ~= ChatChannelType.SYSTEM) then
		    if  listview.needReload_ then
		    	listview:refreshData()
		    else
		    	listview:scrollToBottom()
		    end
		else
            --self:setWdCount(listview:getUnReadCount())
		end
	end
end


-- 接收信息函数
-- /*
--  *
--  *type 信息类型  1.文本信息  2.语音信息
--  *content 文本信息内容或语音信息ID
--  *sender  发送者
--  *
--  */--  */
function ChatsWin:receiveInfo(data)
	local chatData
	if data.type == 2 then
		chatData = {
			--频道id
			channelId = 4,
					--vip等级
			vip = RoleManager:getInstance().roleInfo.vip,
					--名称
			player_name = 0,
					--时间
			time = os.time(),
					--内容
			content = data.content,
					--
			player_id = data.sender,
		}
		if self.curPC then
			chatData.player_name = self.curPC.name or 0
		end
	else
		chatData = data.content
	end
	self.chatController:pushChat(chatData,true,data.type,data.sender)
end

function ChatsWin:onSendChat()
	local roleinfo = RoleManager:getInstance().roleInfo
	if roleinfo.vip < 1 and roleinfo.lv < 10 and (self.curTagBtnIndex == ChatChannelType.ALL or self.curTagBtnIndex == ChatChannelType.PRIVATE or self.curTagBtnIndex == ChatChannelType.WORLD) then
		local chatData = {
			type = 1,
			sender = roleinfo.player_id,
			--频道id
			channelId = self.curSendChannelIndex,
			--vip等级
			vip = roleinfo.vip,
			--名称
			--player_name = self.curPC.name,
			--时间
			time = os.time(),
			--内容
			content = "10级开启此聊天频道，努力升级吧!",
			player_name = roleinfo.name,
			--组队id
			team_id = roleinfo.teamId,
			--行会id
			guild_id = roleinfo.guild_id,
			player_id = roleinfo.player_id,
		}
		self:receiveInfo({content = chatData,type = 1,sender = roleinfo.player_id,channelId = self.curTagBtnIndex})
		GlobalAlert:show("10级开启此聊天频道，努力升级吧!")
		return 
	end
	if not self.canSay and self.curTagBtnIndex ~= ChatChannelType.GUILD and self.curTagBtnIndex ~= ChatChannelType.TEAM and self.curTagBtnIndex ~= ChatChannelType.PRIVATE and self.curTagBtnIndex ~= 7 then
		GlobalAlert:show("您发言太快，10秒后才能发言。")
		--return 
	end
 	self.chatInput:handlerInput()
 	local talkContent,head = self.chatInput:getString()
 	if talkContent == "" then
 		GlobalAlert:show("请输入聊天内容！")
 		return 
 	end
 	if self.sayEventId == nil then
 		self.sayEventId = GlobalTimer.scheduleGlobal(function() 
 			self.canSay = true
 			if self.updateEnergyTimeId then
		        GlobalTimer.unscheduleGlobal(self.sayEventId)
		        self.sayEventId = nil
    		end
 		 end,10)
 	end
 	self.canSay = false
	if talkContent ~= "" and self.chatController.channelProtocol[self.curTagBtnIndex] then
		--如果是私聊
		if self.curTagBtnIndex == ChatChannelType.PRIVATE then
			if self.curPC and head == self.curPC.name then
				local player_id
				if self.curPC.id == nil then
					player_id = tonumber(self.curPC.player_id) 
				else
					player_id = tonumber(self.curPC.id) 
				end

				local data = {
					player_id = player_id,
					player_name = self.curPC.name,
					content = talkContent
				}
				GameNet:sendMsgToSocket(self.chatController.channelProtocol[self.curTagBtnIndex], data)
				--新的语音聊天
				--ChatAPI:sendTextMessage(data,handler(self, self.sendTextMessageBack))
				local chatData = {
					--频道id
					channelId = ChatChannelType.PRIVATE,
					--vip等级
					vip = roleinfo.vip,
					--名称
					player_name = self.curPC.name,
					--时间
					time = os.time(),
					--组队id
					team_id = roleinfo.teamId,
					--行会id
					guild_id = RoleManager:getInstance().guildInfo.guild_id,
					--内容
					content = talkContent,
					--
					player_id = player_id,
				}
				self.chatController:pushChat(chatData,true)
			elseif head ~= "" then
				local data = {
					player_id = 0,
					player_name = head,
					content = talkContent
				}
				GameNet:sendMsgToSocket(self.chatController.channelProtocol[self.curTagBtnIndex], data)

				local chatData = {
					--频道id
					channelId = ChatChannelType.PRIVATE,
					--vip等级
					vip = roleinfo.vip,
					--名称
					player_name = head,
					--时间
					time = os.time(),
					--组队id
					team_id = roleinfo.teamId,
					--行会id
					guild_id = RoleManager:getInstance().guildInfo.guild_id,
					--内容
					content = talkContent,
					--
					player_id = 0,
				}
				self.chatController:pushChat(chatData,true)
			else
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有私聊对象!")
			end
		else

			local data = {
				content = talkContent,
				--组队id
				teamId = roleinfo.teamId,
				--行会id
				guild_id = RoleManager:getInstance().guildInfo.guild_id,
			}

			GameNet:sendMsgToSocket(self.chatController.channelProtocol[self.curTagBtnIndex], data)
			--新的语音聊天
			--ChatAPI:sendTextMessage(data,handler(self, self.sendTextMessageBack))
		end
		self.chatInput:clear()
	end
end


function ChatsWin:close()
	ChatsWin.super.close(self)
	if self.chatUpdateEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.chatUpdateEventId)
		self.chatUpdateEventId = nil
	end
	if self.privateEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.privateEventId)
		self.privateEventId = nil
	end

	if self.md5TimeEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.md5TimeEventId)
		self.md5TimeEventId = nil
	end
	if self.addFaceEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.addFaceEventId)
		self.addFaceEventId = nil
	end
	if self.addGoodsEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.addGoodsEventId)
		self.addGoodsEventId = nil
	end
	if self.opeBagEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.opeBagEventId)
		self.opeBagEventId = nil
	end
	if self.openFaceEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.openFaceEventId)
		self.openFaceEventId = nil
	end
	if self.opeRoleEventId then
		GlobalEventSystem:removeEventListenerByHandle(self.opeRoleEventId)
		self.opeRoleEventId = nil
	end
	self.chatController.chatWinIsOpen = false
end

--清理界面
function ChatsWin:destory()
	if self.root then
		self.root:stopAllActions()
	end
	ChatsWin.super.destory(self)
	
end
 
return ChatsWin