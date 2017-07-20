--
-- Author: casen
-- Date: 2015-09-01 
-- 主角属性窗口
local MainRoleWin = class("MainRoleWin", BaseView)

local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local SpecialRingShowerView = require("app.modules.role.view.SpecialRingShowerView")

local equipCompareWin = require("app.modules.tips.view.equipCompareWin")

-- local BagView = require("app.modules.bag.view.BagView")
local PageManager = require("app.modules.bag.view.PageManager")

-- local configHelper = import("app.utils.ConfigHelper").getInstance()

import("app.utils.EquipUtil")

function MainRoleWin:ctor(winTag,data,winconfig)
    self.initTabIndex = data.tabIndex
    MainRoleWin.super.ctor(self,winTag,data,winconfig)
    self:creatPillar()
    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")
    self.win = win
    self.equipnum = 30
    --15件装备格子
    self.itemBgs = {}
    for i=1,self.equipnum do
        -- 武器801
        -- 衣服802
        -- 头盔803
        -- 项链804
        -- 勋章805
        -- 左护腕806
        -- 右护腕811
        -- 左戒指807
        -- 右戒指812
        -- 腰带808
        -- 裤子809    
        -- 鞋子810
        -- 翅膀813
        -- 宠物814
        -- 坐骑815
        
        local itemBg = cc.uiloader:seekNodeByTag(win,800+i)
        -- itemBg:setTouchEnabled(true)
        -- itemBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --     if event.name == "began" then
        --         SoundManager:playClickSound()
        --         -- itemBg:setScale(1.2)
        --     elseif event.name == "ended" then
        --         -- itemBg:setScale(1)
        --         self:onItemBgClick(i)
        --     end     
        --     return true
        -- end)
        
        if itemBg ~= nil then
            --todo
            self.itemBgs[i] = itemBg
        end
        --table.insert(self.itemBgs,itemBg)
    end

    self.mainLayer = cc.uiloader:seekNodeByName(win,"mainLayer")
    self.normalLayer = cc.uiloader:seekNodeByName(win,"normalLayer")
    self.specialLayer = cc.uiloader:seekNodeByName(win,"specialLayer")
    self.StampLayer = cc.uiloader:seekNodeByName(win,"StampLayer")
    
    ---------------------新增特殊装备-------------------------
    --[[
    self.SPweapon = cc.uiloader:seekNodeByName(win,"SPweapon")
    self.SParmour = cc.uiloader:seekNodeByName(win,"SParmour")
    self.amulet = cc.uiloader:seekNodeByName(win,"amulet")
    self.SPring = cc.uiloader:seekNodeByName(win,"SPring")
    self.legguard = cc.uiloader:seekNodeByName(win,"legguard")
    self.shoulder = cc.uiloader:seekNodeByName(win,"shoulder")
    self.SPring2 = cc.uiloader:seekNodeByName(win,"SPring2")
    self.earring = cc.uiloader:seekNodeByName(win,"earring")
    self.hood = cc.uiloader:seekNodeByName(win,"hood")
    self.mask = cc.uiloader:seekNodeByName(win,"mask")
    --]]
    self.switchBtn = cc.uiloader:seekNodeByName(win,"switchBtn")
    self.checkBox = cc.uiloader:seekNodeByName(win,"checkBox")
    
    --普通武器  item.grid = 1 item.num = 1 item.goods_id
    --特武      item.grid = 21 item.num = 1 item.goods_id
    self.checkBox:setButtonSelected(RoleManager:getInstance().roleInfo.wing_state == 1)
    self.checkBox:onButtonStateChanged(function()
        --SysOptionModel:getOptionByDefine(DefineOptions.HIDE_SPEQUIP)
        local isSelected = self.checkBox:isButtonSelected()
        local isVisible = 0
        if isSelected then
            isVisible = 1
        end
        RoleManager:getInstance().roleInfo.wing_state = isVisible
        GameNet:sendMsgToSocket(10013,{subtype = 21,state = isVisible})
        self.imv:setWeaponId(RoleManager:getInstance().roleInfo:getWeaponResId())
        --SysOptionModel:setOptionByDefine(DefineOptions.HIDE_SPEQUIP, isSelected)
    end)

    self.specialLayer:setVisible(false)
    self.normalLayer:setVisible(true)
    self.showNormal = true

    self.switchBtn:setTouchEnabled(true)
    self.switchBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.switchBtn:setScale(1.2)
        elseif event.name == "ended" then
            self.switchBtn:setScale(1)
            if self.showNormal then
                self.showNormal = false
                self.specialLayer:setVisible(true)
                self.normalLayer:setVisible(false)
                --self.switchBtn:setSpriteFrame("#roleWin_equipBtn.png")
                self.switchBtn:setButtonImage("normal", "#roleWin_equipBtn.png")
                self.switchBtn:setButtonImage("pressed", "#roleWin_equipBtn.png")
            else
                self.showNormal = true
                self.specialLayer:setVisible(false)
                self.normalLayer:setVisible(true)
                self.switchBtn:setButtonImage("normal", "#roleWin_SPBtn.png")
                self.switchBtn:setButtonImage("pressed", "#roleWin_SPBtn.png")
            end
            self:updateCheckBoxVisibele()
            --self:onCoinClick(2)
        end     
        return true
    end)

    ---------------------新增特殊装备-------------------------

    --人物内观
    self.imv = InnerModelView.new()
    self.imv:setPosition(220+24, 275-38+53)
    self.mainLayer:addChild(self.imv,100,100)

    self.tagBtns = {}
    --属性标签按钮
    self.tagBtns[1] = cc.uiloader:seekNodeByName(root,"btn_property")
    self.tagBtns[1]:setTouchEnabled(true)
    self.tagBtns[1]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(1)
        end     
        return true
    end)
    --装备标签按钮
    self.tagBtns[2] = cc.uiloader:seekNodeByName(root,"btn_equip")
    self.tagBtns[2]:setTouchEnabled(true)
    self.tagBtns[2]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(2)
        end     
        return true
    end)
    --印记标签按钮
    self.tagBtns[3] = cc.uiloader:seekNodeByName(root,"btn_stamp")
    self.tagBtns[3]:setTouchEnabled(true)
    self.tagBtns[3]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onTagBtnClick(3)
        end     
        return true
    end)

    --坐骑标签按钮
    self.tagBtns[4] = cc.uiloader:seekNodeByName(root,"btn_mount")
    self.tagBtns[4]:setTouchEnabled(true)
    self.tagBtns[4]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            local roleManager = RoleManager:getInstance()
            local roleInfo = roleManager.roleInfo
     
            if roleInfo.rideInfo == nil  then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"50级可免费领取坐骑")
                return
            end
            self:onTagBtnClick(4)
        end     
        return true
    end)

    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_STAMP,self.tagBtns[3],8,54)
    local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_RIDE,self.tagBtns[4],8,54)

    --隐藏称号标签，其他标签位移
    --[[
    self.tagBtns[1]:setPositionX(self.tagBtns[2]:getPositionX())
    self.tagBtns[2]:setPositionX(self.tagBtns[3]:getPositionX())
    self.tagBtns[3]:setVisible(false)
    --]]

    local btnRing = cc.uiloader:seekNodeByName(self.specialLayer,"ringBtn")
    btnRing:addButtonClickedEventListener(function()
        self:showSpecialRingShowerView()
    end)

    --玩家名字
    self.roleName = cc.uiloader:seekNodeByName(win,"roleName")
    self.roleName:setString("")
    -- self.roleName:enableOutline(cc.c4b(255,0,0,100),10)

    local rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")
    self.rightLayer = rightLayer

    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onEnterView))

    --请求主角装备列表
    --GameNet:sendMsgToSocket(14020, {})--这有有问题，移除

    self:updateCheckBoxVisibele()
