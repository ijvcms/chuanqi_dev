--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-08 16:19:53
--

local TabFlag = import(".TabFlag")
local TabButton = class("TabButton", TabFlag)

function TabButton:ctor(tab, flag, selectSkinName)
	TabButton.super.ctor(self, flag)
	assert(tab ~= nil, "TabButton::ctor - tab can't be nil!!")
	self._tab  = tab
	self._selectSkinName = selectSkinName or "state_selected"
	self:initialization()
end

function TabButton:initialization()
	self._handler = nil
	self._selectedSkin = cc.uiloader:seekNodeByName(self._tab, self._selectSkinName)

	self._tab:setTouchEnabled(true)
	self._tab:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if "ended" == event.name then
			if self._handler then
				self._handler(self)
			end
		end
		return true
	end)
end

function TabButton:Select()
	self._selectedSkin:setVisible(true)
end

function TabButton:UnSelect()
	self._selectedSkin:setVisible(false)
end

function TabButton:SetOnSelectedHandler(handler)
	self._handler = handler
end

--
-- 标识匹配
--
function TabButton:Match()
	self:Select()
end

--
-- 标识不匹配
--
function TabButton:UnMatch()
	self:UnSelect()
end

return TabButton