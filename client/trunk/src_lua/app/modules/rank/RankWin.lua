--排行榜主UI
--
local RankWin = RankWin or class("RankWin", BaseView)

function RankWin:ctor(winTag,data,winconfig)
	self.super.ctor(self,winTag,data,winconfig)
	self.controller = require("app.modules.rank.RankWinController").new()
    self.controller:setOnDataGetFunc(handler(self, self.onDataGet))
    local root = self:getRoot()
    self:createMenu()
    self:createListView()
    self.infoLabel = self:seekNodeByName("myInfo")
    self.infoNumLabel = self:seekNodeByName("myInfoNum")
    self.rankLabel = self:seekNodeByName("rank_info")
    self.infoNumLabel:setVisible(false)
    
    self.titles = {
         self:seekNodeByName("level_Rank_title"),
         self:seekNodeByName("power_Rank_title"),
         self:seekNodeByName("union_Rank_title")
    }
    local roleManager = RoleManager:getInstance()
    self.info ={
        {"我的等级："..roleManager.roleInfo.lv, "lv", "我的排名"},
        {"我的战力："..roleManager.roleInfo.fighting, "fight", "我的排名"},
        {"我的行会："..roleManager.guildInfo.guild_name, "guild_name", "行会排名"} 
    }
end

function RankWin:createListView()
    local rightLayer = self:seekNodeByName("rightLayer")
    local size = rightLayer:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(2, 2, size.width, size.height-55)}
    self.rankList = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.rankList:setContentSize(size)
    self.rankList:setPosition(0, 0)
    self.rankList:onTouch(handler(self, self.touchListener))

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/rankingItem.ExportJson", "app.modules.rank.RankContentItem", 20)
    self.rankList:setAdapter(self.rankListAdapter)
    self.rankListAdapter:setRequestDataFunc(handler(self,self.requestNewPageData))
    rightLayer:addChild(self.rankList)
end

--创建分类控件
function RankWin:createMenu()
	local leftLayer = self:seekNodeByName("leftLayer")
    local size = leftLayer:getContentSize()
	self.listView = require("app.gameui.CQMenuList").new(cc.rect(0,0,size.width, size.height-10),cc.ui.UIScrollView.DIRECTION_VERTICAL)
	leftLayer:addChild(self.listView)
	self.listView:setPosition(0, 4)
 
	self:setMenu()

end

--加载分类控件数据
function RankWin:setMenu()

    self.isGuild = false
	self.menuDataList = {
        {key = 32010, type = SCLIST_TYPE.SCLIST_MENU, name = "战力榜", subKey = 32010},
        {key = 32009, type = SCLIST_TYPE.SCLIST_MENU, name = "等级榜", subKey = 32009},
        {key = 32011, type = SCLIST_TYPE.SCLIST_MENU, name = "行会榜"}
    }
    self.subDatalist = {}
    local names = {"全部", "战士", "法师", "道士"}
    for i = 32009, 32010 do
    	local subMenus = {}
    	for j = 0, 3 do
    	    local subMenu = {key = j, ptype = i, type = SCLIST_TYPE.SCLIST_SUBITEM, name = names[j + 1]}
    	    table.insert(subMenus, subMenu)
        end
        self.subDatalist[i] = subMenus
    end
	self.listView:setData(self.menuDataList,self.subDatalist,require("app.modules.rank.RankMenuItem"))
	self.listView:setItemClickFunc(handler(self, self.subMenuItemClick))
	self.listView:setMenuItemClickFunc(handler(self, self.menuItemClick))
end


function RankWin:setViewInfo(key)
    self.RankKey = key - 32008
    for i = 1,3 do
        self.titles[i]:setVisible(false)
    end
    self.titles[key - 32008]:setVisible(true)
    self.infoLabel:setString(self.info[key - 32008][1])

end

function RankWin:touchListener(event)
    local listView = event.listView

    if "clicked" == event.name then
        local content = event.item:getChildByTag(11)--UIListViewItem.CONTENT_TAG
        if self.lastClickItem ~= nil then
            self.lastClickItem:setSelect(false)
        end
        if content ~= nil then
            content:setSelect(true)
            self.lastClickItem = content
            if self.isGuild == false then
        
                local node = require("app.modules.rank.RankOPList").new()
                if node then
                    node:setData(content:getData())
                    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
                end

            end
 
        end
        
    elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function RankWin:menuItemClick(item)
    local data = item:getData()
    self.lastClickItem = nil
    if data.key == 32011 then
        self.isGuild = true
        self:setViewInfo(data.key)
    	self.controller:requestData(data.key, 0, 1)
        self.rankListAdapter:clearData()
    else
        self.isGuild = false
    end
end

function RankWin:subMenuItemClick(item)
	local data = item:getData()
    self.lastClickItem = nil
	if data.ptype ~= 32011 then
        self:setViewInfo(data.ptype)
	    self.controller:requestData(data.ptype, data.key, 1)
        self.rankListAdapter:clearData()
        self.isGuild = false
    else
        self.isGuild = true
	end
end

function RankWin:onDataGet(data)
    if self.rankListAdapter:getCount() == 0 then
        self.rankListAdapter:setData(data.rank_list)
    else
        self.rankListAdapter:addData(data.rank_list)
    end
    self.infoNumLabel:setString(data[self.info[self.RankKey][2]])
    if data.rank == 0 then
        self.rankLabel:setString("未上榜")
    else
        self.rankLabel:setString(self.info[self.RankKey][3].."："..data.rank)
    end     
end

function RankWin:requestNewPageData(page)
    self.controller:requestPageData(page)
end

function RankWin:open()
    RankWin.super.open(self)
    self.listView:clickItem(1)
    self.listView:clickItem(2)
end

function RankWin:close()
  	 self.controller:clean()
end



return RankWin