--
-- Author: Yi hanneng
-- Date: 2016-07-18 18:16:18
--
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local EquipShowView = EquipShowView or class("EquipShowView", BaseView)

local EquipShowMenu =  class("EquipShowMenu", function()return display.newNode()end)

function EquipShowView:ctor(winTag,data,winconfig)
	EquipShowView.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
    self:creatPillar()
     
	--self.ccui = cc.uiloader:load("resui/strategyEquip.ExportJson")
  	--self:addChild(self.ccui)
   	
   	self:init()
end

function EquipShowView:init()


	self.show = true
	local root = self:getRoot()
	root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")

	self.rightLayer = cc.uiloader:seekNodeByName(win, "rightLayer")
	self.leftLayer = cc.uiloader:seekNodeByName(win, "leftLayer")
 
	self.closeBtn = cc.uiloader:seekNodeByName(win, "closeBtn")
	self.getBtn = cc.uiloader:seekNodeByName(win, "getBtn")

	self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)

    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.getBtn:setScale(1.0)
    
            if self.EquipShowMenu == nil then
            	self.EquipShowMenu = EquipShowMenu.new()
            	self.rightLayer:addChild(self.EquipShowMenu)
            	self.EquipShowMenu:setPosition(self.rightLayer:getContentSize().width/2 - self.EquipShowMenu:getContentSize().width/2, self.rightLayer:getContentSize().height/2 - self.EquipShowMenu:getContentSize().height/2)
            end

            if self.imv  and self.show then
            	self.imv:setVisible(false)
            	self.EquipShowMenu:setVisible(true)
            	self.show = false
            	self.getBtn:setButtonLabelString("返回")
            elseif self.imv  and self.show == false then
            	self.imv:setVisible(true)
            	self.EquipShowMenu:setVisible(false)
            	self.show = true
            	self.getBtn:setButtonLabelString("获取途径")
            end

        end     
        return true
    end)

    self.equipnum = 30
    --15件装备格子
    self.itemBgs = {}
    for i=1,self.equipnum do
        -- 武器801
        -- 衣服802
        -- 头盔803
        -- 项链804
        -- 勋章805
        -- 左护腕806
        -- 右护腕811
        -- 左戒指807
        -- 右戒指812
        -- 腰带808
        -- 裤子809    
        -- 鞋子810
        -- 翅膀813
        -- 宠物814
        -- 坐骑815
        
        local itemBg = cc.uiloader:seekNodeByTag(win,800+i)
        -- itemBg:setTouchEnabled(true)
        -- itemBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --     if event.name == "began" then
        --         SoundManager:playClickSound()
        --         -- itemBg:setScale(1.2)
        --     elseif event.name == "ended" then
        --         -- itemBg:setScale(1)
        --         self:onItemBgClick(i)
        --     end     
        --     return true
        -- end)
        if itemBg ~= nil then
            --todo
            self.itemBgs[i] = itemBg
        end
        --table.insert(self.itemBgs,itemBg)
    end

        --人物内观
    self.imv = InnerModelView.new()
    self.imv:setPosition(self.rightLayer:getContentSize().width/2, 180)
    self.rightLayer:addChild(self.imv,100)

	self:initMenuList()
end

function EquipShowView:initMenuList()

    --攻略列表
    local strategyList = configHelper:getEquipShowByCareer(RoleManager:getInstance().roleInfo.career)
    self.strategyList = strategyList
    self.itemList = {}

    self.list_strategy = cc.ui.UIListView.new({
            direction = 1,
            viewRect = {x = 0, y = 0, width = self.leftLayer:getContentSize().width - 10, height = self.leftLayer:getContentSize().height - 10}})
        :pos(5,5)
        :addTo(self.leftLayer)
        :onTouch(handler(self, self.touchListener))

    for i=1, #strategyList do
        self:newItem(strategyList[i], i)
    end

    self.list_strategy:reload()

end

function EquipShowView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item =self.itemList[event.itemPos]
 
       	if self.lastClick ~= nil and self.lastClick ~= item then
        	self.lastClick:setSpriteFrame("com_labBtn31.png")
        end

        item:setSpriteFrame("com_labBtn31Over.png")
        self.lastClick = item
        self:showEquip(self.strategyList[event.itemPos])
   
    end
