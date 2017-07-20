--
-- Author: Yi hanneng
-- Date: 2016-01-22 18:35:11
--

--[[
vipWin_2  ：vip列表界面
vipbtn2：vip图标
selected:选择背景
vip4 ：vip等级文字显示。
--]]
local VipItem = VipItem or class("VipItem", BaseView)

function VipItem:ctor(data)
	self.data = data
	local ccui = cc.uiloader:load("resui/vipItem.ExportJson")
  	self:addChild(ccui)
  	self.bg = cc.uiloader:seekNodeByName(ccui, "itemBg")
  	self.text = cc.uiloader:seekNodeByName(ccui, "itemLabel")
  	self:setContentSize(cc.size(ccui:getContentSize().width, ccui:getContentSize().height))
 	self:setViewInfo(data)
end

function VipItem:setViewInfo(data)
	if data == nil then return end
	self.text:setString("VIP"..data.lv)
	--红点提示
  	local btnTips = BaseTipsBtn.new(31+tonumber(data.lv),self,162,36)
	 
end

function VipItem:getData()
	return self.data
end

function VipItem:setData(data)
	self.data = data
	self:setViewInfo(data)
end

function VipItem:setSelected(b)
	if b == self.selected then
		return
	end
	self.selected = b
	if self.selected then
		self.text:setColor(cc.c3b(255, 255, 255))
		self.bg:setSpriteFrame("com_labBtn31Over.png")
	else
        self.text:setColor(cc.c3b(237, 192, 45))
        self.bg:setSpriteFrame("com_labBtn31.png")
	end
end

return VipItem