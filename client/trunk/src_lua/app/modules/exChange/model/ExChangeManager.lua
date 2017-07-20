--
-- Author: Yi hanneng
-- Date: 2016-02-25 19:50:27
--

ExChangeEvent = {
	BUYVIEW_INFO = "BUYVIEW_INFO",--拍卖信息
	BUYVIEW_FEE = "BUYVIEW_FEE",--购买税
	RECEIVEVIEW_INFO = "RECEIVEVIEW_INFO",--领取物品信息
	STORAGEVIEW_INFO = "STORAGEVIEW_INFO",--货架物品信息
	SALE_UP_SUCCESS = "SALE_UP_SUCCESS",--上架成功
	RECEIVEVIEW_RECEIVE_SUCCESS = "RECEIVEVIEW_RECEIVE_SUCCESS",--领取成功
	STORAGEVIEW_DOWN_SUCCESS = "STORAGEVIEW_DOWN_SUCCESS", --下架成功
	BUY_SUCCESS = "BUY_SUCCESS", --拍卖成功
	SALE_FEE = "SALE_FEE",--获取手续费
	RECEIVE_FEE = "RECEIVE_FEE",--获取手续费
}

ExChangeManager = ExChangeManager or class("ExChangeManager", BaseManager)

function ExChangeManager:ctor()
	ExChangeManager.Instance = self
	self.buyMenuList = {}
end

function ExChangeManager:getInstance()
	if nil == ExChangeManager.Instance then
		ExChangeManager.new()
	end
	return ExChangeManager.Instance
end
--处理交易所购买菜单栏
function ExChangeManager:getMenuData()
	if #self.buyMenuList > 0 then
		return self.buyMenuList
	end
	
	local config = configHelper:getBuyMenu()

	local tem = {}
	local menu1 = {}
	local menu2 = {}
	local tem2 = {}
	for i=1,#config do

		if not tem[config[i].sort1] then
			tem[config[i].sort1] = {}
			table.insert(menu1, { type = SCLIST_TYPE.SCLIST_MENU,keyName = "sort1",key = config[i].sort1,name = config[i].name1, subKey = config[i].sort1 ,resType = 1})
			table.insert(tem[config[i].sort1], { type = SCLIST_TYPE.SCLIST_MENU,keyName = "sort1",key =  config[i].sort1,name = config[i].name1, subKey = config[i].sort1, resType = 1})
		end
			
		if not menu2[config[i].sort1] then
			menu2[config[i].sort1] = {}
		end

		if not tem2[config[i].sort2] then
			tem2[config[i].sort2] = {}
			table.insert(tem2[config[i].sort2], { type = SCLIST_TYPE.SCLIST_MENU, keyName = "sort2",key =  config[i].sort2,name = config[i].name2, subKey = config[i].sort2, resType = 2})
			table.insert(menu2[config[i].sort1], { type = SCLIST_TYPE.SCLIST_MENU,keyName = "sort2", key =  config[i].sort2,name = config[i].name2, subKey = config[i].sort2, resType = 2})
		end
 
		if not menu2[config[i].sort2] then
			menu2[config[i].sort2] = {}
		end
		table.insert(menu2[config[i].sort2], { type = SCLIST_TYPE.SCLIST_SUBITEM, keyName = "sort3",key =  config[i].sort3,name = config[i].name3, resType = 3})
		  
	end
 
	self.buyMenuList[1] = menu1
	self.buyMenuList[2] = menu2
 
	return self.buyMenuList
end

function ExChangeManager:handler33000(data)

	if data == nil then
		return 
	end
 
	GlobalEventSystem:dispatchEvent(ExChangeEvent.BUYVIEW_INFO,data)

end

function ExChangeManager:handler33002(data)

	if data == nil then
		return 
	end
 
	GlobalEventSystem:dispatchEvent(ExChangeEvent.STORAGEVIEW_INFO,data.sale_goods_list)

end

function ExChangeManager:handler33003(data)

	if data == nil then
		return 
	end
 
	GlobalEventSystem:dispatchEvent(ExChangeEvent.RECEIVEVIEW_INFO,data.sale_goods_list)

end
 
 