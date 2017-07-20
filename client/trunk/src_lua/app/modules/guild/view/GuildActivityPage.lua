--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-21 17:13:26
--
local GuildBasePage     = import(".GuildBasePage")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local GuildActivityPage = class("GuildActivityPage", GuildBasePage)
local ListItem = class("ListItem", function()
	return display.newNode()
end)

local ITEM_LAYOUT_FILE = "resui/activityListWin.ExportJson"

function GuildActivityPage:ctor()
	self:initialization()
end

function GuildActivityPage:initialization()
	local loader = GameUILoaderUtils.new()
	self.loader = loader
	self.loader:AddUIEditorCache(ITEM_LAYOUT_FILE)

	self:initComponents()
	self:loadActivityList()
end

function GuildActivityPage:initComponents()
	self:setPosition(190, 127-55+32)
	-- 滑动列表
	local listView = cc.ui.UIListView.new({
		viewRect = cc.rect(0, 0, 650, 400-26),
		direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	})
	listView:setPosition(23, 8)
	self:addChild(listView)

	self.listView = listView
end

function GuildActivityPage:loadActivityList()
	self.listView:removeAllItems()
	local activityList = configHelper:getGuildActivityList()
	for _, config in ipairs(activityList) do
		if config.isopen == 1 then
			local newLayoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
			local listContent = ListItem.new(newLayoutNode)
	        local itemSize = newLayoutNode:getContentSize()
	        listContent:setItemData(config)
	        listContent:setOnEnterClickHandler(handler(self, self.onItemEnterHandler))

	        local item = self.listView:newItem()
	        item:addContent(listContent)
	        item:setItemSize(itemSize.width, itemSize.height + 10)
	        self.listView:addItem(item)
		end
	end

	self.listView:reload()
end

function GuildActivityPage:onItemEnterHandler(config)
	GlobalController.guild:openActivity(config)
end


function GuildActivityPage:onShow()
	
end

function GuildActivityPage:onHide()
end

function GuildActivityPage:onDestory()
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end
end

-- ============================================================================================ Class ListItem imp
function ListItem:ctor(root)
	self._root = root
	self:initialization()
end

function ListItem:initialization()
	self:initComponents()
end

function ListItem:initComponents()
	local itemUI = self._root
	self:addChild(itemUI)
	self:setContentSize(itemUI:getContentSize())

	self.lbl_act_name = cc.uiloader:seekNodeByName(itemUI, "activityname")
	self.lbl_act_desc = cc.uiloader:seekNodeByName(itemUI, "activitytxt")
	self.btn_enter    = cc.uiloader:seekNodeByName(itemUI, "btnenter")

	self.btn_enter:onButtonClicked(function()
		if self._handler then
			self._handler(self:getItemData())
		end
	end)
end

function ListItem:invalidateData()
	local data = self:getItemData()
	if data then
		self.lbl_act_name:setString(data.name)
		if data.id == 1 then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_BOSS,self.btn_enter,104,34)
		elseif data.id == 2 then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_GUILD_MJ,self.btn_enter,104,34)
		elseif data.id == 3 then
			local dd = BaseTipsBtn.new(BtnTipsType.BTN_SBK_MJ,self.btn_enter,104,34)
		end
		self.lbl_act_desc:setString(data.desc)
	end
end

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

function ListItem:setOnEnterClickHandler(handler) self._handler = handler end

return GuildActivityPage