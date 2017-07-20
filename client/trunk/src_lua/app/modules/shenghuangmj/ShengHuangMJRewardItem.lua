-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 神皇密境
--
local ShengHuangMJRewardItem = class("ShengHuangMJRewardItem", BaseView)
function ShengHuangMJRewardItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/shenhuangExchangeItem.ExportJson")
	self:addChild(self.root)
    self.lvLab = self:seekNodeByName("Lv")
    self.name = self:seekNodeByName("name")
    self.itemBg = self:seekNodeByName("itemBg")
    self.numLabel = self:seekNodeByName("numLabel")
    self.exchangeBtn = self:seekNodeByName("exchangeBtn")
    self.exchangeBtn:setTouchEnabled(true)
    self.exchangeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.exchangeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.exchangeBtn:setScale(1)
            --print("EXCHANG",self.vo.id)
            GameNet:sendMsgToSocket(35006,{id = self.vo.id})
        end
        return true
    end)
    self.isCancelRemoveSpriteFrams = true

end


function ShengHuangMJRewardItem:open(datas)
    
end

function ShengHuangMJRewardItem:setData(vo)
    self.vo = vo
    self.lvLab:setString("LV"..self.vo.lv)
    self.numLabel:setString(self.vo.point)
    local goods = self.vo.goods[1]
    local itemName = configHelper:getGoodNameByGoodId(goods[1])
    self.name:setString(itemName)
    local quality = configHelper:getGoodQualityByGoodId(goods[1])
    local color
    if quality then
        
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
            self.name:setTextColor(color)
        end
    end

    self.item = CommonItemCell.new()
    self.itemBg:addChild(self.item)
    self.item:setData({goods_id = goods[1], is_bind = goods[2], num = goods[3]})
    self.item:setCount(goods[3])
    self.item:setPosition(40,40)
end


function ShengHuangMJRewardItem:close()
    
    ShengHuangMJRewardItem.super.close(self)
end


--清理界面
function ShengHuangMJRewardItem:destory()
    if self.item then
        self.item:destory()
        self.item = nil
    end
    self.super.destory(self)
end

return ShengHuangMJRewardItem