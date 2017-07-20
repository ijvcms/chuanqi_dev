--
-- 行会主窗口
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 17:50:50
--

local GuildListPage    = import(".GuildListPage")
local GuildOperatePage = import(".GuildOperatePage")
local CorpsListPage    = import(".CorpsListPage")
local CorpsOperatePage = import(".CorpsOperatePage")

local GuildWin = class("GuildWin", BaseView)

function GuildWin:ctor(winTag, data, winconfig)
	GuildWin.super.ctor(self, winTag, data, winconfig)
	self.data = data
	local root = self:getRoot()
    self.win = cc.uiloader:seekNodeByName(root, "win")
	self:initialization()
end

function GuildWin:initialization()
	self:initComponents()
end

function GuildWin:initComponents()
    self.tabGuild = cc.uiloader:seekNodeByName(self.win, "tagUnion")
    BaseTipsBtn.new(BtnTipsType.BTN_GUIDE_TAG, self.tabGuild, 120, 40)
    self.tabGuild:setTouchEnabled(true)
    self.tabGuild:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.tabGuildLabel:setColor(cc.c3b(231, 211, 173))
            self.tabCorpsLabel:setColor(cc.c3b(203, 165, 115))
            self.tabGuildSel:setVisible(true)
            self.tabCorpsSel:setVisible(false)
            self.guildWin:setVisible(true)
            if self.corpsWin then
                self.corpsWin:setVisible(false)
            end
        end
        return true
    end)

    self.tabGuildSel = cc.uiloader:seekNodeByName(self.tabGuild, "unionSelect")


    self.tabCorps = cc.uiloader:seekNodeByName(self.win, "tagGroup")
    BaseTipsBtn.new(BtnTipsType.BTN_GROUP_TAG, self.tabCorps, 120, 40)
    self.tabCorps:setTouchEnabled(true)
    self.tabCorps:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.tabCorpsLabel:setColor(cc.c3b(231, 211, 173))
            self.tabGuildSel:setVisible(false)
            self.tabCorpsSel:setVisible(true)
            if not self.corpsWin then
                self:initCorpsWin()
            else
                self.corpsWin:setVisible(true)
            end
            self.guildWin:setVisible(false)
        end
        return true
    end)

    self.tabCorpsSel = cc.uiloader:seekNodeByName(self.tabCorps, "groupSelect")
	self:initGuildWin()
end

-- Copt from app/modules/social/view/SocialWin.lua
function GuildWin:initGuildWin()
    if not self.guildWin then
        self.guildWin = display.newLayer()
        self.guildWin:setTouchSwallowEnabled(false)
        self.win:addChild(self.guildWin)
    end
    
    local guildInfo = RoleManager:getInstance().guildInfo
    if tonumber(guildInfo.guild_id) == 0 then          --还没加入公会
        if self.guildOperatePage then
            self.guildOperatePage:onDestory()
            self.guildOperatePage:removeSelf()
            self.guildOperatePage = nil
        end
        --行会列表页
        self.guildListPage = GuildListPage.new()
        self.guildWin:addChild(self.guildListPage)
        --监听加入行会
        local function onJoinGuild()
            self:initGuildWin()
            GlobalEventSystem:removeEventListenerByHandle(self.joinGuildEvent)
            self.joinGuildEvent = nil
        end
        self.joinGuildEvent = GlobalEventSystem:addEventListener(GuildEvent.JOIN_GUILD,onJoinGuild)
    elseif tonumber(guildInfo.guild_id) > 0 then       --已经加入公会
        if self.guildListPage then
            self.guildListPage:removeSelf()
        end
        --行会操作页
        self.guildOperatePage = GuildOperatePage.new(self.data)
        self.guildWin:addChild(self.guildOperatePage)
        --监听离开行会
        local function onExitGuild()
            self:initGuildWin()
            if self.exitGuildEvent then
                GlobalEventSystem:removeEventListenerByHandle(self.exitGuildEvent)
                self.exitGuildEvent = nil
            end   
        end
        self.exitGuildEvent = GlobalEventSystem:addEventListener(GuildEvent.EXIT_GUILD, onExitGuild)
    end
end

function GuildWin:initCorpsWin()
    if not self.corpsWin then
        self.corpsWin = display.newLayer()
        self.corpsWin:setTouchSwallowEnabled(false)
        self.win:addChild(self.corpsWin)
    end
    local corpsInfo = RoleManager:getInstance().corpsInfo
    if tonumber(corpsInfo.legion_id) == 0 then          --还没加入军团
        if self.corpsOperatePage then
            self.corpsOperatePage:onDestory()
            self.corpsOperatePage:removeSelf()
            self.corpsOperatePage = nil
        end
        --军团列表页
        self.corpsListPage = CorpsListPage.new()
        self.corpsWin:addChild(self.corpsListPage)
        --监听加入行会
        local function onJoinCorps()
            self:initCorpsWin()
            GlobalEventSystem:removeEventListenerByHandle(self.joinCorpsEvent)
            self.joinCorpsEvent = nil
        end
        self.joinCorpsEvent = GlobalEventSystem:addEventListener(CorpsEvent.JOIN_CORPS, onJoinCorps)
    elseif tonumber(corpsInfo.legion_id) > 0 then       --已经加入军团
        if self.corpsListPage then
            self.corpsListPage:removeSelf()
        end
        --军团操作页
        self.corpsOperatePage = CorpsOperatePage.new(self.data)
        self.corpsWin:addChild(self.corpsOperatePage)
        --监听离开行会
        local function onExitCorps()
            self:initCorpsWin()
            if self.exitCoprsEvent then
                GlobalEventSystem:removeEventListenerByHandle(self.exitCoprsEvent)
                self.exitCoprsEvent = nil
            end   
        end
        self.exitCoprsEvent = GlobalEventSystem:addEventListener(CorpsEvent.EXIT_CORPS, onExitCorps)
    end
end

--关闭按钮回调
function GuildWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)
end

--打开界面
function GuildWin:open()
end

--关闭界面
function GuildWin:close()
end

--清理界面
function GuildWin:destory()
    if self.guildOperatePage then
        self.guildOperatePage:onDestory()
    end

    if self.corpsOperatePage then
        self.corpsOperatePage:onDestory()
    end

    if self.joinGuildEvent then
        GlobalEventSystem:removeEventListenerByHandle(self.joinGuildEvent)
        self.joinGuildEvent = nil
    end

    if self.exitGuildEvent then
        GlobalEventSystem:removeEventListenerByHandle(self.exitGuildEvent)
        self.exitGuildEvent = nil
    end

    if self.joinCorpsEvent then
        GlobalEventSystem:removeEventListenerByHandle(self.joinCorpsEvent)
        self.joinCorpsEvent = nil
    end

    if self.exitCorpsEvent then
        GlobalEventSystem:removeEventListenerByHandle(self.exitCorpsEvent)
        self.exitCorpsEvent = nil
    end

    self.super.destory(self)
end

return GuildWin