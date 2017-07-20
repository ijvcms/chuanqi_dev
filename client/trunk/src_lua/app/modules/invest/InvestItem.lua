--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 投资Item
local InvestItem = class("InvestItem", BaseView)
function InvestItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/investItem.ExportJson")
	self:addChild(self.root)

    self.getBtn = self:seekNodeByName("getBtn")
    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.getBtn:setScale(1)
           	GameNet:sendMsgToSocket(30007,{type = self.data.type,key = self.data.value})
        end
        return true
    end)

    self.itemBg = self:seekNodeByName("itemBg")
    self.tipsLabel = self:seekNodeByName("tipsLabel")
    self.getBtn:setVisible(false)
    --self.itemBg = self:seekNodeByName("itemBg")
end

function InvestItem:open(datas)
    self.data = datas
    if self.item == nil then
        self.item = CommonItemCell.new()
        self.itemBg:addChild(self.item)
         self.item:setPosition(40,40)
    end
    self.item:setData({goods_id = self.data.goods[1][1], is_bind = self.data.goods[1][2], num = self.data.goods[1][3]})
    self.item:setCount(self.data.goods[1][3])

    self.tipsLabel:setString(datas.des)
    if false then
        -- self.getBtn:setVisible(true)
        -- self.getBtn:setButtonLabelString("已领取")
        -- self.getBtn:setButtonEnabled(false)
    else
        self.getBtn:setVisible(true)
        --0未获得，1可领取，2已领取
        if datas.states and datas.states == 1 then
            self.getBtn:setButtonLabelString("领取")
            self.getBtn:setButtonEnabled(true)
        elseif datas.states and datas.states == 2 then
            self.getBtn:setButtonLabelString("已领取")
            self.getBtn:setButtonEnabled(false)
        else
            self.getBtn:setButtonLabelString("领取")
            self.getBtn:setButtonEnabled(false)
        end
    end
end

function InvestItem:close()
    InvestItem.super.close(self)
    if self.item then
        self.item:destory()
        self.itemBg:removeChild(item)
        self.item = nil
    end
end

--清理界面
function InvestItem:destory()
    self:close()
	
end

return InvestItem