--
-- Author: Yi hanneng
-- Date: 2016-01-19 18:17:47
--
--[[
    装备分解
--]]
require("app.modules.equip.EquipManager")
local PageManager = require("app.modules.bag.view.PageManager")
local EquipDecomposeView = EquipDecomposeView or class("EquipDecomposeView", BaseView)

function EquipDecomposeView:ctor(winTag,data,winconfig)
	EquipDecomposeView.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
   self.decomposeList = {}
   self.equipList = {}
   self.goodsList = {}
 
    self.leftLay = self:seekNodeByName("leftLay")

   self.common = self:seekNodeByName("common")
   self.equiptips = self:seekNodeByName("equiptips")
   self.btnsolve = self:seekNodeByName("btnsolve")
   self.btnbatchsolve = self:seekNodeByName("btnbatchsolve"):setVisible(false)
 
    self.equiptips:setVisible(false)

    self:initBag()
    self:addEvent()

end

function EquipDecomposeView:initBag()
 
  self.equipList = {}
  local bodyEquipList = RoleManager:getInstance().roleInfo.equip
  local bagEquipList = BagManager:getInstance().bagInfo:getEquipList()

  --身上的装备不可以分解
  --过滤不可分解装备
  --[[
  for i=1,#bodyEquipList do
      if EquipManager:getInstance():canDecompose(bodyEquipList[i]) then
        self.equipList[#self.equipList + 1] = bodyEquipList[i]
      end
  end
  --]]
  for j=1,#bagEquipList do
      if EquipManager:getInstance():canDecompose(bagEquipList[j]) then
        self.equipList[#self.equipList + 1] = bagEquipList[j]
      end
  end

  local pageManager = PageManager.new(self.leftLay, 5, 48,{colum = 5,rows = 4,pageWidth = 480,pageHeight = 440,pageOfNum = 5,pageCapacity = 20}) --492 488
    pageManager:SetOnItemsSelectedHandler(function(event)
        local data       = event.data
        local isSelected = event.isSelected
        self:onStoreItemClick(data, isSelected)
    end)
    self.pageManager = pageManager
 
    self.pageManager:SetPageItemsData(self.equipList)
    self.pageManager:SetItemsSelectVisible(true)
    self.pageManager:ResetItemsSelectState()
end
 
function EquipDecomposeView:addEvent()

  self.btnsolve:setTouchEnabled(true)
    self.btnsolve:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnsolve:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnsolve:setScale(1.0)
            if #self.decomposeList > 0 then
                local has = false
                for i=1, #self.goodsList do
                    dump(configHelper:getGoodQualityByGoodId(self.goodsList[i]))
                    if configHelper:getGoodQualityByGoodId(self.goodsList[i]) > 3 then
                        has = true
                        break
                    end
                end

                if has then
                    local function save()
                       GameNet:sendMsgToSocket(14037, {goods_list = self.decomposeList})
                    end
 
                    GlobalMessage:alert({
                        enterTxt = "分解",
                        backTxt= "取消",
                        tipTxt = "分解列表内有珍贵道具，是否分解？",
                        enterFun = handler(self, save),
                        tipShowMid = true,
                    })
                 
                else
                    GameNet:sendMsgToSocket(14037, {goods_list = self.decomposeList})
                end
                
            else
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请选择装备!")
            end
        end     
        return true
    end)
end

function EquipDecomposeView:onStoreItemClick(itemData, isSelected)

   if isSelected then
      table.insert(self.decomposeList,itemData.id)
      table.insert(self.goodsList,itemData.goods_id)

      local goodType = configHelper:getGoodTypeByGoodId(itemData.goods_id)
      if not goodType then return end
      self.equiptips:setVisible(true)
      self.common:setVisible(false)
      self:setViewInfo(itemData)
    else

      for i=1,#self.decomposeList do
        if itemData.id == self.decomposeList[i] then
          table.remove(self.decomposeList,i)
          break
        end
      end

      for i=1,#self.goodsList do
        if itemData.goods_id == self.goodsList[i] then
          table.remove(self.goodsList,i)
          break
        end
      end

    end

    if #self.decomposeList == 0 then
      self.equiptips:setVisible(false)
      self.common:setVisible(true)
    end
 

end

function EquipDecomposeView:setViewInfo(data)

 
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.data = data

    --标题部分
    --装备名
    local labName = cc.uiloader:seekNodeByName(self.equiptips, "labName")
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    if data.stren_lv >0 then
        labName:setString(equipName.."+"..data.stren_lv)
    else
        labName:setString(equipName)
    end
    local quality = configHelper:getGoodQualityByGoodId(data.goods_id)
    if quality then
        local color
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
            color = TextColor.TEXT_R
        end 
        if color then
            labName:setTextColor(color)
        end
    end

    --装备等级
    local labLevel
    local equipLevel = configHelper:getGoodLVByGoodId(data.goods_id)
    if equipLevel>roleInfo.lv then
        labLevel = cc.uiloader:seekNodeByName(self.equiptips, "labLevel1")
        labLevel:setString("LV."..(equipLevel or 0))
        labLevel:setVisible(true)
        cc.uiloader:seekNodeByName(self.equiptips, "labLevel"):setVisible(false)
    else
        labLevel = cc.uiloader:seekNodeByName(self.equiptips, "labLevel")
        labLevel:setString("LV."..(equipLevel or 0))
        labLevel:setVisible(true)
        cc.uiloader:seekNodeByName(self.equiptips, "labLevel1"):setVisible(false)
    end

    --是否绑定
    local labBind = cc.uiloader:seekNodeByName(self.equiptips, "labBind")
    labBind:setVisible((data.is_bind==1) or false)

    --调整位置
    local x1 = labName:getContentSize().width + labName:getPositionX()
    
    labLevel:setPositionX(x1+10)
    local x2 = x1 + 10 + labLevel:getContentSize().width
    labBind:setPositionX(x2+10) 

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    commonItem:setItemClickFunc(handler(self,function()end))
    local itemBg = cc.uiloader:seekNodeByName(self.equiptips, "itemBg")
    commonItem:setTag(10)
    if self.equiptips:getChildByTag(10) then
        self.equiptips:removeChildByTag(10, true)
    end
    self.equiptips:addChild(commonItem,10,10)
    commonItem:setPosition(itemBg:getPositionX(),itemBg:getPositionY())
    --类型
    local labTypeValue = cc.uiloader:seekNodeByName(self.equiptips, "labTypeValue")
    local eType = configHelper:getEquipTypeByEquipId(data.goods_id)
    labTypeValue:setString(eType or "")

    --职业
    local labCareerValue = cc.uiloader:seekNodeByName(self.equiptips, "labCareerValue")
    local eType,eId = configHelper:getEquipCareerByEquipId(data.goods_id)
    if eId ~= roleInfo.career then
        labCareerValue:setColor(TextColor.TEXT_R)
    else
        labCareerValue:setColor(cc.c3b(23,7,8))
    end
    labCareerValue:setString(eType or "")

    --评分
    local labScoreValue = cc.uiloader:seekNodeByName(self.equiptips, "labScoreValue")
    labScoreValue:setString(data.fighting)

    --基础属性部分
    local validAttr = configHelper:getEquipValidAttrByEquipId(data.goods_id)
    local showAttr = EquipUtil.showBaseAttrFormat(validAttr)
    for i=1,#showAttr do
        local labAttrName = cc.uiloader:seekNodeByName(self.equiptips,"labAttr"..i)
        if labAttrName then
            labAttrName:setVisible(true)
            labAttrName:setString(showAttr[i][1]..":")
        end
        local labAttrValue = cc.uiloader:seekNodeByName(self.equiptips,"labAttrValue"..i)
        if labAttrValue then
            labAttrValue:setVisible(true)
            local str
            if showAttr[i].max then
                str = showAttr[i].min.."-"..showAttr[i].max
                if data.stren_lv > 0 then
                    --local plus = configHelper:getStengPlusStrengLv(data.stren_lv)
                    --local plusMin = math.floor(plus*showAttr[i].min)
                    --local plusMax = math.floor(plus*showAttr[i].max)
                    str = str.." + ("..showAttr[i].min.."-"..showAttr[i].max..")"
                end
            else
                str = showAttr[i].min
                if data.stren_lv > 0 then
                    --local plus = configHelper:getStengPlusStrengLv(data.stren_lv)
                    --local plusMin = math.floor(plus*showAttr[i].min)
                    str = str.." + ("..showAttr[i].min..")"
                end
            end
            labAttrValue:setString(str)
        end
    end
    if #showAttr <3 then
        for i=#showAttr+1,3 do
            local labAttrName = cc.uiloader:seekNodeByName(self.equiptips,"labAttr"..i)
            labAttrName:setVisible(false)
            local labAttrValue = cc.uiloader:seekNodeByName(self.equiptips,"labAttrValue"..i)
            labAttrValue:setVisible(false)
        end
    end

    local attrScroll = cc.uiloader:seekNodeByName(self.equiptips,"attrScroll")
    attrScroll:getScrollNode():removeAllChildren()
    self.proPerList = require("app.modules.tips.view.EquipProperList").new()
    self.proPerList:setViewInfo(data)
    attrScroll:getScrollNode():addChild(self.proPerList)
    self.proPerList:setPositionY( - self.proPerList:getContentSize().height)
    
    attrScroll:scrollAuto()
    
    --箭头
    local arrow1 = cc.uiloader:seekNodeByName(self.equiptips,"arrow1")
    arrow1:setVisible(false)
    local arrow2 = cc.uiloader:seekNodeByName(self.equiptips,"arrow2")
    arrow2:setVisible(false)
    --如果是可穿戴的本职业的装备,并且评分高于身上的装备,则装备显示提升的小箭头
    local careerName,career = configHelper:getEquipCareerByEquipId(data.goods_id)
    if career == roleInfo.career and data.location==0 then
        -- if configHelper:getGoodLVByGoodId(data.goods_id) <= roleInfo.lv then
            local showIncArrow = false
            local showRedArrow = false
            local etName,etid = configHelper:getEquipTypeByEquipId(data.goods_id)
            local fighting = data.fighting
            if etid == 7 then                           --判断戒指佩戴情况
                local left = false
                local right = false
                local leftItem
                local rightItem 
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == 7 then
                        left = true
                        leftItem = roleInfo.equip[i]
                    elseif roleInfo.equip[i].grid == 12 then
                        right = true
                        rightItem = roleInfo.equip[i]
                    end
                end
                if left and not right then              --右边没有佩戴戒指
                    showIncArrow = true
                elseif not left and right then          --左边没有佩戴戒指
                    showIncArrow = true
                elseif left and right then              --两边都佩戴了戒指
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showIncArrow = true
                    elseif fighting < math.min(leftItem.fighting,rightItem.fighting) then
                        showRedArrow = true
                    end
                else                                    --两边都没佩戴戒指
                    showIncArrow = true
                end
            elseif etid == 6 then                       --判断手镯佩戴情况
                local left = false
                local right = false
                local leftItem
                local rightItem 
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == 6 then
                        left = true
                        leftItem = roleInfo.equip[i]
                    elseif roleInfo.equip[i].grid == 11 then
                        right = true
                        rightItem = roleInfo.equip[i]
                    end
                end
                if left and not right then              --右边没有佩戴手镯
                    showIncArrow = true
                elseif not left and right then          --左边没有佩戴手镯
                    showIncArrow = true
                elseif left and right then              --两边都佩戴了手镯
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showIncArrow = true
                    elseif fighting < math.min(leftItem.fighting,rightItem.fighting) then
                        showRedArrow = true
                    end
                else                                    --两边都没佩戴手镯
                    showIncArrow = true
                end
            else                                        --其余部位的装备
                local findItem = false
                local eqItem
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == etid then
                        findItem = true
                        eqItem = roleInfo.equip[i] 
                        break
                    end
                end
                if findItem then                        --身上有穿戴这个部位的装备,则需要根据身上装备的评分来判断
                    if fighting>eqItem.fighting then
                        showIncArrow = true
                    elseif fighting<eqItem.fighting then
                        showRedArrow = true
                    end
                else                                    --身上没有穿戴这个部位的装备
                    showIncArrow = true
                end
            end

            if showIncArrow then
                arrow1:setVisible(true)
            end

            if showRedArrow then
                arrow2:setVisible(true)
            end
        -- end
    end
end

function EquipDecomposeView:open()
 
  GlobalEventSystem:addEventListener(EquipEvent.DECOMPOSE_SUCCESS,handler(self,self.decomposeSuccess))
 
end

function EquipDecomposeView:close()
  GlobalEventSystem:removeEventListener(EquipEvent.DECOMPOSE_SUCCESS)
end

function EquipDecomposeView:destory()
    self:close()
    EquipDecomposeView.super.destory(self)
end

function EquipDecomposeView:decomposeSuccess()
  self.decomposeList = {}
  self.goodsList = {}
  self.equiptips:setVisible(false)
  self.common:setVisible(true)
  self:initBag()
end

return EquipDecomposeView