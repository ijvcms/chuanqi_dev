--行会列表项
local CreateGuildView = import(".CreateGuildView")

local GuildListInfo = class("GuildListInfo", function()
	return display.newNode()
end)

function GuildListInfo:ctor(data,idx)
	self.data = data
	self:setContentSize(880,36)
	--底图
	-- if idx%2==0 then
	-- 	local bg = GradientTips.new({width = 650,height = 36},cc.c3b(80,80,80))
	-- 	bg:setPosition((self:getContentSize().width-bg:getContentSize().width)/2,0)
	-- 	self:addChild(bg)
	-- end

	--排名
	local labPM = display.newTTFLabel({
    	text = data.guild_rank,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labPM = labPM
	display.setLabelFilter(labPM)
	labPM:setPosition(85,18)
	self:addChild(labPM)
	--行会名称
	local labBHMC = display.newTTFLabel({
    	text = data.guild_name,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labBHMC = labBHMC
	display.setLabelFilter(labBHMC)
	labBHMC:setPosition(240,18)
	self:addChild(labBHMC)
	--行会会长
	local labBHHZ = display.newTTFLabel({
    	text = data.chairman_name,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labBHHZ = labBHMC
	display.setLabelFilter(labBHHZ)
	labBHHZ:setPosition(400,18)
	self:addChild(labBHHZ)
	--行会等级
	local labBHDJ = display.newTTFLabel({
    	text = data.guild_lv,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labBHDJ = labBHDJ
	display.setLabelFilter(labBHDJ)
	labBHDJ:setPosition(550,18)
	self:addChild(labBHDJ)
	--战力要求
	local labZLYQ = display.newTTFLabel({
    	text = data.fight,
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labZLYQ = labZLYQ
	display.setLabelFilter(labZLYQ)
	labZLYQ:setPosition(700,18)
	self:addChild(labZLYQ)
	--行会人数
	local labBHRS = display.newTTFLabel({
    	text = data.number.."/"..configHelper:getGuildMemberLimit(data.guild_lv),
    	size = 20,
    	color = TextColor.TEXT_W
	})
	self.labBHRS = labBHRS
	display.setLabelFilter(labBHRS)
	labBHRS:setPosition(850,18)
	self:addChild(labBHRS)

	
end

-- function GuildListInfo:setData(data)
-- 	self.labPM:setString(data.guild_rank)
-- 	self.labBHMC:setString(data.guildName)
-- 	self.labBHHZ:setString(data.leaderName)
-- 	self.labBHDJ:setString(data.guildLevel)
-- 	self.labZLYQ:setString(data.powerRequire)
-- 	self.labBHRS:setString(data.memberCur.."/"..data.memberMax)
-- end

--行会列表页
local infoPerPage = 9 	--每页9条信息
local GuildListPage = class("GuildListPage", function()
	return display.newNode()
end)

local isSinglePage = ture

function GuildListPage:ctor(isSinglePage)

	self.isSinglePage = isSinglePage
	self:setTouchSwallowEnabled(false)
	if true then
		local sp3 = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(880,500))
		sp3:setAnchorPoint(0,0)

		if isSinglePage then
			sp3:setPosition(81,58)
		else
			sp3:setPosition(0,0)
		end
		sp3:setTouchEnabled(true)
		sp3:setTouchSwallowEnabled(true)
		self:addChild(sp3)
	end


	local xxOffset = -50
	local yyOffset = -57
	if isSinglePage then
		
		xxOffset = 40
		yyOffset = 0
	end

	--"排名"
	local labPM = display.newTTFLabel({
    	text = "排名",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labPM)
	labPM:setPosition(85+xxOffset,530+yyOffset)
	self:addChild(labPM)
	--"行会名称"
	local labBHMC = display.newTTFLabel({
    	text = "行会名称",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labBHMC)
	labBHMC:setPosition(240+xxOffset,530+yyOffset)
	self:addChild(labBHMC)
	--"行会会长"
	local labBHHZ = display.newTTFLabel({
    	text = "行会会长",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labBHHZ)
	labBHHZ:setPosition(400+xxOffset,530+yyOffset)
	self:addChild(labBHHZ)
	--"行会等级"
	local labBHDJ = display.newTTFLabel({
    	text = "行会等级",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labBHDJ)
	labBHDJ:setPosition(550+xxOffset,530+yyOffset)
	self:addChild(labBHDJ)
	--"战力要求"
	local labZLYQ = display.newTTFLabel({
    	text = "战力要求",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labZLYQ)
	labZLYQ:setPosition(700+xxOffset,530+yyOffset)
	self:addChild(labZLYQ)
	--"行会人数"
	local labBHRS = display.newTTFLabel({
    	text = "行会人数",
    	size = 20,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labBHRS)
	labBHRS:setPosition(850+xxOffset,530+yyOffset)
	self:addChild(labBHRS)

	if not isSinglePage then
		--创建行会按钮
		local btnCreateGuild = display.newSprite("#com_labBtn2.png")
		self.btnCreateGuild = btnCreateGuild
		btnCreateGuild:setTouchEnabled(true)
	    btnCreateGuild:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btnCreateGuild:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btnCreateGuild:setScale(1.0)
	            self:onCreateGuildClick()
	        end     
	        return true
	    end)
	    btnCreateGuild:setPosition(250+xxOffset,155+yyOffset -62)
	    local label = display.newTTFLabel({
	    	text = "创建行会",
	    	size = 22,
	    	color = TextColor.TEXT_W
		})
		label:setPosition(btnCreateGuild:getContentSize().width/2,btnCreateGuild:getContentSize().height/2)
		btnCreateGuild:addChild(label)
		display.setLabelFilter(label)
		self:addChild(btnCreateGuild)
		--申请加入按钮
		local btnApplyGuild = display.newSprite("#com_labBtn2.png")
		self.btnApplyGuild = btnApplyGuild
		btnApplyGuild:setTouchEnabled(true)
	    btnApplyGuild:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btnApplyGuild:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btnApplyGuild:setScale(1.0)
	            self:onApplyGuildClick()
	        end     
	        return true
	    end)
	    btnApplyGuild:setPosition(960-250+xxOffset,155+yyOffset-62)
	    local label = display.newTTFLabel({
	    	text = "申请加入",
	    	size = 22,
	    	color = TextColor.TEXT_W
		})
		label:setPosition(btnApplyGuild:getContentSize().width/2,btnApplyGuild:getContentSize().height/2)
		btnApplyGuild:addChild(label)
		display.setLabelFilter(label)
		BaseTipsBtn.new(BtnTipsType.BTN_GUILD_APPLY, btnApplyGuild, 130,46)
		self:addChild(btnApplyGuild)
	end
	

	--frameBg
	local frameBg = display.newSprite("#com_moneyBg.png")
	frameBg:setPosition(480+xxOffset,155+yyOffset-62)
	self:addChild(frameBg)
	--下一页按钮
	local nextPageBtn = display.newSprite("#com_arrowBtn1.png")
	nextPageBtn:setTouchEnabled(true)
    nextPageBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            nextPageBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            nextPageBtn:setScale(1.0)
            self:onNextPage(true)
        end     
        return true
    end)
    nextPageBtn:setPosition(frameBg:getContentSize().width/2+60,frameBg:getContentSize().height/2)
    frameBg:addChild(nextPageBtn)
	--上一页按钮
	local prePageBtn = display.newSprite("#com_arrowBtn1.png")
	prePageBtn:setScaleX(-1)
	prePageBtn:setTouchEnabled(true)
    prePageBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            prePageBtn:setScaleY(1.1)
            prePageBtn:setScaleX(-1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            prePageBtn:setScaleY(1.0)
            prePageBtn:setScaleX(-1.0)
            self:onNextPage(false)
        end     
        return true
    end)
    prePageBtn:setPosition(frameBg:getContentSize().width/2-60,frameBg:getContentSize().height/2)
    frameBg:addChild(prePageBtn)
	--"当前页/总页数"
	self.labPage = display.newTTFLabel({
    	text = "1/1",
    	size = 22,
    	color = TextColor.TEXT_W
	})
	display.setLabelFilter(self.labPage)
	self.labPage:setPosition(frameBg:getContentSize().width/2,frameBg:getContentSize().height/2)
	frameBg:addChild(self.labPage)

	--
	self.pageLayers = {}
	self.pageFirstLoad = {}
	self.curPageIndex = nil
	self.curInfo = nil
	self.lastFivePage = {}
	--
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onEnter))

	--
	self:registerEvent()

	--请求有多少行会
	GameNet:sendMsgToSocket(17004, {})

	self.haveGetCount = false
end

function GuildListPage:onEnter(data)
	if data.name == "cleanup" then
        self:unregisterEvent()
    end
end

function GuildListPage:createPages(pageCount)
	for i=1,pageCount do
		local pageLayer = display.newLayer()
		pageLayer:setTouchSwallowEnabled(false)
		self:addChild(pageLayer)

		if self.isSinglePage then
			pageLayer:setPosition(38,-18)
		else	
			pageLayer:setPosition(-47,-71)
		end
		self.pageLayers[i] = pageLayer
		pageLayer:setVisible(false)
	end

	if self.pageLayers[1] then
		self.pageLayers[1]:setVisible(true)
	end

	--请求第一页列表
	GameNet:sendMsgToSocket(17005, {min_value=1,max_value=9})
end

function GuildListPage:registerEvent()
	self.registerEventId = {}

	--行会数改变
    local function onGetGuildCount(data)
        if self.haveGetCount == false then
        	local maxPage = data.data>1 and math.ceil(data.data/infoPerPage) or 1
	        self.maxPage = maxPage
    		self:createPages(maxPage)
    		self.curPageIndex = 1
	        self.labPage:setString(self.curPageIndex.."/"..maxPage)
    		self.haveGetCount = true
    	end
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_COUNT,onGetGuildCount)

    --加入行会成功
    local function onJoinGuild(data)
        self:unregisterEvent()
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(GuildEvent.JOIN_GUILD,onJoinGuild)

    --取得一页行会列表
    local function onGetListInfo(data)
    	self:createList(data.data)
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_LISTINFO,onGetListInfo)
end

function GuildListPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuildListPage:onNextPage(isRight)
	if not self.curPageIndex then return end
	local pageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
	if self.pageLayers[pageIndex] then

		self.pageLayers[self.curPageIndex]:setVisible(false)
		self.pageLayers[pageIndex]:setVisible(true)
		self.curPageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
		if self.pageFirstLoad[pageIndex] == nil then
			--请求下一页
			GameNet:sendMsgToSocket(17005, {min_value=(self.curPageIndex-1)*infoPerPage+1,max_value=(self.curPageIndex-1)*infoPerPage+9})
		end
		self.labPage:setString(self.curPageIndex.."/"..(self.maxPage or 1))
	end
end

function GuildListPage:onCreateGuildClick()		
 	local node = CreateGuildView.new()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
end

function GuildListPage:onApplyGuildClick()
	if not self.curInfo then return end
	local data = {
		guild_id = self.curInfo.data.guild_id
	}
	--发送申请加入行会协议
	GameNet:sendMsgToSocket(17006,data)
end

function GuildListPage:createList(listData)
	if not listData or #listData==0 then return end 
	--根据排名判断是第几页的
	local page = math.ceil(listData[1].guild_rank/infoPerPage)
	if self.pageFirstLoad[page] == nil then 	--第一次取得该页数据
		if #self.lastFivePage == 5 then
			self.pageFirstLoad[self.lastFivePage[1]] = nil
			self.pageLayers[self.lastFivePage[1]]:removeAllChildren()
			if self.curInfoInPage and self.curInfoInPage == self.lastFivePage[1] then
				self.curInfo = nil
			end
			table.remove(self.lastFivePage,1)
		end 
		local pageLayer = self.pageLayers[page]
		if not pageLayer then return end
		for i=1,#listData do
			local guildInfo = GuildListInfo.new(listData[i],i)
	 		guildInfo:setPosition(0,477-36*(i-1))
	 		guildInfo:setTouchEnabled(true)
	 		guildInfo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				if event.name == "ended" then
		          	if self.curInfo then
		          		self.curInfo:removeChildByTag(10)
		          	end
	          		self.curInfo = guildInfo
	          		self.curInfoInPage = page
	          		local sp = display.newScale9Sprite("#com_listBg2Sel.png", 0, 0, cc.size(865,36),cc.rect(16, 16,1, 1))
	          		--display.newScale9Sprite("#com_listBg2Sel.png")
	          		sp:setTag(10)
	          		sp:setOpacity(100)
	          		sp:setPosition(guildInfo:getContentSize().width/2+46,guildInfo:getContentSize().height/2)
	          		guildInfo:addChild(sp)
		        end     
		        return true
		    end)
	 		pageLayer:addChild(guildInfo)

	 		if i== 1 then
	 			if self.curInfo then
		          		self.curInfo:removeChildByTag(10)
		          	end
	          		self.curInfo = guildInfo
	          		self.curInfoInPage = page
	          		local sp = display.newScale9Sprite("#com_listBg2Sel.png", 0, 0, cc.size(865,36),cc.rect(16, 16,1, 1))
	          		--display.newScale9Sprite("#com_listBg2Sel.png")
	          		sp:setTag(10)
	          		sp:setOpacity(100)
	          		sp:setPosition(guildInfo:getContentSize().width/2+46,guildInfo:getContentSize().height/2)
	          		guildInfo:addChild(sp)
	 		end
		end
		self.pageFirstLoad[page] = true
		table.insert(self.lastFivePage,page)
	end
end

return GuildListPage