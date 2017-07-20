--
-- Author: Yi hanneng
-- Date: 2016-01-19 18:20:39
--

--[[
	装备提纯


  purificationWin
allpur：全部提纯
tenpur：提纯10次
pur：提纯
goods1：放入物品框
rule：规则界面
goodsname1:放入物品名称
goods2：提纯后的物品框
goodsname2：提纯后的物品名字
number1：放入物品的数量
number2：当前拥有提纯后物品的数量

规则：
1.  只有强化材料可以提纯。
2.  每次消耗2个相同的强化材料，可以获得一个下一级纯度的材料。
3.  提出必定成功。
--]]

require("app.modules.equip.EquipManager")
local EquipComposeView = EquipComposeView or class("EquipComposeView", BaseView)

function EquipComposeView:ctor(winTag,data,winconfig)
	EquipComposeView.super.ctor(self,winTag,data,winconfig)
  local root = self:getRoot()

  self.goodsList = {}
  self.composeNum = 0
  self.formula_id = 0
	self.goods1 = self:seekNodeByName("goods1")

  	self.goods2 = self:seekNodeByName("goods2")
  	self.goodsname = self:seekNodeByName("goodsname")
 
  	self.number1 = self:seekNodeByName("number1")
  	self.number2 = self:seekNodeByName("number2")
 
  	self.rule = self:seekNodeByName("rule")
  	self.allpur = self:seekNodeByName("allpur")
    self.tenpur = self:seekNodeByName("tenpur")
    self.pur = self:seekNodeByName("pur")
    self.number1:setString("0/0")
    self.number2:setString("0")
  	
    self:addEvent()
end

function EquipComposeView:setViewInfo(data)
    data = data.data
    self.data = data
 
    if self.commonItem == nil then
        self.commonItem = CommonItemCell.new()
        self.commonItem:setData(data)
        --self.commonItem:setNameShow(true)
        self.goods1:addChild(self.commonItem, 10,10)
        --self.commonItem:setItemClickFunc(handler(self,self.onItemClick))
        self.commonItem:setPosition(self.goods1:getContentSize().width/2, self.goods1:getContentSize().height/2)
        self.commonItem:setScale(0.8)
    else
        self.commonItem:setData(data)
        --self.commonItem:setNameShow(true)
    end

    self.commonItem:setNameShow(true)
    self.commonItem:setItemClickFunc(handler(self,self.onItemClick))
    
    self.number1:setString(data.num.."/"..EquipManager:getInstance():getPurNum(data.goods_id))
    self.composeNum = math.floor(data.num/EquipManager:getInstance():getPurNum(data.goods_id))
    self.formula_id = EquipManager:getInstance():getPurKey(data.goods_id)
     
    local info = EquipManager:getInstance():getAfterPur(data.goods_id)
    
    if self.commonItem2 == nil then
        self.commonItem2 = CommonItemCell.new()
        self.commonItem2:setData({goods_id = info[1][2]})
        --self.commonItem2:setNameShow(true)
        self.goods2:addChild(self.commonItem2, 10,10)
        self.commonItem2:setPosition(self.goods2:getContentSize().width/2, self.goods2:getContentSize().height/2)
        --self.commonItem2:setScale(0.8)
    else
        self.commonItem2:setData({goods_id = info[1][2]})
        --self.commonItem2:setNameShow(true)
    end

    self.commonItem2:setNameShow(true)
    
    self.number2:setString(info[1][3])
    
end

