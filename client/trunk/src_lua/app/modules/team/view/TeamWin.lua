--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-07 14:45:27
--
--[[
	组队界面
	三个子页面：
		- 我的队伍
		- 附近队伍
		- 附近玩家

	子视图继承关系：
	TabFlag.lua
	    ├─TabButton.lua
	    └─TabView.lua
	        ├─SubView_MyTeam.lua
	        ├─SubView_NearPlayer.lua
	        └─SubView_NearTeam.lua
]]
local TeamWin = class("TeamWin", BaseView)
local TabButton          = import("app.gameui.tab.TabButton")
local SubView_MyTeam     = import(".SubView_MyTeam")
local SubView_NearTeam   = import(".SubView_NearTeam")
--local SubView_NearPlayer = import(".SubView_NearPlayer")

TeamWin.TAB_MY_TEAM     = 1
TeamWin.TAB_NEAR_TEAM   = 2

function TeamWin:ctor(winTag, data, winconfig)
	TeamWin.super.ctor(self, winTag, data, winconfig)
	self:initialization()
end

function TeamWin:initialization()
	self:initComponents()
end

--
-- 初始化当前窗口的所有组件。
--
function TeamWin:initComponents()
	local root = self:getRoot()
	local win = cc.uiloader:seekNodeByName(root, "win")
	--self:initTabButtons(win)
	self:initTabViews(win)
end

--
-- 初始化三个页卡按钮。
--
function TeamWin:initTabButtons(win)
	self._currentTabFlag = TeamWin.TAB_MY_TEAM

	local tabContainer = cc.uiloader:seekNodeByName(win, "container_tabs")
	local tab_myTeam     = cc.uiloader:seekNodeByName(tabContainer, "btn_myTeam")
	local tab_nearTeam   = cc.uiloader:seekNodeByName(tabContainer, "btn_nearTeam")
	--local tab_nearPlayer = cc.uiloader:seekNodeByName(tabContainer, "btn_nearPlayer")

	local onSelectedHandler = function(tab)
		self:SelectTabView(tab:GetTabFlag())

		-- GUIDE CONFIRM
		if tab:GetTabFlag() == TeamWin.TAB_NEAR_TEAM then
			GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_NEAR_TEAM_TAG)
		end
	end

	local tabButtons = {
		TabButton.new(tab_myTeam, TeamWin.TAB_MY_TEAM),
		TabButton.new(tab_nearTeam, TeamWin.TAB_NEAR_TEAM),
		--TabButton.new(tab_nearPlayer, TeamWin.TAB_NEAR_PLAYER),
	}

	for _, v in ipairs(tabButtons) do
		v:SetOnSelectedHandler(onSelectedHandler)
	end

	self.tabButtons = tabButtons
end

--
-- 初始化三个子视图。
--
function TeamWin:initTabViews(win)
	local tabContainer = cc.uiloader:seekNodeByName(win, "container_pages")
	local tab_myTeam     = cc.uiloader:seekNodeByName(tabContainer, "container_myTeam")
	local tab_nearTeam   = cc.uiloader:seekNodeByName(tabContainer, "container_nearTeam")
	

	local tabViews = {
		SubView_MyTeam.new(tab_myTeam, TeamWin.TAB_MY_TEAM),
		SubView_NearTeam.new(tab_nearTeam, TeamWin.TAB_NEAR_TEAM),
	}

	self.tabViews = tabViews
end

--
-- 使之前的页卡标记为无效，并更新相应视图。
--
function TeamWin:invalidateTabFlag()
	local doMatch = function(matchArray)
		if not matchArray then return end
		for _, v in pairs(matchArray) do
			v:CompareFlagWithCalling(self._currentTabFlag)
		end
	end

	doMatch(self.tabButtons)
	doMatch(self.tabViews)
end

--
-- 设置当前组队界面的显示子界面.
-- @param flag:
-- 		TeamWin.TAB_MY_TEAM
-- 		TeamWin.TAB_NEAR_TEAM
-- 		TeamWin.TAB_NEAR_PLAYER
--
function TeamWin:SelectTabView(flag)
	if flag == self._currentTabFlag then return end
	self._currentTabFlag = flag
	self:invalidateTabFlag()
	SoundManager:playClickSound()
end

--打开界面
function TeamWin:open()
	self.super.open(self)

	GlobalEventSystem:addEventListener(TeamEvent.SHOW_MYTEAM,function()
		 self:SelectTabView(TeamWin.TAB_MY_TEAM)
	end)
	
	GlobalEventSystem:addEventListener(TeamEvent.SHOW_NEARTEAM,function()
		 self:SelectTabView(TeamWin.TAB_NEAR_TEAM)
		 GlobalController.team:RefreshNearTeamList()
	end)
 
	GlobalController.team:RefreshMyTeamInfo()
end
 
--关闭界面
function TeamWin:close()
	GlobalEventSystem:removeEventListener(TeamEvent.SHOW_MYTEAM)
	GlobalEventSystem:removeEventListener(TeamEvent.SHOW_NEARTEAM)
	self.super.close(self)
end

--清理界面
function TeamWin:destory()
	self:close()
	for _, v in ipairs(self.tabViews or {}) do
		v:Destory()
	end
	self.tabViews = {}
	self.super.destory(self)
end

return TeamWin