--
-- Author: Shine
-- Date: 2016-09-05
--
--军团成员页
local GMP_infoPerPage = 8
local GuildBasePage   = import(".GuildBasePage")
local MemberListInfo  = import(".MemberListInfo")
local MoreOperateList = import(".MoreOperateList")
local CorpsMemberPage = class("CorpsMemberPage", GuildBasePage)

function CorpsMemberPage:ctor()
	self:setPosition(-81,-60)
	local texts = {
		[1] = "名称",
		[2] = "职位",
		[3] = "等级",
		[4] = "职业",
		[5] = "战斗力",
		[6] = "贡献"
	}
	local pos = {
		[1] = {x=370,y=530},
		[2] = {x=500,y=530},
		[3] = {x=580,y=530},
		[4] = {x=665,y=530},
		[5] = {x=760,y=530},
		[6] = {x=860,y=530}
	}
	for i=1,6 do
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

	--两个按钮
	local btnText = {
		[1] = "更多操作",
	}
	for i=1,1 do
		local btn = display.newSprite("#com_labBtn1.png")
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
	    btn:setPosition(680+140+20,155-50)
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

function CorpsMemberPage:createPages(pageCount)
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
	GameNet:sendMsgToSocket(37012, {min_value=1,max_value=GMP_infoPerPage})
end

function CorpsMemberPage:createList(listData,min,max)
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
			local memberInfo = MemberListInfo.new(listData[i], i, true)
	 		memberInfo:setPosition(290,477-36*(i-1))
	 		memberInfo:setTouchEnabled(true)
	 		memberInfo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
				if event.name == "ended" then
		          	if self.curInfo then
		          		self.curInfo:removeChildByTag(10)
		          	end
	          		self.curInfo = memberInfo
	          		self.curInfoInPage = page
	          		local sp = display.newScale9Sprite("#com_listBg2Sel.png", 0, 0, cc.size(635,36),cc.rect(16, 16,1, 1))
	          		sp:setTag(10)
	          		sp:setOpacity(100)
	          		sp:setPosition(memberInfo:getContentSize().width/2,memberInfo:getContentSize().height/2)
	          		memberInfo:addChild(sp)
		        end     
		        return true
		    end)
	 		pageLayer:addChild(memberInfo)
		end
		self.pageFirstLoad[page] = true
		table.insert(self.lastFivePage,page)
	end
end

function CorpsMemberPage:onNextPage(isRight)
	if not self.curPageIndex then return end
	local pageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
	if self.pageLayers[pageIndex] then
		self.pageLayers[self.curPageIndex]:setVisible(false)
		self.pageLayers[pageIndex]:setVisible(true)
		self.curPageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
		if self.pageFirstLoad[pageIndex] == nil then
			--请求下一页
			GameNet:sendMsgToSocket(37012, {min_value=(self.curPageIndex-1)*GMP_infoPerPage+1,max_value=(self.curPageIndex-1)*GMP_infoPerPage+GMP_infoPerPage})
		end
		self.labPage:setString(self.curPageIndex.."/"..(self.maxPage or 1))
	end
end

function CorpsMemberPage:onNodeEvent(data)
	if data.name == "cleanup" then
        self:unregisterEvent()
    end
end

