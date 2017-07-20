--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-28 21:02:37
-- 角色头像
local RoleHeadUI = class("RoleHeadUI", function()
	return display.newNode()
end)


function RoleHeadUI:ctor(data)
    self:setContentSize(cc.size(246, 158))
    self.width = 246
    self.height = 158

    self.headPic = display.newSprite()
    self:addChild(self.headPic)
    self.headPic:setPosition(42,116)

    local bg = display.newSprite("#scene/scene_roleHeadBg.png")
    self:addChild(bg)
    bg:setTouchEnabled(true)
    bg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            --GlobalEventSystem:dispatchEvent(SceneEvent.OPEN_NAV)
            GlobalWinManger:openWin(WinName.MAINROLEWIN)
        end
        return true
    end)
    local bgSize = bg:getContentSize()
    bg:setPosition(122,117)
    local bgPx,bgPy = bg:getPosition()

    --战力
    self.powerLab = display.newBMFontLabel({
            text = "",
            font = "fonts/number_style1.fnt",
            })
    self.powerLab:setTouchEnabled(false)
    self:addChild(self.powerLab)
    self.powerLab:setPosition(120,96)
    self.powerLab:setAnchorPoint(0,0.5)
    --vip
    local vipBtn = display.newSprite("#scene/scene_vipBg.png")
    vipBtn:setPosition(47,55)
    self:addChild(vipBtn)
    self.vipLab = display.newBMFontLabel({
            text = "11",
            font = "fonts/bitmapText_22.fnt",
            })
    self.vipLab:setTouchEnabled(false)
    vipBtn:addChild(self.vipLab)
    self.vipLab:setPosition(47,16)
    self.vipLab:setAnchorPoint(0.5,0.5)
    self.vipLab:setColor(cc.c3b(255, 254, 0))



    vipBtn:setTouchEnabled(true)
    local btnTips = BaseTipsBtn.new(BtnTipsType.BIN_VIP_BUTTON,vipBtn,86,24)
    vipBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            GlobalWinManger:openWin(WinName.VIPWIN)
        end
        return true
    end)

    self.nameLab = display.newTTFLabel({size = 16, color = cc.c3b(255, 254, 211), text = ""})
            :align(display.CENTER, bgPx+16,bgPy+29)
            :addTo(self)

    self.careerLab = display.newSprite():addTo(self)
    self.careerLab:setPosition(112,125)


    self.lvLab = display.newBMFontLabel({
            text = "",
            font = "fonts/bitmapText_22.fnt",
            })
    self.lvLab:setTouchEnabled(false)
    self:addChild(self.lvLab)
    self.lvLab:setPosition(166,125)
    self.lvLab:setAnchorPoint(0.5,0.5)
    --self.lvLab:setScale(0.9)
    --self.lvLab:setColor(cc.c3b(228, 228, 228))


    self.atkModeBtn = display.newSprite("#scene/scene_settingBtn.png")
    self:addChild(self.atkModeBtn)
    self.atkModeBtn:setPosition(41,16)
    self.atkModeBtn:setTouchEnabled(true)
    self.atkModeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.atkModeBtn:setScale(1)
            if FunctionOpenManager:getFunctionOpenById(FunctionOpenType.PkMode) then
                local xx,yy = self.atkModeBtn:getPosition()
                local view = require("app.modules.mainUI.SelectFightModelView").new({xx = xx,yy = yy})
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
            else
                FunctionOpenManager:showFunctionOpenTips(FunctionOpenType.PkMode)
            end
        elseif event.name == "began" then
            self.atkModeBtn:setScale(1.1)
        end       
        return true
    end)

    self.nearBtn = display.newSprite("#scene/scene_settingBtn.png")
    self:addChild(self.nearBtn)
    self.nearBtn:setTouchEnabled(true)
    self.nearBtn:setPosition(117,16)
    self.nearBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.nearBtn:setScale(1)
            local view = require("app.modules.near.view.NearView").new()
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
        elseif event.name == "began" then
            self.nearBtn:setScale(1.1)
        end       
        return true
    end)
    -- self.nearLab = display.newTTFLabel({size = 16, color = cc.c3b(255, 254, 211), text = "附近"})
    --         :align(display.CENTER, 36,16)
    --         :addTo(self.nearBtn)
    -- --self.nearLab:setPosition(47,16)
    --  self.nearLab = display.newBMFontLabel({
    --         text = "附近",
    --         font = "fonts/bitmapText_22.fnt",
    --         })
    -- self.nearLab:setTouchEnabled(false)
    -- self.nearBtn:addChild(self.nearLab)
    -- self.nearLab:setPosition(36,17)
    -- self.nearLab:setAnchorPoint(0.5,0.5)

    local nearLab =  display.newSprite("#scene/scene_txtFujin.png")
    nearLab:setTouchEnabled(false)
    self.nearBtn:addChild(nearLab)
    nearLab:setPosition(36,15)
    nearLab:setAnchorPoint(0.5,0.5)


    self.lineBtn = display.newSprite("#scene/scene_settingBtn.png")
    self:addChild(self.lineBtn)
    self.lineBtn:setTouchEnabled(true)
    self.lineBtn:setPosition(193,16)
    self.lineBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.lineBtn:setScale(1)
            if GameSceneModel.sceneId == 32115 then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"该场景不允许切线！")
            else
                GlobalWinManger:openWin(WinName.CHANGLINEWIN)
            end
        elseif event.name == "began" then
            self.lineBtn:setScale(1.1)
        end       
        return true
    end)
    -- self.lineLab = display.newTTFLabel({size = 16, color = cc.c3b(255, 254, 211), text = "--"})
    --         :align(display.CENTER, 36,16)
    --         :addTo(self.lineBtn)
    -- self.lineBtn:setVisible(false)

    self.lineLab = display.newBMFontLabel({
            text = "--",
            font = "fonts/bitmapText_22.fnt",
            })
    self.lineLab:setTouchEnabled(false)
    self.lineBtn:addChild(self.lineLab)
    self.lineLab:setPosition(36,17)
    self.lineLab:setAnchorPoint(0.5,0.5)



    self.buffLay = display.newNode()
    self.buffLay:setContentSize(cc.size(172, 40))
    self.buffLay:setPosition(98,35)
    self:addChild(self.buffLay)


    self.buffIcon = {}

    self:open()
