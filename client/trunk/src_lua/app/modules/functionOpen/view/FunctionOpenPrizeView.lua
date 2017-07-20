--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-22 20:11:58
-- 功能开放奖励面板
local FunctionOpenPrizeView = class("FunctionOpenPrizeView", BaseView)
function FunctionOpenPrizeView:ctor(winTag,data,winconfig)
	self.data = data

     self.posList = {
        [1] = {{229,60}},
        [2] = {{159,60},{298,60}},
        [3] = {{118,60},{229,60},{340,60}},
        [4] = {{81,60},{176,60},{272,60},{368,60}},
    }

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	FunctionOpenPrizeView.super.ctor(self,winTag,data,winconfig)
	-- self.root = cc.uiloader:load("resui/storyInstanceWin.ExportJson")
	-- self:addChild(self.root)
    self.root:setPosition((display.width-680)/2,(display.height-470)/2)

    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	GlobalWinManger:closeWin(WinName.FUNCTIONOPENPRIZEVIEW)
        end
        return true
    end)
	
    self.iconLayer = self:seekNodeByName("iconLayer")

    self.functionLabel = self:seekNodeByName("functionLabel")

    self.mainLayer = self:seekNodeByName("mainLayer")
    self.reward1 = self:seekNodeByName("reward1")
    self.reward2 = self:seekNodeByName("reward2")
    self.reward3 = self:seekNodeByName("reward3")
    self.reward4 = self:seekNodeByName("reward4")

    self.mainLayer2 = self:seekNodeByName("mainLayer2")
    self.item1 = self:seekNodeByName("item1")
    self.item2 = self:seekNodeByName("item2")
    self.itemName1 = self:seekNodeByName("itemName1")
    self.itemName2 = self:seekNodeByName("itemName2")
    self.arrow = self:seekNodeByName("arrow")

    self.desLabel = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'></font>",420)
    self.desLabel:setAnchorPoint(0,1)
    self.root:addChild(self.desLabel)
    self.desLabel:setPosition(35,125)

    --右边itemBg
    self.itemBg = self:seekNodeByName("itemBg")
    self.tipsLabel = self:seekNodeByName("tipsLabel")
    self.processBar = self:seekNodeByName("processBar")--162
    self.processBar:setAnchorPoint(0,0.5)
    self.processBar:setPosition(495,171)
    self.processLabel = self:seekNodeByName("processLabel")

    self.getBtn = self:seekNodeByName("getBtn")
    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.getBtn:setScale(1)
            GameNet:sendMsgToSocket(32038, {key = self.data.id})
            GlobalWinManger:closeWin(WinName.FUNCTIONOPENPRIZEVIEW)
        end
        return true
    end)
end



function FunctionOpenPrizeView:open()
    self.functionLabel:setString(self.data.title)
    if self.iconImag then
        self.iconLayer:removeChild(self.iconImag)
        self.iconImag = nil
    end
    if self.iconImag == nil then
        print(self.data.icon)
        self.iconImag = display.newSprite("#"..self.data.icon..".png")
        self.iconLayer:addChild(self.iconImag)
        self.iconImag:setPosition(40,40)
    end
    self.desLabel:renderXml(self.data.text)

    self.prizeViewDic1 = {}
    self.prizeViewDic2 = {}

    --右边itemBg
    if self.prizeItem == nil then
        self.prizeItem = CommonItemCell.new()
        self.itemBg:addChild(self.prizeItem)
        self.prizeItem:setPosition(38,38)
    end

    local item = self.data.reward[1]
    self.prizeItem:setData({goods_id = item[1], is_bind = item[2], num = item[3]})
    self.prizeItem:setCount(item[3])
    self.tipsLabel:setString(self.data.lv.."级可领取")


    -- self.processBar = self:seekNodeByName("processBar")--162
    -- self.processLabel = self:seekNodeByName("processLabel")
    self:setType(self.data.type)
    

    -- self.processBar:setAnchorPoint(0,0.5)
    -- self.processBar = self:seekNodeByName("processBar")--162
    -- self.processLabel = self:seekNodeByName("processLabel")
    local conf = configHelper:getFunctionNotice()
    local lv = math.min(RoleManager:getInstance().roleInfo.lv,self.data.lv)
    local beginLv = 0
    local t= 1000
        for k,v in pairs(conf) do
            if v.lv < lv and lv - v.lv < t then
                t = lv - v.lv
                beginLv = v.lv
            end
        end
    --local lv = RoleManager:getInstance().roleInfo.lv
    self.processBar:setPercent(math.min((RoleManager:getInstance().roleInfo.lv/self.data.lv)*100,100))
    if RoleManager:getInstance().roleInfo.lv >= self.data.lv then
        self.processLabel:setString("已达成")
    else
        self.processLabel:setString(RoleManager:getInstance().roleInfo.lv.."/"..self.data.lv)
    end
end


function FunctionOpenPrizeView:setType(ctype)
    local itemList = self.data.goods_id
    if ctype == 1 then
        self.mainLayer:setVisible(true)
        self.mainLayer2:setVisible(false)
       local pos = self.posList[#itemList]
       for i=1,4 do
            if itemList[i] then
                self["reward"..i]:setVisible(true)
                local item = self.prizeViewDic1[i]
                if item == nil then
                    item = CommonItemCell.new()
                    self["reward"..i]:addChild(item)
                    item:setPosition(38,38)
                    self.prizeViewDic1[i] = item
                end
                self["reward"..i]:setPosition(pos[i][1],pos[i][2])
                local vo = itemList[i]
                item:setData({goods_id = vo[1], is_bind = vo[2], num = vo[3]})
                item:setCount(vo[3])
            else
                self["reward"..i]:setVisible(false)
            end
       end

    elseif ctype == 2 then
        self.mainLayer:setVisible(false)
        self.mainLayer2:setVisible(true)
        
         for i=1,2 do
            if itemList[i] then
                
                local item = self.prizeViewDic2[i]
                if item == nil then
                    item = CommonItemCell.new()
                    self["item"..i]:addChild(item)
                    item:setPosition(38,38)
                    self.prizeViewDic2[i] = item
                end
                local vo = itemList[i]
                local strenLV = vo[4] or 0
                local soulLv = vo[5] or 0
                item:setData({goods_id = vo[1], is_bind = vo[2], num = vo[3],stren_lv = strenLV,soul = soulLv})
                item:setCount(vo[3])
                local goodsConf = configHelper:getGoodsByGoodId(vo[1])
                self["itemName"..i]:setString(goodsConf.name)
            end
       end
    end
end


function FunctionOpenPrizeView:close()
    FunctionOpenPrizeView.super.close(self)
    self.prizeViewDic1 = {}

    self.prizeViewDic2 = {}
end


--清理界面
function FunctionOpenPrizeView:destory()
	
end

return FunctionOpenPrizeView