end

function MainRoleWin:showSpecialRingShowerView()
    local specialRingView = SpecialRingShowerView.new()
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,specialRingView)  
end


function MainRoleWin:updateCheckBoxVisibele()
    if self.curTagBtnIndex == 1 or self.curTagBtnIndex == 2 then
        if self.showNormal then
            self.checkBox:setVisible(false)
        else
            self.checkBox:setVisible(false)
            local roleManager = RoleManager:getInstance()
            if not roleManager.roleInfo  then return end
            local equipList = roleManager.roleInfo.equip
            for _,equipItem in ipairs(equipList or {}) do
                if equipItem.grid == 21 and equipItem.num >= 1 and equipItem.is_use == 1 then
                    self.checkBox:setVisible(true)
                    return
                end
            end
        end
    else
        self.checkBox:setVisible(false)
    end
end

function MainRoleWin:onEnterView(data)
    if data.name == "enterTransitionFinish" then
        --打开时选中属性标签
        self:onTagBtnClick(self.initTabIndex or 1)
        self.hadEnter = true
    end
end

--设置装备格子的装备
--itemIndex:格子索引
--equip:装备
function MainRoleWin:setEquipToItemBg(itemIndex,equip)
    if not self.itemBgs[itemIndex] then return end
    if self.itemBgs[itemIndex]:getChildByTag(10) then
        self.itemBgs[itemIndex]:removeChildByTag(10, true)
    end
    if not equip then return end

    local commonItem = CommonItemCell.new()
    commonItem:setData(equip)
    
    self.itemBgs[itemIndex]:addChild(commonItem, 10, 10)
    commonItem:setPosition(self.itemBgs[itemIndex]:getContentSize().width/2,self.itemBgs[itemIndex]:getContentSize().height/2)
    commonItem:setTag(10)

    if equip.grid == 13 then
        --翅膀红点
        local btnTips = BaseTipsBtn.new(BtnTipsType.BTN_ROLE_WING,commonItem,self.itemBgs[itemIndex]:getContentSize().width - 40,self.itemBgs[itemIndex]:getContentSize().height - 40)
    end

    if equip.grid == 13 then
        if equip.expire_time ~= 0 and equip.expire_time <= socket.gettime() then
             commonItem:checkAndSetGray(true)
        else
            commonItem:checkAndSetGray(false)
        end
    end
 
    commonItem:setItemClickFunc(function()
        --弹出装备提示窗口
        if equip.grid == 13 then
            if GlobalController.wingUp:isTempWing(equip) and equip.expire_time <= socket.gettime() then
                GlobalWinManger:openWin(WinName.UPGRADEWINGTIPSVIEW)
                return
            end
        end
        local eTWin = equipTipsWin.new()
        eTWin:setData(equip)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)  
    end)