function EquipComposeView:addEvent()

    self.goods1:setTouchEnabled(true)
    self.goods1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:goodsClick(0)
        end     
        return true
    end)

  self.rule:setTouchEnabled(true)
    self.rule:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rule:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.rule:setScale(1.0)
             GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(2),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    self.allpur:setTouchEnabled(true)
    self.allpur:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.allpur:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.allpur:setScale(1.0)
            if self.composeNum > 0 then
              GameNet:sendMsgToSocket(14035, {formula_id = self.formula_id, num = self.composeNum})
            else
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有足够的道具提纯!")
            end
        end     
        return true
    end)

    self.tenpur:setTouchEnabled(true)
    self.tenpur:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.tenpur:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.tenpur:setScale(1.0)
            if self.composeNum > 9 then
              GameNet:sendMsgToSocket(14035, {formula_id = self.formula_id, num = 10})
            else
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有足够的道具提纯!")
            end
        end     
        return true
    end)

    self.pur:setTouchEnabled(true)
    self.pur:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.pur:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.pur:setScale(1.0)
            print(self.formula_id,self.composeNum)
            if self.composeNum > 0 then
              GameNet:sendMsgToSocket(14035, {formula_id = self.formula_id, num = 1})
            else
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"没有足够的道具提纯!")
            end
   
        end     
        return true
    end)
end

function EquipComposeView:open()

  GlobalEventSystem:addEventListener(EquipEvent.SELECT_GOODS_SUCCESS,handler(self,self.setViewInfo))
  GlobalEventSystem:addEventListener(EquipEvent.COMPOSE_SUCCESS,handler(self,self.composeSuccess))
  self.goodsList = {}
  local list = BagManager:getInstance().bagInfo:getPropList()
  for i=1,#list do
    if EquipManager:getInstance():isInPurList(list[i].goods_id) then
      if not self.goodsList[list[i].goods_id] then
        self.goodsList[list[i].goods_id] = {goods_id = list[i].goods_id, num = list[i].num, id = list[i].id, is_bind = list[i].is_bind,location = list[i].location, stren_lv = list[i].stren_lv}
      else
        self.goodsList[list[i].goods_id].num = self.goodsList[list[i].goods_id].num + list[i].num
      end
    end
  end

end

function EquipComposeView:close()
  GlobalEventSystem:removeEventListener(EquipEvent.SELECT_GOODS_SUCCESS)
  GlobalEventSystem:removeEventListener(EquipEvent.COMPOSE_SUCCESS)
end

function EquipComposeView:destory()
  self:close()
  self.super.destory(self)
end

function EquipComposeView:composeSuccess()
    
    self.composeNum = 0
    self.formula_id = 0
    self.number1:setString("0/0")
    self.number2:setString("0")
    self.goodsList = {}
    local list = BagManager:getInstance().bagInfo:getPropList()
    for i=1,#list do
      if EquipManager:getInstance():isInPurList(list[i].goods_id) then
        if not self.goodsList[list[i].goods_id] then
          self.goodsList[list[i].goods_id] = {goods_id = list[i].goods_id, num = list[i].num, id = list[i].id, is_bind = list[i].is_bind,location = list[i].location, stren_lv = list[i].stren_lv}
        else
          self.goodsList[list[i].goods_id].num = self.goodsList[list[i].goods_id].num + list[i].num
        end
      end
    end

    ------------
    if self.data then
  
      local num = BagManager:getInstance():findItemCountByItemId(self.data.goods_id)
       
      if  num > 0 then
        self.data.num = num
        self:setViewInfo({data = self.data})
      else
        self:onItemClick(nil)
      end
      
    end

  end

function EquipComposeView:onItemClick(data)
  self.data = nil
  if self.goods1:getChildByTag(10) then
      self.goods1:removeChildByTag(10, true)
      self.commonItem = nil
    end
    if self.goods2:getChildByTag(10) then
      self.goods2:removeChildByTag(10, true)
      self.commonItem2 = nil
    end
    self.composeNum = 0
    self.formula_id = 0
    self.number1:setString("0/0")
    self.number2:setString("0")
end

function EquipComposeView:goodsClick(index)
  local selectItemsWin = require("app.modules.equip.view.SelectItemsWin").new({name = "选择道具",type = 2, from = index,bagEquipList = self.goodsList})
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,selectItemsWin)
end

return EquipComposeView