end

function EquipShowView:showEquip(data)

	local roleInfo = RoleManager:getInstance().roleInfo
	
	self.imv:setSex(roleInfo.sex)

    self.imv:setBodyId(configHelper:getGoodResId(data["2"]))
    self.imv:setWeaponId(configHelper:getGoodResId(data["1"]))
    self.imv:setWingId(configHelper:getGoodResId(data["13"]))
	--[[
 
    self.imv:setSex(roleInfo.sex)
    self.imv:setBodyId(roleInfo.clothes)
    self.imv:setWeaponId(roleInfo.weapon)
    self.imv:setWingId(roleInfo.wing)
	--]]
 
    for i=1,self.equipnum do
        self:setEquipToItemBg(i,nil)
    end
    for i=1,#self.itemBgs do
    	if tostring(i) == "12" then
    		--戒指 因为有两个
    		self:setEquipToItemBg(i, {goods_id = data["7"],stren_lv = data.strength_lv,soul = data.soul_lv})
    	elseif tostring(i) == "11" then
    		--手腕
    		self:setEquipToItemBg(i, {goods_id = data["6"],stren_lv = data.strength_lv,soul = data.soul_lv})
    	elseif tostring(i) == "5" or tostring(i) == "13" then
    		self:setEquipToItemBg(i, {goods_id = data[tostring(i)],stren_lv = 0,soul = 0})
    	else
    		self:setEquipToItemBg(i, {goods_id = data[tostring(i)],stren_lv = data.strength_lv,soul = data.soul_lv})
    	end
    end
 
end

function EquipShowView:setEquipToItemBg(itemIndex,equip)
    if not self.itemBgs[itemIndex] or equip == nil then return end
    if self.itemBgs[itemIndex]:getChildByTag(10) then
        self.itemBgs[itemIndex]:removeChildByTag(10, true)
    end
    if not equip then return end

    local commonItem = CommonItemCell.new()
    commonItem:setData(equip)
    
    self.itemBgs[itemIndex]:addChild(commonItem, 10)
    commonItem:setPosition(self.itemBgs[itemIndex]:getContentSize().width/2,self.itemBgs[itemIndex]:getContentSize().height/2)
    commonItem:setTag(10)
    commonItem:setItemClickFunc(function()
        --弹出装备提示窗口
        local eTWin = equipTipsWin.new()
        eTWin:setData(equip,true)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)  
    end)
end

function EquipShowView:open()
	self.lastClick = self.itemList[1]
	self.lastClick:setSpriteFrame("com_labBtn31Over.png")
	self:showEquip(self.strategyList[1])
end

function EquipShowView:close()
end

function EquipShowView:destory()
	self:close()
end

function EquipShowView:newItem(data, index)
    if not self.list_strategy then return end

    local item = self.list_strategy:newItem()
    local content = display.newSprite("#com_labBtn31.png")
    local name = display.newTTFLabel({
            text = data.name,
            font = "simhei",
            color = TextColor.BTN_Y,
            x=content:getContentSize().width/2,
            y=content:getContentSize().height/2})
    display.setLabelFilter(name)
    content:addChild(name)
    item:addContent(content)
    item:setItemSize(170, 44+6)
    self.list_strategy:addItem(item)
    self.itemList[index] = content
end

--------------------------------------------

function EquipShowMenu:ctor()
	self.ccui = cc.uiloader:load("resui/strategyEquipList.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function EquipShowMenu:init()
	self.btnList = {}
	local config = configHelper:getEquipShowExhibition()
	self.data = config
	for i=1,4 do
		self.btnList[i] = cc.uiloader:seekNodeByName(self.ccui, "btn"..i)
		self.btnList[i]:setButtonLabelString(config[i].name)
		self.btnList[i]:setTouchEnabled(true)
    	self.btnList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnList[i]:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnList[i]:setScale(1.0)
            if self.data and self.data[i] and self.data[i].function_id and self.data[i].function_id > 0 then
            	FunctionOpenManager:gotoFunctionById(self.data[i].function_id)
            end
        end     
        return true
    end)
	end
end
 
function EquipShowMenu:destory()
end

return EquipShowView