end


--金币点击回调
--coinType:金币类型,1:金币 2:金锭 3:银票
function MainRoleWin:onCoinClick(coinType)
    -- body
end

--标签按钮点击回调
--tagBtnIndex:标签按钮类型,1:属性 2:装备 3:称号
function MainRoleWin:onTagBtnClick(tagBtnIndex)
    if not self.tagBtns[tagBtnIndex] then return end

    if self.curTagBtnIndex and self.curTagBtnIndex == tagBtnIndex then
        return
    else
        if self.curTagBtnIndex then
            local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
            sp:setVisible(false)
        end
        self.curTagBtnIndex = tagBtnIndex
        local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
        sp:setVisible(true)
    end
    if tagBtnIndex == 1 then

        if self.mainLayer then
            self.mainLayer:setVisible(true)
        end

        if self.hallMarkView then
            self.hallMarkView:setVisible(false)
        end
        if self.rideView then
            self.rideView:setVisible(false)
            self.rideView:close()
        end

        if not self.propertyLayer then
            self.propertyLayer = cc.uiloader:load("resui/roleWin_propertyLayer.ExportJson")
            local function onPropertyEnter(data)
                if data.name == "enterTransitionFinish" then
                    self:initPropertyLayer()
                    self.propertyLayer:setVisible(true)
                    self:refreshProperty()
                end
            end
            self.propertyLayer:addNodeEventListener(cc.NODE_EVENT,onPropertyEnter)
            self.rightLayer:addChild(self.propertyLayer)
            --self.propertyLayer:setPositionX(-17)
        else
            if self.propertyLayerInit then
                if self.recoverEnterTag1 then
                    self.recoverEnterTag1 = false
                end
                self.propertyLayer:setVisible(true)
                self:refreshProperty()
            end
        end
        
        if self.pageManager then
            self.pageManager:setVisible(false)
        end
    elseif tagBtnIndex == 2 then
        
        if self.mainLayer then
            self.mainLayer:setVisible(true)
        end

        if self.hallMarkView then
            self.hallMarkView:setVisible(false)
        end

        if self.rideView then
            self.rideView:setVisible(false)
            self.rideView:close()
        end

        if self.propertyLayer then
            self.propertyLayer:setVisible(false)
        end
        if not self.pageManager then
            ------------------------------------------------------------------------------------
            local pageManager = PageManager.new(self.rightLayer, 6, 40,{colum = 3,rows = 5,pageWidth = 256,pageHeight = 435,pageOfNum = 7,pageCapacity = 15}) --268 480
            pageManager:SetOnItemsSelectedHandler(function(event)
                local data       = event.data
                local isSelected = event.isSelected
                self:onBagEquipClickHandler(data, isSelected)
            end)
            self.pageManager = pageManager
            self:refreshBagList()
            ------------------------------------------------------------------------------------
        else
            self.pageManager:setVisible(true)
        end
        
    elseif tagBtnIndex == 3 then
        if self.propertyLayer then
            self.propertyLayer:setVisible(false)
        end
        if self.pageManager then
            self.pageManager:setVisible(false)
        end

        if self.mainLayer then
            self.mainLayer:setVisible(false)
        end

        if self.rideView then
            self.rideView:setVisible(false)
            self.rideView:close()
        end

        if self.hallMarkView == nil then
            self.hallMarkView = require("app.modules.role.view.HallMarkView").new()
            self.StampLayer:addChild(self.hallMarkView)
            --self.hallMarkView:setPosition(-16, -85)
        end
        self.hallMarkView:setVisible(true)
        self.hallMarkView:open()

    elseif tagBtnIndex == 4 then
 
        if self.propertyLayer then
            self.propertyLayer:setVisible(false)
        end
        if self.pageManager then
            self.pageManager:setVisible(false)
        end

        if self.mainLayer then
            self.mainLayer:setVisible(false)
        end

        if self.hallMarkView then
            self.hallMarkView:setVisible(false)
        end

        if self.rideView == nil then
            self.rideView = require("app.modules.role.view.RideView").new()
            self.StampLayer:addChild(self.rideView)
            --self.rideView:setPosition(-16, -85)
        end
        self.rideView:setVisible(true)
        self.rideView:open()

    end

    self:updateCheckBoxVisibele()
