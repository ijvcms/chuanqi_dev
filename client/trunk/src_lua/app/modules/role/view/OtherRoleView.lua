--
-- Author: Yi hanneng
-- Date: 2016-05-31 09:24:09
--
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local OtherRoleView = OtherRoleView or class("OtherRoleView", BaseView)

function OtherRoleView:ctor(winTag,data,winconfig)
	OtherRoleView.super.ctor(self,winTag,data,winconfig)
	--颜色层
	local maskbg = cc.LayerColor:create(cc.c4b(0,0,0,100))
	self:addChild(maskbg)

	self.ccui = cc.uiloader:load("resui/roleInfoWin.ExportJson")
  	self:addChild(self.ccui)
   	--self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    local rootSize = self.ccui:getContentSize()
   dump(rootSize)
   	self.ccui:setPosition((display.width-self.ccui:getContentSize().width)/2,(display.height-self.ccui:getContentSize().height)/2)
   	

	--self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeSelfSafety()
        end     
        return true
    end)
	
	self:init()
end

function OtherRoleView:init()
 
    local win  = cc.uiloader:seekNodeByName(self.ccui,"win")

    self.equipnum = 30
    --15件装备格子
    self.equipItemBgs = {}
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
 
        if itemBg ~= nil then
            self.equipItemBgs[i] = itemBg
        end
        --table.insert(self.itemBgs,itemBg)
    end

    self.normalLayer = cc.uiloader:seekNodeByName(win,"normalLayer")
    self.specialLayer = cc.uiloader:seekNodeByName(win,"specialLayer")
    ---------------------新增特殊装备-------------------------
    
    self.switchBtn = cc.uiloader:seekNodeByName(win,"switchBtn")

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
                self.switchBtn:setButtonImage("pressed", "#roleWin_equipBtn.png")
            else
                self.showNormal = true
                self.specialLayer:setVisible(false)
                self.normalLayer:setVisible(true)
                self.switchBtn:setButtonImage("normal", "#roleWin_SPBtn.png")
                self.switchBtn:setButtonImage("pressed", "#roleWin_SPBtn.png")
            end
            --self:onCoinClick(2)
        end     
        return true
    end)

    ---------------------新增特殊装备-------------------------

    --人物内观
    self.imv = InnerModelView.new()
    self.imv:setPosition(230+33, 300+10)--220+24, 275-38+53
    win:addChild(self.imv,100)

    --玩家名字
    self.roleName = cc.uiloader:seekNodeByName(win,"roleName")
    self.roleName:setString("")
    self.lvLabel = cc.uiloader:seekNodeByName(win,"lvLabel")
    self.lvLabel:setString("")
    self.unionLabel = cc.uiloader:seekNodeByName(win,"unionLabel")
    self.unionLabel:setString("")

    -- self.roleName:enableOutline(cc.c4b(255,0,0,100),10)

    --self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))

end

function OtherRoleView:setData(data)
 
	--装备列表
	self.career = data.career--职业
	for i=1,#data.equips_list do
		data.equips_list[i] = EquipUtil.formatEquipItem(data.equips_list[i])
	end


	for i=1,#data.equips_list do
		self:setEquipToItemBg(data.equips_list[i].grid,data.equips_list[i])
	end

	--等级label
	self.lvLabel:setString("Lv."..data.lv)
	--姓名label
	self.roleName:setString(data.name)
    self.unionLabel:setString(data.guild_name)
	--内观
	self.imv:setSex(data.sex)
    self.imv:setBodyId(data.guise.clothes)
    self.imv:setWeaponId(data.guise.weapon)
    self.imv:setWingId(data.guise.wing)
end

function OtherRoleView:setEquipToItemBg(itemIndex,equip)
    if not self.equipItemBgs[itemIndex] then return end
    if self.equipItemBgs[itemIndex]:getChildByTag(10) then
        self.equipItemBgs[itemIndex]:removeChildByTag(10, true)
    end
    if not equip then return end

    local commonItem = CommonItemCell.new()
    commonItem:setData(equip)
    self.equipItemBgs[itemIndex]:addChild(commonItem, 10)
    commonItem:setPosition(self.equipItemBgs[itemIndex]:getContentSize().width/2,self.equipItemBgs[itemIndex]:getContentSize().height/2)
    commonItem:setTag(10)
    commonItem:setItemClickFunc(function()
        --弹出装备提示窗口
        local eTWin = equipTipsWin.new()
        eTWin:setData(equip, true, self.career)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)  
    end)
end
 
return OtherRoleView