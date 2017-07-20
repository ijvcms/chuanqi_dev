--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-29 18:18:00
--
local WelfareTypeItem = class("WelfareTypeItem")

function WelfareTypeItem:ctor(root)
	self._root = root
	self:initComponent()
end

function WelfareTypeItem:getData() return self._data end
function WelfareTypeItem:setData(data)
	self._data = data
	self:invalidateData()
end

function WelfareTypeItem:initComponent()
	self.lbl_name = cc.uiloader:seekNodeByName(self._root, "welfarename")
	self.img_selected = cc.uiloader:seekNodeByName(self._root, "select")
end

function WelfareTypeItem:setSelected(enabled)
	self.img_selected:setVisible(enabled)
end


function WelfareTypeItem:invalidateData()
	self.lbl_name:setString(self._data.name)
end

return WelfareTypeItem