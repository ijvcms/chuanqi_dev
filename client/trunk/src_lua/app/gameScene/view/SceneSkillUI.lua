--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-02 11:10:40
-- 场景技能UI
local SceneSkillUIItem = class("SceneSkillUIItem", function()
	return display.newNode()
end)

function SceneSkillUIItem:ctor(index,useSkillVO)
    self.vo = nil
    self.progressValue = 0
    --背景
	local skillBg = display.newSprite("#scene/scene_useSkillBtn.png")
    self:addChild(skillBg)
    --图标
    self.skillIcon = display.newSprite()
    self:addChild(self.skillIcon)
    self.skillIcon:setScale(0.9)
    --选中框
    self.skillSelPic = display.newSprite("#scene/scene_skillSelRoundBg.png")
    self:addChild(self.skillSelPic)
    self.skillSelPic:setVisible(false)
    --CD后闪
    self.skillShanPic = display.newSprite("#scene/scene_skillCDfinish.png")
    self:addChild(self.skillShanPic)
    self.skillShanPic:setVisible(false)

    --锁定
    self.lockBg = display.newSprite("#scene/scene_skillLockPic.png")
    self:addChild(self.lockBg)
    self.lockBg:setVisible(false)
   	self.maskRect = cc.rect(-40, -40, 75, 0)
    --self.skillClippingRegion:setClippingRegion(cc.rect(-40, 0, 75, 40))

    self.indexBg = display.newSprite("#scene/scene_skillIndexBg.png")
    self:addChild(self.indexBg)
    self.indexBg:setPosition(24,24)
    self.indexBg:setVisible(false)

    self.indexLab = display.newSprite("#scene/attrName_A_"..index..".png")
    self.indexLab:setScale(0.6)
    self.indexLab:setTouchEnabled(false)
    self.indexBg:addChild(self.indexLab)
    self.indexLab:setPosition(12,12)
    self.indexLab:setAnchorPoint(0.5,0.5)

    -- self.indexLab = display.newBMFontLabel({
    --         text = index,
    --         font = "fonts/bitmapText_22.fnt",
    --         })
    -- self.indexLab:setTouchEnabled(false)
    -- self.indexBg:addChild(self.indexLab)
    -- self.indexLab:setPosition(12,12)
    -- self.indexLab:setAnchorPoint(0.5,0.5)

    self.curVisible = true

    self.circleProgress = require("app.gameui.CircleProgressBar").new()
    self:addChild(self.circleProgress)
    self.circleProgress:setVisible(false)
    self.circleProgress:setPercent(1)

    self.curAutoAtkStates = false
end


function SceneSkillUIItem:showSkillShanPic()
    self.skillShanPic:stopAllActions()
    self.skillShanPic:setVisible(true)
    self.skillShanPic:setOpacity(0)
    local action1 = cc.FadeIn:create(0.1)
    local action2 = cc.FadeOut:create(0.3)
    local action3 = cc.CallFunc:create(function() 
            self.skillShanPic:setVisible(false)
            self.skillShanPic:stopAllActions()
            end)
    local action5 = transition.sequence({
                action1,
                action2,
                action3,
            })
    --local action6 = cc.RepeatForever:create(action5)
    self.skillShanPic:runAction(action5)
end

function SceneSkillUIItem:setLock(isLock)
    if self.isLock ~= isLock then
        self.isLock = isLock
        self.lockBg:setVisible(self.isLock == true)
    end
end

--点击技能
function SceneSkillUIItem:onSkillClick()
    if self.vo == nil then
        return true
    end
    if self.vo:getSkillLock() == false then
        --暂时注销
        --GlobalMessage:show("技能冷却中")
        return true
    end
    if self.vo:isOnlySelSkill() then
        self.vo:setSkillIsSelect()
    else
        if self.vo.mp <= RoleManager:getInstance().roleInfo.cur_mp then
            local player = GlobalController.fight:getSelfPlayerModel()
            if player.silent then
                GlobalAlert:show("沉默中")
                return true
            end
            FightModel.atkByDefaultSkill = false
            RoleManager:getInstance().nextUseSkillID = self.vo.id
            if player.vo.states ~= RoleActivitStates.ATTACK then
                player:setStates(RoleActivitStates.PRE_ATTACK)
            end
            FightModel:setAutoAttackStates(false)
        else
            GlobalAlert:show("魔法不足")
        end
    end
