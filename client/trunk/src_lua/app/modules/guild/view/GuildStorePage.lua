--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:19:53
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--行会商店页
local GuildBasePage = import(".GuildBasePage")
local GuildStoreView = import(".GuildStoreView")
local batchBuyWin = require("app.modules.store.view.batchBuyWin")
local GuildStorePage = class("GuildStorePage", GuildBasePage)

function GuildStorePage:ctor()
    self:setPosition(-81+4,-60-5)
	self.storeView = GuildStoreView.new()
	self.storeViewInit = false
    self.storeView:setPosition(288,170)
    self:addChild(self.storeView)
    self.items = {}

    local roleManager = RoleManager:getInstance()
	local guildInfo = roleManager.guildInfo
    self.contLabel = display.newTTFLabel({
	    	text = "当前贡献:"..guildInfo.contribution,
	    	size = 20,
	    	color = TextColor.TEXT_O
		})
	display.setLabelFilter(self.contLabel)
	self.contLabel:setPosition(340,145)
	self:addChild(self.contLabel)

    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function GuildStorePage:initStoreView()
	local sellItemList = configHelper:getGuildStoreItems()
    self.storeView:pushItemData(sellItemList,handler(self,self.itemModifyFunc))
    --[[
    for i = 1,#sellItemList do
        local v = sellItemList[i]
        self.storeView:pushItemData(v,handler(self,self.itemModifyFunc),{v})
    end
    --]]
    self.storeViewInit = true
end

function GuildStorePage:itemModifyFunc(item,args)
	local itemData = args[1]
	table.insert(self.items,{item = item, itemData =itemData})
	self:checkItemShow(item, itemData)
	item.buyBtn:setTouchEnabled(true)
    item.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	item.buyBtn:setScale(0.85)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
	        item.buyBtn:setScale(0.8)
            if item.buyBtn:getCascadeBoundingBox():containsPoint(cc.p(event.x, event.y)) then
                self:onStoreItemClick(itemData)
            end
        end     
        return true
    end)
end

function GuildStorePage:onStoreItemClick(itemData)
	local bw = batchBuyWin.new({
        title="购买道具",

        sureText="购买",

        clickFunc=function(curCount,data)
	        --行会商城
	        local sendData = {
	            shop_id = data.key,
	            num = curCount
	        }
	        GameNet:sendMsgToSocket(17051, sendData)
	    end,

        countFunc=function(curCount,label)
	        label:setString("总共"..curCount*itemData.need_contribution.."贡献")
	    end,

        data=itemData,

        max=math.floor(RoleManager:getInstance().guildInfo.contribution / itemData.need_contribution)
    })

    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,bw)
end

function GuildStorePage:checkItemShow(item,itemData)
	local roleManager = RoleManager:getInstance()
	local roleInfo = roleManager.roleInfo
	local guildInfo = roleManager.guildInfo
	item.tips[1]:setVisible(false)
	item.tips[2]:setVisible(false)
	item.buyBtn:setVisible(false)
	if guildInfo.guild_lv < itemData.limit_guild_lv then
		item.tips[1]:setVisible(true)
	elseif roleInfo.lv < itemData.limit_lv then
		item.tips[2]:setVisible(true)
	else
		item.buyBtn:setVisible(true)
	end
end

function GuildStorePage:registerEvent()
	self.registerEventId = {}
    --行会等级改变
    local function onGuildLvChange()
       	for i=1,#self.items do
       		self:checkItemShow(self.items[i].item,self.items[i].itemData)
       	end
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_LV_CHANGE, onGuildLvChange)

    --人物升级
    local function onMainRoleLvUp()
        for i=1,#self.items do
       		self:checkItemShow(self.items[i].item,self.items[i].itemData)
       	end
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(RoleEvent.MAINROLE_LEVEL_UP, onMainRoleLvUp)

    --人物贡献值变化
    local function onGuildContChange()
    	local roleManager = RoleManager:getInstance()
		local guildInfo = roleManager.guildInfo
       	self.contLabel:setString("当前贡献:"..guildInfo.contribution)
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_CONT_CHANGE, onGuildContChange)
    
end

function GuildStorePage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuildStorePage:onNodeEvent(data)
	if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
    	self:unregisterEvent()
    end
end

function GuildStorePage:onShow()
	if self.storeViewInit == false then
		self:initStoreView()
	end
	--回到第一页
	--self.storeView:gotoPage(1)
end

return GuildStorePage