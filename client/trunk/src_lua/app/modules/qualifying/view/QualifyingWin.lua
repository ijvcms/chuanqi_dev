--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-15 16:44:43
--
local QualifyingWin = class("QualifyingWin", BaseView)
local TabButton             = import("app.gameui.tab.TabButton")
local SubView_ChallengeList = import(".SubView_ChallengeList")
local SubView_TotalRankList = import(".SubView_TotalRankList")
local SubView_RecordList    = import(".SubView_RecordList")
local QualifyingRuleView    = import(".QualifyingRuleView")

QualifyingWin.TAB_CHALLENGE_LIST  = 1
QualifyingWin.TAB_TOTAL_RANK_LIST = 2
QualifyingWin.TAB_RECORD_LIST     = 3

function QualifyingWin:ctor(winTag, data, winconfig)
	QualifyingWin.super.ctor(self, winTag, data, winconfig)
	
	self:initialization()
	-- require("app.modules.qualifying.QualifyingTest").new():Test()
end

function QualifyingWin:initialization()
	self:initComponents()
	self:initListeners()
	self:invalidateRankData()
	GlobalController.qualifying:RefreshMyRank()
end

--
-- 初始化全局数据事件监听。
--
function QualifyingWin:initListeners()
	-- 获取我在排位赛中的排名
	self:registerGlobalEventHandler(QualifyingEvent.RANK_OF_QUALIFYING, function()
		self:invalidateRankData()
	end)

	-- 挑战开始的时候，要关闭本窗口。
	self:registerGlobalEventHandler(QualifyingEvent.CHALLENGE_START, function()
		GlobalWinManger:closeWin(self.winTag)
	end)
end

--
-- 初始化当前窗口的所有组件。
--
function QualifyingWin:initComponents()
	local win = cc.uiloader:seekNodeByName(self:getRoot(), "win")

	self:initLeftView(win)
	self:initTabViews(win)
end

function QualifyingWin:initLeftView(win)
	local leftView = cc.uiloader:seekNodeByName(win, "container_left")

	self:initTabButtons(leftView)
	self.lbl_myRank  = cc.uiloader:seekNodeByName(leftView, "lbl_my_rank")
	self.lbl_myFight = cc.uiloader:seekNodeByName(leftView, "lbl_fight")
	self.lbl_fame    = cc.uiloader:seekNodeByName(leftView, "lbl_fame")
	self.lbl_gold    = cc.uiloader:seekNodeByName(leftView, "lbl_gold")

	local btn_rule  = cc.uiloader:seekNodeByName(leftView, "btn_rule")
	local btn_store = cc.uiloader:seekNodeByName(leftView, "btn_store")
	btn_rule:onButtonClicked(handler(self, self.onRuleButton_clickHandler))
	btn_store:onButtonClicked(handler(self, self.onStoreButton_clickHandler))
end

--
-- 初始化三个页卡按钮。
--
function QualifyingWin:initTabButtons(win)
	self._currentTabFlag = QualifyingWin.TAB_CHALLENGE_LIST

	local tabContainer = cc.uiloader:seekNodeByName(win, "container_tabs")
	local tab_challenge_list  = cc.uiloader:seekNodeByName(tabContainer, "btn_challenge_list")
	local tab_total_rank_list = cc.uiloader:seekNodeByName(tabContainer, "btn_total_rank")
	local tab_record_list     = cc.uiloader:seekNodeByName(tabContainer, "btn_challenge_record")

	local onSelectedHandler = function(tab)
		self:SelectTabView(tab:GetTabFlag())
	end

	local tabButtons = {
		TabButton.new(tab_challenge_list,  QualifyingWin.TAB_CHALLENGE_LIST),
		TabButton.new(tab_total_rank_list, QualifyingWin.TAB_TOTAL_RANK_LIST),
		TabButton.new(tab_record_list,     QualifyingWin.TAB_RECORD_LIST),
	}

	for _, v in ipairs(tabButtons) do
		v:SetOnSelectedHandler(onSelectedHandler)
	end

	self.tabButtons = tabButtons
end

--
-- 初始化三个子视图。
--
function QualifyingWin:initTabViews(win)
	local tabContainer = cc.uiloader:seekNodeByName(win, "container_pages")
	local tab_challenge_list  = cc.uiloader:seekNodeByName(tabContainer, "container_challenge_list")
	local tab_total_rank_list = cc.uiloader:seekNodeByName(tabContainer, "container_total_rank_list")
	local tab_record_list     = cc.uiloader:seekNodeByName(tabContainer, "container_record_list")

	local tabViews = {
		SubView_ChallengeList.new(tab_challenge_list,  QualifyingWin.TAB_CHALLENGE_LIST),
		SubView_TotalRankList.new(tab_total_rank_list, QualifyingWin.TAB_TOTAL_RANK_LIST),
		SubView_RecordList.new(tab_record_list,        QualifyingWin.TAB_RECORD_LIST),
	}

	self.tabViews = tabViews
end


function QualifyingWin:onRuleButton_clickHandler()
	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, QualifyingRuleView.new())
end

function QualifyingWin:onStoreButton_clickHandler()
	GlobalWinManger:openWin(WinName.QUALIFYINGSTOREWIN)
end

--
-- 注册全局事件监听。
--
function QualifyingWin:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function QualifyingWin:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

--
-- 使之前的页卡标记为无效，并更新相应视图。
--
function QualifyingWin:invalidateTabFlag()
	print("-- Current tab flag = " .. self._currentTabFlag)

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
-- 更新排名显示。
--
function QualifyingWin:invalidateRankData()
	-- clear
	self.lbl_myRank:setString("")
	self.lbl_myFight:setString("")
	self.lbl_fame:setString("")
	self.lbl_gold:setString("")

	-- set
	local rank = GlobalController.qualifying:GetQualifyingRank()
	self.lbl_myRank:setString(rank)

	local fight = RoleManager:getInstance().roleInfo.fighting
	self.lbl_myFight:setString(fight)
	local rewardData = configHelper.getInstance():GetQualifyingRewardByRank(rank)
	if rewardData then
		self.lbl_fame:setString(rewardData.fame)
		self.lbl_gold:setString(rewardData.glod)
	end
end

--
-- 设置当前组队界面的显示子界面.
-- @param flag:
-- 		QualifyingWin.TAB_CHALLENGE_LIST
-- 		QualifyingWin.TAB_TOTAL_RANK_LIST
-- 		QualifyingWin.TAB_RECORD_LIST
--
function QualifyingWin:SelectTabView(flag)
	if flag == self._currentTabFlag then return end
	self._currentTabFlag = flag
	self:invalidateTabFlag()
	SoundManager:playClickSound()
end

--打开界面
function QualifyingWin:open()
	self.super.open(self)
end

--关闭界面
function QualifyingWin:close()
	self.super.close(self)
end

--清理界面
function QualifyingWin:destory()
	self:removeAllEvents()
	for _, v in ipairs(self.tabViews or {}) do
		v:Destory()
	end
	self.super.destory(self)
end

return QualifyingWin