function CorpsMemberPage:registerEvent()
	self.registerEventId = {}
    --取得一页成员列表
    local function onGetListInfo(data)
    	self:createList(data.data.legion_member_info_list,data.data.min_value)
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_CORPS_MEMBER_LISTINFO, onGetListInfo)

    --成员数改变
    local function onGetMemberCount(data)
        if self.haveGetCount == false then
        	local maxPage = data.data>1 and math.ceil(data.data/GMP_infoPerPage) or 1
	        self.maxPage = maxPage
    		self:createPages(maxPage)
    		self.curPageIndex = 1
	        self.labPage:setString(self.curPageIndex.."/"..maxPage)
    		self.haveGetCount = true
    	end
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_CORPS_MEMBER_COUNT,onGetMemberCount)

    --成员职位改变
    local function onMemberPositionChange(data)
		for k,v in pairs(self.pageLayers) do
			local childs = v:getChildren()
			for i=1,#childs do
				if childs[i].data.player_id == data.data.player_id then
					childs[i].data.position = data.data.position
					childs[i].labs[2]:setString(CorpsPosition[data.data.position])
					local playerName = childs[i].data.player_name
					GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(ERR_COMMON_SUCCESS,playerName.."被任命为"..CorpsPosition[data.data.position]))
					return 
				end
			end
		end
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_APPOINT_MEMBER,onMemberPositionChange)

    --成员详细信息
	-- local function onReqMemberDetail(data)
	-- 	local node = OtherRoleView.new()
	-- 	node:setData(data.data)
	-- 	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)  
	-- end
	-- self.registerEventId[4] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GET_MEMBER_INFO,onReqMemberDetail)

	--成员被踢出行会
	local function onReqRejectMember(data)
		self:onShow()
	end
	self.registerEventId[4] = GlobalEventSystem:addEventListener(CorpsEvent.REQ_REJECT_MEMBER,onReqRejectMember)
end

function CorpsMemberPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
    if self.RoleCorpsInfoChangeEvent then
    	GlobalEventSystem:removeEventListenerByHandle(self.RoleCorpsInfoChangeEvent)
    	self.RoleCorpsInfoChangeEvent = nil
    end
end

function CorpsMemberPage:onBtnClick(index)
	if not self.curInfo then return end
	if index == 1 then 		--更多操作按钮
		local roleManager = RoleManager:getInstance()
		local roleInfo = roleManager.roleInfo 
		if self.curInfo.data.player_id == roleInfo.player_id then
			GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"不可对自己操作")
			return
		end
	    local corpsInfo = roleManager.corpsInfo
	    local node
	    if corpsInfo.position == 1 then 			--会长
	    	node = MoreOperateList.new({1,2,3,4,5},self.curInfo.data,{[3]=handler(self,self.onTransferLeader)}, true)
	    elseif corpsInfo.position == 2 then 		--副会长
	    	node = MoreOperateList.new({1,2,4,5},self.curInfo.data,nil, true)
	    elseif corpsInfo.position == 3 or corpsInfo.position==4 then 		--精英和会员
	    	node = MoreOperateList.new({1,2},self.curInfo.data,nil, true)
	    else
	    	return 
	    end
	    if node then
	    	node:setPosition(display.width/2,display.height/2)
	    	-- node:setPosition(0,0)
	    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)  
	    end
	end
end

function CorpsMemberPage:onTransferLeader()
	local roleManager = RoleManager:getInstance()
    local corpsInfo = roleManager.corpsInfo
    --不是会长,没有权利
    if corpsInfo.position ~= 1 then
    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"无处理权限")
    	return 
    end
    GameNet:sendMsgToSocket(37019, {player_id = self.curInfo.data.player_id, position = 1})
    --主角帮会职位信息改变
    if not self.RoleCorpsInfoChangeEvent then
    	local function onRoleCorpsInfoChange()
    		if self.RoleCorpsInfoChangeEvent then
		    	GlobalEventSystem:removeEventListenerByHandle(self.RoleCorpsInfoChangeEvent)
		    	self.RoleCorpsInfoChangeEvent = nil
		    end
	    	local roleManager = RoleManager:getInstance()
	    	local roleInfo = roleManager.roleInfo
		    local corpsInfo = roleManager.corpsInfo
		    for k,v in pairs(self.pageLayers) do
				local childs = v:getChildren()
				for i=1,#childs do
					if childs[i].data.player_id == roleInfo.player_id then
						childs[i].data.position = corpsInfo.position
						childs[i].labs[2]:setString(GuildPosition[corpsInfo.position])
						return 
					end
				end
			end
	    end
	    self.RoleCorpsInfoChangeEvent = GlobalEventSystem:addEventListener(CorpsEvent.ROLE_CORPS_INFO_CHANGE,onRoleCorpsInfoChange)
    end
end

function CorpsMemberPage:onShow()
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

	--请求有多少成员
	GameNet:sendMsgToSocket(37015,{})
	--
	self.haveGetCount = false
end

return CorpsMemberPage


