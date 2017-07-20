--
-- Author: Yi hanneng
-- Date: 2016-01-13 10:54:36
--
import("app.modules.bag.view.TipsEquip")
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local ChatRoleView = class("ChatRoleView", BaseView)

function ChatRoleView:ctor(posX,posY)

    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self.bg:setAnchorPoint(0.5,0.5)
    self.bg:setPosition(325, 320)
    self:setTouchEnabled(true)
    self:addChild(self.bg)
	

	local ccui = cc.uiloader:load("resui/sendroleWin.ExportJson")
	self:addChild(ccui)
	ccui:setPosition((650 - ccui:getContentSize().width) / 2, posY - 6 +50)
	self.itemBgs = {}
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
        
        local itemBg = cc.uiloader:seekNodeByTag(ccui,800+i)
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

    self.normalLayer = cc.uiloader:seekNodeByName(ccui,"normalLayer")
    self.specialLayer = cc.uiloader:seekNodeByName(ccui,"specialLayer")
    ---------------------新增特殊装备-------------------------
    --[[
    self.SPweapon = cc.uiloader:seekNodeByName(win,"SPweapon")
    self.SParmour = cc.uiloader:seekNodeByName(win,"SParmour")
    self.amulet = cc.uiloader:seekNodeByName(win,"amulet")
    self.SPring = cc.uiloader:seekNodeByName(win,"SPring")
    self.legguard = cc.uiloader:seekNodeByName(win,"legguard")
    self.shoulder = cc.uiloader:seekNodeByName(win,"shoulder")
    self.SPring2 = cc.uiloader:seekNodeByName(win,"SPring2")
    self.earring = cc.uiloader:seekNodeByName(win,"earring")
    self.hood = cc.uiloader:seekNodeByName(win,"hood")
    self.mask = cc.uiloader:seekNodeByName(win,"mask")
    --]]
    self.switchBtn = cc.uiloader:seekNodeByName(ccui,"switchBtn")

    self.specialLayer:setVisible(false)
    self.normalLayer:setVisible(true)
    self.showNormal = true

    self.switchBtn:setTouchEnabled(true)
    self.switchBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.switchBtn:setScale(1.2)
        elseif event.name == "ended" then
            self.switchBtn:setScale(1)
            if self.showNormal then
                self.showNormal = false
                self.specialLayer:setVisible(true)
                self.normalLayer:setVisible(false)
                --self.switchBtn:setSpriteFrame("#roleWin_equipBtn.png")
                self.switchBtn:setButtonImage("normal", "#roleWin_equipBtn.png")
            else
                self.showNormal = true
                self.specialLayer:setVisible(false)
                self.normalLayer:setVisible(true)
                self.switchBtn:setButtonImage("normal", "#roleWin_SPBtn.png")
            end
            --self:onCoinClick(2)
        end     
        return true
    end)

    ---------------------新增特殊装备-------------------------


    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
    
        elseif event.name == "ended" then
      
            if not cc.rectContainsPoint(ccui:getBoundingBox(), event) then
                if self.tipsLayer:isVisible() then
                    self.tipsLayer:setVisible(false)
                    if self.tipsLayer.tipsEquip then
                        self.tipsLayer.tipsDefault:setVisible(true)
                        self.tipsLayer.tipsEquip:setVisible(false)
                         
                    end
                else
                    self:setVisible(false)
                end
            end
            
        end     
        return true
    end)

    self.winn = cc.uiloader:seekNodeByName(ccui,"win")
    --人物内观
    self.imv = InnerModelView.new()
    self.imv:setPosition(250, 330)
    self.winn:addChild(self.imv,100)

    self.roleName = cc.uiloader:seekNodeByName(ccui,"roleName")
    self.roleName:setString("")

    self.tipsLayer = cc.uiloader:seekNodeByName(ccui,"equipTips")


    self.tipsLayer.tipsDefault = cc.uiloader:load("resui/goodstipsWin.ExportJson")
 	self.tipsLayer.tipsDefault:setAnchorPoint(0.5,0.5)
 	self.tipsLayer:addChild(self.tipsLayer.tipsDefault)

    self.tipsLayer.tipsEquip = TipsEquip.new()
    self.tipsLayer.tipsEquip:setAnchorPoint(0.5,0.5)
    self.tipsLayer:addChild(self.tipsLayer.tipsEquip)
    self.tipsLayer.tipsEquip:setVisible(true)

    self.tipsLayer:setPosition(258 , 265)
    self.tipsLayer:setVisible(false)
   local closeBtn = cc.uiloader:seekNodeByName(ccui,"close")

    closeBtn:setTouchEnabled(true)
 	closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            closeBtn:setScale(1.1)
        elseif event.name == "ended" then
         	closeBtn:setScale(1)
        	self:setVisible(false)
        	self.tipsLayer.tipsDefault:setVisible(true)
        	self.tipsLayer.tipsEquip:setVisible(false)

            self.tipsLayer:setVisible(false)
        end     
        return true
    end)

end

function ChatRoleView:getEauipInfo()
    local roleManager = RoleManager:getInstance()
    if not roleManager.roleInfo  then return end

    --内观
    self.imv:setSex(roleManager.roleInfo.sex)
    self.imv:setBodyId(roleManager.roleInfo.clothes)
    self.imv:setWeaponId(roleManager.roleInfo.weapon)
    self.imv:setWingId(roleManager.roleInfo.wing)

    --玩家名
    self.roleName:setString(roleManager.roleInfo.name)

    local equipList = roleManager.roleInfo.equip
    for i=1,self.equipnum do
        self:setEquipToItemBg(i,nil)
    end

    for j=1,#equipList do
        self:setEquipToItemBg(equipList[j].grid, equipList[j])
    end
end

function ChatRoleView:setEquipToItemBg(itemIndex,equip)
 
    if not self.itemBgs[itemIndex] then return end
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
        if self.tipsLayer.tipsEquip then
        	self.tipsLayer.tipsDefault:setVisible(false)
        	self.tipsLayer.tipsEquip:setVisible(true)
        	self.tipsLayer.tipsEquip:setData(equip, true)
            self.tipsLayer:setVisible(true)
        end
 
    end)
 
end

return ChatRoleView