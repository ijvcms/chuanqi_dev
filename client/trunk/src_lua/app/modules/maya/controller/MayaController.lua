--
-- Author: Your Name
-- Date: 2015-12-10 17:46:59
--

require("app.modules.maya.model.MayaManager")

MayaController = MayaController or class("MayaController", BaseController)

function MayaController:ctor()
	MayaController.Instance = self
	self:initProtocal()
end

function MayaController:getInstance()
	if nil == MayaController.Instance then
		MayaController.new()
	end

	return MayaController.Instance
end

function MayaController:initProtocal()
	self:registerProtocal(11010,handler(self,self.onHandle11010))
end

function MayaController:onHandle11010(data)
	MayaManager:getInstance():setInfo(data)
end