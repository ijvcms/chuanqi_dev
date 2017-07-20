--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 14:29:56
-- 合服活动model
MergeActivityModel = MergeActivityModel or class("MergeActivityModel", BaseManager)

function MergeActivityModel:ctor()
	MergeActivityModel.Instance = self
	self.activityTypeInfo = {}

	self.activitiyTypeData ={}
end

function MergeActivityModel:getInstance()
	if MergeActivityModel.Instance == nil then
		MergeActivityModel.new()
	end
	return MergeActivityModel.Instance
end

function MergeActivityModel:setActivityTypeInfo(data)
 	self.activityTypeInfo = data
end
function MergeActivityModel:getActivityTypeInfo()
 	return self.activityTypeInfo
end

function MergeActivityModel:setActivityTypeData(typeId,data)
 	self.activitiyTypeData[typeId] = data
end

function MergeActivityModel:getActivityTypeData(typeId)
 	return self.activitiyTypeData[typeId]
end