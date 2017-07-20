--
-- Author: Yi hanneng
-- Date: 2016-05-16 19:03:52
--
local EquipBaptizeItem = EquipBaptizeItem or class("EquipBaptizeItem", BaseView)

function EquipBaptizeItem:ctor()
	self.ccui = cc.uiloader:load("resui/equipNewbaptize_item.ExportJson")
  	self:addChild(self.ccui)
   	self:init()
end

function EquipBaptizeItem:init()

	self.hasNew = false

	self.attr1 = cc.uiloader:seekNodeByName(self.ccui, "attr1")
	self.attrNum1 = cc.uiloader:seekNodeByName(self.ccui, "attrNum1")
	self.lockIcon = cc.uiloader:seekNodeByName(self.ccui, "lockIcon")
	self.attr2 = cc.uiloader:seekNodeByName(self.ccui, "attr2")
	self.attrNum2 = cc.uiloader:seekNodeByName(self.ccui, "attrNum2")
	self.attr1 = cc.uiloader:seekNodeByName(self.ccui, "attr1")
 
	self.lockIcon:setTouchEnabled(true)
	self.lockIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.lockIcon:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.lockIcon:setScale(1.0)

            if self.clickfun then
            	self.clickfun(self)
            end

         end     
        return true
    end)

end
 
function EquipBaptizeItem:setData(data,color)

	if data == nil then
		return 
	end
 
	self.data = data
 
	self.attr1:setString(data.name..":")
	self.attrNum1:setString(data.min)
	self.attr1:setColor(color)
	self.attrNum1:setColor(color)

	if data.state == 1 then
		self.lockIcon:setSpriteFrame("com_picLockClose.png")
	elseif data.state == 0 then
		self.lockIcon:setSpriteFrame("com_picLockOpen.png")
	end
	self.lockIcon:setVisible(true)
end

function EquipBaptizeItem:setDes(str,color)

	if str == nil then
		return 
	end
 
	self.attr1:setString(str)
	self.attrNum1:setString("")
	self.attr1:setColor(color)
 
	self.lockIcon:setVisible(false)
end

function EquipBaptizeItem:setNewData(data,color)
 
	if data == nil then
		return 
	end

	if color == nil then
		self.attr2:setString(data.name)
		self.attrNum2:setString(data.min)
		return 
	end

	if data.name ~= "" then
		self.hasNew = true
	else
		self.hasNew = false
	end
	
	self.attr2:setString(data.name..":")
	self.attrNum2:setString(data.min)
	self.attr2:setColor(color)
	self.attrNum2:setColor(color)

	if not self.data then
		self.lockIcon:setVisible(false)
	end
	
end

function EquipBaptizeItem:getData()
	return self.data
end

function EquipBaptizeItem:setItemClick(func)

	self.clickfun = func

end

function EquipBaptizeItem:clear()

	self.attr1:setString("")
	self.attrNum1:setString("")
	self.lockIcon:setVisible(false)
end


return EquipBaptizeItem