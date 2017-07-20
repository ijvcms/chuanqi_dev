--
-- Author: Yi hanneng
-- Date: 2016-05-13 16:20:35
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
 
local OpenServeBossItem = OpenServeBossItem or class("OpenServeBossItem", UIAsynListViewItemEx)

function OpenServeBossItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/serveBossItem.ExportJson")
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function OpenServeBossItem:init()

	self.itemList = {}

	self.BossNameLabel = cc.uiloader:seekNodeByName(self.ccui, "BossNameLabel")
	self.tipsLabel = cc.uiloader:seekNodeByName(self.ccui, "tipsLabel")
	self.playerNameLabel = cc.uiloader:seekNodeByName(self.ccui, "playerNameLabel")
	self.stateLayer = cc.uiloader:seekNodeByName(self.ccui, "stateLayer")
	self.btn_get = cc.uiloader:seekNodeByName(self.ccui, "getBtn")

	self.btn_get:setTouchEnabled(true)
  	self.btn_get:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_get:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_get:setScale(1.0)
            if self.func then
            	self.func(self)
            end
            --GlobalController.activity:requestActivityServiceReward(self.data.active_service_id)
        end
        return true
    end)

    self.headIcon = display.newSprite()--display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png")
    self.ccui:addChild(self.headIcon)
    self.headIcon:setTag(100)
    self.headIcon:setPosition(50, 50)

end

function OpenServeBossItem:setData(data)
	if data == nil then
		return 
	end
 
	self.data = data

	for i=1,#self.itemList do
		self.itemList[i]:removeSelf()
	end

	self.itemList = {}

	self:setGoods(data["reward_"..RoleManager:getInstance().roleInfo.career],0)
	--个人首杀
	self:setGoods(data["reward"],140)

	if data.is_receive == 0 then
		self.btn_get:setButtonLabelString("领取")
		self.btn_get:setButtonEnabled(true)
	elseif data.is_receive == 1 then
		self.btn_get:setButtonLabelString("未获得")
		self.btn_get:setButtonEnabled(false)
	elseif data.is_receive == 2 then
		self.btn_get:setButtonLabelString("已领取")
		self.btn_get:setButtonEnabled(false)
		display.newSprite("#serveActivity_getIcon.png"):addTo(self.ccui):pos(335,50)
	elseif data.is_receive == 3 then
		self.btn_get:setButtonLabelString("已领完")
		self.btn_get:setButtonEnabled(false)
	end

	if data.state2 == 0 then
		self.btn_get:setButtonLabelString("领取")
		self.btn_get:setButtonEnabled(true)
	elseif data.state2 == 1 then
		self.btn_get:setButtonLabelString("未获得")
		self.btn_get:setButtonEnabled(false)
	elseif data.state2 == 2 then
		self.btn_get:setButtonLabelString("已领取")
		self.btn_get:setButtonEnabled(false)
		display.newSprite("#serveActivity_getIcon.png"):addTo(self.ccui):pos(475,50)
	end
 	 
	if data.name ~= nil and data.name ~= "" then
		self.tipsLabel:setVisible(false)
		self.stateLayer:setVisible(true)
		self.playerNameLabel:setString(data.name)
	else
		self.stateLayer:setVisible(false)
		self.tipsLabel:setVisible(true)
	end

	local path = "res/icons/worldBoss/".. configHelper:getMonsterResById(data.value) ..".png"
    local fileUtil = cc.FileUtils:getInstance()
 
    if fileUtil:isFileExist(path) then
        display.addImageAsync(path, function()
            if self.headIcon then
                self.headIcon:setTexture(path)
            end
        end)
         
    else
        self.headIcon:setTexture("common/input_opacity1Bg.png")
    end

	self.BossNameLabel:setString(configHelper:getMonsterNameById(data.value))
	
end

function OpenServeBossItem:getData()

	return self.data

end

function OpenServeBossItem:setGoods(data,posX)


	if data == nil then
		return 
	end

	for i=1,#data do
		local item = self:createItem(data[i])
		self.itemList[#self.itemList+1] = item
		self.ccui:addChild(item)
		item:setPosition(255 + 80 * i + posX, self.ccui:getContentSize().height/2)
	end

end

function OpenServeBossItem:createItem(data)
    local node = display.newNode()
    local contentBg = display.newSprite("#com_propBg1.png")
    local item = CommonItemCell.new():addTo(contentBg)
    item:setData({goods_id=data[1],is_bind = data[2]})
    item:setCount(data[3])
    --item:setScale(0.85)
 	item:setPosition(contentBg:getContentSize().width/2, contentBg:getContentSize().height/2)
    node:addChild(contentBg)
 
    return node
end

function OpenServeBossItem:setItemClick(func)

	self.func = func

end

function OpenServeBossItem:setTouchEnabled(enable)

	if self.btn_get then
		if enable then
			self.btn_get:setButtonLabelString("领取")
		else
			self.btn_get:setButtonLabelString("已领取")
		end
		
		self.btn_get:setButtonEnabled(enable)
	end
 
end

function OpenServeBossItem:open()
end

function OpenServeBossItem:close()
end

function OpenServeBossItem:destory()
end

return OpenServeBossItem