end

--初始化属性页
function MainRoleWin:initPropertyLayer()
    local propertyLayer = self.propertyLayer
    --属性值label
    self.propLabels = {}
    for i=1,18 do
        local label = cc.uiloader:seekNodeByName(propertyLayer,"valueLab"..i)
        label:setString("")
        table.insert(self.propLabels,label)
    end

    --经验进度条
    self.expBar = cc.ClippingRegionNode:create()
    self.expBar:setPosition(154/2,20/2)
    local bg = cc.uiloader:seekNodeByName(propertyLayer,"expValue")
    bg:addChild(self.expBar)
    local bar = display.newScale9Sprite("#roleWin_greenBar.png",nil,nil,cc.size(150, 14))
    self.expBar:addChild(bar)
    self.expBar:setClippingRegion(cc.rect(-150/2, -7, 150, 14))
    self.expBar:setVisible(false)
    --经验label
    self.expLabel = cc.uiloader:seekNodeByName(cc.uiloader:seekNodeByName(propertyLayer,"expValue"),"lab")
    self.expLabel:setString("")

    --生命值进度条
    self.HPBar = cc.ClippingRegionNode:create()
    self.HPBar:setPosition(154/2,20/2)
    local bg = cc.uiloader:seekNodeByName(propertyLayer,"HPValue")
    bg:addChild(self.HPBar)
    local bar = display.newScale9Sprite("#roleWin_redBar.png",nil,nil,cc.size(150, 14))
    self.HPBar:addChild(bar)
    self.HPBar:setClippingRegion(cc.rect(-150/2, -7, 150, 14))
    self.HPBar:setVisible(false)
    --生命值label
    self.HPLabel = cc.uiloader:seekNodeByName(cc.uiloader:seekNodeByName(propertyLayer,"HPValue"),"lab")
    self.HPLabel:setString("")

    --魔法值进度条
    self.MPBar = cc.ClippingRegionNode:create()
    self.MPBar:setPosition(154/2,20/2)
    local bg = cc.uiloader:seekNodeByName(propertyLayer,"MPValue")
    bg:addChild(self.MPBar)
    local bar = display.newScale9Sprite("#roleWin_blueBar.png",nil,nil,cc.size(150, 14))
    self.MPBar:addChild(bar)
    self.MPBar:setClippingRegion(cc.rect(-150/2, -7, 150, 14))
    self.MPBar:setVisible(false)
    --魔法值label
    self.MPLabel = cc.uiloader:seekNodeByName(cc.uiloader:seekNodeByName(propertyLayer,"MPValue"),"lab")
    self.MPLabel:setString("")

    self.propertyLayerInit = true

    self.helpBtn = cc.uiloader:seekNodeByName(propertyLayer,"helpBtn")
            self.helpBtn:setTouchEnabled(true)
            self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                    self.helpBtn:setScale(1.2)
                    SoundManager:playClickSound()
                elseif event.name == "ended" then
                    self.helpBtn:setScale(1.0)
                    GlobalMessage:alert({
                      enterTxt = "确定",
                      backTxt= "取消",
                      tipTxt = configHelper:getRuleByKey(14),
                      tipShowMid = true,
                      hideBackBtn = true,
                  })
                end     
                return true
            end)

