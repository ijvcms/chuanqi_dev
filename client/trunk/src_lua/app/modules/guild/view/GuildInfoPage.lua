--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:15:29
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--

--行会信息页
local GuildBasePage = import(".GuildBasePage")
local DayDonateView = import(".DayDonateView")
local GuildListPage = import(".GuildListPage")

local GuildInfoPage = class("GuildInfoPage", GuildBasePage)

function GuildInfoPage:ctor()
	self:setPosition(-81,-60)
	local leftLabels = {}
	local leftTexts = {
		[1] = "行会名称：",
		[2] = "行会会长：",
		[3] = "行会等级：",
		[4] = "行会排名：",
		[5] = "行会人数：",
		[6] = "行会经验：",
		[7] = "行会资金: ",
	}
	for i=1,7 do
		local label = display.newTTFLabel({
	    	text = leftTexts[i],
	    	size = 20,
	    	color = TextColor.TEXT_O
		})
		display.setLabelFilter(label)
		label:setAnchorPoint(0,0.5)
		label:setPosition(315,500-(i-1)*45)
		self:addChild(label)
	end

	self.rightLabels = {}
	for i=1,7 do
		local label = display.newTTFLabel({
	    	text = "",
	    	size = 20,
	    	color = TextColor.TEXT_W
		})
		display.setLabelFilter(label)
		label:setAnchorPoint(0,0.5)
		label:setPosition(415,500-(i-1)*45)
		self:addChild(label)
		table.insert(self.rightLabels,label)
	end

	--"行会公告:"
	local label = display.newTTFLabel({
	    	text = "行会公告：",
	    	size = 20,
	    	color = TextColor.TEXT_O
		})
		display.setLabelFilter(label)
		label:setAnchorPoint(0,0.5)
		label:setPosition(570,510)
		self:addChild(label)
	--行会公告背景
	 local ggBg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(310,265))
	 ggBg:setAnchorPoint(0,0)
	 ggBg:setPosition(570,220)
	 self:addChild(ggBg)

	--公告输入框
	local function onEdit(event, editbox)
	    if event == "ended" then
	        -- 输入结束
	        local str = editbox:getText()
	        local ret = StringUtil.CheckChinese(str)
	        if ret and #ret>50 then
	        	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"行会公告最多50字")
	        else
	        	if str~="" then
	        		self.ggContent:setString(str)	
	        		self.sureModifyGGBtn:setVisible(true)
	        	end
	        end
	        editbox:setText("")
	    end
	end
	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(310, 55),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(310, 265)
        })
	if self.inputLab.setInputShowMode then
		self.inputLab:setInputShowMode(1)
	end
    self.inputLab:setFontSize(20)
    self.inputLab:setPosition(570, 220+210)
    self.inputLab:setAnchorPoint(0,0)
    self.inputLab:setTouchEnabled(false)
    self.inputLab:setTouchSwallowEnabled(false)
    self:addChild(self.inputLab)

	--公告内容
	self.ggContent = display.newTTFLabel({
	    	text = "",
	    	size = 20,
	    	color = TextColor.TEXT_G,
	    	dimensions = cc.size(280,240)
		})
		-- display.setLabelFilter(self.ggContent)
		self.ggContent:setAnchorPoint(0,1)
		self.ggContent:setPosition(585,470)
		self:addChild(self.ggContent)

	--确定修改公告按钮
	local btn = display.newSprite("#com_labBtn1.png")
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn:setScale(1.0)
            self.ggContent:setString(StringUtil:replaceStr(self.ggContent:getString(),configHelper:getSensitiveWord()))
            local data = {
            	content = self.ggContent:getString()
        		
        	}
            GameNet:sendMsgToSocket(17016, data)
        end     
        return true
    end)
    btn:setPosition(720,250)
    local label = display.newTTFLabel({
    	text = "确定修改",
    	size = 22,
    	color = TextColor.TEXT_W
	})
	label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
	btn:addChild(label)
	display.setLabelFilter(label)
	self:addChild(btn)
	btn:setVisible(false) 
	self.sureModifyGGBtn = btn

	--四个按钮
	--还需要根据在行会的职位隐藏一些按钮
	local btnText = {
		[1] = "退出行会",
		[2] = "查看排名",
		[3] = "每日捐献"
	}
	for i=1,3 do
		local btn = display.newSprite("#com_labBtn1.png")
		if i == 3 then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_CONTRIBUTION,btn,104,34)
		end
		btn:setTouchEnabled(true)
	    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btn:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            self:onBtnClick(i)
	        end     
	        return true
	    end)
	    btn:setPosition(505+(i-1)*(140+20),155-45)
	    local label = display.newTTFLabel({
	    	text = btnText[i],
	    	size = 22,
	    	color = TextColor.TEXT_W
		})
		label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
		btn:addChild(label)
		display.setLabelFilter(label)
		self:addChild(btn) 
	end

	local modfiyBtn = display.newSprite("#com_labBtn1.png")
	modfiyBtn:setTouchEnabled(true)
	modfiyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	    if event.name == "began" then
	        modfiyBtn:setScale(1.2)
	        SoundManager:playClickSound()
	    elseif event.name == "ended" then
	        modfiyBtn:setScale(1.0)
	        self:onBtnClick(4)
	    end     
	    return true
	end)
	modfiyBtn:setPosition(824, 510)
	local label = display.newTTFLabel({
	    text = "修改",
	    size = 22,
	    color = TextColor.TEXT_W
	})
	label:setPosition(modfiyBtn:getContentSize().width/2,modfiyBtn:getContentSize().height/2)
	modfiyBtn:addChild(label)
	display.setLabelFilter(label)
	self:addChild(modfiyBtn) 

	--NodeEvent
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function GuildInfoPage:setData(data)
	self.data = data
	--行会名称
	self.rightLabels[1]:setString(data.guild_name)
	--行会会长
	self.rightLabels[2]:setString(data.chairman_name)
	--行会等级
	self.rightLabels[3]:setString(data.guild_lv)
	--行会资金
	self.rightLabels[7]:setString(data.capital)
	--行会排名
	self.rightLabels[4]:setString(data.guild_rank)
	--行会人数
	self.rightLabels[5]:setString(data.number.."/"..configHelper:getGuildMemberLimit(data.guild_lv))
	--行会经验
	self.rightLabels[6]:setString(data.exp.."/"..configHelper:getGuildExp(data.guild_lv))
	--行会公告
	self.ggContent:setString(data.announce)