end

function RoleHeadUI:updateBuff()
    for i=1,#self.buffIcon do
        if self.buffIcon[i] then
            self.buffIcon[i]:removeSelf()
        end
    end
    self.buffIcon = {}
    local data = RoleManager:getInstance().buffData
    
    for _,buffer in ipairs(data.spec_buff_list or {}) do
        local config = configHelper:getBuffConfigById(buffer.type)
        local buff = display.newSprite("#scene/scene_bg2.png")
        local buffIcon = display.newSprite(ResUtil.getGoodsIcon(config.icon))
        buffIcon:setPosition(buff:getContentSize().width/2, buff:getContentSize().height/2)
        buff:setScale(0.6)
        buffIcon:setScale(0.8)
        buff:addChild(buffIcon)
        self.buffLay:addChild(buff)
        buff:setTouchEnabled(true)
        buff:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "ended" then
            local xx,yy = self.buffLay:getPosition()
            local view = require("app.modules.buff.BuffListView").new({xx = xx,yy = yy - 40})
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
            end
            return true
        end)

        table.insert(self.buffIcon, buff)
    end
    
    for _,buffer in ipairs(data.buff_list or {}) do
        local config = configHelper:getBuffConfigById(buffer.buff_id)
        local buff = display.newSprite("#scene/scene_bg2.png")
        local buffIcon = display.newSprite(ResUtil.getGoodsIcon(config.icon))
        buffIcon:setPosition(buff:getContentSize().width/2, buff:getContentSize().height/2)
        buff:setScale(0.6)
        buffIcon:setScale(0.8)
        buff:addChild(buffIcon)
        self.buffLay:addChild(buff)
        buff:setTouchEnabled(true)
        buff:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "ended" then
            local xx,yy = self.buffLay:getPosition()
            local view = require("app.modules.buff.BuffListView").new({xx = xx,yy = yy - 40})
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view) 
            end
            return true
        end)

        table.insert(self.buffIcon, buff)
    end

    for i,buffIcon in ipairs(self.buffIcon or {}) do
        buffIcon:setPosition( (i-1)*(buffIcon:getContentSize().width*0.7-2) + 20, buffIcon:getContentSize().height/2 - 8)
    end
