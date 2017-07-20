--
-- Author: Yi hanneng
-- Date: 2016-07-19 11:46:17
--
StrategyManager = StrategyManager or class("StrategyManager", BaseManager)

function StrategyManager:ctor()
	StrategyManager.Instance = self
	self.menuList = {}
end

function StrategyManager:getInstance()
	if nil == StrategyManager.Instance then
		StrategyManager.new()
	end
	return StrategyManager.Instance
end
--新手攻略菜单栏
function StrategyManager:getMenuData()
	if #self.menuList > 0 then
		return self.menuList
	end
	
	local config = configHelper:getStrategyList()
	local tem = {}
	local menu1 = {}
	local menu2 = {}
 
	for i=1,#config do

		if not tem[config[i].sort1] then
			tem[config[i].sort1] = {}
			table.insert(menu1, { type = SCLIST_TYPE.SCLIST_MENU,keyName = "sort1",key = config[i].sort1,name = config[i].name1, subKey = config[i].sort1,resType = 1})
		end
			
		if not menu2[config[i].sort1] then
			menu2[config[i].sort1] = {}
		end
 
		table.insert(menu2[config[i].sort1], { type = SCLIST_TYPE.SCLIST_SUBITEM,keyName = "sort2", key =  config[i].sort2,name = config[i].name2, function_id = config[i].function_id, resType = 2})
	end
 
	self.menuList[1] = menu1
	self.menuList[2] = menu2
 
	return self.menuList
end