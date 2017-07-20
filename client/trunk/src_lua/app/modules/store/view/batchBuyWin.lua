--
-- Author: casen
-- Date: 2015-09-01 
-- 批量购买窗口

local batchBuyWin = batchBuyWin or class("batchBuyWin", function()
    return display.newNode()
end)

--构造
function batchBuyWin:ctor(params)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:setContentSize(display.width, display.height)

    local ccui = cc.uiloader:load("resui/batchBuyWin.ExportJson")
    self:addChild(ccui)

    local root = cc.uiloader:seekNodeByName(ccui, "root")
    -- root:setTouchEnabled(true)
    -- root:setTouchSwallowEnabled(true)
    -- root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "began" then
    --         SoundManager:playClickSound()
    --     elseif event.name == "ended" then
    --         self:onCloseClick()
    --     end     
    --     return true
    -- end)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    local winbg = cc.uiloader:seekNodeByName(win, "bg")
    winbg:setTouchEnabled(true)
    winbg:setTouchSwallowEnabled(true)

    self.labTitle = cc.uiloader:seekNodeByName(win,"labTitle")

    --关闭按钮
    self.closeBtn = cc.uiloader:seekNodeByName(win,"btnClose")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            self:onCloseClick()
        end     
        return true
    end)

    --------------------------------------
    local function setFunc(value)
        self.curCount = value
        self:refreshCount()
    end

    local function getFunc()
        return self.curCount or 1
    end

    self.ctl = require("app.utils.QuickQuantityController").new(setFunc, getFunc)
    self.ctl:setMinimumValue(1)
    --增加按钮
    self.btnAdd = cc.uiloader:seekNodeByName(win,"btnAdd")
    self.btnAdd:setTouchEnabled(true)
    self.btnAdd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnAdd:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, true)
        elseif event.name == "ended" then
            self.btnAdd:setScale(1.0)
            if not self.ctl:stop() then
                self:onAddClick()
            end
        end     
        return true
    end)

    --减少按钮
    self.btnRedu = cc.uiloader:seekNodeByName(win,"btnRedu")
    self.btnRedu:setTouchEnabled(true)
    self.btnRedu:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRedu:setScale(1.2)
            SoundManager:playClickSound()
            self.ctl:start(.5, false)
        elseif event.name == "ended" then
            self.btnRedu:setScale(1.0)
            if not self.ctl:stop() then
                self:onReduClick()
            end
        end     
        return true
    end)

    --购买按钮
    self.btnBuy = cc.uiloader:seekNodeByName(win,"btnBuy")
    self.textOnBtn = self.btnBuy:getChildByTag(128)
    self.textOnBtn:setString("确定")
    self.btnBuy:setTouchEnabled(true)
    self.btnBuy:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnBuy:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnBuy:setScale(1.0)
            self:onBuyClick()
        end     
        return true
    end)

    --
    self.curCount = 1
    --self.labCurCount = cc.uiloader:seekNodeByName(win,"labCurCount")

    self.labBg = cc.uiloader:seekNodeByName(win,"Image_52")
    self.labCurCount = cc.ui.UIInput.new({
          UIInputType = 1,
          size = self.labBg:getContentSize(),
          listener = handler(self,self.onEdit),
          image = "common/input_opacity1Bg.png"
        })
    self.labCurCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.labCurCount:setReturnType(1)
    self.labCurCount:setFontSize(18)
    self.labCurCount:setAnchorPoint(0, 0)
    --self.labCurCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.labCurCount:setPosition(0, -2)
    self.labBg:addChild(self.labCurCount)
   
    self.labPart1 = cc.uiloader:seekNodeByName(win,"labPart1")
    self.labPart1:setString("")
    self.labPart2 = cc.uiloader:seekNodeByName(win,"labPart2")
    self.labPart2:setVisible(false)
    self.labPart3 = cc.uiloader:seekNodeByName(win,"labPart3")
    self.labPart3:setVisible(false)
    self.limit_name = cc.uiloader:seekNodeByName(win,"limit_name")    
    self.limit_num = cc.uiloader:seekNodeByName(win,"limit_num")    
    GameNet:registerProtocal(16003, handler(self,self.setBuyCount))
    if params then
        --标题
        if params.title then
            self:setTitle(params.title)
        end
        --确认按钮文字
        if params.sureText then
            self:setBuyBtnText(params.sureText)
        end
        --确认按钮点击回调
        if params.clickFunc then
            self:setClickFunc(params.clickFunc)
        end
        --数量改变回调
        if params.countFunc then
            self:setCountChangeListener(params.countFunc)
        end
        --数据
        if params.data then
            self:setData(params.data)
        end
        --最大数量
        if params.max then
            self:setMax(params.max)
        end
    end

    
