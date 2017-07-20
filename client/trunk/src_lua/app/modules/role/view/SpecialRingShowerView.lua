--
-- Author: wuqiang
-- Date: 2017-03-13 11:10:44
--

local SpecialRingShowerView = class("SpecialRingShowerView", function()
	return display.newNode()
end)

local GoodsUtil = require("app.utils.GoodsUtil")

local kMaxRingNum = 3
local kImageTag = 10
local kMaxAttributeNum = 3

local kAttributeNames = {{"物理攻击","法术攻击","道术攻击"},{"物理防御","法术防御"},{"生命"}}

SpecialRingShowerView.background = nil
SpecialRingShowerView.csbNode = nil
SpecialRingShowerView.specialRingBtns = nil
SpecialRingShowerView.labelName = nil
SpecialRingShowerView.labelPhysics = nil
SpecialRingShowerView.labelMagic = nil
SpecialRingShowerView.labelDaoSu = nil
SpecialRingShowerView.labelAttributeNames = nil
SpecialRingShowerView.labelAttributeValues = nil

SpecialRingShowerView.nodeActive = nil
SpecialRingShowerView.nodeNotActive = nil

SpecialRingShowerView.nodeRingItem = nil

local function _setAttribute(self,index,name,value)
    local labelAttributeName = self.labelAttributeNames[index]
    local labelAttributeValue = self.labelAttributeValues[index]
    labelAttributeName:setString(tostring(name))
    labelAttributeValue:setString(string.format("+%s",tostring(value)))
    labelAttributeName:setVisible(true)
    labelAttributeValue:setVisible(true)
end

local function _checkHasEquipId(self,goodId)
    local roleManager = RoleManager:getInstance()
    if not roleManager.roleInfo  then return end
    local equipList = roleManager.roleInfo.equip
    for _,equipItem in ipairs(equipList or {}) do
        if equipItem.goods_id == goodId then
            return true
        end
    end
    return false
end

local function _updateAttributeView(self,index)
    local allCanDeliverGoods = GoodsUtil.getAllLoginSpecialRingGoodIds()
    local ringGoodId = allCanDeliverGoods[index]
    local attributeNames = kAttributeNames[index]
    for _,labelAttributeName in ipairs(self.labelAttributeNames or {}) do
        labelAttributeName:setVisible(false)
    end
    for _,labelAttributeValue in ipairs(self.labelAttributeValues or {}) do
        labelAttributeValue:setVisible(false)
    end
    if index == 1 then --攻击
        for i = 1,#attributeNames do
            local minValue,maxValue = configHelper:getAtkByEquipId(ringGoodId,i)
            local attributeName = attributeNames[i]
            _setAttribute(self,i,attributeName,string.format("%i-%i",minValue,maxValue))
        end
    elseif index == 2 then
        for i = 1,#attributeNames do
            local minValue,maxValue = configHelper:getDefByEquipId(ringGoodId,i)
            local attributeName = attributeNames[i]
            _setAttribute(self,i,attributeName,string.format("%i-%i",minValue,maxValue))
        end
    elseif index == 3 then
        for i = 1,#attributeNames do
            local hpValue = configHelper:getHpByEquipId(ringGoodId)
            local attributeName = attributeNames[i]
            _setAttribute(self,i,attributeName,hpValue)
        end
    end
    local hasEquip = _checkHasEquipId(self,ringGoodId)
    self.nodeActive:setVisible(hasEquip)
    self.nodeNotActive:setVisible(not hasEquip)
end


local function _onClickIndex(self,index)
    local allCanDeliverGoods = GoodsUtil.getAllLoginSpecialRingGoodIds()
	local ringGoodId = allCanDeliverGoods[index]
    
    --图标id
    local path = GoodsUtil.getIconPathByGoodId(ringGoodId)
    
	local originSprite = self.nodeRingItem:getChildByTag(kImageTag)
	if originSprite then
        self.nodeRingItem:removeChild(originSprite, true)
    end
    originSprite = display.newSprite(path)
    originSprite:setPosition(cc.p(self.nodeRingItem:getContentSize().width/2,self.nodeRingItem:getContentSize().height/2))
    self.nodeRingItem:addChild(originSprite, kImageTag, kImageTag)

    local ringName = configHelper:getGoodNameByGoodId(ringGoodId)
    local ringDesc = configHelper:getGoodDescByGoodId(ringGoodId)
    self.labelName:setString(ringName)
    _updateAttributeView(self,index)

    for _index,btn in ipairs(self.specialRingBtns or {}) do
        btn:setButtonEnabled(_index ~= index)
    end  
    
    --btn:setButtonEnabled(true)
end

local function _init(self)
	local root = cc.uiloader:seekNodeByName(self.csbNode, "root")

	self.specialRingBtns = {}
    local allCanDeliverGoods = GoodsUtil.getAllLoginSpecialRingGoodIds()
	for i = 1,kMaxRingNum do
		local ringBtn = cc.uiloader:seekNodeByName(root,"btn"..i)
        ringBtn:addButtonClickedEventListener(function()
            _onClickIndex(self,i)
            SoundManager:playClickSound()
        end)
    	local ringGoodId = allCanDeliverGoods[i]
    	local ringName = configHelper:getGoodNameByGoodId(ringGoodId)

    	table.insert(self.specialRingBtns,ringBtn)
	end

	self.nodeRingItem = cc.uiloader:seekNodeByName(root,"itemBg")
    --self.nodeRingItem:setAnchorPoint(cc.p(0.5,0.5))
	self.labelName = cc.uiloader:seekNodeByName(root,"nameLabel")
    self.labelPhysics = cc.uiloader:seekNodeByName(root,"attr1")
    self.labelMagic = cc.uiloader:seekNodeByName(root,"attr2")
    self.labelDaoSu = cc.uiloader:seekNodeByName(root,"attr3")

    local btnClose = cc.uiloader:seekNodeByName(root,"closeBtn")
    if btnClose and btnClose.addButtonClickedEventListener then

        btnClose:addButtonClickedEventListener(function()
            self:close()
        end)
    end

    self.labelAttributeNames = {}
    self.labelAttributeValues = {}

    for i = 1,kMaxAttributeNum do
        local att_name = "labAttr"..i
        local att_value = "attr"..i
        table.insert(self.labelAttributeNames,cc.uiloader:seekNodeByName(root,att_name))
        table.insert(self.labelAttributeValues,cc.uiloader:seekNodeByName(root,att_value))
    end

    self:setPosition(cc.p(display.cx/2,display.cy/2))

    self.nodeActive = cc.uiloader:seekNodeByName(root,"stateImg2")
    self.nodeNotActive = cc.uiloader:seekNodeByName(root,"stateImg")
    self.nodeActive:setVisible(false)
    self.nodeNotActive:setVisible(false)
    
end

function SpecialRingShowerView:ctor()

	self.background =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.background:setPosition(cc.p(-display.width/2,-display.height/2))
    self.background:setContentSize(display.width *2, display.height *2)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.background)
    local ccui = cc.uiloader:load("resui/roleRingWin.ExportJson")
    self.csbNode = ccui
    self:addChild(ccui)

	_init(self)	
	_onClickIndex(self,1)
end


function SpecialRingShowerView:show(tips)
end

function SpecialRingShowerView:close()
    local parent = self:getParent()
    if parent ~= nil then
        parent:removeChild(self)
    end
end



return SpecialRingShowerView

