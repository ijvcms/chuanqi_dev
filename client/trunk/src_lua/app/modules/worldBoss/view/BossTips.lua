--
-- Author: Yi hanneng
-- Date: 2016-08-04 16:32:00
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BossTips = BossTips or class("BossTips", BaseView)
 
function BossTips:ctor()
	self.ccui = cc.uiloader:load("resui/BossTips.ExportJson")
    ccui:setPosition(display.cx-188/2,display.cy-240)
    self:addChild(self.ccui)
    self:init()
    self.isCancelRemoveSpriteFrams = true
    self:setNodeEventEnabled(true)
end

function BossTips:init()
	
	self.headIcon = cc.uiloader:seekNodeByName(self.ccui, "headIcon")
    self.btnClose = cc.uiloader:seekNodeByName(self.ccui, "btnClose")
    self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "btnGo")
    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
    self.lvLabel = cc.uiloader:seekNodeByName(self.ccui, "lvLabel")

    self.btnClose:setTouchEnabled(true)
    self.btnClose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnClose:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnClose:setScale(1.0)
            self:close()
        end     
        return true
    end)

    self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)

            local info = configHelper:getWorldBossConfigById(self.data.scene_id,self.data.monster_id)

            if info then
                if  RoleManager:getInstance().roleInfo.lv < info.lv_limit then
                    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"等级需要达到"..info.lv_limit.."级才能进入!")
                    return
                end
                local flyShoesNum = BagManager:getInstance():findItemCountByItemId(110078)
         
                if info.vip_lv == nil then
                   
                    local posArr = string.split(info.point, ",")
                    local pos = cc.p(tonumber(posArr[1]),tonumber(posArr[2]))

                    if flyShoesNum > 0 then
                        GameNet:sendMsgToSocket(11033,{scene_id = info.scene_id})
                        self:close()
                    else
                        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送失败，小飞鞋不足，已开启自动寻路!")
                        SceneManager:playerMoveTo(info.scene_id,pos,nil,true)
                        self:close()
                    end
                    
                elseif info.index == 2 then
                    
                    local  vip = RoleManager:getInstance().roleInfo.vip
                    
                    if vip < info.vip_lv then
                        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"VIP等级不足"..info.vip_lv.."级，请提升VIP等级。")
                    else
                        if flyShoesNum > 0 then
                            GameNet:sendMsgToSocket(11033,{scene_id = info.scene_id})
                            self:close()
                        else
                            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送失败，小飞鞋不足!")
                        end
                    end
                end
            end

            
        end     
        return true
    end)
   
end

function BossTips:setData(data)
	if data == nil then
        return 
    end
    
    self.data = data

    self.nameLabel:setString(configHelper:getMonsterNameById(data.monster_id))
    self.lvLabel:setString(configHelper:getMonsterLvById(data.monster_id))

    
    if self.headIcon:getChildByTag(100) then
        self.headIcon:removeChildByTag(100, true)
    end
    
    local itembg = display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.monster_id) ..".png")
    self.headIcon:addChild(itembg)
    itembg:setTag(100)
    itembg:setPosition(self.headIcon:getContentSize().width/2, self.headIcon:getContentSize().height/2)

    self.delay = require("framework.scheduler").performWithDelayGlobal(function() 
            self:close()
        end, 5)

end
 
function BossTips:getData()
	return self.data
end

local function _removeEvents(self)
    if self.delay then
        scheduler.unscheduleGlobal(self.delay)
        self.delay = nil
    end
end

function BossTips:close()
    _removeEvents(self)
    self:removeSelfSafety()
end

function BossTips:destory()
    _removeEvents(self)
    self.super.destory(self)
end

return BossTips