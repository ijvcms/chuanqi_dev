
local LocalDatasManager = require("common.manager.LocalDatasManager")
TipsProp = TipsProp or class("TipsProp",function()
	return cc.uiloader:load("resui/tt_itemBox.ExportJson")
end)

--构造
function TipsProp:ctor()	
	local root = cc.uiloader:seekNodeByName(self, "root")
    root:setTouchEnabled(false)
    root:setTouchSwallowEnabled(false)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    --使用按钮
    local btnUse = cc.uiloader:seekNodeByName(win, "btnUse")
    self.btnUse = btnUse
    btnUse:setTouchEnabled(true)
    btnUse:onButtonPressed(function ()
        btnUse:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnUse:onButtonRelease(function()
        btnUse:setScale(1.0)
    end)
    btnUse:onButtonClicked(function ()
        btnUse:setScale(1.0)
        self:onUse()
    end)

    --快速使用按钮
    local btnQuickUse = cc.uiloader:seekNodeByName(win, "btnSet")
    self.btnQuickUse = btnQuickUse
    btnQuickUse:setTouchEnabled(true)
    btnQuickUse:onButtonPressed(function ()
        btnQuickUse:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnQuickUse:onButtonRelease(function()
        btnQuickUse:setScale(1.0)
    end)
    btnQuickUse:onButtonClicked(function ()
        btnQuickUse:setScale(1.0)
        self:onQuickUse()
    end)

    --出售按钮
    local btnSell = cc.uiloader:seekNodeByName(win, "btnSell")
    self.btnSell = btnSell
    btnSell:setTouchEnabled(true)
    btnSell:onButtonPressed(function ()
        btnSell:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnSell:onButtonRelease(function()
        btnSell:setScale(1.0)
    end)
    btnSell:onButtonClicked(function ()
        btnSell:setScale(1.0)
        self:onSell()
    end)   

    local btnSend = cc.uiloader:seekNodeByName(win, "btnSend")
    self.btnSend = btnSend
    btnSend:setTouchEnabled(true)
    btnSend:onButtonPressed(function ()
        btnSend:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnSend:onButtonRelease(function()
        btnSend:setScale(1)
    end)
    btnSend:onButtonClicked(function ()
        btnSend:setScale(1)
        self:onSendClick()
    end)

    --关闭按钮
    local btnClose = cc.uiloader:seekNodeByName(win, "btnClose") 
    btnClose:setVisible(false)

    self.labLacol = cc.uiloader:seekNodeByName(self.win, "labLacol")
    self.location = cc.uiloader:seekNodeByName(self.win, "location")
    self.goodsType = 0
end

function TipsProp:setData(data, isChat)
    self.data = data

    local goods_config = configHelper:getGoodsByGoodId(data.goods_id)
    --dump(goods_config, "goods_config")
    self.data.skip = goods_config.skip
    self.goodsType = goods_config.type

    --按钮部分
    --显示相应的按钮
    self.btnUse:setButtonLabelString("使用")
    if self.data.skip == nil or self.data.skip == "" then
        if configHelper:getPropCanUseByPropId(data.goods_id) then

            if self.goodsType == 4 and configHelper:getGoodSubTypeByGoodId(data.goods_id) == 2 then
                self.btnQuickUse:setVisible(true)
                self.btnUse:setVisible(false)
            else
                self.btnQuickUse:setVisible(false)
                self.btnUse:setVisible(true)
            end
        
            self.btnSell:setPosition(100,38)

            -- 跨服幻境之城(掉落宝箱,在背包中"使用"改成"开启")
            if goods_config.is_open == 1 then -- is_open字段,策划WSH添加,表示显示"使用"还是"打开"
                self.btnUse:setButtonLabelString("开启")
            end
        else
            self.btnUse:setVisible(false)
            self.btnSell:setPosition(200,38)
            self.btnQuickUse:setVisible(false)
        end
    else
        self.btnSell:setPosition(100,38)
        self.btnQuickUse:setVisible(false)
    end
 
    if isChat == true then
        self.btnSend:setVisible(true)
        self.btnUse:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnQuickUse:setVisible(false)
    else
        self.btnSend:setVisible(false)
    end

    if self.goodsType == 7 then
        self.labLacol:setVisible(true)
        self.location:setVisible(true)
        local mapConf = getConfigObject(data.map_scene,ActivitySceneConf)
        if mapConf then 
            local sceneName = mapConf.name
            self.location:setString(sceneName.."("..data.map_x..","..data.map_y..")")
        end
        --self.data.map_scene,cc.p(self.data.map_x,self.data.map_y
    else
        self.labLacol:setVisible(false)
        self.location:setVisible(false)
    end

    --标题部分
    --装备名
    local labName = cc.uiloader:seekNodeByName(self.win, "labName")
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    labName:setString(equipName or "")

    --装备等级
    local labLevel = cc.uiloader:seekNodeByName(self.win, "labLevel")
    local equipLevel = configHelper:getGoodLVByGoodId(data.goods_id)
    labLevel:setString("LV."..(equipLevel or 0))

    --是否绑定
    local labBind = cc.uiloader:seekNodeByName(self.win, "labBind")
    labBind:setVisible((data.is_bind==1) or false)

    --调整位置
    local x1 = labName:getContentSize().width + labName:getPositionX()
    labLevel:setPositionX(x1+10)
    local x2 = x1 + 10 + labLevel:getContentSize().width
    labBind:setPositionX(x2+10) 

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    local itemBg = cc.uiloader:seekNodeByName(self.win, "itemBg")
    if itemBg:getChildByTag(10) then
        itemBg:removeChildByTag(10,true)
    end
    itemBg:addChild(commonItem)
    commonItem:setItemClickFunc(handler(self,self.onItemClick))
    commonItem:setPosition(itemBg:getContentSize().width/2,itemBg:getContentSize().height/2)
    commonItem:setTag(10)

    --类型
    local labTypeValue = cc.uiloader:seekNodeByName(self.win, "labTypeValue")
    local eType = configHelper:getGoodTypeStringByGoodId(data.goods_id)
    labTypeValue:setString(eType or "")

    --物品描述
    local labContent = cc.uiloader:seekNodeByName(self.win, "labContent")
    local describe = configHelper:getGoodDescByGoodId(data.goods_id)
    labContent:setString(describe or "")
 
    
end

function TipsProp:onItemClick()
end

function TipsProp:onUse()
   
    if not self.data then return end
    --self:setVisible(false)
    --跳转
    if self.data.skip and self.data.skip ~= "" then
        GlobalEventSystem:dispatchEvent(DailyTaskEvent.TASK_JUMP,{win = self.data.skip })
        return
    end

    local hasExpAdd = nil
    if self.data.goods_id == 110148 or self.data.goods_id == 110149 then
        for k,v in pairs(RoleManager:getInstance().buffData.buff_list) do
            if v.buff_id then
                if v.buff_id == 2002 and self.data.goods_id == 110148 then
                    hasExpAdd = 110148
                    break
                elseif v.buff_id == 2001 and self.data.goods_id == 110149 then
                    hasExpAdd = 110149
                    break
                end
            end
        end
        
    end

    local onEnterFun = function()
        --道具使用
        local data = {
            goods_id = self.data.goods_id
        }
        --GameNet:sendMsgToSocket(14007, data)

        if configHelper:checkBatchUseByGoodId(self.data.goods_id) and self.data.num > 1 then
            local itWin = require("app.modules.bag.view.BatchUseView").new()
            itWin:setViewInfo(self.data)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin) 
        else
            if self.goodsType == 7 then
                SceneManager:playerMoveToBaoCang(self.data.map_scene,cc.p(self.data.map_x,self.data.map_y),self.data.id)
                GlobalWinManger:closeWin(WinName.BAGWIN)
            else
                BagController:getInstance():requestUseGoods(data)
                -- GUIDE CONFIRM
                GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_BAG_USE_BUTTON) 
            end
        end
    end
    if hasExpAdd ~= nil then
        local onBackFun = function()
        end
        local str = ""
        if hasExpAdd == 110149 then
            str = "当前已有二倍卷轴，是否替换"
        else
            str = "当前已有三倍卷轴，是否替换"
        end

        local param = {enterTxt = "使 用",backTxt="返 回",tipTxt = str,enterFun = onEnterFun,backFun = handler(self, onBackFun),hideCloseBtn = false,hideBackBtn = false}
        GlobalMessage:alert(param)
    elseif self.data.goods_id == 110318 then--幻金宝箱
        local needItemList = configHelper:getGoodsByGoodId(self.data.goods_id).cost
        local bagItemNum = BagManager:getInstance():findItemCountByItemId(needItemList[1][1])
        local needItemNum = needItemList[1][2]
        local itemMoney = configHelper:getGoodsByGoodId(needItemList[1][1]).price_jade
        if #needItemList > 0 and bagItemNum >= needItemNum then
             onEnterFun()
        else
            local str = ""
            str = "打开宝箱还需要幻金秘钥*"..(needItemNum-bagItemNum).."（幻金秘钥可通过【幻境之地】【神皇秘境】获得）"
            local param = {enterTxt = "确 定", tipTxt = str, hideCloseBtn = false,hideBackBtn = true}
            GlobalMessage:alert(param)
        end
    else
        onEnterFun()
    end
end

function TipsProp:onSell()
    if not self.data then return end
    local hasWarn = configHelper:getGoodsByGoodId(self.data.goods_id).warn
    function exfunc()
        local id_list = {
            [1] = self.data.id
        }
        GameNet:sendMsgToSocket(14005, {goods_list = id_list})
        self:setVisible(false) 
    end

    if hasWarn == 1 then
        GlobalMessage:alert({
                enterTxt = "确定",
                backTxt= "取消",
                tipTxt = "该物品是稀有物品，确定出售吗",
                enterFun = exfunc,
                tipShowMid = true,
        })
    else
        exfunc()
    end
    
end

function TipsProp:onSendClick()
    --发送聊天
     GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_SEND_GOODS, self.data)
end

function TipsProp:onQuickUse()
    local data = {
        id =  self.data.goods_id
    }

    LocalDatasManager:saveLocalData(data, "QUICK_USE_GOODS")
    GlobalEventSystem:dispatchEvent(BagEvent.QUICK_USE_CHANGE, data.id)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"快捷喝药设置成功！")
end