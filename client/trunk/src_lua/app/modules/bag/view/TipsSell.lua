

TipsSell = TipsSell or class("TipsSell",function()
	return cc.uiloader:load("resui/tt_sell.ExportJson")
end)

--构造
function TipsSell:ctor()	
	local root = cc.uiloader:seekNodeByName(self, "root")
    root:setTouchEnabled(false)
    root:setTouchSwallowEnabled(false)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    self.value = cc.uiloader:seekNodeByName(win, "labValue")

    self.btnCancel = cc.uiloader:seekNodeByName(win, "btnCancel")
    local btn = self.btnCancel
    btn:setTouchEnabled(true)
    btn:onButtonPressed(function ()
        btn:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btn:onButtonRelease(function()
        btn:setScale(1.0)
    end)
    btn:onButtonClicked(function ()
        btn:setScale(1.0)
        self:onCancel()
    end)

    self.btnSure = cc.uiloader:seekNodeByName(win, "btnSure")
    local btn = self.btnSure
	btn:setTouchEnabled(true)
    btn:onButtonPressed(function ()
        btn:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btn:onButtonRelease(function()
        btn:setScale(1.0)
    end)
    btn:onButtonClicked(function ()
        btn:setScale(1.0)
        self:onSure()
    end)

    self:reset()
end

function TipsSell:setValue(v)
	self.value:setString("本次出售可以获得铜钱:"..v)
end

function TipsSell:reset()
	self.sellItems = {}
	self.sellValue = 0
	self:setValue(self.sellValue)
end

function TipsSell:addSellItem(item)
	if self:isAddedItem(item) then return end
	table.insert(self.sellItems,item)
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	local sale = configHelper:getGoodSaleByGoodId(item.goods_id)*item.num
	self.sellValue = self.sellValue + sale
	self:setValue(self.sellValue)
end

function TipsSell:removeSellItem(item)
	if self:findItem(item) then
		local pos = self:findItem(item)
		table.remove(self.sellItems,pos)
		-- local configHelper = import("app.utils.ConfigHelper").getInstance()
		local sale = configHelper:getGoodSaleByGoodId(item.goods_id)*item.num
		self.sellValue = self.sellValue - sale
		self:setValue(self.sellValue)
	end
end

function TipsSell:isAddedItem(item)
	for i=1,#self.sellItems do
		if item.id == self.sellItems[i].id then
			return true
		end
	end
	return false
end

function TipsSell:findItem(item)
	for i=1,#self.sellItems do
		if item.id == self.sellItems[i].id then
			return i
		end
	end
	return nil
end

function TipsSell:onSure( )
	local id_list = {

	}
	for i=1,#self.sellItems do
		id_list[i] = self.sellItems[i].id
	end
	GameNet:sendMsgToSocket(14005, {goods_list = id_list})
	self.sellItems = {}
	GlobalEventSystem:dispatchEvent(BagEvent.SEND_SELL)
	self:reset()
end

function TipsSell:onCancel( )
	GlobalEventSystem:dispatchEvent(BagEvent.CANCEL_SELL)
end