end

function batchBuyWin:setBuyCount(data)
    self.limit_name:setVisible(true)
    self.limit_num:setVisible(true)
    local max = data.limit_num - data.use_num
    self.limit_num:setString(max.."/"..data.limit_num)
    if max < self.max then
        self:setMax(max)
    end
end

function batchBuyWin:onEdit(event, editbox)
    if event == "changed" then
        local checkText = editbox:getText()
        local text = string.gsub(checkText,"[\\.]", "")
        local count = tonumber(text, 10) or 1
        self.curCount = count
        if self.max then
            if count > self.max then
                count = self.max
            end
        end
        if count < 1 then
            count = 1
        end
        if checkText ~= text or self.curCount ~= count then
            editbox:setText(tostring(count))
        end
        self.curCount = count
        if self.countChangeListener then
            self.countChangeListener(self.curCount,self.labPart1)
        end
    end
end

-- function batchBuyWin:setData(data,coinType,price)
function batchBuyWin:setData(data)
    self.data = data
    dump(data)
    if data.counter_id ~= nil and data.counter_id ~= 0 and data.key ~= nil then --限制购买
        GameNet:sendMsgToSocket(16003, {id = data.key})
    else
        self.limit_name:setVisible(false)
        self.limit_num:setVisible(false)
    end

    --物品名
    local labName = cc.uiloader:seekNodeByName(self.win, "labName")
    labName:setString(configHelper:getGoodNameByGoodId(data.goods_id))

    --物品描述
    local labContent = cc.uiloader:seekNodeByName(self.win, "labContent")
    labContent:setString(configHelper:getGoodDescByGoodId(data.goods_id))

    --物品图标
    local itemBg = cc.uiloader:seekNodeByName(self.win, "itemBg")
    if itemBg:getChildByTag(10) then
        itemBg:removeChildByTag(10)
    end
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    commonItem:setTag(10)
    commonItem:setPosition(itemBg:getContentSize().width/2, itemBg:getContentSize().height/2)
    commonItem:setFrameVisible(false)
    itemBg:addChild(commonItem)

    --何种类型的金币
    -- coinType = coinType or 1
    -- if coinType == 1 then
    --     self.labPart3:setString("金币")
    -- elseif coinType == 2 then
    --     self.labPart3:setString("元宝")
    -- elseif coinType == 3 then
    --     self.labPart3:setString("礼券")
    -- elseif coinType == 4 then
    --     self.labPart3:setString("贡献")
    -- end

    --重置购买数量
    self:resetCount()
end

function batchBuyWin:setCountChangeListener(func)
    self.countChangeListener = func
end

function batchBuyWin:resetCount()
    self.curCount = 1 
    self:refreshCount()
end

function batchBuyWin:onAddClick( )

    self.curCount = self.curCount + 1
    self:refreshCount()
end

function batchBuyWin:onReduClick( )
    self.curCount = self.curCount - 1 
    self:refreshCount()
end

function batchBuyWin:refreshCount()
    if self.max then
        if self.curCount > self.max then
            self.curCount = self.max
            GlobalAlert:show("最多购买"..self.max.."个")
        end
    end
    if self.curCount < 1 then
        self.curCount = 1
    end      
    self.labCurCount:setText(tostring(self.curCount))
    if self.countChangeListener then
        self.countChangeListener(self.curCount,self.labPart1)
    end
end

function batchBuyWin:setClickFunc(func)
    self.clickFunc=func
end

function batchBuyWin:onBuyClick( )
    if self.clickFunc then
        self.clickFunc(self.curCount,self.data)
    end
    self:onCloseClick()
end

function batchBuyWin:setBuyBtnText(str)
    self.textOnBtn:setString(str)
end

function batchBuyWin:setTitle(str)
    self.labTitle:setString(str)
end

function batchBuyWin:setMax(max)
    self.max = max
    self.ctl:setMaximumValue(max)
end

function batchBuyWin:setCloseFunc(func)
    self.closeFunc = func
end

--关闭按钮回调
function batchBuyWin:onCloseClick()
    if self.closeFunc then
        self.closeFunc()
    end
    if self:getParent() then
        self:removeSelfSafety()
        --self:getParent():removeChild(self)
        --self:removeSelf()
        GameNet:unRegisterProtocal(16003)
    end
end
function batchBuyWin:close()
    self:onCloseClick()
end


return batchBuyWin