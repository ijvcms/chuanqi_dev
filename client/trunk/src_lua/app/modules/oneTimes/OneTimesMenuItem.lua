--
-- Author: Yi hanneng
-- Date: 2016-09-23 12:01:40
--
--local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local OneTimesMenuItem = OneTimesMenuItem or class("OneTimesMenuItem", BaseView)
function OneTimesMenuItem:ctor()
	self.ccui = cc.uiloader:load("resui/oneTimesItem.ExportJson")
    
    --self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function OneTimesMenuItem:init()

    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "text")
    self.bg = cc.uiloader:seekNodeByName(self.ccui, "btnBg")
    self.btnSel = cc.uiloader:seekNodeByName(self.ccui, "btnSel")
    self.btnSel:setVisible(false)
end
    
function OneTimesMenuItem:setData(data)
 
	if data == nil or (data ~= nil and self.data == data) then
        return 
    end
    
    self.data = data
 
    self.nameLabel:setString(data.lv.."级福利")
 
 
end

function OneTimesMenuItem:setSelect(b)
	if b then
		self.btnSel:setVisible(true)
	else
		self.btnSel:setVisible(false)
	end
end

function OneTimesMenuItem:getData()
	return self.data
end

function OneTimesMenuItem:destory()
end

return OneTimesMenuItem