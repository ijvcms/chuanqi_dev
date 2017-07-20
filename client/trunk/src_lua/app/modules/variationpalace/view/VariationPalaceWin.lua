local VariationPalaceWin = class("VariationPalaceWin",require("app.modules.common.bonusjump.view.SimpleBonusJumpWin"))

VariationPalaceWin.SimpleBonusJumpPresenter = require("app.modules.variationpalace.presenter.VariationPalacePresenter")

function VariationPalaceWin:createModel()
	local conf = configHelper:getDarkHouseGoods(14)  --这里只是个Demo
	local dropList = nil
	if conf then
		dropList = conf.drop_list
	end
	local model = self.SimpleBonusJumpModel.new(winTag,data,winconfig,dropList)
	return model
end

return VariationPalaceWin