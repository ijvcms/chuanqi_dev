--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-14 17:27:09
--

-- ------------------------------------------------------------------------
-- ////////////////////////////////////////////////////////////////////////
-- 排位赛模块测试，主要测试模块的功能列表以及事件派发验证。


local QualifyingTest = class("QualifyingTest")

function QualifyingTest:ctor()
end

function QualifyingTest:markFlag(flag, success)
	local flags = self._flags or {}
	flags[flag] = success or false
	self._flags = flags
end

function QualifyingTest:checkFlag(flag)
	if self._flags[flag] then
		return true
	end
	return false
end

function QualifyingTest:checkFlags(delay)
	-- 没有标志就没有测试内容，直接返回。
	if not self._flags then return end
	local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
	scheduler.performWithDelayGlobal(function()
		for k, _ in pairs(self._flags) do
			if not self:checkFlag(k) then
				printError("===================================================[QualifyingTest Test Failed!!!]" )
				dump(self._flags)
				return
			end
		end
		printInfo("===================================================[QualifyingTest Test pass !]")
	end, delay or 5)
end

--
-- 注册全局事件监听。
--
function QualifyingTest:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function QualifyingTest:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

function QualifyingTest:setUp()
	-- 获取我在排位赛中的排名
	self:registerGlobalEventHandler(QualifyingEvent.RANK_OF_QUALIFYING, function()
		self:markFlag("RefreshMyRank", true)
	end)

	-- 获取我当前的挑战次数
	self:registerGlobalEventHandler(QualifyingEvent.COUNT_OF_CHALLENGE, function()
		self:markFlag("RefreshChallengeCount", true)
	end)

	-- 获取挑战列表
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_CHALLENGE, function()
		if self:checkFlag("RefreshChallengeList") then
			self:markFlag("ReloadChallengeList", true)
		else
			self:markFlag("RefreshChallengeList", true)
		end
		dump(GlobalController.qualifying:GetChallengeList())
	end)

	-- 获取总排行
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_TOTAL_RANK, function()
		self:markFlag("RefreshTotalRankList", true)
		dump(GlobalController.qualifying:GetTotalRankList())
	end)

	-- 获取我的挑战记录列表
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_RECORD, function()
		self:markFlag("RefreshRecordList", true)
	end)

	-- 获取排位赛声望
	self:registerGlobalEventHandler(QualifyingEvent.VALUE_OF_FAME, function()
		self:markFlag("RefreshFame", true)
	end)

	self:markFlag("RefreshMyRank")
	self:markFlag("RefreshChallengeCount")
	self:markFlag("RefreshChallengeList")
	self:markFlag("RefreshTotalRankList")
	self:markFlag("RefreshRecordList")
	self:markFlag("RefreshFame")
	self:markFlag("ReloadChallengeList")

	GlobalController.qualifying:RefreshMyRank()
	GlobalController.qualifying:RefreshChallengeCount()
	GlobalController.qualifying:RefreshChallengeList()
	GlobalController.qualifying:RefreshTotalRankList()
	GlobalController.qualifying:RefreshRecordList()
	GlobalController.qualifying:RefreshFame()
	GlobalController.qualifying:ReloadChallengeList()
end

function QualifyingTest:Test()
	self:setUp()
	self:checkFlags()
end

return QualifyingTest