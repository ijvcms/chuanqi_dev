----------------喝药item END
local LocalDatasManager = require("common.manager.LocalDatasManager")

local DrinkDrugItem = class("DrinkDrugItem", function()
    return display.newNode()
end)

function DrinkDrugItem:ctor(index,useSkillVO)
    self.vo = nil
    self.btnBg = display.newSprite("#scene/scene_drinkBg.png")
    self:addChild(self.btnBg)
    self.btnBg:setPosition(0,0)

    self.shanPic = display.newSprite("#scene/scene_skillCDfinish.png")
    self:addChild(self.shanPic)
    self.shanPic:setScale(0.72)
    self.shanPic:setPosition(0,0)
    self.shanPic:setVisible(false)

    self.iconLay = display.newNode()
    self:addChild(self.iconLay)

    self.circleProgress = require("app.gameui.CircleProgressBar").new()
    self:addChild(self.circleProgress)
    self.circleProgress:setVisible(false)
    self.circleProgress:setPercent(1)
    self.circleProgress:setScale(0.72)

    self:setTouchEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self:setScale(1)
        elseif event.name == "began" then
            self:setScale(1.1)
            self:onClick()
        end
        return true
    end)

    self.maskRect = cc.rect(-28, -28, 56, 0)
    self.precent = 100
    self.isClickEnable = true --是否可以点击
    self.isUseEnable = true --是否可以使用 ，没有药的情况下不可用
    self.cdTime = 1
    self.goodsList = configHelper:getQuickUseList()
    local info = LocalDatasManager:getLocalData("QUICK_USE_GOODS")
    if info then
        self.goods_id = info.id
    else
        self.goods_id = self.goodsList[1]
    end
    if self.propChangEventId == nil then
        self.propChangEventId = GlobalEventSystem:addEventListener(BagEvent.PROP_CHANGE, handler(self, self.setDrugId))
    end

    if self.quickUseChangEventId == nil then
        self.quickUseChangEventId = GlobalEventSystem:addEventListener(BagEvent.QUICK_USE_CHANGE, handler(self, self.quickUseChang))
    end

    self:setDrugId()
end

--显示闪的图片
function DrinkDrugItem:showShanPic()
    self.shanPic:stopAllActions()
    self.shanPic:setVisible(true)
    self.shanPic:setOpacity(0)
    local action1 = cc.FadeIn:create(0.1)
    local action2 = cc.FadeOut:create(0.3)
    local action3 = cc.CallFunc:create(function()
            self.shanPic:setVisible(false)
            self.shanPic:stopAllActions()
            end)
    local action5 = transition.sequence({
                action1,
                action2,
                action3,
            })
    --local action6 = cc.RepeatForever:create(action5)
    self.shanPic:runAction(action5)
end


--点击按钮
function DrinkDrugItem:onClick()
    if self.isClickEnable and self.isUseEnable then
        if self.drinkDrugTimeId == nil then
            self.precent = 0
            self.beginTime = socket.gettime()
            self.drinkDrugTimeId =  GlobalTimer.scheduleGlobal(handler(self,self.update),0.1)
        end
        local data = {
            goods_id = self.goods_id
        }
        --GameNet:sendMsgToSocket(14007, data)
        BagController:getInstance():requestUseGoods(data)
    else
        if self.isUseEnable == false then
            GlobalMessage:show("没有可使用的药品")
        end
    end
end

function DrinkDrugItem:setBtnUseEnable(bool)
    self.isUseEnable = bool
    if bool == false then
        local curfilter = filter.newFilter("GRAY")
        curfilter:initSprite(nil)
        self.btnBg:setGLProgramState(curfilter:getGLProgramState()) --使用
        if self.drugIcon then
            local curfilter = filter.newFilter("GRAY")
            curfilter:initSprite(nil)
            self.drugIcon:setGLProgramState(curfilter:getGLProgramState()) --使用
        end
        -- btnQQFriend:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")) --清除
    else
        self.btnBg:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP"))
        if self.drugIcon then
            self.drugIcon:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP"))
        end
        --self.btnBg:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")) --清除
    end
