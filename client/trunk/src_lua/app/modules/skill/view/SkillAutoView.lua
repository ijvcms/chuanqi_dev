--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-14 14:11:08
-- 技能自动战斗界面

local SkillAutoView = SkillAutoView or class("SkillAutoView", function()
    return display.newNode()
end)

--构造
function SkillAutoView:ctor()
    local bg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(312, 475),cc.rect(6, 6,1, 1))
    self:addChild(bg)
    bg:setPosition(6+156,6+238)

    local bg2 = display.newScale9Sprite("#skill_frame1.png", 0, 0, cc.size(432, 476),cc.rect(82, 82,1, 1))
    bg2:setPosition(760-216-6,6+238)
    self:addChild(bg2)

	local leftTips = display.newTTFLabel({text = "周围只有一个怪物会自动使用单体\n技能，两个以上怪物使用群体技能",
        size = 18,color = TextColor.TEXT_W})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    leftTips:setPosition(20,444)
    display.setLabelFilter(leftTips)

    --单体技能
    self.singleSkillBtn = display.newSprite("#com_alertTitleBg.png")
    self.singleSkillBtn:setTouchEnabled(false)	
    self:addChild(self.singleSkillBtn)
    local lab = display.newTTFLabel({
        	text = "单体技能",
        	size = 20,
        	color = TextColor.BTN_W, 
   	})
    --display.setLabelFilter(lab)
    lab:setTouchEnabled(false)	
    lab:setPosition(100,15)
    self.singleSkillBtn:addChild(lab)
    self.singleSkillBtn:setPosition(156,392)

    --群体技能
    self.groupSkillBtn = display.newSprite("#com_alertTitleBg.png")
    self.groupSkillBtn:setTouchEnabled(true)	
    self:addChild(self.groupSkillBtn)
    --self.groupSkillBtn:setScale(1.2)
    -- self.groupSkillBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)			
    --         if event.name == "began" then            	
    --             self.groupSkillBtn:setScale(1.3)
    --         elseif event.name == "ended" then            	
    --             self.groupSkillBtn:setScale(1.2)
    --             self:selAutoSkill(2)
    --         end
    --         return true
    --     end)
    local lab = display.newTTFLabel({
        	text = "群体技能",
        	size = 20,
        	color = TextColor.BTN_W, 
   	})
    display.setLabelFilter(lab)
    lab:setTouchEnabled(false)	
    lab:setPosition(100,15)
    self.groupSkillBtn:addChild(lab)
    self.groupSkillBtn:setPosition(156,230)


    -- self.groupItem = autoItem.new()
    -- self:addChild(self.groupItem)
    -- self.groupItem:setPosition(67+190,123)

    self.autoUseItemArr = {} --自动使用技能item字典
    self.singleItemArr = {} --使用单体技能item字典
    self.groupItemArr = {} --使用群体技能item字典
    
    self.singleVO = nil
    self.groupVO = nil
    self.autoUseSkillVOList = {}
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)            
            if event.name == "began" then               
            elseif event.name == "ended" then               
                if self.selSkill then
                    self:removeChild(self.selSkill)
                    self.selSkill = nil
                end
            end
            return true
        end)

    local yyoffset = 190
    local closeTxt = display.newTTFLabel({text = "关闭",
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    closeTxt:setPosition(156-50 - 20,0+yyoffset)
    display.setLabelFilter(closeTxt)

    local openTxt = display.newTTFLabel({text = "开启",
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    openTxt:setPosition(156+50+20,0+yyoffset)
    display.setLabelFilter(openTxt)

    local selbg = display.newScale9Sprite("#com_switchBg.png", 0, 0, cc.size(100, 22),cc.rect(18, 18,1, 1))
    self:addChild(selbg)
    selbg:setPosition(156,0+yyoffset)
    selbg:setTouchEnabled(true)
    selbg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then         
        elseif event.name == "ended" then
            if GlobalController.skill.autoGroupSkillSwitch then
                GameNet:sendMsgToSocket(12008,{type = 0})--"0关 1开  其他获取开关"
            else
                 GameNet:sendMsgToSocket(12008,{type = 1})
            end
        end
        return true
    end)

    self.selBtn = display.newSprite("#com_switchBtn.png")
    selbg:addChild(self.selBtn)
    self:updateAutoGroupSwitch()

end


function SkillAutoView:updateAutoGroupSwitch()

    if GlobalController.skill.autoGroupSkillSwitch then
        self.selBtn:setPosition(88,11)
    else
        self.selBtn:setPosition(12,11)
    end
end

function SkillAutoView:update()
    self.singleVO = nil
    self.groupVO = nil
    self.autoUseSkillVOList = {}

    local singleVOArr = {}
    local groupVOArr = {}

    local sourcelist = RoleManager:getInstance():getSkillArr()
    for i=1,#sourcelist do
        local vo = sourcelist[i]
        if vo.lv > 0 then
            if vo.conf.autoType == 1 then
                if vo.autoSet == 1 then
                    self.singleVO = vo
                end
                table.insert(singleVOArr,vo)
            elseif vo.conf.autoType == 2 then
                if vo.autoSet == 1 then
                    self.groupVO = vo
                end
                table.insert(groupVOArr,vo)
            elseif vo.conf.autoType == 3 or vo.conf.autoType == 4 then
                table.insert(self.autoUseSkillVOList,vo)
            end
        end
    end

    -- self.singleItem:setSkillVO(self.singleVO)
    -- self.groupItem:setSkillVO(self.groupVO)


    local listItem = require("app.modules.skill.view.SkillQuickListItem")
    local item 
    local ii = 0
    for k,v in pairs(singleVOArr) do
        item = self.singleItemArr[v.id]
        ii = ii +1
        if item == nil then
            item = listItem.new(v)
            self:addChild(item)
            self.singleItemArr[v.id] = item
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                elseif event.name == "ended" then
                    if  v.autoSet == 0 then
                        GlobalMessage:show("选择了"..v.conf.name.."作为单体技能")
                        GameNet:sendMsgToSocket(12007,{skill_id = v.id,switch = 1})
                    end
                end
                return true
            end)
        end
        item:setPosition(86*ii - 38+4,327)
        if v.autoSet == 1 then
            item:setSelect(true)
        else
            item:setSelect(false)
        end
    end
    ii=0
    for k,v in pairs(groupVOArr) do
        item = self.groupItemArr[v.id]
        ii = ii +1
        if item == nil then
            item = listItem.new(v)
            self:addChild(item)
            self.groupItemArr[v.id] = item
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                elseif event.name == "ended" then
                    if  v.autoSet == 0 then
                        GlobalMessage:show("选择了"..v.conf.name.."作为群体技能")
                        GameNet:sendMsgToSocket(12007,{skill_id = v.id,switch = 1})
                    end
                end
                return true
            end)
        end
        item:setPosition(86*ii - 38+4,117)
        if v.autoSet == 1 then
            item:setSelect(true)
        else
            item:setSelect(false)
        end
    end

    -- local listItem = require("app.modules.skill.view.SkillQuickListItem")
    -- item = listItem.new(skillList[i])
    --         self.listItemArr[vo.id] = item
    --         self:addChild(item)
    --         item:setTouchEnabled(true)
    --         item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --             if event.name == "began" then
    --               if self.isClearSetting then
    --                   return true
    --               end
    --               if self.selItem == nil then
    --                 self.selItem = listItem.new(item:getSkillVO())
    --                 self:addChild(self.selItem)
    --                 self.selItem:setPosition(self:convertToNodeSpace(cc.p(event.x, event.y)))
    --               end
    --                 elseif event.name == "moved" then
    --                   if self.selItem then
    --                     self.selItem:setPosition(self:convertToNodeSpace(cc.p(event.x, event.y)))
    --                   end
    --                 elseif event.name == "ended" then
    --                   if self.selItem then
    --                     self:removeChild(self.selItem)
    --                     self.selItem = nil

    --                     local pos = self:convertToNodeSpace(cc.p(event.x, event.y))
    --                     for k,v in pairs(self.useItemArr) do
    --                       local xx,yy = v:getPosition()
    --                       if FightUtil:getDistance(xx,yy,pos.x,pos.y) < 30 then
    --                           local vvo = item:getSkillVO()
    --                           if vvo.posKey > 0 then
    --                               GlobalMessage:show("该技能已添加快捷键")
    --                           else
    --                               v:setSkillVO(item:getSkillVO(),true)
    --                           end
    --                           return true
    --                       end
    --                     end
    --                   end
    --             end
    --             return true
    --         end)
    --     end

    --左边技能列表
    if self.itemListView == nil then
        self.itemListView = cc.ui.UIListView.new {
            viewRect = cc.rect(15, 15, 400, 446),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            }
            --scrollbarImgV = "bar.png"}
            --:onTouch(handler(self, self.touchListener))
            :addTo(self)
        self.itemListView:setPosition(760-432-6+3,5)
    end

    self.needReload = false
    --自动释放列表
    local autoUseItem = require("app.modules.skill.view.SkillAutoUseItem")
    for i=1,#self.autoUseSkillVOList do
        local vo = self.autoUseSkillVOList[i]
        local content = self.autoUseItemArr[vo.id]
        if content == nil then
            local item = self.itemListView:newItem()
            content = autoUseItem.new(vo)
            item:addContent(content)
            item:setItemSize(400, 120)
            self.itemListView:addItem(item)
            --self:addChild(item)
            self.autoUseItemArr[vo.id] = content
            self.needReload = true
        end
        content:setAutoStates(vo)
        --content:setPosition(480,320 -(i-1)*120)
    end
    if self.needReload then
        self.itemListView:reload()
    end

    -- self.itemList = {}
    -- local skillUiItem = require("app.modules.skill.view.SkillUIItem")

    -- local skillList = RoleManager:getInstance():getSkillArr()
    -- for i=1,#skillList do
    --     local content = self.itemList[i]
    --     if content == nil then
    --         local item = self.itemListView:newItem()
    --         content = skillUiItem.new(skillList[i])
        
    --         self.itemList[i] = content
    --         item:addContent(content)
    --         item:setItemSize(333, 103)
    --         self.itemListView:addItem(item)
    --     end
    --     if i == 1 then
    --         self:onListClick(content)
    --     end
    -- end
    -- self.itemListView:reload()

end

function SkillAutoView:open()
    if self.updateSkillListEventId == nil then
        self.updateSkillListEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_SKILL_LIST,handler(self,self.update))
    end

    if self.updateAutoGroupSwitchEventId == nil then
        self.updateAutoGroupSwitchEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_AUTO_GROUP_SWITCH,handler(self,self.updateAutoGroupSwitch))
    end
    GameNet:sendMsgToSocket(12008,{type = 2})
    self:update()
end

function SkillAutoView:close()
    if self.updateSkillListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateSkillListEventId)
        self.updateSkillListEventId = nil
    end

    if self.updateAutoGroupSwitchEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateAutoGroupSwitchEventId)
        self.updateAutoGroupSwitchEventId = nil
    end
end

return SkillAutoView