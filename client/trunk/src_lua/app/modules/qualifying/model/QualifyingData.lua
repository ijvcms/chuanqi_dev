--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-14 17:21:09
--

local BaseArray = require("common.base.BaseArray")
local QualifyingData = class("QualifyingData")

function QualifyingData:ctor()
	self:initialization()
end

function QualifyingData:initialization()
	self._rankOfQualifying = 0
	self._countOfChallenge = 0
	self._fame = 0
	self._challengeList = BaseArray.new()
	self._totalRankList = BaseArray.new()
	self._recordList    = BaseArray.new()
end

function QualifyingData:GetQualifyingRank()
	assert(self._challengeList ~= nil, "[QualifyingData] the data has destory.")
	return self._rankOfQualifying
end

function QualifyingData:SetQualifyingRank(newRank)
	assert(self._challengeList ~= nil, "[QualifyingData] the data has destory.")
	self._rankOfQualifying = newRank
end

function QualifyingData:GetChallengeCount()
	assert(self._countOfChallenge ~= nil, "[QualifyingData] the data has destory.")
	return self._countOfChallenge
end

function QualifyingData:SetChallengeCount(newCount)
	assert(self._countOfChallenge ~= nil, "[QualifyingData] the data has destory.")
	self._countOfChallenge = newCount
end

function QualifyingData:GetFame()
	assert(self._fame ~= nil, "[QualifyingData] the data has destory.")
	return self._fame
end

function QualifyingData:SetFame(newFame)
	assert(self._fame ~= nil, "[QualifyingData] the data has destory.")
	self._fame = newFame
end


-- --------------------------------------------------------------------------
-- -------------------------------------------------------------------------- list
function QualifyingData:GetChallengeList()
	assert(self._challengeList ~= nil, "[QualifyingData] the data has destory.")
	return self._challengeList
end

function QualifyingData:GetTotalRankList()
	assert(self._totalRankList ~= nil, "[QualifyingData] the data has destory.")
	return self._totalRankList
end

function QualifyingData:GetRecordList()
	assert(self._recordList ~= nil, "[QualifyingData] the data has destory.")
	return self._recordList
end

function QualifyingData:Destory()
	self._rankOfQualifying = nil
	self._countOfChallenge = nil
	self._challengeList = nil
	self._totalRankList = nil
	self._recordList    = nil
end

return QualifyingData