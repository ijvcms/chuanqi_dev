--
-- Author: Yi hanneng
-- Date: 2016-04-05 19:33:58
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local DailyTaskLeftItem =  class("DailyTaskLeftItem", UIAsynListViewItemEx)

function DailyTaskLeftItem:ctor(loader, layoutFile)

    self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()

end

function DailyTaskLeftItem:init()

	self.goalName = cc.uiloader:seekNodeByName(self.ccui, "goalName")
	self.goaldes = cc.uiloader:seekNodeByName(self.ccui, "goaldes")
	self.activenum = cc.uiloader:seekNodeByName(self.ccui, "activenum")
	self.progress = cc.uiloader:seekNodeByName(self.ccui, "progress")
	self.btngo = cc.uiloader:seekNodeByName(self.ccui, "btngo")
	self.completed = cc.uiloader:seekNodeByName(self.ccui, "completed")



end

function DailyTaskLeftItem:setData(data)

	if data == nil then
		return 
	end

	self.data = data
	self.goalName:setString(data.taskName)
    self.goaldes:setString(data.taskDes)
    self.progress:setString("("..data.hadFinish.."/"..data.neednum..")")
    self.activenum:setString("活跃＋"..data.active)

    self.progress:setPosition(self.goaldes:getPositionX() + self.goaldes:getContentSize().width, self.goaldes:getPositionY())
    self.activenum:setPosition(self.goalName:getPositionX() + self.goalName:getContentSize().width + 3, self.goalName:getPositionY())

	if data.finish == 1 then
        self.completed:setVisible(true)
        self.btngo:setVisible(false)
    else

    	self.completed:setVisible(false)
        self.btngo:setVisible(true)
    	self.btngo:setTouchEnabled( true )
    	self.btngo:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)			
              	if event.name == "began" then            	
                	self.btngo:setScale(1.1)
            	elseif event.name == "ended" then            	
                	self.btngo:setScale(1)
              
                		GlobalEventSystem:dispatchEvent(DailyTaskEvent.TASK_JUMP,{win = data.interface})
                 

            end
            return true
        end)

   end

end

function DailyTaskLeftItem:getData()
	return self.data
end

function DailyTaskLeftItem:setSelect(b)
end

return DailyTaskLeftItem