end

--设置技能可显示
function SceneSkillUIItem:setItemVisible(bool)
    self.curVisible = bool
    self:setVisible(self.curVisible)
end

--获取技能显示状态
function SceneSkillUIItem:getItemVisible()
    return self.curVisible 
end

--设置技能VO
function SceneSkillUIItem:setSkillVO(vo)
    if vo == nil then
        self.skillIcon:setVisible(false)
        self.circleProgress:setVisible(false)
        self.skillShanPic:setVisible(false)
        self.lockBg:setVisible(false)
        self.vo = vo
        return
    else
        self.skillIcon:setVisible(true)
        if self.vo and vo and self.vo.id == vo.id then
            self.vo = vo
            return
        else
            self.vo = vo
            if self.skillIcon then
                self.skillIcon:setTexture(string.format("icons/skill/%s.png",tostring(self.vo.resID)))
            end
        end
    end
end


--更新技能
function SceneSkillUIItem:update(data)
    if self.vo == nil then
        if self.progressValue ~= 0 then
            self.progressValue = 0
        end
        self.circleProgress:setVisible(false)
        return
    end
	if self.vo:getSkillLock() and self.progressValue ~= 0 then
        --技能解锁
        self:showSkillShanPic()
        --self.skillShanPic:setVisible(true)
        self.circleProgress:setVisible(false)
        self.circleProgress:setPercent(0)
        self.progressValue = 0
    elseif self.vo.precent < 1 then
        --技能锁定
        self.progressValue = self.vo.precent*100
        self.circleProgress:setVisible(true)
        self.circleProgress:setPercent(self.progressValue)
    end
    if self.vo:getSkillIsSelect() then
        self.skillSelPic:setVisible(true)
    else
        self.skillSelPic:setVisible(false)
    end
end

function SceneSkillUIItem:setIndexLabelVisible(visible)
    self.indexLab:setVisible(visible)
    self.indexBg:setVisible(visible)
end

--销毁技能
function SceneSkillUIItem:destory()
    if self.skillShanPic then
        self.skillShanPic:stopAllActions()
    end
end
-------------------------技能item END


--战斗场景技能页面
local SceneSkillUI = class("SceneSkillUI", function()
	return display.newNode()
end)

local kFightSceneSpecialSkillItemCounts = 1

SceneSkillUI.specialSkillItems = nil
SceneSkillUI.rightSkillNode = nil

local function _createSpecialSkillItems(self)
    self.specialSkillItems = {}
    local baseY = -30
    local baseX = 130
    local spaceX = 60
    for i = 1,kFightSceneSpecialSkillItemCounts do
        local skillItem = SceneSkillUIItem.new(i)
        self:addChild(skillItem)
      --  skillItem:setScale(0.8)

        skillItem:setPosition(-display.width /2 + baseX + spaceX * (i - 1) ,baseY)
        skillItem:setIndexLabelVisible(false)
        skillItem:setItemVisible(false)
        table.insert(self.specialSkillItems,skillItem)
    end
end

