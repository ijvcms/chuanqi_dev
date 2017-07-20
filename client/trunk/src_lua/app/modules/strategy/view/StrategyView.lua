--
-- Author: Yi hanneng
-- Date: 2016-07-18 17:49:51
--
require("app.modules.strategy.StrategyManager")

local StrategyView = StrategyView or class("StrategyView", BaseView)

local strategyItemS =  class("strategyItemS", function()return display.newNode()end)
local strategyItemM =  class("strategyItemM", function()return display.newNode()end)
local strategyItemL =  class("strategyItemL", function()return display.newNode()end)


 
function StrategyView:ctor(winTag,data,winconfig)
    StrategyView.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
    self:creatPillar()
    
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")

    self.leftLayer = cc.uiloader:seekNodeByName(win,"leftLayer")
    self.rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")

    self:initStrategy()
    self:initChapterList()
    self.list_strategy:selectOne(1)
    --self:showStrategyContent(1)
end

function StrategyView:initStrategy()
    --攻略列表
 
    self.list_strategy = require("app.gameui.CQMenuList").new(cc.rect(0,0,175, 470),cc.ui.UIScrollView.DIRECTION_VERTICAL)
        :pos(44-72+36,102-83-14)
        :addTo(self.leftLayer)
 	self.list_strategy:setItemClickFunc(handler(self, self.itemClick))
	self.list_strategy:setMenuItemClickFunc(handler(self, self.itemClick))
	self:createMenu()

end

function StrategyView:createMenu()
	local data = StrategyManager:getInstance():getMenuData()
	self.list_strategy:setData(data[1],data[2],require("app.modules.exChange.view.ExchangeMenuItem"))
end

function StrategyView:itemClick(item)
 
	local key = item:getData().key
	local type = item:getData().type
	local function_id = item:getData().function_id

	if function_id and function_id ~= 0 then
		FunctionOpenManager:gotoFunctionById(function_id)
        self:onCloseClick()
	elseif self.currentKey ~= key then
		self.currentKey = key
		self:loadChapterByStrategyId(key,type)
	end
 
end

function StrategyView:initChapterList()

	self.itemList = {}
	self.contentLayer = cc.Node:create()
    self.contentLayer:setAnchorPoint(0,0)
	self.scrollView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.rightLayer:getContentSize().width - 10,self.rightLayer:getContentSize().height -10)})
        :addScrollNode(self.contentLayer)  
        :pos(5, 5) 
        :addTo(self.rightLayer)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)  
        --:onScroll(handler(self, self.onTouchHandler))
         
    self.scrollView:setTouchSwallowEnabled(false)
    
end
 
function StrategyView:loadChapterByStrategyId(strategyId,type)
     
    if #self.itemList > 0 then
    	for i=1,#self.itemList do
    		self.itemList[i]:removeSelf()
    	end

    	self.itemList = {}
    end

    local chapterList

    if type == SCLIST_TYPE.SCLIST_MENU then
    	chapterList = configHelper:getStrategyChaptersByType(strategyId)
	else
		chapterList = configHelper:getStrategyChaptersById(strategyId)
	end
    
    
    if chapterList == nil or chapterList[1] == nil then
		return 
	end

	if chapterList[1].chapter_type == 1 then
		self:createItemS(chapterList)
	elseif chapterList[1].chapter_type == 2 then
		self:createItemM(chapterList)
	elseif chapterList[1].chapter_type == 3 then
		self:createItemL(chapterList)
	end
    
end


