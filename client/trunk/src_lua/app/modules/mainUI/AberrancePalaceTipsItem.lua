--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-03-13 20:41:24
--
local AberrancePalaceTipsItem = class("AberrancePalaceTipsItem", BaseView)
function AberrancePalaceTipsItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/aberrancePalaceItem.ExportJson")
	self:addChild(self.root)
	self.root:setPosition(-170, -12)
    self.nameLabel = cc.uiloader:seekNodeByName(self.root,"nameLabel")
    self.stateLabel = cc.uiloader:seekNodeByName(self.root,"stateLabel")
    self.nameLabel:setString("")
    self.stateLabel:setString("")
    self.isCancelRemoveSpriteFrams = true
end

function AberrancePalaceTipsItem:open(datas)
    
end

function AberrancePalaceTipsItem:setData(vo)
	self.vo = vo
	self.nameLabel:setString(self.vo.tips)
	if self.vo.num >=2 then
		self.stateLabel:setString("(已达成)")
		self.stateLabel:setColor(cc.c3b(0, 255, 13))
	else
		self.stateLabel:setString("未达成")
		self.stateLabel:setColor(cc.c3b(235, 12, 12))
	end
	-- self.time:setString(self.vo.open_time1)
	-- self.name:setString(self.vo.name)
	-- self.state:setString(self.vo.state) --进行中 未开始
 --    self.reward:setString(self.vo.reward_txt)
	-- self:updateStates(date)
    -- self.vo = vo
    -- self.lvLab:setString("LV"..self.vo.lv)
    -- self.numLabel:setString(self.vo.point)
    -- local goods = self.vo.goods[1]
    -- local itemName = configHelper:getGoodNameByGoodId(goods[1])
    -- self.name:setString(itemName)
    -- local quality = configHelper:getGoodQualityByGoodId(goods[1])
    -- local color
    -- if quality then
        
    --     if quality == 1 then            --白
    --         color = TextColor.TEXT_W
    --     elseif quality == 2 then        --绿
    --         color = TextColor.TEXT_G
    --     elseif quality == 3 then        --蓝
    --         color = TextColor.ITEM_B
    --     elseif quality == 4 then        --紫
    --         color = TextColor.ITEM_P
    --     elseif quality == 5 then        --橙
    --         color = TextColor.TEXT_O
    --     elseif quality == 6 then        --红
    --         color = TextColor.TEXT_R
    --     end 
    --     if color then
    --         self.name:setTextColor(color)
    --     end
    -- end

    -- self.item = CommonItemCell.new()
    -- self.itemBg:addChild(self.item)
    -- self.item:setData({goods_id = goods[1], is_bind = goods[2], num = goods[3]})
    -- self.item:setCount(goods[3])
    -- self.item:setPosition(40,40)
end


function AberrancePalaceTipsItem:close()
    
    AberrancePalaceTipsItem.super.close(self)
end


--清理界面
function AberrancePalaceTipsItem:destory()
    if self.item then
        self.item:destory()
        self.itemBg:removeChild(self.item)
        self.item = nil
    end
    self.super.destory(self)
	
end

return AberrancePalaceTipsItem