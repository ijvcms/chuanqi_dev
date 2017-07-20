local SimpleBonusJumpModel = SimpleBonusJumpModel or class("SimpleBonusJumpModel")

SimpleBonusJumpModel.winTag = nil
SimpleBonusJumpModel.data = nil
SimpleBonusJumpModel.winConfig = nil

SimpleBonusJumpModel.dropList = nil

function SimpleBonusJumpModel:ctor(tag,data,config,dropList)
	self.winTag = tag
	self.data = data
	self.winConfig = config
	self.dropList = dropList
end

return SimpleBonusJumpModel