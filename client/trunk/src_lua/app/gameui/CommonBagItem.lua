local CommonBagItem = class("CommonBagItem", function ()
	return CommonItemCell.new()
end)

function CommonBagItem:ctor()
	self.curShowPos = -1
	self.inBagPos 	= -1
end

return CommonBagItem