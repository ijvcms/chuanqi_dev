--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-04-30 00:22:25
-- 任务面板
local TaskUI = TaskUI or class("TaskUI", function() return display.newNode() end )

function TaskUI:ctor()
	self.isOpen = true -- true:为打开 false:隐藏
	self:init()
	self:open()
end

function TaskUI:init()
	self.curTabType = 0
	self.bgSize = cc.size(228, 124)
	local btnW = 91
	local btnH = 36
	self.taskBtn =  display.newSprite("#scene/scene_tabBtn.png")--98 38
	self.taskBtn:setTouchEnabled(true)
	self:addChild(self.taskBtn)
	self.taskBtn:setPosition(btnW/2, self.bgSize.height + btnH/2-3)
	
	local taskTxt =  display.newSprite("#scene/scene_txtRenwu.png")
	taskTxt:setTouchEnabled(false)
	self.taskBtn:addChild(taskTxt)
	taskTxt:setPosition(btnW/2, btnH/2)

	-- display.newTTFLabel({
 --        text = "任 务",
 --        size = 18,
 --        color = cc.c3b(255, 222, 176),
 --        -- align = cc.TEXT_ALIGNMENT_LEFT,
 --        -- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
 --    }):addTo(self.taskBtn):pos(btnW/2, 38/2)


    -- local taskTxt = display.newBMFontLabel({
    --         text = "任 务",
    --         font = "fonts/bitmapText_22.fnt",
    --         })
    -- taskTxt:setTouchEnabled(false)
    -- self.taskBtn:addChild(taskTxt)
   	-- taskTxt:setPosition(btnW/2, 38/2)
    -- taskTxt:setAnchorPoint(0.5,0.5)
    -- taskTxt:setColor(cc.c3b(255, 222, 176))
    -- taskTxt:setScale(1.2)



    self.teamBtn =  display.newSprite("#scene/scene_tabBtn.png")
	self.teamBtn:setTouchEnabled(true)
	self:addChild(self.teamBtn)
	self.teamBtn:setPosition(btnW/2+btnW, self.bgSize.height + btnH/2-3)

	local teamTxt =  display.newSprite("#scene/scene_txtZudui.png")
	teamTxt:setTouchEnabled(false)
	self.teamBtn:addChild(teamTxt)
	teamTxt:setPosition(btnW/2, btnH/2)

	-- display.newTTFLabel({
 --        text = "组 队",
 --        size = 18,
 --        color = cc.c3b(255, 222, 176),
 --    }):addTo(self.teamBtn):pos(btnW/2, btnH/2)

    -- local teamTxt = display.newBMFontLabel({
    --         text = "组 队",
    --         font = "fonts/bitmapText_22.fnt",
    --         })
    -- teamTxt:setTouchEnabled(false)
    -- self.teamBtn:addChild(teamTxt)
   	-- teamTxt:setPosition(btnW/2, btnH/2)
    -- teamTxt:setAnchorPoint(0.5,0.5)
    -- teamTxt:setColor(cc.c3b(255, 222, 176))
    -- teamTxt:setScale(1.2)

     --隐藏按钮
	self.hideBtn = display.newSprite("#scene/scene_taskMinBtn.png")
	self.hideBtn:setTouchEnabled(true)
	self:addChild(self.hideBtn)
	self.hideBtn:setPosition(btnW+btnW+23, self.bgSize.height + btnH/2-3)

    self.bg = display.newSprite("#scene/scene_taskBg.png")
    self.bg:setScaleX(228/32)
	self.bg:setTouchEnabled(false)
	self:addChild(self.bg)
	self.bg:setPosition(self.bgSize.width/2,self.bgSize.height/2)


	self.clickTeamNum = 0
	self.layer = display.newNode():addTo(self)
 
 
	self.taskBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
        	if GameSceneModel.isInterService then
				GlobalMessage:show("跨服中，不能使用该功能")
				return true
			end
     		self:onTabBtnClick(1)
        end
        return true
    end)

    self.teamBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
        	self:onTabBtnClick(2)
        end
        return true
    end)

	self.hideBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
             if self.isOpen then
             	self.hideBtn:setScale(1)
             	self:onShowMin()	
             else
             	self.hideBtn:setScale(-1)
             	self:onShowMax()
			 
             end
        end
        return true
    end)

	--显示隐藏位置
	self.maxPoint = 0
	self.minPoint = 0-btnW*2

	self:initContent()

	self:onTabBtnClick(1)
