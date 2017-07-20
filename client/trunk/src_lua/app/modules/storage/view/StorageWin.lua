--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-11-30 15:11:50
--

local StorageAdapter        = import(".StorageAdapter")
local GoodsAccessDialog = import(".GoodsAccessDialog")

local StorageWin  = class("StorageWin", BaseView)
local PageManager = class("PageManager")

function StorageWin:ctor(winTag, data, winconfig)
	StorageWin.super.ctor(self, winTag, data, winconfig)
	self:initialization()
end

function StorageWin:initialization()
	self:initComponents()
	self:initListeners()

	self:refreshStorage()
	self:refreshUserBag()
end

function StorageWin:initComponents()
	local win = cc.uiloader:seekNodeByName(self:getRoot(), "win")
	-- INIT PAGE
	local userBagLayer = cc.uiloader:seekNodeByName(win, "layer_userBag")
	local storageLayer = cc.uiloader:seekNodeByName(win, "layer_storage")

	self.storagePM = PageManager.new(storageLayer)
	self.storagePM:SetOnItemsSelectedHandler(handler(self, self.onStorageItemSelected))

	self.userBagPM = PageManager.new(userBagLayer)
	self.userBagPM:SetOnItemsSelectedHandler(handler(self, self.onUserBagItemSelected))

	self.storageCapacity = cc.uiloader:seekNodeByName(storageLayer, "lbl_capacity")
	self.userBagCapacity = cc.uiloader:seekNodeByName(userBagLayer, "lbl_capacity")
end

function StorageWin:initListeners()
	local handles = {}
	-- 仓库数据更改
	handles[1] = GlobalEventSystem:addEventListener(StorageEvent.DATA_CHANGED, handler(self, self.onStorageDataChanged))

	-- 背包数据更改
	handles[2] = GlobalEventSystem:addEventListener(BagEvent.EQUIP_CHANGE, handler(self, self.onUserBagDataChanged))
	handles[3] = GlobalEventSystem:addEventListener(BagEvent.PROP_CHANGE, handler(self, self.onUserBagDataChanged))
	self._eventHandles = handles
end

function StorageWin:refreshStorage()
	GlobalController.storage:RefreshStorageGoodsList()
end

function StorageWin:refreshUserBag()
	self:onUserBagDataChanged()
end

function StorageWin:onStorageItemSelected(event)
	local data = event.data
	local dialog = GoodsAccessDialog.new()
	dialog:SetAccessType(GoodsAccessDialog.ACCESS_TYPE_TAKE)
	dialog:setTakeFunc(handler(GlobalController.storage, GlobalController.storage.Take))
	dialog:SetDialogData(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
end

function StorageWin:onUserBagItemSelected(event)
	local data = event.data
	local dialog = GoodsAccessDialog.new()
	dialog:SetAccessType(GoodsAccessDialog.ACCESS_TYPE_SAVE)
	dialog:setSaveFunc(handler(GlobalController.storage, GlobalController.storage.Save))
	dialog:SetDialogData(data)
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
end

function StorageWin:onStorageDataChanged(event)
	local storageData     = GlobalController.storage:GetStorageItems()
	local storageCapacity = GlobalController.storage:GetStorageCapacity()

	self.storagePM:SetPageItemsData(storageData)
	self.storageCapacity:setString(string.format("%d/%d", #storageData, storageCapacity))
end

function StorageWin:onUserBagDataChanged(event)
	local userBagData     = BagManager:getInstance().bagInfo:getTotalList()
	local userBagCapacity = RoleManager:getInstance().roleInfo.bag

	self.userBagPM:SetPageItemsData(userBagData)
	self.userBagCapacity:setString(string.format("%d/%d", #userBagData, userBagCapacity))
end

function StorageWin:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

--打开界面
function StorageWin:open()
	self.super.open(self)
end

--关闭界面
function StorageWin:close()
	self.super.close(self)
end

--清理界面
function StorageWin:destory()
	self:removeAllEvents()
	self.storagePM:Destroy()
	self.userBagPM:Destroy()
	self.super.destory(self)
end

-- ============================================================================================ PageManager Imp
function PageManager:ctor(pageParent)
	self._parent = pageParent
	self:initialization()
end

function PageManager:initialization()
	local adapter = StorageAdapter.new({pageCapacity = 20})
	local pager   = ViewPager.new({x = 5, y = 40, height = 390, width = 420})
	local pagerMarker = PageMarker.create(5)
	pager:addEventListener(ViewPager.PAGE_CHANGED, handler(self, self.onPageChanged))
	pager:SetAdapter(adapter)
	pagerMarker:setPosition(240, 40)
	pager:setPosition(0,20)

	self._parent:addChild(pager)
	self._parent:addChild(pagerMarker)

	self.adapter = adapter
	self.pager   = pager
	self.pagerMarker = pagerMarker
end

function PageManager:onPageChanged(event)
	local index = event.currentIndex
	self.pagerMarker:SetMarkIndex(index)
end

function PageManager:SetPageItemsData(data)
	self.adapter:SetBagItems(data)
end

function PageManager:SetOnItemsSelectedHandler(handler)
	self.adapter:addEventListener(StorageAdapter.ON_SELECTED_ITEM, handler)
end

function PageManager:Destroy()
	self.adapter:Destroy()
end

return StorageWin