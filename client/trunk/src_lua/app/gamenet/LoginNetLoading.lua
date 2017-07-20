--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-03-28 16:42:52
-- 网络socket加载条
local LoginNetLoading = LoginNetLoading or class("LoginNetLoading", function()
	return display.newNode()
end)


function LoginNetLoading:ctor(param)
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
    
    self.armatureDataManager = ccs.ArmatureDataManager:getInstance()
    self.effectID = "waiting"
    self.url = ResUtil.getEffect(self.effectID)
    -- ArmatureManager:getInstance():loadEffect("waiting")
    -- self.armatureDataManager:addArmatureFileInfo(url)
    self.armatureDataManager:addArmatureFileInfo(ResUtil.getEffectPVRImg(self.effectID),ResUtil.getEffectPlist(self.effectID),self.url)
    if self.armatureDataManager:getArmatureData(self.effectID) then
        self.armatureEff = ccs.Armature:create(self.effectID)
        --self.armatureGHEff:stopAllActions()    
        self.armatureEff:getAnimation():play("effect")
        self:addChild(self.armatureEff)
        self.armatureEff:setPosition(display.cx, display.cy)
    end

end


function LoginNetLoading:show(tips)

end

function LoginNetLoading:close()
    if self.armatureEff then
        self.armatureEff:getAnimation():stop()
        --self.armatureEff:stopAllActions()
        if self.armatureEff:getParent() then
            self.armatureEff:getParent():removeChild(self.armatureEff)
        end 
        self.armatureEff = nil
    end
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self.url)
    local parent = self:getParent()
    if parent ~= nil then
        parent:removeChild(self)
    end 
end

return LoginNetLoading
 