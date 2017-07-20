--[[--

针对 cc.Node 的扩展

]]

local c = cc
local Node = c.Node

--安全移除Node
function Node:removeSelfSafety(delay)
	if delay == nil then
		delay = 0.08
	end
    self:setVisible(false)
	GlobalTimer.performWithDelayGlobal(function(event)
		if self:getParent() then
			self:removeFromParent()
		end
    end ,delay)
end