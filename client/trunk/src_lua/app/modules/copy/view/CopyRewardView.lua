--
-- Author: Your Name
-- Date: 2015-12-15 15:02:39
--
local CopyRewardView = CopyRewardView or class("CopyRewardView", BaseView)

function CopyRewardView:ctor(winTag,data,winconfig)

    CopyRewardView.super.ctor(self, winTag,data,winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    --self.bg:setPosition(display.cx, display.cy)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)


  	self.data = data or {}

	local ccui = cc.uiloader:load("resui/copyReward_1.ExportJson")
  	self:addChild(ccui)
    
  local root = cc.uiloader:seekNodeByName(ccui, "root")
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
    end)

  self.itemLayer = cc.uiloader:seekNodeByName(ccui, "item")
  self.itemLayer:setScale(1)

end

function CopyRewardView:setViewInfo(data)
    self.scene_id = data.scene_id
    data = data.goodsList or {}

    local w = 0
    local w1 = 0
    for i=1,#data do
      local item = self:createRewardItem(data[i])
      self.itemLayer:addChild(item)
      w1 = item:getContentSize().width
      item:setPosition((w1 + 50)*i, 0)
      w = w + w1 + 50
    end

    w = w + w1/2 + 50

    self.itemLayer:setPositionX(-w/2 + display.cx)

end

function CopyRewardView:onCloseClick( )
  if self:getParent() then
    --self:setVisible(false)
    self:removeSelfSafety()
    --Guild 
    GlobalController.guide:getTriggerManager():tryTrigger(TriggerType.INSTANCE_FINISH, {
        scene_id = self.scene_id
    })
  end
end

function CopyRewardView:createRewardItem(data)

    local node = display.newNode()
    local nameLbl = display.newTTFLabel({
      text = configHelper:getGoodNameByGoodId(data.goodsId),
      size = 20,
      color = TextColor.TEXT_W
    })
 
    local commonItem = CommonItemCell.new()
    commonItem:setData({goods_id = data.goodsId})
    commonItem:setCount(data.goodsNum)
    node:addChild(commonItem)
    node:addChild(nameLbl)
    node:setContentSize(cc.size(commonItem:getBoundingBox().width, commonItem:getBoundingBox().height + 40))
    nameLbl:setPosition(commonItem:getBoundingBox().x , commonItem:getPositionY() - commonItem:getBoundingBox().height/2 - 20)

    return node

end

return CopyRewardView