end

function GuildInfoPage:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    end
end

function GuildInfoPage:onBtnClick(index)
	if not self.data then return end
	if index == 1 then 			--退出行会按钮
		local roleManager = RoleManager:getInstance()
	    local guildInfo = roleManager.guildInfo
		if self.data.number == 1 then
			local function enterFun()
	            --发送退出行会协议
	            GameNet:sendMsgToSocket(17013, {})

	        end
	        GlobalMessage:alert({
	            enterTxt = "确定",
	            backTxt= "取消",
	            tipTxt = "当前行会只有您一人,退出行会后你的帮众将会解散,确定退出行会吗?",
	            enterFun = handler(self, enterFun),
	            tipShowMid = true,
	        })
		else
			local isLeader = guildInfo.position == 1
			if isLeader then
				--会长不可以直接退出行会，需要将会长职位转移之后，才可以退出
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您贵为会长，先转移会长职位")
			else
				--其他行会成员可以无条件退出行会，退出行会后，成员的行会贡献清空
				local function enterFun()
		            --发送退出行会协议 
		            GameNet:sendMsgToSocket(17013, {})
		        end
		        GlobalMessage:alert({
		            enterTxt = "确定",
		            backTxt= "取消",
		            tipTxt = "退出行会后3小时内无法再次加入行会,确定退出行会吗?",
		            enterFun = handler(self, enterFun),
		            tipShowMid = true,
		        })
			end
		end
		
	elseif index == 2 then 		--查看排名按钮
		local guildListPage = GuildListPage.new(true)
		self:addChild(guildListPage)
	elseif index == 4 then 		--修改公告按钮
		local roleManager = RoleManager:getInstance()
	    local guildInfo = roleManager.guildInfo
	    --不是会长和副会长,没有权利
	    if guildInfo.position ~= 1 and guildInfo.position ~= 2 then
	    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"无处理权限")
	    	return 
	    end
		self.inputLab:touchDownAction(self,2)
	elseif index == 3 then 		--每日捐献按钮
		local node = DayDonateView.new()
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
	end
end

function GuildInfoPage:registerEvent()
	self.registerEventId = {}
    --取得行会详细信息
    local function onGuildDetailedInfo(data)
       self:setData(data.data)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_DETAILED_INFO, onGuildDetailedInfo)

    --行会公告修改成功
    local function onGuildNoticeChange(data)
       self.sureModifyGGBtn:setVisible(false)
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_NOTICE_CHANGE, onGuildNoticeChange)

    
end

function GuildInfoPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuildInfoPage:onShow()
	local info = GlobalController.guild:getGuildDetailedInfo()
	if info then
		self:setData(info)
	end
	--获取行会详细信息，多个界面用到
    GameNet:sendMsgToSocket(17010, {})
	self.sureModifyGGBtn:setVisible(false)
end

return GuildInfoPage