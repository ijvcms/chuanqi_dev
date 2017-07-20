-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 
--
local PrizeRankItem = class("PrizeRankItem", BaseView)
function PrizeRankItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/serverRankItem.ExportJson")
	self.root:setPosition(-153,-53)
	self:addChild(self.root)
    self.rank = self:seekNodeByName("rank")
    self.layer = self:seekNodeByName("layer")
    self.pic = self:seekNodeByName("pic")
    self.itemList = {}
end


function PrizeRankItem:open(datas)
    
end

function PrizeRankItem:setData(vo)
    self.vo = vo
    if self.vo.des ~= "" then
        self.rank:setString(self.vo.des)
        self.rank:setVisible(true)
    else
        self.rank:setVisible(false)
    end

    if self.vo.pic ~= "" then
        self.pic:setSpriteFrame(self.vo.pic)
        self.pic:setVisible(true)
    else
        self.pic:setVisible(false)
    end
    --self.pic:setSpriteFrame("serveActivity_coming.png")


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

    for i=1,#self.vo.goods do
    	local good = self.vo.goods[i]
    	 local item = CommonItemCell.new()
	     self.layer:addChild(item)
	     item:setData({goods_id = good[1], is_bind = good[2], num = good[3]})
	     item:setCount(good[3])
	     item:setPosition((1-i)*45+140,50)
	     self.itemList[i] = item
    end
end


function PrizeRankItem:close()
    PrizeRankItem.super.close(self)
end


--清理界面
function PrizeRankItem:destory()
	for k,v in pairs(self.itemList) do
		v:destory()
	end
	self.itemList = {}
end

return PrizeRankItem