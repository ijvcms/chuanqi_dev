--
-- Author: Yi hanneng
-- Date: 2016-06-22 11:01:07
--

local GuildWarItem = GuildWarItem or class("GuildWarItem", function() return display.newNode() end)

local GuidWarWin = GuidWarWin or class("GuidWarWin", BaseView)

function GuidWarWin:ctor(winTag,data,winconfig)
	GuidWarWin.super.ctor(self,winTag,data,winconfig)
	self:init()
	self.isCancelRemoveSpriteFrams = true
end

function GuidWarWin:init()
	self.btnLeft = self:seekNodeByName("btnLeft")
	self.btnRight = self:seekNodeByName("btnRight")
	self.pageLabel = self:seekNodeByName("pageLabel")
	self.mainLayer = self:seekNodeByName("mainLayer")

	self.itemList = {}
	self.pageData = {}
	self.count = 5

	for i=1,self.count do
		local item = GuildWarItem.new()
		self.itemList[i] = item
		self.mainLayer:addChild(item)
		item:setPosition(0, (self.count - i)*(item:getContentSize().height + 2) - 8)
	end
  	--下一页按钮
	 
	self.btnLeft:setTouchEnabled(true)
    self.btnLeft:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnLeft:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnLeft:setScale(1.0)
            self:onNextPage(false)
        end     
        return true
    end)
     
	--上一页按钮
	 
	self.btnRight:setTouchEnabled(true)
    self.btnRight:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRight:setScaleY(1.2)
          
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnRight:setScaleY(1.0)
            self:onNextPage(true)
        end     
        return true
    end)
    

end

function GuidWarWin:setViewInfo(data)


	for i=#self.itemList,#data,-1 do
		self.itemList[i]:setVisible(false)
	end

	for i=1,#data do
		self.itemList[i]:setData(data[i])
		self.itemList[i]:setVisible(true)
	end

	self.pageLabel:setString(self.curPageIndex.."/"..(self.maxPage or 1))
end

function GuidWarWin:onNextPage(isRight)

	if not self.curPageIndex then return end

	local page = isRight and self.curPageIndex + 1 or self.curPageIndex - 1
	 
	if page > self.maxPage or page < 1 then
		return
	end

	self.curPageIndex = isRight and self.curPageIndex + 1 or self.curPageIndex - 1

	if self.pageData[self.curPageIndex] == nil then
		GameNet:sendMsgToSocket(17005, {min_value=(self.curPageIndex-1)*self.count+1,max_value=(self.curPageIndex-1)*self.count+self.count})
 	else
 		self:setViewInfo(self.pageData[self.curPageIndex])
	end

end

function GuidWarWin:open()
	self.registerEventId = {}

	--行会数改变
    local function onGetGuildCount(data)

        	if data.data > 1 then
        		if data.data%self.count == 0 then
	        	 	self.maxPage = data.data/self.count
	        	else
	        	 	self.maxPage = math.ceil(data.data/self.count)
	        	end
        	else
        		self.maxPage = 1
        	end

    		self.curPageIndex = 1
	        self.pageLabel:setString(self.curPageIndex.."/"..self.maxPage)
    		 
    		GameNet:sendMsgToSocket(17005, {min_value=1,max_value=self.count})
 
    end
 
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_COUNT,onGetGuildCount)
	 --取得一页行会列表
    local function onGetListInfo(data)
    	self.pageData[self.curPageIndex] = data.data
    	self:setViewInfo(data.data)
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_LISTINFO,onGetListInfo)
    GameNet:sendMsgToSocket(17004, {})
end

function GuidWarWin:close()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuidWarWin:destory()
	self:close()
	self.super.destory(self)
end


-------------------------------------
function GuildWarItem:ctor()
	self.ccui = cc.uiloader:load("resui/guildWarItem.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function GuildWarItem:init()
	self.rankLabel =  cc.uiloader:seekNodeByName(self.ccui, "rankLabel")
	self.unionName =  cc.uiloader:seekNodeByName(self.ccui, "unionName")
	self.ownerName =  cc.uiloader:seekNodeByName(self.ccui, "ownerName")
	self.unionLevel =  cc.uiloader:seekNodeByName(self.ccui, "unionLevel")
	self.powerLabel =  cc.uiloader:seekNodeByName(self.ccui, "powerLabel")
	self.peopleNum =  cc.uiloader:seekNodeByName(self.ccui, "peopleNum")
	self.operateBtn =  cc.uiloader:seekNodeByName(self.ccui, "operateBtn")

	self.operateBtn:setTouchEnabled(true)
    self.operateBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.operateBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.operateBtn:setScale(1.0)
            GlobalController.guild:requestGuildWar(self.data.guild_id)
        end     
        return true
    end)

end

function GuildWarItem:setData(data)

	if data == nil then
		return 
	end

	self.data = data

	if self.data.guild_id == RoleManager:getInstance().guildInfo.guild_id then
		self.operateBtn:setVisible(false)
	else
		self.operateBtn:setVisible(true)
	end

	self.rankLabel:setString(data.guild_rank)
	self.unionName:setString(data.guild_name)
	self.ownerName:setString(data.chairman_name)
	self.unionLevel:setString(data.guild_lv)
	self.powerLabel:setString(data.fight)
	self.peopleNum:setString(data.number.."/"..configHelper:getGuildMemberLimit(data.guild_lv))

end
 
return GuidWarWin