end

--刷新属性
function MainRoleWin:refreshProperty()
    local roleManager = RoleManager:getInstance()
    if not roleManager then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    local roleInfo = roleManager.roleInfo
    if not roleInfo then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    if self.propLabels then
    --内观
    self.imv:setSex(roleInfo.sex)
    self.imv:setBodyId(roleInfo.clothes)
    --self.imv:setWeaponId(roleInfo.weapon)
    self.imv:setWeaponId(roleInfo:getWeaponResId())
    self.imv:setWingId(roleInfo.wing)
 
    --玩家名
    self.roleName:setString(roleInfo.name)
    --等级
    self.propLabels[1]:setString(roleInfo.lv or 0)
    --战力
    self.propLabels[2]:setString(roleInfo.fighting or 0)
    --物理攻击
    self.propLabels[3]:setString(string.format("%d - %d",roleInfo.min_ac or 0,roleInfo.max_ac or 0))
    --魔法攻击
    self.propLabels[4]:setString(string.format("%d - %d",roleInfo.min_mac or 0,roleInfo.max_mac or 0))
    --道术攻击
    self.propLabels[5]:setString(string.format("%d - %d",roleInfo.min_sc or 0,roleInfo.max_sc or 0))
    --物理防御
    self.propLabels[6]:setString(string.format("%d - %d",roleInfo.min_def or 0,roleInfo.max_def or 0))
    --魔法防御
    self.propLabels[7]:setString(string.format("%d - %d",roleInfo.min_res or 0,roleInfo.max_res or 0))
    --暴击
    self.propLabels[8]:setString(roleInfo.crit or 0)
    --准确
    self.propLabels[9]:setString(roleInfo.hit or 0)
    --幸运和诅咒
    if roleInfo.lucky then
        self.propLabels[10]:setString(roleInfo.lucky>0 and roleInfo.lucky or 0)
        self.propLabels[13]:setString(roleInfo.lucky>0 and 0 or math.abs(roleInfo.lucky))
    end
    
    --暴击力(暴击伤害?)
    self.propLabels[11]:setString(roleInfo.crit_att or 0)
    --敏捷
    self.propLabels[12]:setString(roleInfo.dodge or 0)

    --伤害加深
    self.propLabels[14]:setString(roleInfo.holy or 0)
    --魔法命中
    self.propLabels[15]:setString(roleInfo.hp_recover or 0)
    --伤害减免(在10003上有2个伤害减免,是damage_reduction还是damage_offset呢?)
    self.propLabels[16]:setString(roleInfo.skill_add or 0)
    --魔法闪避
    self.propLabels[17]:setString(roleInfo.mp_recover or 0)
    --pk值
    self.propLabels[18]:setString(roleInfo.pkValue or 0)

    --红蓝变化
    self:refreshBloodAndMana()

    --经验变化    
    self:refreshExp()
    end
