--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-02 18:00:31
-- 导航按钮

local NavigationBtn = class("NavigationBtn", function()
	return display.newNode()
end)

function NavigationBtn.create(param)
	return NavigationBtn.new(param)
end


function NavigationBtn:ctor(param)
	self.win = param.win
	-- self.bg = "#scene/scene_menuBtnBg.png"
	-- self.selBg = "#scene/scene_menuBtnBg.png"
	self.wname = param.name
	self.icon = param.icon
	self.data = param.data
	self.isSelect = false
	-- self.bgSpr = display.newSprite(self.bg)
	-- self:addChild(self.bgSpr)
	-- self.bgSelSpr = display.newSprite(self.selBg)
	-- self:addChild(self.bgSelSpr)
	self.iconSpr = display.newSprite(self.icon)
	self:addChild(self.iconSpr)

	-- self.nameLab = display.newTTFLabel({size = 18, color = cc.c3b(255, 254, 255), text =self.wname})
 --            :align(display.CENTER)
 --            :addTo(self)
 --    self.nameLab:setPosition(0,0)


	-- self.txtSpr = display.newSprite(self.name)
	-- self:addChild(self.txtSpr)
	-- self.txtSpr:setPosition(0,-26)
	-- self:setSelect(self.isSelect)
	self:setNodeEventEnabled(true)
end

function NavigationBtn:onEnter()
	self:setupGuide()
end

function NavigationBtn:onCleanup()
	self:clearGuide()
end

function NavigationBtn:setSelect(isSelect)
	self.isSelect = isSelect
	-- if self.isSelect then
	-- 	self.bgSpr:setVisible(false)
	-- 	self.bgSelSpr:setVisible(true)
	-- else
	-- 	self.bgSpr:setVisible(true)
	-- 	self.bgSelSpr:setVisible(false)
	-- end
end

function NavigationBtn:setConfig(config) self._config = config end
function NavigationBtn:getConfig() return self._config end

function NavigationBtn:getSelect()
	return self.isSelect
end

-----------------------------------------------------------------------------
-- START---------------------------------------------------------------------
-- MARK GUIDE DEMAND SETUP & CLEAR
function NavigationBtn:setupGuide()
	if self.guideHandle then return end

	-- 处理这个动态引导需求。
	-- 此引导需求用于反馈这个物品在世界坐标系中的位置以及大小。
	self.guideHandle = GlobalController.guide:addDemandEventListener(function(event)
		local demandEvent = event.data
		local guideMark = demandEvent:getGuideMark()

        if guideMark:isDynamic() then
        	local omt_type = guideMark:getOptionType()

        	-- 这里，动态需求类型判断，只有为这个类型的才进行处理。
            if omt_type == GUIMR.OMT_AUTO_CLICK_NAV and  guideMark:isIntrestedIn(self.win) then
            	local itemParent = self:getParent()
	            if itemParent then
	            	event:stop()
	            	demandEvent:processed()

	            	-- get item rect box in world space
	            	local worldPoint = itemParent:convertToWorldSpace(cc.p(self:getPosition()))
					local rect = cc.rect(worldPoint.x - 32, worldPoint.y - 32, 64, 64)
					local notifyEvent = GlobalController.guide:createEventWithDemandBack(guideMark:getMark())
					notifyEvent:setData(rect)
					GlobalController.guide:notifyEvent(notifyEvent)
	            end
            end
        end
    end)
end

function NavigationBtn:clearGuide()
	if self.guideHandle then
		GlobalController.guide:removeDemandEventByHandle(self.guideHandle)
		self.guideHandle = nil
	end
end
-- END OF GUIDE ---------------------------------------------------------------

return NavigationBtn