end

function TaskUI:open()
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_HIDE)
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_SHOW)
	GlobalEventSystem:addEventListener(TaskEvent.NAV_HIDE,handler(self,self.hide))
	GlobalEventSystem:addEventListener(TaskEvent.NAV_SHOW,handler(self,self.show))
end

function TaskUI:close()
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_HIDE)
	GlobalEventSystem:removeEventListener(TaskEvent.NAV_SHOW)
	if self.taskNav then
		self.taskNav:close()
	end
	if self.team then
		self.team:close()
	end
end

--tab选项框按钮
function TaskUI:onTabBtnClick(ttype)
	if ttype == 1 and self.curTabType ~= ttype then
		self.curTabType = ttype
		self.taskBtn:setSpriteFrame("scene/scene_tabBtnSel.png")
		self.teamBtn:setSpriteFrame("scene/scene_tabBtn.png")
		self.taskNav:setVisible(true)
		self.team:setVisible(false)
		self.clickTeamNum = 0
	elseif ttype == 2 and self.curTabType ~= ttype then
		self.curTabType = ttype
		self.taskBtn:setSpriteFrame("scene/scene_tabBtn.png")
		self.teamBtn:setSpriteFrame("scene/scene_tabBtnSel.png")
 		self.taskNav:setVisible(false)
		self.team:setVisible(true)
		if  tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 and self.clickTeamNum > 0 then
			GlobalWinManger:openWin(WinName.TEAMWIN)
		end
		self.clickTeamNum = self.clickTeamNum + 1
	elseif ttype == 3 then
	end
end

function TaskUI:initContent()
	if self.taskNav == nil then
		self.taskNav = require("app.modules.dailyTask.view.TaskNavView").new(self.bgSize.width,self.bgSize.height-8)
		self.layer:addChild(self.taskNav)
		self.taskNav:setPosition(0,4)
	end
	if self.team == nil then
		self.team = require("app.modules.team.view.TeamNavView").new(self.bgSize.width,self.bgSize.height-8)
		self.layer:addChild(self.team)
		self.team:setPosition(0,4)
		self.team:setVisible(false)
	end
end

function TaskUI:showTeamView()
	if self.team then
		self:onTabBtnClick(2)
	end
end

function TaskUI:hide()
	if self and self:getParent() then
		self:setVisible(false)
	end

end
function TaskUI:show()
	if self and self:getParent() then
		self:setVisible(true)
	end
end

function TaskUI:onShowMax()
	if self and self:getParent() then
		self.teamBtn:setVisible(true)
		self.taskBtn:setVisible(true)
		self.bg:setVisible(true)
		self.layer:setVisible(true)
		local action = cc.MoveTo:create(0.1, cc.p(self.maxPoint, self:getPositionY()))					
		local action3 = cc.CallFunc:create(function()
			self.hideBtn:setScaleX(1)
			self.isOpen = true 
		end)     
		self:stopAllActions()  
		self:runAction(transition.sequence({action,action3}))
	end
end
function TaskUI:onShowMin()
	if self and self:getParent() then
		local action = cc.MoveTo:create(0.1, cc.p(self.minPoint, self:getPositionY()))	
	    local action2 = cc.CallFunc:create(function() 
		    self.hideBtn:setScaleX(-1)
		    self.teamBtn:setVisible(false)
			self.taskBtn:setVisible(false)
			self.bg:setVisible(false)
	 		self.layer:setVisible(false)
		    self.isOpen = false
	    end)       
	     self:stopAllActions()
		self:runAction(transition.sequence({action,action2}))
	end
end

return TaskUI