function SceneSkillUI:ctor(data)
	--272,143
    self:setTouchEnabled(false)

    self.disToAng = 2
    self.defSkill = RoleManager:getInstance():getCarrerDefSkill()
    --技能层
    self.rightSkillNode = display.newNode()
    self:addChild(self.rightSkillNode)

    self.defSkillPx = -52
    self.defSkillPy = 52
    self.defSkillW = 106
    --箭头
    local arrow = display.newSprite("#scene/scene_skillarrowPic1.png")
    self:addChild(arrow)
    arrow:setPosition(self.defSkillPx - 10,self.defSkillPy +62)

    local arrow2 = display.newSprite("#scene/scene_skillarrowPic2.png")
    self:addChild(arrow2)
    --arrow2:setScaleY(-1)
    arrow2:setPosition(self.defSkillPx - 62,self.defSkillPy +12)
    --默认技能
    self.defSkillBtn = display.newSprite("#scene/scene_defSkillBtn.png")
    self.defSkillIcon = display.newSprite("icons/skill/"..self.defSkill.."A.png")
    self.defSkillBtn:addChild(self.defSkillIcon)
    self.defSkillIcon:setScale(0.9)
    self.defSkillIcon:setPosition(53,53)

    self.lockBg = display.newSprite("#scene/scene_skillLockPic.png")
    self.defSkillBtn:addChild(self.lockBg)
    self.lockBg:setPosition(53,53)
    --self.lockBg:setVisible(false)
    self.rightSkillNode:addChild(self.defSkillBtn)
    
    self.defSkillBtn:setPosition(self.defSkillPx,self.defSkillPy)

    --self.defSkillBtn:setTouchEnabled(true)
    self.defSkillBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --self.changtarBtn:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
        if event.name == "ended" then
            self.defSkillBtn:setScale(1)
            local player = GlobalController.fight:getSelfPlayerModel()

            if player.silent then
                GlobalAlert:show("沉默中")
                return true
            end

            RoleManager:getInstance().nextUseSkillID = self.defSkill
            FightModel.atkByDefaultSkill = true
            if player.vo.states ~= RoleActivitStates.ATTACK then
                player:setStates(RoleActivitStates.PRE_ATTACK)
            end
            FightModel:setAutoAttackStates(false)
        elseif event.name == "began" then
            self.defSkillBtn:setScale(1.1)
        end
        return true
    end)

    self.autoBtn = display.newSprite("#scene/scene_autoSkillBtn.png")
    self.rightSkillNode:addChild(self.autoBtn)
    self.autoBtn:setPosition(self.defSkillPx + 26,self.defSkillPy+206)
    --self.autoBtn:setTouchEnabled(true)
    self.autoBtnIsClick = false
    self.autoBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            if self.autoBtnIsClick then
                self.autoBtnIsClick = false
                self.autoBtn:setScale(1)
                FightModel:setAutoAttackStates(true)
                self:updateAutoAttack()
                GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_AUTO_ATTACK)
            end

        elseif event.name == "began" then
            self.autoBtn:setScale(1.1)
            self.autoBtnIsClick = true
        end
        return true
    end)

    self.canelAutoBtn = display.newSprite("#scene/scene_canelAutoSkillBtn.png")
    self.rightSkillNode:addChild(self.canelAutoBtn)
    self.canelAutoBtn:setPosition(self.autoBtn:getPosition())
    --self.canelAutoBtn:setTouchEnabled(true)
    self.canelAutoBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            if self.autoBtnIsClick then
                self.autoBtnIsClick = false
                self.canelAutoBtn:setScale(1)
                FightModel:setAutoAttackStates(false)
                self:updateAutoAttack()
                GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_AUTO_ATTACK)
            end
        elseif event.name == "began" then
            self.canelAutoBtn:setScale(1.1)
            self.autoBtnIsClick = true
        end
        return true
    end)

    --宠物攻击休息
    self.petAtkBtnLay = display.newNode()
    self.rightSkillNode:addChild(self.petAtkBtnLay)
    self.petAtkBtn = display.newSprite("#scene/scene_petStateA.png")
    self.petAtkBtnLay:addChild(self.petAtkBtn)
    self.petDefBtn = display.newSprite("#scene/scene_petStateR.png")
    self.petAtkBtnLay:addChild(self.petDefBtn)
    self.petAtkBtnLay:setPosition(self.defSkillPx + 29,self.defSkillPy+271+56)
    --self.petAtkBtnLay:setTouchEnabled(true)
    self.petAtkBtnLay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.petAtkBtnLay:setScale(1)
        elseif event.name == "began" then
            self.petAtkBtnLay:setScale(1.1)
            GameNet:sendMsgToSocket(10014, {})
        end
        return true
    end)


    --回城石
    -- self.homeBtnLay = display.newNode()
    -- self.otherBtnLyr:addChild(self.homeBtnLay)
    self.homeBtnLay = display.newSprite("#scene/scene_homeStoneBtn.png")
    self:addChild(self.homeBtnLay)
    --self.homeBtnLay:setTouchEnabled(true)
    self.homeBtnLay:setPosition(self.defSkillPx +30,self.defSkillPy+271)
    self.homeBtnLay:setTouchEnabled(true)
    self.homeBtnLay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.homeBtnLay:setScale(1)
            --GameNet:sendMsgToSocket(14007, {goods_id = 110152})
        elseif event.name == "began" then
            self.homeBtnLay:setScale(1.1)
            BagController:getInstance():requestUseGoods({goods_id = 110152})
        end
        return true
    end)
    self:updateHome()

    --瞬回药
    self.drinkDrugBtn = require("app.modules.fight.view.item.DrinkDrugItem").new()
    self:addChild(self.drinkDrugBtn)
    self.drinkDrugBtn:setPosition(self.defSkillPx -120+3,self.defSkillPy+170)
    self.drinkDrugBtn:setTouchEnabled(false)

    --切换目标
    self.changtarBtn = display.newSprite("#scene/scene_changtarBtn.png")
    --self.changtarBtn:setTouchEnabled(true)
    self:addChild(self.changtarBtn)
    self.changtarBtn:setPosition(self.defSkillPx -46,self.defSkillPy+200)
    self.changtarBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self.changtarBtn:setScale(1)
        elseif event.name == "began" then
            self.changtarBtn:setScale(1.1)
            FightModel.atkByDefaultSkill = false
            FightModel:changSelAtkTarVO()
        end
        return true
    end)

    --9个技能相关
    self.radioXX = self.defSkillPx  --技能圆点X
    self.radioYY = self.defSkillPy --技能圆点Y
    self.skillRadio = 128  --技能半径
    self.beginAng = 40
    self.skillItemList = {}
    for i=1,9 do
        local ang = 40*i + self.beginAng
        local xx = math.cos((ang*3.1415)/180)*self.skillRadio + self.radioXX
        local yy = math.sin((ang*3.1415)/180)*self.skillRadio + self.radioYY
        local skillItem = SceneSkillUIItem.new(i)
        self.rightSkillNode:addChild(skillItem)
        table.insert(self.skillItemList,skillItem)
        skillItem:setPosition(xx,yy)
    end

    self.btnList = {self.defSkillBtn,self.autoBtn,self.canelAutoBtn,self.petAtkBtnLay,self.drinkDrugBtn,self.homeBtnLay,self.changtarBtn}
    self.num = 0
    --self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --self.defSkillBtn:EventDispatcher( cc.NODE_TOUCH_EVENT, event )
        self.num = self.num + 1
        local pp = cc.p(event.x,event.y)
        local btn = nil
        for i=1,#self.btnList do
            btn = self.btnList[i]
            if btn and btn:isVisible() and cc.rectContainsPoint(btn:getCascadeBoundingBox(), pp) then
                btn:EventDispatcher( cc.NODE_TOUCH_EVENT, event)
                break
            end
        end
        local point = self:convertToNodeSpace(cc.p(event.x, event.y))
        if event.name == "began" then
            for i=1,#self.skillItemList do
                local item = self.skillItemList[i]
                local ix,iy = item:getPosition()
                if item:getItemVisible() and FightUtil:getDistance(point.x,point.y,ix,iy) < 45 then
                    item:setScale(1.1)
                    self.clickItem = item
                    self.isClick = true
                    break
                end
            end
            if not self.clickItem then
                for _,skillItem in ipairs(self.specialSkillItems or {}) do
                    local ix,iy = skillItem:getPosition()
                    if skillItem:getItemVisible() and FightUtil:getDistance(point.x,point.y,ix,iy) < 45 then
                        skillItem:setScale(1.05)
                        self.clickItem = skillItem
                        self.isClick = true
                        break
                    end
                end
            end
            self.setVisible = false
            self.moveBeginY = point.y
            return true
        elseif event.name == "moved" then

            local yy = self.moveBeginY - point.y
                if math.abs(yy) > 6 then
                if  self.setVisible == false then
                    self:setSkillItemVisible(true)
                    self.setVisible = true
                end
                self.isClick = false
                local beginAng = self.beginAng +yy/self.disToAng
                for i=1,9 do
                    local ang = 40*i + beginAng
                    local xx = math.cos((ang*3.1415)/180)*self.skillRadio + self.radioXX
                    local yy = math.sin((ang*3.1415)/180)*self.skillRadio + self.radioYY
                    local skillItem = self.skillItemList[i]
                    skillItem:setPosition(xx,yy)
                    skillItem:setIndexLabelVisible(true)
                end
            end
            return true
        elseif event.name == "ended" then
            if self.isClick then
                if self.clickItem then
                    self.clickItem:setScale(1)
                    self.clickItem:onSkillClick()
                end
            else
                local yy = self.moveBeginY - point.y
                local newAng = self.beginAng +yy/self.disToAng

                self.beginAng = math.round((newAng - self.beginAng)/40)*40+self.beginAng
                for i=1,9 do
                    local ang = 40*i + self.beginAng
                    local xx = math.cos((ang*3.1415)/180)*self.skillRadio + self.radioXX
                    local yy = math.sin((ang*3.1415)/180)*self.skillRadio + self.radioYY
                    local skillItem = self.skillItemList[i]
                    skillItem:setPosition(xx,yy)
                    skillItem:setIndexLabelVisible(false)
                end
                self:setSkillItemVisible(false)
            end

            if self.clickItem then
                self.clickItem:setScale(1)
                self.clickItem = nil
            end
            if self.setVisible then
                -- GUIDE CONFIRM
                 GlobalController.guide:notifyEventWithConfirm(GUIOP.SLIDE_QUICK_TURN)
            end
            
        end       
        return true
    end)
    self:setSkillItemVisible(false)
    _createSpecialSkillItems(self)
    self:updatePetAtkBtn(true)