end

function DrinkDrugItem:quickUseChang(data)
    if data.data then
        self.goods_id = data.data
    else
        self.goods_id = self.goodsList[1]
    end
    self:setDrugId()
end

--设置技能VO
function DrinkDrugItem:setDrugId()
    if BagManager:getInstance():findItemCountByItemId(self.goods_id) > 0 then
        if self.drugIcon == nil then
            self.drugIcon = display.newSprite(ResUtil.getGoodsSmallIcon(self.goods_id))
            self.iconLay:addChild(self.drugIcon )
        else
            self.drugIcon:setTexture(ResUtil.getGoodsSmallIcon(self.goods_id))
        end
        if self.isUseEnable == false then
            self:setBtnUseEnable(true)
            local type = configHelper:getGoodTypeByGoodId(self.goods_id)
            local subType = configHelper:getGoodSubTypeByGoodId(self.goods_id)
            self.cdTime = configHelper:getGoodCDTime(type, subType)
        end
        return
    end
    for i=1,#self.goodsList do
        local goods_id = self.goodsList[i]
        if BagManager:getInstance():findItemCountByItemId(goods_id) > 0 then
            self.goods_id = goods_id
            LocalDatasManager:saveLocalData({id = goods_id}, "QUICK_USE_GOODS")
            local type = configHelper:getGoodTypeByGoodId(goods_id)
            local subType = configHelper:getGoodSubTypeByGoodId(goods_id)

            self.cdTime = configHelper:getGoodCDTime(type, subType)
            if self.drugIcon then
                self.iconLay:removeChild(self.drugIcon)
                self.drugIcon = nil
            end
            self.drugIcon = display.newSprite(ResUtil.getGoodsSmallIcon(self.goods_id))
            self.iconLay:addChild(self.drugIcon )
            if self.isUseEnable == false then
                self:setBtnUseEnable(true)
            end
            return
        end
    end
    if self.drugIcon == nil and self.goods_id ~= 0 then
        self.drugIcon = display.newSprite(ResUtil.getGoodsSmallIcon(self.goods_id))
        self.iconLay:addChild(self.drugIcon )
    end
    if self.isUseEnable then
        self:setBtnUseEnable(false)
    end
end


--更新技能
function DrinkDrugItem:update(data)
    local curTime = socket.gettime()
    if curTime - self.cdTime > self.beginTime then
        self.isClickEnable = true
        --self.maskRect.height = 0
        self.circleProgress:setVisible(false)
        --self.clippingRegion:setClippingRegion(self.maskRect)
        if self.drinkDrugTimeId then
            GlobalTimer.unscheduleGlobal(self.drinkDrugTimeId)
            self.drinkDrugTimeId = nil
        end
        --self.maskPic1:setVisible(false)
        self:showShanPic()
    else
        self.isClickEnable = false
        self.circleProgress:setVisible(true)

        self.circleProgress:setPercent(100*(curTime-self.beginTime)/self.cdTime)

        --self.maskRect.height = 75*(curTime-self.beginTime)/self.cdTime
        --self.clippingRegion:setClippingRegion(self.maskRect)
        --self.maskPic1:setVisible(true)
    end
end

--销毁技能
function DrinkDrugItem:destory()
    if self.shanPic then
        self.shanPic:stopAllActions()
    end
    if self.drinkDrugTimeId then
        GlobalTimer.unscheduleGlobal(self.drinkDrugTimeId)
        self.drinkDrugTimeId = nil
    end
    if self.propChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.propChangEventId)
        self.propChangEventId = nil
    end

    if self.quickUseChangEventId ~= nil then
        GlobalEventSystem:removeEventListenerByHandle(self.quickUseChangEventId)
        self.quickUseChangEventId = nil
    end
end

return DrinkDrugItem

-----------------喝药item END