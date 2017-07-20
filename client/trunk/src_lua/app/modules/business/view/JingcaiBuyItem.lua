--
-- Author: Yi hanneng
-- Date: 2016-09-26 19:29:39
--
 
local JingcaiBuyItem = JingcaiBuyItem or class("JingcaiBuyItem", BaseView)

function JingcaiBuyItem:ctor()
	self.ccui = cc.uiloader:load("resui/jingcaiBuyItem.ExportJson")
    --self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function JingcaiBuyItem:init()
 
    self.itemList = {}
    self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
    self.compoundBtn = cc.uiloader:seekNodeByName(self.ccui, "buyBtn")
    self.item = cc.uiloader:seekNodeByName(self.ccui, "item")
    self.priceOld = cc.uiloader:seekNodeByName(self.ccui, "priceOld")
    self.priceNow = cc.uiloader:seekNodeByName(self.ccui, "priceNow")
    self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")

    self.coin1 = cc.uiloader:seekNodeByName(self.ccui, "coin1")
    self.coin2 = cc.uiloader:seekNodeByName(self.ccui, "coin2")
 
 	self.compoundBtn:setTouchEnabled(true)
    self.compoundBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.compoundBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.compoundBtn:setScale(1.0)
            if self.itemClickFunc then
            	self.itemClickFunc(self.data)
            end
        end
        return true
    end)


 
end

function JingcaiBuyItem:setData(data)

	if data == nil then
		 
        return 
    end
 
    self.data = data

    if data.count < 1 then
        self.compoundBtn:setButtonEnabled(false)
        self.compoundBtn:setButtonLabelString("已抢光")
    else
        self.compoundBtn:setButtonEnabled(true)
        self.compoundBtn:setButtonLabelString("抢购")
    end
 
    self.titleLabel:setString(data.content)
    self.priceOld:setString(data.old_price[1].num)
    self.priceNow:setString(data.new_price[1].num)
    self.numLabel:setString(data.count)

    if self.commonItem == nil then
        self.commonItem = CommonItemCell.new()
        self.commonItem:setData({goods_id = data.shop[1].goods_id,is_bind = data.shop[1].is_bind })
        self.item:addChild(self.commonItem, 10,10)
        self.commonItem:setPosition(self.item:getContentSize().width/2, self.item:getContentSize().height/2)
        --self.commonItem:setScale(0.8)
    else
        self.commonItem:setData({goods_id = data.shop[1].goods_id,is_bind = data.shop[1].is_bind })
    end

    local oldIconId = configHelper:getIconByGoodId(data.old_price[1].goods_id)
    --图标id
    local oldPath = ResUtil.getGoodsIcon(oldIconId)
    --是否存在这个文件
    local fileUtil = cc.FileUtils:getInstance()
    --设置物品精灵
    if fileUtil:isFileExist(oldPath) then
        display.addImageAsync(oldPath, function()
 
            if self.coin1 then
                self.coin1:setTexture(oldPath)
                self.coin1:setScale(0.5)
            end
            
            
        end)
 
    else
        self.coin1:setTexture("common/input_opacity1Bg.png")
    end

    local newIconId = configHelper:getIconByGoodId(data.new_price[1].goods_id)
    --图标id
    local newPath = ResUtil.getGoodsIcon(newIconId)
    --是否存在这个文件
    local fileUtil = cc.FileUtils:getInstance()
    --设置物品精灵
    if fileUtil:isFileExist(newPath) then
        display.addImageAsync(newPath, function()
 
            if self.coin2 then
                self.coin2:setTexture(newPath)
                self.coin2:setScale(0.5)
            end
            
        end)
 
    else
        self.coin2:setTexture("common/input_opacity1Bg.png")
    end
 
end

function JingcaiBuyItem:setItemClick(func)
	self.itemClickFunc = func
end

function JingcaiBuyItem:getData()
	return self.data
end

return JingcaiBuyItem