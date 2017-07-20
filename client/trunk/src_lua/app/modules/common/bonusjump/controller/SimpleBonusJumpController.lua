SimpleBonusJumpController = SimpleBonusJumpController or class("SimpleBonusJumpController",BaseController)

SimpleBonusJumpController.instance = nil 

function SimpleBonusJumpController:getInstance()
	if not SimpleBonusJumpController.instance then
		SimpleBonusJumpController.instance = SimpleBonusJumpController.new()
	end
	return SimpleBonusJumpController.instance
end

function SimpleBonusJumpController:ctor()
	SimpleBonusJumpController.super.ctor(self)
	
end
