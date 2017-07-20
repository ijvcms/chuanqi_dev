local VariationPalacePresenter = class("VariationPalacePresenter",require("app.modules.common.bonusjump.controller.SimpleBonusJumpPresenter"))


function VariationPalacePresenter:onEnterClick()
	local scene_id = 32122
	GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(32122)})
end


return VariationPalacePresenter