end

--刷新红蓝
function MainRoleWin:refreshBloodAndMana()
    local roleManager = RoleManager:getInstance()
    if not roleManager then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    local roleInfo = roleManager.roleInfo
    if not roleInfo then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    --生命值
    local percent = (roleInfo.cur_hp or 0)/(roleInfo.hp or 0)
    if percent>0 then
        self.HPBar:setVisible(true)
        self.HPBar:setClippingRegion(cc.rect(-150/2, -7, 150*(percent), 14))
    else
        self.HPBar:setVisible(false)
    end
    self.HPLabel:setString(string.format("%d/%d",(roleInfo.cur_hp or 0),(roleInfo.hp or 0)))
    --魔法值
    local percent = (roleInfo.cur_mp or 0)/(roleInfo.mp or 0)
    if percent>0 then
        self.MPBar:setVisible(true)
        self.MPBar:setClippingRegion(cc.rect(-150/2, -7, 150*(percent), 14))
    else
        self.MPBar:setVisible(false)
    end
    self.MPLabel:setString(string.format("%d/%d",(roleInfo.cur_mp or 0),(roleInfo.mp or 0)))
end

--刷新经验值
function MainRoleWin:refreshExp()
    local roleManager = RoleManager:getInstance()
    if not roleManager then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    local roleInfo = roleManager.roleInfo
    if not roleInfo then
        --发送获取主角属性协议
        GameNet:sendMsgToSocket(10003, {})
        --转小菊花

        return
    end
    
    --取得升到下级需要的总经验
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local expTotal = configHelper:getLevelUpgradeExp(roleInfo.lv)
    --当前经验
    local curExp = roleInfo.exp or 0
    local percent = curExp/expTotal
    self.expBar:setVisible(percent>0)
    if expTotal then            
        self.expBar:setClippingRegion(cc.rect(-150/2, -7, 150*(curExp/expTotal), 14))
        self.expLabel:setString(string.format("%d/%d",curExp,expTotal))
    else        --满级了
        self.expBar:setClippingRegion(cc.rect(-150/2, -7, 150, 14))
        self.expLabel:setString("")
    end
end

--刷新装备列表
function MainRoleWin:refreshEquips()
    local roleManager = RoleManager:getInstance()
    if not roleManager.roleInfo  then return end
    local equipList = roleManager.roleInfo.equip
    for i=1,self.equipnum do
        self:setEquipToItemBg(i,nil)
    end
    --self.checkBox:setButtonSelected(SysOptionModel:getOptionByDefine(DefineOptions.HIDE_SPEQUIP))
    self.checkBox:setVisible(false)
    --print(SysOptionModel:getOptionByDefine(DefineOptions.HIDE_SPEQUIP))
    for i=1,#equipList do
        --print(equipList[i].grid,equipList[i].goods_id,equipList[i].is_use,equipList[i].num,equipList[i].location)
        self:setEquipToItemBg(equipList[i].grid, equipList[i])
      --  if equipList[i].grid == 21 and equipList[i].num >= 1 and equipList[i].is_use == 1 then
        --    self.checkBox:setVisible(true)
      --  end 
    end
    self:updateCheckBoxVisibele()