end


--更新回城石按钮状态
function SceneSkillUI:updateHome(data)
    if data then
        data = data.data
        if data.num == 0 then
            local curfilter = filter.newFilter("GRAY")
            curfilter:initSprite(nil)
            self.homeBtnLay:setGLProgramState(curfilter:getGLProgramState()) --使用
        else
            self.homeBtnLay:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP"))
        end
    else
        if BagManager:getInstance().bagInfo:findItemCountByItemId(110152) == 0 then
         local curfilter = filter.newFilter("GRAY")
            curfilter:initSprite(nil)
            self.homeBtnLay:setGLProgramState(curfilter:getGLProgramState()) --使用
        else
            self.homeBtnLay:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP"))
        end
    end
end



function SceneSkillUI:updatePetAtkBtn(isOnlysetView)
    self.petAtkBtn:setVisible(RoleManager:getInstance().roleInfo.petStates == 1)
    self.petDefBtn:setVisible(RoleManager:getInstance().roleInfo.petStates ~= 1)
end

--设置技能在可见范围内显示
function SceneSkillUI:setSkillItemVisible(b)
    for i=1,9 do
        local skillItem = self.skillItemList[i]
        local xx, yy = skillItem:getPosition()
        if xx < self.defSkillPx  + 60 and xx > self.defSkillPx-130 and yy < self.defSkillPy+135 and yy > self.defSkillPy - 60 then
            skillItem:setItemVisible(true)
        else
            skillItem:setItemVisible(b or false)
        end
        --skillItem:setItemVisible(true)
    end
