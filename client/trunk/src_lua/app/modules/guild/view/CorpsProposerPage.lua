--
-- Author: Shine
-- Date: 2016-09-05
-- 军团申请列表
--

local GMP_infoPerPage = 8
local GuildBasePage     = import(".GuildBasePage")
local ProposerListInfo  = import(".ProposerListInfo")
local SetGuildPowerView = import(".SetGuildPowerView")
local CorpsProposerPage = class("CorpsProposerPage", GuildBasePage)

function CorpsProposerPage:ctor()
	self:setPosition(-81,-60)

	local texts = {
		[1] = "名称",
		[2] = "等级",
		[3] = "职业",
		[4] = "战斗力",
		[5] = "状态"
	}
	local pos = {
		[1] = {x=370,y=530},
		[2] = {x=500,y=530},
		[3] = {x=615,y=530},
		[4] = {x=735,y=530},
		[5] = {x=865,y=530},
	}
	for i=1,5 do
		local label = display.newTTFLabel({
	    	text = texts[i],
	    	size = 20,
	    	color = TextColor.TEXT_O
		})
		display.setLabelFilter(label)
		label:setAnchorPoint(0.5,0.5)
		label:setPosition(pos[i].x,pos[i].y)
		self:addChild(label)
	end

	--四个按钮
	local btnText = {
		[1] = "申请设置",
		[2] = "清空列表",
		[3] = "拒 绝",
		[4] = "同 意"
	}
	for i=1,4 do
		local btn = display.newSprite("#com_labBtn1.png")
		btn:setTouchEnabled(true)
	    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            self:onBtnClick(i)
	        end     
	        return true
	    end)
	    btn:setPosition(365+(i-1)*(140+20),105)
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
	--frameBg
	local frameBg = display.newSprite("#com_moneyBg.png")
	frameBg:setPosition(615,205)
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
	self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	self:registerEvent()
end

function CorpsProposerPage:createPages(pageCount)
	for i=1,pageCount do
		local pageLayer = display.newLayer()
		pageLayer:setTouchSwallowEnabled(false)
		self:addChild(pageLayer)
		self.pageLayers[i] = pageLayer
		pageLayer:setVisible(false)
	end

	if self.pageLayers[1] then
		self.pageLayers[1]:setVisible(true)
	end

	--请求第一页列表
	GameNet:sendMsgToSocket(37008, {min_value=1,max_value=GMP_infoPerPage})
end

function CorpsProposerPage:createList(listData,min,max)
	if not listData or #listData==0 then return end 
	--是第几页的
	local page = math.ceil(min/GMP_infoPerPage)
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
			local proposerInfo = ProposerListInfo.new(listData[i],i)
	 		proposerInfo:setPosition(290,477-36*(i-1))
	 		proposerInfo:setTouchEnabled(true)
	 		proposerInfo:setTag(10)
	 		proposerInfo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				if event.name == "ended" then
		          	if self.curInfo then
		          		self.curInfo:removeChildByTag(10)
		          	end
	          		self.curInfo = proposerInfo
	          		self.curInfoInPage = page
	          		local sp = display.newScale9Sprite("#com_listBg2Sel.png", 0, 0, cc.size(635,36))
	          		sp:setTag(10)
	          		sp:setOpacity(100)
	          		sp:setPosition(proposerInfo:getContentSize().width/2+19,proposerInfo:getContentSize().height/2)
	          		proposerInfo:addChild(sp)
		        end     
		        return true
		    end)
	 		pageLayer:addChild(proposerInfo)
		end
		self.pageFirstLoad[page] = true
		table.insert(self.lastFivePage,page)
	end
end

function CorpsProposerPage:onNextPage(isRight)
	if not self.curPageIndex then return end
	local pageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
	if self.pageLayers[pageIndex] then
		self.pageLayers[self.curPageIndex]:setVisible(false)
		self.pageLayers[pageIndex]:setVisible(true)
		self.curPageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
		if self.pageFirstLoad[pageIndex] == nil then
			--请求下一页
			GameNet:sendMsgToSocket(37008, {min_value=(self.curPageIndex-1)*GMP_infoPerPage+1,max_value=(self.curPageIndex-1)*GMP_infoPerPage+GMP_infoPerPage})
		end
		self.labPage:setString(self.curPageIndex.."/"..(self.maxPage or 1))
	end
