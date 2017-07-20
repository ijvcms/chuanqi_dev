--
-- Author: Yi hanneng
-- Date: 2016-01-13 10:54:14
--
import("app.modules.bag.view.TipsEquip")
import("app.modules.bag.view.TipsProp")
local PageManager = require("app.modules.bag.view.PageManager")
local ChatBagView = ChatBagView or class("ChatBagView", BaseView)
function ChatBagView:ctor(winTag, data, winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:addChild(self.bg)
    
    ChatBagView.super.ctor(self, winTag, data, winconfig)
	
 	local closeBtn = self:seekNodeByName("closeBtn")--cc.uiloader:seekNodeByName(self.root, "closeBtn")
    closeBtn:setTouchEnabled(true)
    closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            closeBtn:setScale(1)
            self:showTipsByType(-1)
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)

    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     if event.name == "began" then
    --     elseif event.name == "ended" then
    --         if not cc.rectContainsPoint(self.root:getBoundingBox(), event) then
    --             self:showTipsByType(-1)
    --         end
    --     end     
    --     return true
    -- end)

    self.leftLay = self:seekNodeByName("leftLay")---cc.uiloader:seekNodeByName(self.root, "leftLay")
	local pageManager = PageManager.new(self.leftLay,3,45,{colum = 5,rows = 4,pageWidth = 410,pageHeight = 346,pageOfNum = 5,pageCapacity = 20})
    pageManager:SetOnItemsSelectedHandler(function(event)
        local data       = event.data
        local isSelected = event.isSelected
        self:onStoreItemClick(data, isSelected)
    end)

    self.pageManager = pageManager


 	self.tipsDefault = self:seekNodeByName("commontxt")--cc.uiloader:seekNodeByName(self.root, "commontxt")
 	self.tipsDefault:setAnchorPoint(0,0)

    self.rightLay = self:seekNodeByName("rightLay") --cc.uiloader:seekNodeByName(self.root, "rightLay")

    self.tipsEquip = TipsEquip.new()
    self.tipsEquip:setAnchorPoint(0,0)
    self.rightLay:addChild(self.tipsEquip)
    self.tipsEquip:setVisible(false)
    self.tipsEquip:setPosition(0,0)

    self.tipsProp = TipsProp.new()
    self.tipsProp:setAnchorPoint(0,0)
    self.rightLay:addChild(self.tipsProp)    	
    self.tipsProp:setVisible(false)

    self.tipsProp:setPosition(0,0)

 	--self:setPosition(715, 230)
end

function ChatBagView:refreshData()
    self.pageManager:SetPageItemsData(BagManager:getInstance().bagInfo:getTotalList())
end

function ChatBagView:onStoreItemClick(itemData, isSelected)
    self.curItemData = itemData

        local goodType = configHelper:getGoodTypeByGoodId(itemData.goods_id)
        if not goodType then return end
        
        if goodType == 2 then
            if self.tipsEquip then
                self.tipsEquip:setData(itemData, true)
            end
            self:showTipsByType(2)
            
        elseif goodType == 1 or goodType == 6 or goodType == 7 or goodType == 4 or goodType == 3  then
            if self.tipsProp then
                self.tipsProp:setData(itemData, true)
            end
            self:showTipsByType(1)
            
        end
    
end

function ChatBagView:showTipsByType(tt)
 
    if tt == 1 then                                         --显示道具tips
         
        if self.tipsEquip ~= nil then
            self.tipsEquip:setVisible(false)
        end
        if self.tipsProp  ~= nil  then
            self.tipsProp:setVisible(true)
        end
        if self.tipsDefault  ~= nil  then
            self.tipsDefault:setVisible(false)
        end
    elseif tt == 2 then                                     --显示装备tips
        
        if self.tipsEquip  ~= nil  then
            self.tipsEquip:setVisible(true)
        end
        if self.tipsProp  ~= nil  then
            self.tipsProp:setVisible(false)
        end
        if self.tipsDefault  ~= nil  then
            self.tipsDefault:setVisible(false)
        end
    else
    	if self.tipsProp  ~= nil  then
            self.tipsProp:setVisible(false)
        end
    	if self.tipsEquip ~= nil then
            self.tipsEquip:setVisible(false)
        end
    	if self.tipsDefault  ~= nil  then
            self.tipsDefault:setVisible(true)
        end
    	 
    end

    self.pageManager:SetItemsSelectVisible(false)
    self.pageManager:ResetItemsSelectState()
end



function ChatBagView:open()
    self:refreshData()
end

function ChatBagView:close()

end
 
 function ChatBagView:destory()
    self.super.destory(self)
 end

return ChatBagView