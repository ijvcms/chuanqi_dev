--
-- Author: casen
-- Date: 2015-09-01 
-- 道具tips窗口

-- local itemTipsWin = itemTipsWin or class("itemTipsWin",function()
--     return cc.uiloader:load("resui/itemTipsWin.ExportJson")
-- end)

local itemTipsWin = itemTipsWin or class("itemTipsWin", function()
    return display.newNode()
end)

--构造
function itemTipsWin:ctor()
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    local ccui = cc.uiloader:load("resui/itemTipsWin.ExportJson")
    self:addChild(ccui)

    local root = cc.uiloader:seekNodeByName(ccui, "root")
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
    end)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    local winbg = cc.uiloader:seekNodeByName(win, "bg")
    winbg:setTouchEnabled(true)
    winbg:setTouchSwallowEnabled(true)

    --关闭按钮
    local btnClose = cc.uiloader:seekNodeByName(win, "btnClose")
    btnClose:setTouchEnabled(true)
    btnClose:onButtonPressed(function ()
        btnClose:setScale(1.0)
        SoundManager:playClickSound()
    end)
    btnClose:onButtonRelease(function()
        btnClose:setScale(0.8)
    end)
    btnClose:onButtonClicked(function ()
        btnClose:setScale(0.8)
        self:onCloseClick()
    end)  

    --使用按钮
    local btnUse = cc.uiloader:seekNodeByName(win, "btnUse")
    self.btnUse = btnUse
    btnUse:setTouchEnabled(true)
    btnUse:onButtonPressed(function ()
        btnUse:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnUse:onButtonRelease(function()
        btnUse:setScale(1.0)
    end)
    btnUse:onButtonClicked(function ()
        btnUse:setScale(1.0)
        self:onUse()
    end)

    --出售按钮
    local btnSell = cc.uiloader:seekNodeByName(win, "btnSell")
    self.btnSell = btnSell
    btnSell:setTouchEnabled(true)
    btnSell:onButtonPressed(function ()
        btnSell:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnSell:onButtonRelease(function()
        btnSell:setScale(1.0)
    end)
    btnSell:onButtonClicked(function ()
        btnSell:setScale(1.0)
        self:onSell()
    end)   

end

function itemTipsWin:setData(data)
    self.data = data

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
    commonItem:setPosition(itemBg:getContentSize().width/2,itemBg:getContentSize().height/2)
    commonItem:setItemClickFunc(handler(self,self.onItemClick))
    commonItem:setTag(10)

    --类型
    local labTypeValue = cc.uiloader:seekNodeByName(self.win, "labTypeValue")
    local eType = configHelper:getGoodTypeStringByGoodId(data.goods_id)
    labTypeValue:setString(eType or "")

    --物品描述
    local labContent = cc.uiloader:seekNodeByName(self.win, "labContent")
    local describe = configHelper:getGoodDescByGoodId(data.goods_id)
    labContent:setString(describe or "")
    
    --按钮部分
    --显示相应的按钮
    if configHelper:getPropCanUseByPropId(data.goods_id) then
        self.btnUse:setVisible(true)
        self.btnSell:setPosition(123,73)
    else
        self.btnUse:setVisible(false)
        self.btnSell:setPosition(210,73)
    end
    
    self.labLacol = cc.uiloader:seekNodeByName(self.win, "labLacol")
    self.location = cc.uiloader:seekNodeByName(self.win, "location")
    self.goodsType = 0

    if configHelper:getGoodTypeByGoodId(data.goods_id) == 7 then
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
end

function itemTipsWin:onItemClick()
end

function itemTipsWin:onUse()
    if not self.data then return end
    local data = {
        goods_id = self.data.goods_id
    }
    --GameNet:sendMsgToSocket(14007, data)
    BagController:getInstance():requestUseGoods(data)
    self:setVisible(false)
end

function itemTipsWin:onSell()
    if not self.data then return end
    local id_list = {
        [1] = self.data.id
    }
    GameNet:sendMsgToSocket(14005, {goods_list = id_list})
    self:setVisible(false)
end


--关闭按钮回调
function itemTipsWin:onCloseClick()
    if self:getParent() then
        self:removeSelfSafety()
    end
end

return itemTipsWin