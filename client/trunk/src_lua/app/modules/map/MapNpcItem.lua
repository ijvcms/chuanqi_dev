--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-08 15:29:17
--
--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-15 18:15:31
--
-- 自动技能Item
local MapNpcItem = MapNpcItem or class("MapNpcItem", function()
    return display.newNode()
end)

--
-- 三种类型【NPC、传送阵、怪物点】
--
MapNpcItem.TYPE_NPC      = 1
MapNpcItem.TYPE_TRANSFER = 2
MapNpcItem.TYPE_MONSTER  = 3

--构造
function MapNpcItem:ctor()
  	self.itemBg = display.newSprite("#com_treeBtn3.png")
  	self:addChild(self.itemBg)
  	self.itemBg:setPosition(0,0)

  	local icon = display.newSprite()
  	self:addChild(icon)
  	icon:setPosition(-60,0)
    self.icon = icon

  	self.nameLab = display.newTTFLabel({text = "盟重老兵",
        size = 20})
            :align(display.CENTER,0,0)
            :addTo(self)
   	self.nameLab:setPosition(0,0)
    self.vo = nil
end

function MapNpcItem:setData(data)
  self.vo = data
	self.nameLab:setString(data.name)
end

function MapNpcItem:getData()
  return self.vo
end

function MapNpcItem:setItemType(type)
  self._itemType = type
  self:invalidateItemType()
end

function MapNpcItem:getItemType()
  return self._itemType
end

function MapNpcItem:invalidateItemType()
    if self._itemType == MapNpcItem.TYPE_NPC then
      self.icon:setSpriteFrame("map_npc.png")
    elseif self._itemType == MapNpcItem.TYPE_TRANSFER then
      self.icon:setSpriteFrame("map_road.png")
    elseif self._itemType == MapNpcItem.TYPE_MONSTER then
      self.icon:setSpriteFrame("map_monster.png")
    end
    local color
    if self._itemType == MapNpcItem.TYPE_NPC then
        color = SceneColorType.NPC
    elseif self._itemType == MapNpcItem.TYPE_TRANSFER then
        color = SceneColorType.TRANSFER
    elseif self._itemType == MapNpcItem.TYPE_MONSTER then
        color = SceneColorType.MANSTER
    else
        color = SceneColorType.NPC
    end 
    self.nameLab:setColor(color)
end

return MapNpcItem