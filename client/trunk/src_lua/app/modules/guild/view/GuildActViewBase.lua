--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 17:17:36
--
local GuildActViewBase = class("GuildActViewBase", function()
	return display.newNode()
end)

function GuildActViewBase:ctor(guild_activity)
	self._activity = guild_activity
	self:initialization()
end

--
-- Virtual override 覆写此方法初始化。
--
function GuildActViewBase:initialization()
end

--
-- 获取活动控制器。
--
function GuildActViewBase:getGuildActivity()
	return self._activity
end

--
-- 添加一个黑色的透明遮罩当做底层，值得注意的是你得先在添加内容之后调用此方法。
-- @param closeAsClick 是否在点击黑色遮罩层的时候调用关闭方法。
--
function GuildActViewBase:addBlockMaskLayer(closeAsClick)
	closeAsClick = closeAsClick == nil and true or closeAsClick

	local maskLayer = display.newColorLayer(cc.c4b(0,0,0,100))
	maskLayer:setContentSize(display.width, display.height)
    maskLayer:setTouchEnabled(true)
    self:addChild(maskLayer)

    if closeAsClick then
    	maskLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			if event.name == "ended" then
				self:close()
			end
			return true
		end)
    end
end

--
-- 关闭方法。
--
function GuildActViewBase:close()
	self:getGuildActivity():onDeath(true)
end

--
-- 移除方法。
--
function GuildActViewBase:remove()
	if not tolua.isnull(self) then
		self:removeSelfSafety()
	end
end

--
-- 弹出显示。
--
function GuildActViewBase:showAsPopup()
	self:removeFromParent(false)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, self)
end

return GuildActViewBase