end

function MainRoleWin:refreshMark()
    if self.hallMarkView ~= nil then
        self.hallMarkView:open()
    end
    if self.checkBox then
        self.checkBox:setButtonSelected(RoleManager:getInstance().roleInfo.wing_state == 1)
    end
end

function MainRoleWin:getEquipList()
    local bagInfo = BagManager:getInstance().bagInfo
    if bagInfo then
        return bagInfo:getEquipList()
    end
    return {}
end

--初始化背包数据
function MainRoleWin:refreshBagList()
    if self.pageManager then
        local equipList = self:getEquipList()
        self.pageManager:SetPageItemsData(equipList)
        self.pageManager:GotoFirstPage()
    end
end

function MainRoleWin:onBagEquipClickHandler(itemData)
    --弹出装备提示窗口
    local etName,grid = configHelper:getEquipTypeByEquipId(itemData.goods_id)
    if grid == 6 or grid == 7 then
        --弹出装备提示窗口
        local eTWin = equipTipsWin.new()
        eTWin:setData(itemData)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, eTWin)  
    else
        local find = false
        local pos
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
        for i=1,#roleInfo.equip do
            if roleInfo.equip[i].grid == grid then
                find = true
                pos = i
                break
            end
        end
        if find then
            --弹出装备对比窗口
            local compareWin = equipCompareWin.new()
            compareWin:setData(roleInfo.equip[pos],itemData)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,compareWin) 
        else
            --弹出装备提示窗口
            local eTWin = equipTipsWin.new()
            eTWin:setData(itemData)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin) 
        end
    end
end

--注册监听的事件
function MainRoleWin:registerEvents()

    self:registerGlobalEventHandler(RoleEvent.UPDATE_MARK_SUCCESS, handler(self, self.refreshMark))
    self:registerGlobalEventHandler(BagEvent.CHANGE_EQUIP_TO_BAG, handler(self, self.refreshBagList))
    self:registerGlobalEventHandler(BagEvent.EQUIP_CHANGE,     handler(self, self.refreshProperty))
    self:registerGlobalEventHandler(BagEvent.BODY_EQUIP_CHANGE,      handler(self, self.refreshEquips))
    self:registerGlobalEventHandler(RoleEvent.UPDATE_ROLE_BASE_ATTR,  handler(self, self.refreshProperty))
    self:registerGlobalEventHandler(RoleEvent.UPDATE_ROLE_FIGHT_ATTR, handler(self, self.refreshProperty))
    -- self:registerGlobalEventHandler(RoleEvent.UPDATE_WEALTH,          handler(self, self.refreshCoin))

    self:registerGlobalEventHandler(RoleEvent.OPEN_RIDE_TAG,          function(data)
        local roleManager = RoleManager:getInstance()
            local roleInfo = roleManager.roleInfo
     
            if roleInfo.rideInfo == nil  then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"50级可免费领取坐骑")
                return
            end
            self:onTagBtnClick(4)


    end)


end

--
-- 注册全局事件监听。
--
function MainRoleWin:registerGlobalEventHandler(eventId, handler)
    local handles = self._eventHandles or {}
    handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
    self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function MainRoleWin:removeAllEvents()
    if self._eventHandles then
        for _, v in pairs(self._eventHandles) do
            GlobalEventSystem:removeEventListenerByHandle(v)
        end
    end
    if self.rideView then
        self.rideView:close()
    end

end

--关闭按钮回调
function MainRoleWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)
end

function MainRoleWin:open()
    if self.propertyLayerInit then
        self:refreshProperty()
    end
    self:registerEvents()
    if self.hadEnter then
        self:refreshBagList()
        self.recoverEnterTag1 = true
        self:onTagBtnClick(1)
    end
    self:refreshEquips()
end

function MainRoleWin:close()
    self.super.close(self)
    --解除监听事件
    self:removeAllEvents()
end

function MainRoleWin:destory()
    self:close()
    self.super.destory(self)
end

return MainRoleWin