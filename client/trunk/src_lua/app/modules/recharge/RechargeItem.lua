--
-- Author: Yi hanneng
-- Date: 2016-01-26 11:53:21
--

--[[
充值框：
元宝标题：chargename
额外赠送：giving
赠送限制：limit
人民币：rmb
--]]
local RechargeItem = RechargeItem or class("RechargeItem", function() return display.newNode() end)

function RechargeItem:ctor(loader)
	local ccui = loader:BuildNodesByCache("resui/chargeWin_2.ExportJson")
  	self:addChild(ccui)
  	self:setContentSize(cc.size(ccui:getContentSize().width, ccui:getContentSize().height))
    local root = cc.uiloader:seekNodeByName(ccui, "root")
    self:setTouchEnabled(true)
    --root:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.startY = event.y
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            if math.abs(event.y - self.startY) < 10 then
                if self.itemClick then
                	self.itemClick(self)
                end
            end
        end     
        return true
    end)

    self.conner_mark = cc.uiloader:seekNodeByName(ccui, "conner_mark")
    self.chargename = cc.uiloader:seekNodeByName(ccui, "chargename")
    self.giving = cc.uiloader:seekNodeByName(ccui, "giving")
    self.monthCardLabel = cc.uiloader:seekNodeByName(ccui, "monthCardLabel")
    self.rmb = cc.uiloader:seekNodeByName(ccui, "rmb")
    self.itemBg = cc.uiloader:seekNodeByName(ccui,"Image_2")
    self.monthCardLabel:setVisible(false)
    self.itemClick = nil
    self.data = nil
 
end

function RechargeItem:setViewInfo(data)
	if not data then return end
	self.chargename:setString(data.jade.."元宝")
    --月卡特殊处理
    if data.key == 1 then
        self.chargename:setString("月卡")
    end

    if self.vipLv >= 8 and data.key ~= 1 then --vip 8永久双倍
        self.conner_mark:setSpriteFrame("chargeFDouble.png")
        self.conner_mark:setVisible(true)
        self.giving:setVisible(false)
    else
        if data.markIcon and data.markIcon ~= "" then
            self.conner_mark:setSpriteFrame(data.markIcon..".png")
            self.conner_mark:setVisible(true)
        else
            self.conner_mark:setVisible(false)
        end

        if data.finish then
            if data.markIcon == "chargeDouble" then
                self.conner_mark:setVisible(false)
            end
            self.giving:setVisible(false)
            --self.giving:setString(data.common_desc)
            self.monthCardLabel:setVisible(false)
        else
            --self.limit:setVisible(true)
            self.conner_mark:setVisible(true)
            self.giving:setVisible(true)
            self.giving:setString(data.giving_desc)
            self.monthCardLabel:setString("限买一次")
        end
    end

    if self.itemBg:getChildByTag(999) == nil then
        local icon = display.newSprite("#"..data.icon..".png")
        self.itemBg:addChild(icon)
        icon:setPosition(self.itemBg:getContentSize().width/2,self.itemBg:getContentSize().height / 2 + 5)
        icon:setTag(999)
    end

    self.rmb:setString(data.rmb.."元")
   
    --self:showEffect("shiningEffect")    
    --屏蔽充值标记
    --self.conner_mark:setVisible(false)

end

function RechargeItem:setData(data)
	self.data = data
	self:setViewInfo(data)
    --if self.vipLv then
    --    self:setViewInfo(data)
    --end
end

function RechargeItem:setVipLevel(lv)

    local tmpLv = self.vipLv
    self.vipLv = lv
    if self.data  and  self.vipLv ~= tmpLv then
       self:setViewInfo(self.data)
    end
end

function RechargeItem:getData()
	return self.data
end

function RechargeItem:setItemClick(func)
	self.itemClick = func
end

function RechargeItem:showEffect(actionName)
    if self.armatureEff then
        return
    end 
    self.curGHEffID = actionName
    if nil == self.frameHandle then
        self.frameHandle = GlobalTimer.scheduleUpdateGlobal(handler(self, self.loadEffect))
    end
    ArmatureManager:getInstance():asyLoadEffect(self.curGHEffID)
end

function RechargeItem:loadEffect()
    if not ccs.ArmatureDataManager:getInstance():getArmatureData(self.curGHEffID) then
        return
    end
    if  self.frameHandle then
        GlobalTimer.unscheduleGlobal(self.frameHandle)
        self.frameHandle = nil
    end
    self.armatureEff = ccs.Armature:create(self.curGHEffID)
    self.armatureEff:getAnimation():play("effect")
    self.itemBg:addChild(self.armatureEff)
    self.armatureEff:setLocalZOrder(999)
    self.armatureEff:setPosition(self.itemBg:getContentSize().width/2,self.itemBg:getContentSize().height/2 + 10)
end

function RechargeItem:clearEffect()
    if self.armatureEff then
        self.armatureEff:getAnimation():stop()
        if self.armatureEff:getParent() then
            self.armatureEff:getParent():removeChild(self.armatureEff)
        end 
        self.armatureEff = nil
    end
    if  self.frameHandle then
        GlobalTimer.unscheduleGlobal(self.frameHandle)
        self.frameHandle = nil
    end
end
 
function RechargeItem:destory()
    self:clearEffect()
end

return RechargeItem