function StrategyView:createItemS(data)

	if self.contentLayer~= nil and data ~= nil then
 
 		local itemWidth = 0
        local itemHeight = 0
        local item
        for i=1,#data do
            item = strategyItemS.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onCloseClick))
            self.contentLayer:addChild(item)
 			itemWidth = item:getContentSize().width + 24
 			itemHeight = item:getContentSize().height + 24
            item:setPosition(((i-1)%3)*itemWidth + 40,itemHeight*math.ceil(#data/3) - math.floor((i-1)/3)*itemHeight - itemHeight/2)
            self.itemList[#self.itemList+1] = item
        end

        self.contentLayer:setContentSize(cc.size(self.rightLayer:getContentSize().width - 10, itemHeight*math.ceil(#data/3)))
        self.scrollView:scrollTo(0, self.rightLayer:getContentSize().height - self.contentLayer:getContentSize().height - itemHeight/2)
    end

    self.scrollView:scrollAuto() 
 
end

function StrategyView:createItemM(data)
	if self.contentLayer~= nil and data ~= nil then
 
 		local itemWidth = 0
        local itemHeight = 0
    
        for i=1,#data do
            local item = strategyItemM.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onCloseClick))
            self.contentLayer:addChild(item)
 			itemWidth = item:getContentSize().width
 			itemHeight = item:getContentSize().height
            item:setPosition( 0,itemHeight*#data - (i-1)*itemHeight - itemHeight/2)
            self.itemList[#self.itemList+1] = item
        end

        self.contentLayer:setContentSize(cc.size(itemWidth, itemHeight*#data))
        self.contentLayer:setPosition(0, self.rightLayer:getContentSize().height - self.contentLayer:getContentSize().height - itemHeight/2- 5)
    end

    self.scrollView:scrollAuto() 
end

function StrategyView:createItemL(data)

	if self.contentLayer~= nil and data ~= nil then
 
 		local itemWidth = 0
        local itemHeight = 0

        for i=1,#data do
            local item = strategyItemL.new()
            item:setData(data[i])
            item:setItemClickFunc(handler(self, self.onCloseClick))
            self.contentLayer:addChild(item)
 			itemWidth = item:getContentSize().width
 			itemHeight = item:getContentSize().height
            item:setPosition( 0,itemHeight*#data - (i-1)*itemHeight - itemHeight/2)
            self.itemList[#self.itemList+1] = item
        end

        self.contentLayer:setContentSize(cc.size(itemWidth, itemHeight*#data))
        self.contentLayer:setPosition(0, self.rightLayer:getContentSize().height - self.contentLayer:getContentSize().height - itemHeight/2 - 5)
    end

    self.scrollView:scrollAuto() 
end

 

--关闭按钮回调
function StrategyView:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)
end

function StrategyView:close()
end



--------------------------------------------

function strategyItemS:ctor()
	self.ccui = cc.uiloader:load("resui/strategyItemS.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function strategyItemS:init()
	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
	self.desLabel = cc.uiloader:seekNodeByName(self.ccui, "desLabel")
 
	self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "selectBtn")
 	self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.data and self.data.function_id ~= 0 then
            	--self:onCloseClick()
                FunctionOpenManager:gotoFunctionById(self.data.function_id)
                if self.func ~= nil then
                    self.func()
                end
            end
        end
            return true
    end)
end

function strategyItemS:setData(data)
	if data == nil then
		return
	end
	self.data = data
	self.titleLabel:setString(data.title)
	local chapterContent = SuperRichText.new(data.content, self.ccui:getContentSize().width - 20)
        :addTo(self.ccui)
    chapterContent:setPosition(20, self.titleLabel:getPositionY() - chapterContent:getContentSize().height - 14)
    chapterContent:setContentSize(0, 0)
    if data.function_id ~= 0 then
    	self.goBtn:setButtonLabelString(data.button_label)
    else
    	self.goBtn:setVisible(false)
    end
  
end

function strategyItemS:setItemClickFunc(func)
    self.func = func
end

function strategyItemS:destory()
end

--------------------------------------------

function strategyItemM:ctor()
	self.ccui = cc.uiloader:load("resui/strategyItemM.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function strategyItemM:init()
	self.levelLabel = cc.uiloader:seekNodeByName(self.ccui, "levelLabel")
	self.txtLabel = cc.uiloader:seekNodeByName(self.ccui, "txtLabel")
 
	self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "goBtn")
	self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.data and self.data.function_id ~= 0 then
            	--self:onCloseClick()
                FunctionOpenManager:gotoFunctionById(self.data.function_id)
                if self.func ~= nil then
                    self.func()
                end
            end
        end
            return true
    end)
end

function strategyItemM:setData(data)

	if data == nil then
		return
	end
	self.data = data

	self.levelLabel:setString(data.level)

	local img
	if data.icon_file ~= "" then
    	img = display.newSprite("#"..data.icon_file):addTo(self.ccui)
    	img:setPosition(10 + img:getContentSize().width/2, self.levelLabel:getPositionY() - img:getContentSize().height/2 + 0)
    end
    if img then
    	local chapterContent = SuperRichText.new(data.content, self.ccui:getContentSize().width - img:getContentSize().width - 120)
        --:pos(10 + img:getContentSize().width, self.levelLabel:getPositionY() - 28)
        :addTo(self.ccui)
        chapterContent:setPosition(20 + img:getContentSize().width, self.levelLabel:getPositionY() - chapterContent:getContentSize().height - 28)
    else
		local chapterContent = SuperRichText.new(data.content, self.ccui:getContentSize().width - 120)
        --:pos(10, self.levelLabel:getPositionY() - 28)
        :addTo(self.ccui)
        chapterContent:setPosition(20, self.levelLabel:getPositionY() - chapterContent:getContentSize().height - 28)
    end

    if data.function_id ~= 0 then
    	self.goBtn:setButtonLabelString(data.button_label)
    else
    	self.goBtn:setVisible(false)
    end
end

function strategyItemM:setItemClickFunc(func)
    self.func = func
end

function strategyItemM:destory()
end

--------------------------------------------

function strategyItemL:ctor()
	self.ccui = cc.uiloader:load("resui/strategyItemL.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function strategyItemL:init()
	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
	self.txtLabel = cc.uiloader:seekNodeByName(self.ccui, "txtLabel")
 
	self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "goBtn")
	self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.data and self.data.function_id ~= 0 then
            	--self:onCloseClick()
                FunctionOpenManager:gotoFunctionById(self.data.function_id)
                if self.func ~= nil then
                    self.func()
                end
            end
        end
            return true
    end)
end

function strategyItemL:setData(data)
	if data == nil then
		return
	end
	self.data = data
	self.titleLabel:setString(data.title)

	local img
	if data.icon_file ~= "" then
    	img = display.newSprite("#"..data.icon_file):addTo(self.ccui)
    	img:setPosition(10 + img:getContentSize().width/2, self.titleLabel:getPositionY() - img:getContentSize().height/2 - 22)
    end
    if img then
    	local chapterContent = SuperRichText.new(data.content, self.ccui:getContentSize().width - img:getContentSize().width - 120)
        --:pos(10 + img:getContentSize().width, self.titleLabel:getPositionY() - 28)
        :addTo(self.ccui)
        chapterContent:setPosition(10 + img:getContentSize().width , self.titleLabel:getPositionY() - chapterContent:getContentSize().height - 28)
    else
		local chapterContent = SuperRichText.new(data.content, self.ccui:getContentSize().width - 120)
        --:pos(10, self.titleLabel:getPositionY() - 28)
        :addTo(self.ccui)
        chapterContent:setPosition(10, self.titleLabel:getPositionY() - chapterContent:getContentSize().height - 28)
    end
    if data.function_id ~= 0 then
    	self.goBtn:setButtonLabelString(data.button_label)
    else
    	self.goBtn:setVisible(false)
    end
end

function strategyItemL:setItemClickFunc(func)
    self.func = func
end

function strategyItemL:destory()
end

return StrategyView