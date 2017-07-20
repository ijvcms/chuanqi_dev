--
-- Author: Yi hanneng
-- Date: 2016-05-09 15:16:55
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local WelfareLevelItem = WelfareLevelItem or class("WelfareLevelItem", UIAsynListViewItemEx)

function WelfareLevelItem:ctor(loader, layoutFile)

	--self.ccui = cc.uiloader:load("resui/welfareLevelItem.ExportJson")
	self.ccui = loader:BuildNodesByCache(layoutFile)
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
    self:setNodeEventEnabled(true)
end


function WelfareLevelItem:onCleanup()
	self:destory()
end

function WelfareLevelItem:init()

	self.itemList = {}
	self.levelLabel = cc.uiloader:seekNodeByName(self.ccui, "levelLabel")
	self.btnGet = cc.uiloader:seekNodeByName(self.ccui, "btnGet")

	self.btnGet:setTouchEnabled(true)
	self.btnGet:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnGet:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnGet:setScale(1.0)

            if self.clickfun then
            	self.clickfun(self)
            end

         end     
        return true
    end)

     self._change_handle = GlobalEventSystem:addEventListener(WelfareEvent.CHANGE_REWARDS_STATE, function()
    	self:invalidateData()
	end)
 
end

function WelfareLevelItem:setData(data)

	if data == nil then
		return 
	end
	self.data = data
	self.levelLabel:setString(data.condition_text)
	local info = data["reward_"..RoleManager:getInstance().roleInfo.career]
	--[[
	for i=1,#info do
		local commonItem = CommonItemCell.new()
		commonItem:setData({goods_id = info[i][1],is_bind = info[i][2]})
		commonItem:setCount(data.reward[i][3])
		self.ccui:addChild(commonItem, 10, 10)
		commonItem:setPosition(i*(commonItem:getContentSize().width + 25) + 80 , commonItem:getContentSize().height/2 + 15)
	end
	--]]

	if #self.itemList > 0 then

        for i=#self.itemList,#info + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#info do
            if self.itemList[i] == nil then
                local commonItem = CommonItemCell.new()
				commonItem:setData({goods_id = info[i][1],is_bind = info[i][2]})
				commonItem:setCount(data.reward[i][3])
				self.ccui:addChild(commonItem, 10, 10)
				self.itemList[#self.itemList + 1] = commonItem
				commonItem:setPosition(i*(commonItem:getContentSize().width + 25) + 80 , commonItem:getContentSize().height/2 + 15)
            else
            	self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = info[i][1],is_bind = info[i][2]})
                self.itemList[i]:setCount(data.reward[i][3])
            end
 
        end
    else
        for i=1,#info do
			local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = info[i][1],is_bind = info[i][2]})
			commonItem:setCount(data.reward[i][3])
			self.ccui:addChild(commonItem, 10, 10)
			self.itemList[#self.itemList + 1] = commonItem
			commonItem:setPosition(i*(commonItem:getContentSize().width + 25) + 80 , commonItem:getContentSize().height/2 + 15)
		end
    end

    self:invalidateData()
 
end

function WelfareLevelItem:getData()
	return self.data
end

function WelfareLevelItem:setState(flag)

	if flag then
		self.btnGet:setButtonLabelString("领取")
		self.btnGet:setButtonEnabled(true)
	else
		self.btnGet:setButtonLabelString("已领取")
		self.btnGet:setButtonEnabled(false)
	end

end

function WelfareLevelItem:invalidateData()
	local data = self:getData()
	if data then
 
		-- 0未领取 1已领取 2 条件未达到，无法领取
 		local itemState = GlobalController.welfare:GetRewardState(data.key)
		if itemState == 0 then
			self.btnGet:setButtonEnabled(true)
			self.btnGet:setButtonLabelString("领取")
		elseif itemState == 1 then
			self.btnGet:setButtonEnabled(false)
			self.btnGet:setButtonLabelString("已领取")
		elseif itemState == 2 then
			self.btnGet:setButtonEnabled(false)
			self.btnGet:setButtonLabelString("未获得")
		end
	end
 
end

function WelfareLevelItem:setItemClick(func)

	self.clickfun = func

end

function WelfareLevelItem:destory()
	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
end

return WelfareLevelItem