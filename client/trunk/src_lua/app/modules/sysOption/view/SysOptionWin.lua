--[[
    //////////////////////////////////////////////////////////
    [系统设置窗口]
    /////////////////////////////////////////////////////////

    ===========================================================
    创建者
    Author: casen
    Date: 2015-12-08 
    -----------------------------------------------------------

    ===========================================================
    二次重构修正
    Author: Alex mailto: liao131131@vip.qq.com
    Date: 2015-12-30 14:00:21
    -----------------------------------------------------------
]]

local DrugView     = import(".DrugView")
local AccountView  = import(".AccountView")
local PickupView   = import(".PickupView")
local EffectView   = import(".EffectView")

local SysOptionWin = class("SysOptionWin", BaseView)
local TAB_ACCOUNT = 1 -- 账号标签按钮
local TAB_DRUG    = 2 -- 自动喝药标签按钮
local TAB_PICKUP  = 3 -- 拾取设置按钮
local TAB_EFFECT  = 4 -- 游戏效果按钮

local SysOptionSubViews = {
    {class = AccountView, tabIndex = TAB_ACCOUNT, buttonName = "btnAccount"},
    {class = DrugView,    tabIndex = TAB_DRUG,    buttonName = "btnDrug"},
    {class = PickupView,  tabIndex = TAB_PICKUP,  buttonName = "btnPickup"},
    {class = EffectView,  tabIndex = TAB_EFFECT,  buttonName = "btnEffect"},
}

local ConfirmOps = {
    [TAB_DRUG]  = GUIOP.CLICK_SYS_OP_DRUG,
    [TAB_PICKUP]  = GUIOP.CLICK_SYS_OP_PICKUP,
    [TAB_EFFECT]  = GUIOP.CLICK_SYS_OP_EFFECT,
}

function SysOptionWin:ctor(winTag,data,winconfig)
    SysOptionWin.super.ctor(self,winTag,data,winconfig)
    self:creatPillar()

    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    self.win = cc.uiloader:seekNodeByName(root, "win")

    self:initTagButtons()
    self:onTagBtnClick(TAB_ACCOUNT)
end

------------------------
-- 标签按钮
function SysOptionWin:initTagButtons()
    local addTabButton = function(button, tabIndex)

        if TAB_DRUG == tabIndex then
            local dd = BaseTipsBtn.new(BtnTipsType.BIN_AUTO_DRINK,button, 8,54)
        end
        button:setTouchEnabled(true)
        button:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
            elseif event.name == "ended" then
                self:onTagBtnClick(tabIndex)
            end     
            return true
        end)

        self.tagBtns[tabIndex] = button
    end

    self.tagBtns = {}
    for _, v in ipairs(SysOptionSubViews) do
        addTabButton(cc.uiloader:seekNodeByName(self.root, v.buttonName), v.tabIndex)
    end
end

--标签按钮点击回调
function SysOptionWin:onTagBtnClick(tagBtnIndex)
    local tagButtons  = self.tagBtns
    local previousIdx = self.curTagBtnIndex

    if not tagButtons[tagBtnIndex] then return end
    if previousIdx and previousIdx == tagBtnIndex then
        return
    end
    local op = ConfirmOps[tagBtnIndex]
    if op then
        GlobalController.guide:notifyEventWithConfirm(op)
    end
    

    local setTagButtonVisible = function(button, visible)
        if button then
            local sp = button:getChildByTag(10)
            if sp then
                sp:setVisible(visible)
            end
        end
    end
    
    setTagButtonVisible(tagButtons[previousIdx], false)
    setTagButtonVisible(tagButtons[tagBtnIndex], true)

    self.curTagBtnIndex = tagBtnIndex
    self:changeShowView(tagBtnIndex)
end

--
-- 显示指定子视图
--
function SysOptionWin:changeShowView(viewIndex)
    local tabViews = self.tabViews or {}
    self.tabViews = tabViews

    -- 隐藏所有的标签页
    for _, v in pairs(tabViews) do
        v:setVisible(false)
    end

    -- 显示当前的标签页
    local currentView = tabViews[viewIndex]
    if currentView then
        currentView:setVisible(true)
    else
        local cls = nil
        for _, v in ipairs(SysOptionSubViews) do
            if viewIndex == v.tabIndex then
                cls = v.class
                break
            end
        end
        if cls then
            local container    = cc.uiloader:seekNodeByName(self.win, "bg")
            local viewInstance = cls.new()
            container:addChild(viewInstance)
            tabViews[viewIndex] = viewInstance
        end
        cls:open()
    end
end

--
-- 销毁所有的子视图
--
function SysOptionWin:destorySubViews()
    local tabViews = self.tabViews or {}
    for _, v in pairs(tabViews) do
        v:destory()
    end
end

--打开界面
function SysOptionWin:open()
    self.super.open(self)
end


--点击关闭按钮
function SysOptionWin:onClickCloseBtn()
    GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_WIN_CLOSE_BUTTON)--在关闭之前
    self.super.onClickCloseBtn(self)
end

--关闭界面
function SysOptionWin:close()
    -- 提交设置信息
    SysOptionModel:commitOptions()
    self.super.close(self)
end

--清理界面
function SysOptionWin:destory()
    self:destorySubViews()
    self.super.destory(self)
end

return SysOptionWin