--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-15 16:45:12
--

--[[
	排位赛窗口子视图
	*子视图：挑战玩家列表
]]
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local TabView           = import("app.gameui.tab.TabView")

local SubView_ChallengeList = class("SubView_ChallengeList", TabView)
local ListItem = class("ListItem", function()
	return display.newNode()
end)

local ITEM_LAYOUT_FILE = "resui/item_challenge_player.ExportJson"

--
-- 构造器
--
function SubView_ChallengeList:ctor(view, flag)
	SubView_ChallengeList.super.ctor(self, view, flag)
end

--
-- 初始化操作
--
function SubView_ChallengeList:initialization()
	SubView_ChallengeList.super.initialization(self)

	local loader = GameUILoaderUtils.new()
	self.loader = loader
	self.loader:AddUIEditorCache(ITEM_LAYOUT_FILE)

	self:initComponents()
	self:initListeners()
	GlobalController.qualifying:RefreshChallengeList()
	GlobalController.qualifying:RefreshChallengeCount()
end

--
-- 当需要此视图显示的时候将会调用此方法。
--
function SubView_ChallengeList:Show()
	SubView_ChallengeList.super.Show(self)
end

--
-- 当需要此视图隐藏的时候将会调用此方法。
--
function SubView_ChallengeList:Hide()
	SubView_ChallengeList.super.Hide(self)
end

--
-- 销毁
--
function SubView_ChallengeList:Destory()
	SubView_ChallengeList.super.Destory(self)
	self.loader:Clear()
end

--
-- 初始化组件相关显示对象。
--
function SubView_ChallengeList:initComponents()
	local root = self:GetView()

	-- 剩余次数
	self.lbl_challenge_count = cc.uiloader:seekNodeByName(root, "lbl_challenge_count")

	-- 换一批按钮
	local btn_refresh = cc.uiloader:seekNodeByName(root, "btn_refresh")
    btn_refresh:setTouchEnabled(true)
    btn_refresh:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btn_refresh:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btn_refresh:setScale(1.0)
            -- TODO 换一批挑战列表
            GlobalController.qualifying:ReloadChallengeList()
        end
        return true
    end)

    -- 列表容器
	local itemContainer = display.newNode()
	itemContainer:setPosition(14, 60)
	root:addChild(itemContainer)

	self.itemContainer = itemContainer
end

--
-- 初始化全局数据事件监听。
--
function SubView_ChallengeList:initListeners()
	-- 获取挑战列表
	self:registerGlobalEventHandler(QualifyingEvent.LIST_OF_CHALLENGE, function()
		self:invalidateChallengeList()
	end)

	-- 获取剩余挑战次数
	self:registerGlobalEventHandler(QualifyingEvent.COUNT_OF_CHALLENGE, function()
		self:invalidateChallengeCount()
	end)
end

function SubView_ChallengeList:invalidateChallengeCount()
	local count = GlobalController.qualifying:GetChallengeCount()
	self.lbl_challenge_count:setString(count)
end

function SubView_ChallengeList:invalidateChallengeList()
	-- -------------------------------------------
	local getListItem = function(cacheItems)
		local listItem = nil
		if cacheItems and #cacheItems > 0 then
			listItem = table.remove(cacheItems, #cacheItems)
		else
			local newLayoutNode = self.loader:BuildNodesByCache(ITEM_LAYOUT_FILE)
			listItem = ListItem.new(newLayoutNode)
			self.itemContainer:addChild(listItem)
		end
		return listItem
	end

	-- -------------------------------------------
	local destoryItems = function(items)
		if items and #items > 0 then
			for _, v in ipairs(items) do
				v:removeFromParent()
			end
		end
	end

	-- -------------------------------------------
	local layoutItems = function(items)
		local ITEM_V_GAP  = 5
		local ITEM_HEIGHT = 90
		local LIST_HEIGHT = 400
		local COUNT = #items

		for i = 1, COUNT do
			local posY = LIST_HEIGHT - (ITEM_HEIGHT + ITEM_V_GAP) * (i - 1) - ITEM_HEIGHT
			local listItem = items[i]

			listItem:setPositionY(posY)
		end
	end

	-- -------------------------------------------
	local buildItemsByData = function(data, cacheItems)
		local newListItems = {}
		if data then
			for _, v in ipairs(data) do
				local listItem = getListItem(cacheItems)
				listItem:setItemData(v)
				newListItems[#newListItems + 1] = listItem
			end
		end
		return newListItems
	end

	local oldListItems   = self._playerList
	local playerListData = GlobalController.qualifying:GetChallengeList()
	local newListItems   = buildItemsByData(playerListData, oldListItems)

	destoryItems(oldListItems)
	layoutItems(newListItems)
	self._playerList = newListItems
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

	self.img_avatar_border = cc.uiloader:seekNodeByName(itemUI, "img_avatar_border")
	self.lbl_player_name   = cc.uiloader:seekNodeByName(itemUI, "lbl_player_name")
	self.lbl_player_career = cc.uiloader:seekNodeByName(itemUI, "lbl_career")
	self.lbl_fight_value   = cc.uiloader:seekNodeByName(itemUI, "lbl_fight_value")
	self.lbl_rank          = cc.uiloader:seekNodeByName(itemUI, "lbl_rank")
	self.btn_challenge     = cc.uiloader:seekNodeByName(itemUI, "btn_challenge")

	self.btn_challenge:onButtonClicked(function()
		local data = self:getItemData()
		GlobalController.qualifying:ChallengePlayer(data.player_id)
	end)
end

function ListItem:invalidateData()
	local data = self:getItemData()
	if data then
		local avatar = display.newSprite(ResUtil.getRoleHead(data.career, data.sex))
		avatar:setPosition(42, 42)
		self.img_avatar_border:removeAllChildren()
		self.img_avatar_border:addChild(avatar)

		self.lbl_player_name:setString(data.name)
		self.lbl_player_career:setString(RoleCareerName[data.career])
		self.lbl_fight_value:setString(data.fight)
		self.lbl_rank:setString(data.rank)
	end
end

function ListItem:setItemData(data)
	self._data = data
	self:invalidateData()
end

function ListItem:getItemData()
	return self._data
end

return SubView_ChallengeList