--
-- Author: Yi hanneng
-- Date: 2016-08-10 21:07:46
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
local HomelessBossItem = HomelessBossItem or class("HomelessBossItem", UIAsynListViewItemEx)
function HomelessBossItem:ctor(loader, layoutFile)
	--self.ccui = cc.uiloader:load("resui/homelessBossItem.ExportJson")
    
    self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function HomelessBossItem:init()
    self.itemList = {}
	self.headIcon = cc.uiloader:seekNodeByName(self.ccui, "headIcon")
    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
    self.locationLabel = cc.uiloader:seekNodeByName(self.ccui, "locationLabel")
    self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
    self.rewardLayer = cc.uiloader:seekNodeByName(self.ccui, "rewardLayer")
    self.lvLabel = cc.uiloader:seekNodeByName(self.ccui, "lvLabel")
    self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
    self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")


    self.itembg = display.newSprite()--display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png")
    self.headIcon:addChild(self.itembg)
    self.itembg:setTag(100)
    self.itembg:setPosition(self.headIcon:getContentSize().width/2, self.headIcon:getContentSize().height/2)
    
end

function HomelessBossItem:setData(data)

	if data == nil or (data ~= nil and self.data == data) then
        return 
    end
    
    self.data = data

    self.nameLabel:setString(configHelper:getMonsterNameById(data.boss_id))
    self.lvLabel:setString(configHelper:getMonsterLvById(data.boss_id))
   	self.timeLabel:setString(data.refresh_time)
	self.locationLabel:setString(data.desc)

    local path = "res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png"
    --[[
    if self.headIcon:getChildByTag(100) then
    	self.headIcon:removeChildByTag(100, true)
    end
    
    local path = "res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png"
    
    self.itembg = display.newFilteredSprite()--display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png")
    self.headIcon:addChild(self.itembg)
    self.itembg:setTag(100)
    self.itembg:setPosition(self.headIcon:getContentSize().width/2, self.headIcon:getContentSize().height/2)
    --]]
    local fileUtil = cc.FileUtils:getInstance()
    --清掉原来的物品精灵
    --self.itembg:clearFilter()
    --设置物品精灵
    if fileUtil:isFileExist(path) then
        display.addImageAsync(path, function()
            if self.itembg then
                self.itembg:setTexture(path)
            end
        end)
         
    else
        self.itembg:setTexture("common/input_opacity1Bg.png")
    end

    local itemWidth = 0
    local itemHeight = 0

    if #self.itemList > 0 then

        for i=#self.itemList,#data.drop_list + 1, -1 do
            self.itemList[i]:setVisible(false)
        end

        for i=1,#data.drop_list do
            if self.itemList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = data.drop_list[i]})
                item:setTouchSwallowEnabled(false)
                self.rewardLayer:addChild(item)
                item:setScale(0.8)
                self.itemList[#self.itemList + 1] = item
                    
                itemWidth = item:getContentSize().width*0.8 + 10
                itemHeight = item:getContentSize().height*0.8 + 10

                item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2)
            else
                self.itemList[i]:setVisible(true)
                self.itemList[i]:setData({goods_id = data.drop_list[i]})
                itemWidth = self.itemList[i]:getContentSize().width*0.8 + 10
                itemHeight = self.itemList[i]:getContentSize().height*0.8 + 10
            end
 
        end
    else
        for i=1,#data.drop_list do
                
            local item = CommonItemCell.new()
            item:setData({goods_id = data.drop_list[i]})
            item:setTouchSwallowEnabled(false)
            self.rewardLayer:addChild(item)
            item:setScale(0.8)
            self.itemList[#self.itemList + 1] = item
            	
     		itemWidth = item:getContentSize().width*0.8 + 10
     		itemHeight = item:getContentSize().height*0.8 + 10

            item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2)
        
        end
    end

    self.rewardLayer:setContentSize(cc.size(itemWidth*#data.drop_list, itemHeight))
    self.rewardLayer:setPositionX(self.titleLabel:getPositionX() - self.rewardLayer:getContentSize().width/2)
 
end

function HomelessBossItem:setSelect(b)
	if b then
		self.bg:setSpriteFrame("boss_frame4.png")
		self.headIcon:setSpriteFrame("boss_headframe2.png")
	else
		self.bg:setSpriteFrame("boss_frame3.png")
		self.headIcon:setSpriteFrame("boss_headframe.png")
	end
end

function HomelessBossItem:getData()
	return self.data
end

function HomelessBossItem:destory()
end

return HomelessBossItem