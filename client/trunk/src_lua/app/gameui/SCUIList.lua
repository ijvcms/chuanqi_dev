--
-- Author: zhangshunqiu
-- Date: 2017-06-15 17:01:34
--
 
local SCUIList = class("SCUIList", cc.ui.UIListView)
 

function SCUIList:ctor(params)
	SCUIList.super.ctor(self, params)
 
end

function SCUIList:removeItem(listItem, bAni)
	assert(not self.bAsyncLoad, "UIListView:removeItem() - syncload not support remove")

	local itemW, itemH = listItem:getItemSize()
	self.container:removeChild(listItem)

	local pos = self:getItemPos(listItem)
	if pos then
		table.remove(self.items_, pos)
	end
 
	return self
end
 
return SCUIList