end

local SkillUITypes = require("app.modules.skill.config.SkillUITypes")

local function filterAllkills(self)
    local skillList = RoleManager:getInstance().useSkillList
    local normalUiSkills = {}
    local specialUiSkills = {}
    for _,skillItem in ipairs(skillList or {}) do
        local skillId = skillItem.id
        local skilllevel = skillItem.lv
        local skillConfig = FightModel:getSkillConfig(skillId,skilllevel)
        if skillConfig and skillConfig.uitypes == SkillUITypes.Normal then
            table.insert(normalUiSkills,skillItem)
        elseif skillConfig and skillConfig.uitypes == SkillUITypes.Special then
            table.insert(specialUiSkills,skillItem)
        end
    end
    return normalUiSkills,specialUiSkills
end


--更新技能
function SceneSkillUI:updateSkill()
    local normalUiSkills,specialUiSkills = filterAllkills(self)
    for i=1,9 do
        local skillVO = nil
        for k,v in ipairs(normalUiSkills or {}) do
            if v.posKey == i then
                skillVO = v
                break
            end
        end
        local item = self.skillItemList[i]
        item:setSkillVO(skillVO)
    end

    for skillIndex,specialItem in ipairs(self.specialSkillItems or {}) do
        local skillVo = specialUiSkills[skillIndex]
        if skillVo then
            specialItem:setItemVisible(true)
            specialItem:setSkillVO(skillVo)
        else
            specialItem:setItemVisible(false)
        end
    end
end


function SceneSkillUI:listenerFun()
    local isLockSkill = false
    local player = GlobalController.fight:getSelfPlayerModel()
    if player then
        isLockSkill = player.silent
    end
    
    for k,v in ipairs(self.skillItemList or {}) do
        if v:isVisible() then
            v:update()
            v:setLock(isLockSkill)
        end
    end

    for _,specialItem in ipairs(self.specialSkillItems or {}) do
        specialItem:update()
        specialItem:setLock(isLockSkill)
    end 
    self.lockBg:setVisible(isLockSkill)