end

function CorpsProposerPage:onNodeEvent(data)
	if data.name == "cleanup" then
        self:unregisterEvent()
    end
end

function CorpsProposerPage:registerEvent()
	self.registerEventId = {}
    --取得一页申请人列表
    local function onGetListInfo(data)
    	self:createList(data.data.apply_legion_info,data.data.min_value)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_CORPS_PROPOSER_LISTINFO,onGetListInfo)

    --成员数改变
    local function onGetProposerCount(data)
        if self.haveGetCount == false then
        	local maxPage = data.data>1 and math.ceil(data.data/GMP_infoPerPage) or 1
	        self.maxPage = maxPage
    		self:createPages(maxPage)
    		self.curPageIndex = 1
	        self.labPage:setString(self.curPageIndex.."/"..maxPage)
    		self.haveGetCount = true
    	end
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_CORPS_PROPOSER_COUNT,onGetProposerCount)

    --同意入会
    local function onAgree(data)
    	local playerId = data.data
    	for _,v in pairs(self.pageLayers) do
    		local childs = v:getChildren()
    		for i=1,#childs do
    			if childs[i].data and childs[i].data.player_id == playerId then
    				local sp = display.newSprite("#com_txtAgree.png")
    				sp:setPosition(10,childs[i]:getContentSize().height/2)
    				childs[i]:addChild(sp)
    				return 
    			end
    		end
    	end
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(CorpsEvent.PROPOSER_AGREE,onAgree)

    --拒绝入会
    local function onRefuse(data)
    	local playerId = data.data
    	for _,v in pairs(self.pageLayers) do
    		local childs = v:getChildren()
    		for i=1,#childs do
    			if childs[i].data and childs[i].data.player_id == playerId then
    				local sp = display.newSprite("#com_txtRefuse.png")
    				sp:setPosition(10,childs[i]:getContentSize().height/2)
    				childs[i]:addChild(sp)
    				return 
    			end
    		end
    	end
    end
    self.registerEventId[4] = GlobalEventSystem:addEventListener(CorpsEvent.PROPOSER_REFUSE,onRefuse)

    --申请人已被处理
    local function onProposerHandle(data)
    	--yjc
    end
    self.registerEventId[5] = GlobalEventSystem:addEventListener(CorpsEvent.PROPOSER_HANDLE,onProposerHandle)
end

function CorpsProposerPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function CorpsProposerPage:onBtnClick(index)
	local roleManager = RoleManager:getInstance()
    local corpsInfo = roleManager.corpsInfo
    --不是团长和副团长,没有权利
    if corpsInfo.position ~= 1 and corpsInfo.position ~= 2 then
    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"无处理权限")
    	return 
    end
	if index == 1 then 			--申请设置
		--不是团长和副团长,没有权利
	    if corpsInfo.position ~= 1 and corpsInfo.position ~= 2 then
	    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"无处理权限")
	    	return 
	    end
	    local node = SetGuildPowerView.new(true)
	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
	elseif index == 2 then 		--清空列表
		if self.pageLayers then
			for k,v in pairs(self.pageLayers) do
				v:removeSelf()
			end
		end
		self.pageLayers = {}
		self.labPage:setString("1/1")
		GameNet:sendMsgToSocket(37020,{})
	elseif index == 3 then 		--拒绝
		if not self.curInfo then return end
		local data = {
			player_id = self.curInfo.data.player_id,
			["type"] = 2 
		}
		GameNet:sendMsgToSocket(37009,data)
	elseif index == 4 then 		--同意
		if not self.curInfo then return end
		local data = {
			player_id = self.curInfo.data.player_id,
			["type"] = 1 
		}
		GameNet:sendMsgToSocket(37009,data)
	end
end

function CorpsProposerPage:onShow()
	if self.pageLayers then
		for k,v in pairs(self.pageLayers) do
			v:removeSelf()
		end
	end
	self.pageLayers = {}
	self.pageFirstLoad = {}
	self.curPageIndex = nil
	self.curInfo = nil
	self.lastFivePage = {}

	--请求有多少申请人
	GameNet:sendMsgToSocket(37007,{})
	--
	self.haveGetCount = false
end

return CorpsProposerPage


