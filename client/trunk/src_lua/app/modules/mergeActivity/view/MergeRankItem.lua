-- 合服战力条目

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local MergeRankItem = class("MergeRankItem", UIAsynListViewItemEx)

function MergeRankItem:ctor(loader, layoutFile)
	self.root = loader:BuildNodesByCache(layoutFile)
	self:addChild(self.root)
	self:setContentSize(self.root:getContentSize())
	self:initComponents()
end

function MergeRankItem:initComponents()
    self.rank = cc.uiloader:seekNodeByName(self.root, "rank")
    self.content = cc.uiloader:seekNodeByName(self.root, "mainLayer")
    local size = self.content:getContentSize()
    local offset = 0
    for i = 1, 3 do
    	local item = CommonItemCell.new()
    	item:setTouchSwallowEnabled(false)
    	item:setPosition(100 * (i - 1) + 39, size.height / 2.0)
    	item:setContentSize(78, 78)
    	self["item"..i] = item
    	self.content:addChild(item)
    end
   
end

function MergeRankItem:invalidateData()
	self.rank:setString("第"..self.data.rank.."名")
	local idx = 1
	local goods = self.data.goods
	while idx <= #goods do
		local item =  self["item"..idx]
        item:setData({goods_id = goods[idx][1]})
        item:setLock(goods[idx][2] == 1)
        item:setCount(goods[idx][3])
        item:setVisible(true)
        idx = idx + 1
	end
	while idx <= 3 do
		self["item"..idx]:setVisible(false)
		idx = idx + 1
	end
end


function MergeRankItem:setData(data)
	self.data = data
	self:invalidateData()
end

function MergeRankItem:getData()
	return self.data
end


return MergeRankItem