end

function SceneSkillUI:open()
    self:updateSkill()

    if self.updateHomeEventId == nil then
        self.updateHomeEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_HOME_NUM,handler(self,self.updateHome))
    end
    if self.skillListeneTimeId then
        GlobalTimer.unscheduleGlobal(self.skillListeneTimeId)
        self.skillListeneTimeId = nil
    end
    if self.updateSkillListEventId == nil then
        self.updateSkillListEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_SKILL_LIST,handler(self,self.updateSkill))
    end
	if self.skillListeneTimeId == nil then
		self.skillListeneTimeId =  GlobalTimer.scheduleGlobal(handler(self,self.listenerFun),0.1)
	end
    if self.updateAutoAttackEventId == nil then
        self.updateAutoAttackEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_AUTO_ATTACK,handler(self,self.updateAutoAttack))
    end

    if self.updatePetAttStatesEventId == nil then
        self.updatePetAttStatesEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_PET_ATT_STATES,handler(self,self.updatePetAtkBtn))
    end
    if self.updatePetNumEventId == nil then
        self.updatePetNumEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_PET_NUM,handler(self,self.updatePetNum))
    end

    local sceneConfig = GameSceneModel.sceneConfig
    if sceneConfig then
        if sceneConfig.autofight == nil or sceneConfig.autofight == 3  then
        elseif sceneConfig.autofight == 1  then
            self.curAutoAtkStates = true
            FightModel:setAutoAttackStates(true)
            if sceneConfig.story_reward and sceneConfig.story_reward ~= 0 then
                GlobalEventSystem:dispatchEvent(SceneEvent.HIDE_NAV)
            end
        elseif sceneConfig.autofight == 2  then
            self.curAutoAtkStates = false
            FightModel:setAutoAttackStates(false)
        end
    end
    self.curAutoAtkStates = false
    self:updateAutoAttack()
    self:updatePetNum()
end

function SceneSkillUI:updatePetNum()
    self.petAtkBtnLay:setVisible(RoleManager:getInstance().roleInfo.petNum > 0)
end


function SceneSkillUI:updateAutoAttack()
    if FightModel:getAutoAttackStates(true) then
        self.canelAutoBtn:setVisible(true)
        self.autoBtn:setVisible(false)
    else
        self.canelAutoBtn:setVisible(false)
        self.autoBtn:setVisible(true)
    end
end

function SceneSkillUI:containePoint(point)
    local localPoint = self:convertToNodeSpace(point)
    for _,specialItem in ipairs(self.specialSkillItems or {}) do
        local ix,iy = specialItem:getPosition()
        if specialItem:getItemVisible() and FightUtil:getDistance(localPoint.x,localPoint.y,ix,iy) < 45 then
            return true
        end
    end    
    
    return  cc.rectContainsPoint(self.rightSkillNode:getCascadeBoundingBox(), point)

end

function SceneSkillUI:close()
    if self.updatePetNumEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updatePetNumEventId)
        self.updatePetNumEventId = nil
    end
    if self.updatePetAttStatesEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updatePetAttStatesEventId)
        self.updatePetAttStatesEventId = nil
    end

    if self.updateSkillListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateSkillListEventId)
        self.updateSkillListEventId = nil
    end

    if self.updateAutoAttackEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateAutoAttackEventId)
        self.updateAutoAttackEventId = nil
    end

	if self.skillListeneTimeId then
		GlobalTimer.unscheduleGlobal(self.skillListeneTimeId)
		self.skillListeneTimeId = nil
	end

	if self.updateHomeEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateHomeEventId)
        self.updateHomeEventId = nil
    end
end

function SceneSkillUI:destory()
	self:close()
    if self.drinkDrugBtn then
        self.drinkDrugBtn:destory()
    end
    for k,v in ipairs(self.skillItemList or {}) do
        v:destory()
        self:removeChild(v)
    end
    self.skillItemList = {}
    for _,specialItem in ipairs(self.specialSkillItems or {}) do
        specialItem:destory()
        self:removeChild(specialItem)
    end
    self.specialSkillItems = {}
	if self:getParent() then
		self:getParent():removeChild(self)
	end
end

return SceneSkillUI