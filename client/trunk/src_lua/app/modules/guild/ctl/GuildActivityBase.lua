--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-22 16:49:19
--
local GuildActivityBase = class("GuildActivityBase")

local CURRENT_MODULE_NAME = ...

GuildActivityBase.ACT_BOSS     = 1
GuildActivityBase.ACT_GUILD_FB = 2
GuildActivityBase.ACT_SBK_FB   = 3

local HANDLER_REGISTER = {
	[GuildActivityBase.ACT_BOSS]     = ".GuildActivity_Boss",
	[GuildActivityBase.ACT_GUILD_FB] = ".GuildActivity_GuildFB",
	[GuildActivityBase.ACT_SBK_FB]   = ".GuildActivity_SBKFB",
}

--
-- Factory Method
--
function GuildActivityBase.create(actvity_config)

	local activityId = actvity_config.id
	local handlerName = HANDLER_REGISTER[activityId]
	
	if handlerName then
		return import(handlerName, CURRENT_MODULE_NAME).new(actvity_config)
	end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////

function GuildActivityBase:ctor(actvity_config)
	self._activity_conifg = actvity_config
	self:initialization()

	self:registerGlobalEventHandler(SceneEvent.SCENE_CHANG, function()
		-- 当场景切换的时候关闭。
		self:onDeath()
	end)
end

--
-- Virtual override init.
--
function GuildActivityBase:initialization()
end

--
-- Virtual override when run.
--
function GuildActivityBase:onRun()
end

--
-- Virtual override when death.
--
function GuildActivityBase:onDeath()
	self:removeAllEvents()
end

--
-- Get this data of activity config.
--
function GuildActivityBase:getActivityConfig()
	return self._activity_conifg
end

--
-- 注册全局事件监听。
--
function GuildActivityBase:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function GuildActivityBase:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

return GuildActivityBase