end

function RoleHeadUI:updateRoleInfo()
    local roleInfo = RoleManager:getInstance().roleInfo
    --local roleWealth = RoleManager:getInstance().wealth
    self.nameLab:setString(roleInfo.name)
    self.lvLab:setString("lv"..math.round(roleInfo.lv))
    self.powerLab:setString(math.round(roleInfo.fighting))
    self.vipLab:setString("VIP "..roleInfo.vip)
    --self.careerLab:setString(RoleCareerName[roleInfo.career])
    self.careerLab:setSpriteFrame("scene/scene_textcarrer"..math.floor(roleInfo.career/1000)..".png")
    self.headPic:setTexture(ResUtil.getRoleHead(roleInfo.career,roleInfo.sex))
    self:updateBuff()
end


function RoleHeadUI:updateFightModelType()
    if self.atkTypeTxt then
         self.atkModeBtn:removeChild(self.atkTypeTxt)
         self.atkTypeTxt = nil
    end
    local pic = ResUtil.getFightModelPic(RoleManager:getInstance().roleInfo.pkMode)
    self.atkTypeTxt = display.newSprite(pic)
    self.atkModeBtn:addChild(self.atkTypeTxt)
    self.atkTypeTxt:setPosition(self.atkModeBtn:getContentSize().width/2,self.atkModeBtn:getContentSize().height/2)
end

function RoleHeadUI:open()
    if self.lineUpdateEventId == nil then
        self.lineUpdateEventId = GlobalEventSystem:addEventListener(ChangLineEvent.LINE_UPDATE,handler(self,self.lineUpdate))
    end
    if self.roleBaseAttEventId == nil then
        local function onUpdate()
            self:updateRoleInfo()
        end
        self.roleBaseAttEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_ROLE_BASE_ATTR,onUpdate)
    end

    if self.roleBuffEventId == nil then
        local function onUpdateBuff()
            self:updateBuff()
        end
        self.roleBuffEventId = GlobalEventSystem:addEventListener(BuffEvent.Buff_LIST,onUpdateBuff)
    end

    if self.updateFightModelTypeEventId == nil then
        local function onUpdateFightModelType()

            self:updateFightModelType()
        end
        self.updateFightModelTypeEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_PKMODE,onUpdateFightModelType)
    end

     self:updateRoleInfo()
    self:updateFightModelType(RoleManager:getInstance().roleInfo.pkMode)
    
end

function RoleHeadUI:close()
    if self.roleBaseAttEventId then
         GlobalEventSystem:removeEventListenerByHandle(self.roleBaseAttEventId)
         self.roleBaseAttEventId = nil
    end
    if self.roleBuffEventId then
         GlobalEventSystem:removeEventListenerByHandle(self.roleBuffEventId)
         self.roleBuffEventId = nil
    end
    if self.updateFightModelTypeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateFightModelTypeEventId)
        self.updateFightModelTypeEventId = nil
    end
    if self.lineUpdateEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.lineUpdateEventId)
        self.lineUpdateEventId = nil
    end
    self:destory()
end


function RoleHeadUI:lineUpdate(data)
    self.curLine = GlobalModel.curLine
    if self.curLine > 0 then
        self.lineBtn:setVisible(true)
        self.lineLab:setString(math.round(self.curLine).."线")
    else
        self.lineBtn:setVisible(false)
    end
end

function RoleHeadUI:destory()
    self:removeSelf()
end

return RoleHeadUI


