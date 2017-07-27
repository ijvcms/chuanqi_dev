--
-- Author: Yi hanneng
-- Date: 2016-01-21 12:24:11
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local SelectItem = SelectItem or class("SelectItem", UIAsynListViewItemEx)

function SelectItem:ctor(loader, layoutFile)

    local ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(ccui)
  	self.goodsname = cc.uiloader:seekNodeByName(ccui, "goodsname")
  	self.lv = cc.uiloader:seekNodeByName(ccui, "lv")
  	self.attribute = cc.uiloader:seekNodeByName(ccui, "attribute")
  	self.selected = cc.uiloader:seekNodeByName(ccui, "selected")
  	self.Image_9 = cc.uiloader:seekNodeByName(ccui, "Image_9")
  	self.Image_24 = cc.uiloader:seekNodeByName(ccui, "Image_24")
  	self.attribute:setVisible(false)
  	self:setContentSize(cc.size(ccui:getContentSize().width, ccui:getContentSize().height))
  	self.selected:setVisible(false)
end

function SelectItem:setViewInfo(data)
  self.attribute:setVisible(false)
	local equipItem = configHelper:getEquipValidAttrByEquipId(data.goods_id)
	if data.type == 2 then
        self:setDes(configHelper:getGoodDescByGoodId(data.goods_id))
  elseif data.type == 1 then
      if equipItem[1][1] == "hp" then
      	self:setDes(self:getName(equipItem[1][1])..equipItem[1][2])
    	else
        	self:setDes(self:getName(equipItem[1][1])..equipItem[1][2].."-"..equipItem[2][2]) 
    	end
  else
      self:setDes(configHelper:getGoodDescByGoodId(data.goods_id))            
  end

	self.goodsname:setString(configHelper:getGoodNameByGoodId(data.goods_id))
	self.lv:setString("Lv."..configHelper:getGoodLVByGoodId(data.goods_id))
	local info = {goods_id =data.goods_id,is_bind = data.is_bind, stren_lv = data.stren_lv,soul = data.soul,server_id=data.server_id,is_use=data.is_use}
  if self.commonItem == nil then
      self.commonItem = CommonItemCell.new()
      self.Image_24:addChild(self.commonItem)
  end
	
	self.commonItem:setData(info)
	self.commonItem:setCount(data.num)
	self.commonItem:setTouchEnabled(false)
	self.commonItem:setPosition(self.Image_24:getContentSize().width/2, self.Image_24:getContentSize().height/2)
	--self.commonItem:setScale(0.81)

	self.Image_9:setVisible(data.location == 1)
end

function SelectItem:setDes(str)
	self.attribute:setVisible(true)
	self.attribute:setString(str)
end
 
function SelectItem:getData()
	return self.data
end

function SelectItem:setData(data)
	self.data = data
	self:setViewInfo(data)
end

function SelectItem:setSelected(b)
	if self.selected then
		self.selected:setVisible(b)
	end
end

function SelectItem:setSelect(b)
	self:setSelected(b)
end

function SelectItem:getName(str)

    if str == "min_ac" then
        return "物理攻击:"
    elseif str == "min_def" then
        return "物理防御:"
    elseif str == "min_res" then
        return "魔法防御:"
    elseif str == "hp" then
        return "生命:"
    elseif str == "min_mac" then
        return "魔法攻击:"
    elseif str == "min_sc" then
        return "道术攻击:"
    end

end

return SelectItem