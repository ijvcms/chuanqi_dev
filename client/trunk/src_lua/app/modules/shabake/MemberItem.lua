--
-- Author: Your Name
-- Date: 2015-12-23 12:34:05
--

local MemberItem = MemberItem or class("MemberItem", function()
	return display.newNode()
end)
 
function MemberItem:ctor()
	display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(self, 1, 1):pos(55, 22)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(self, 2, 2):pos(157, 22)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(self, 3, 3):pos(225, 22)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(self, 4, 4):pos(299, 22)


  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(self, 5, 5):pos(381, 22)

  display.newScale9Sprite("#com_listSelFrame.png", 10, 10, cc.size(442, 38)):addTo(self, 6, 6):pos(219, 22):setVisible(false)
 
end

function MemberItem:setData(info)

	self.data = info
	self:getChildByTag(6):setVisible(false)
	if info ~= nil then
          self:getChildByTag(1):setString(info.player_name)
          self:getChildByTag(2):setString(info.lv)
          if info.career == 1000 then
            self:getChildByTag(3):setString("战士")
          elseif info.career == 2000 then
            self:getChildByTag(3):setString("法师")
          elseif info.career == 3000 then
            self:getChildByTag(3):setString("道士")
          end
          self:getChildByTag(4):setString(info.fighting)
          self:getChildByTag(5):setString(info.contribution)
          self:setTouchEnabled(true)
     else
          self:getChildByTag(1):setString("")
          self:getChildByTag(2):setString("")
          self:getChildByTag(3):setString("")
          self:getChildByTag(4):setString("")
          self:getChildByTag(5):setString("")
          self:setTouchEnabled(false)
    end

end

function MemberItem:getData()
	return self.data
end

function MemberItem:setSelect(b)
	self:getChildByTag(6):setVisible(b)
end

return MemberItem