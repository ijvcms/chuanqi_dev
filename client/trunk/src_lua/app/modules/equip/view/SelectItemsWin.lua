--
-- Author: Yi hanneng
-- Date: 2016-01-21 11:09:10
--
local SelectItemsWin = SelectItemsWin or class("selectItemsWin", BaseView)

local GoodsUtil = require("app.utils.GoodsUtil")

function SelectItemsWin:ctor(data)
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)
 
	local ccui = cc.uiloader:load("resui/selectItemsWin_1.ExportJson")
  	self:addChild(ccui)
    ccui:setPosition(display.width/2 - ccui:getContentSize().width/2,display.height/2 - ccui:getContentSize().height/2)
 
    cc.uiloader:seekNodeByName(ccui, "selectgoods"):setString(data.name)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            if not cc.rectContainsPoint(ccui:getBoundingBox(), event) then
                self:onCloseClick()
            end
        end     
        return true
    end)

    --[[
    self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(0,0,300, 420),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(ccui):pos(46, 34)
    --]]

    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, 290, 350)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listViewAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/selectItemsWin_2.ExportJson", "app.modules.equip.view.SelectItem", 20)
    self.listView:setAdapter(self.listViewAdapter)
    ccui:addChild(self.listView)
    self.listView:setPosition(14, 14) 
    self.listView:onTouch(handler(self, self.itemClick))
    --self.listView:setLoadFunc(handler(self, self.load))
    --self.listView:setSort(self.currentSortType)

    self.data = data
    self:setViewInfo(data)

end

function SelectItemsWin:itemClick(event)

    if "clicked" == event.name then
        -- GUIDE CONFIRM
        GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_EQUIP_SEL_LIST)
        local item = event.item:getChildByTag(11)--UIListViewItem.CONTENT_TAG
        item:setSelected(true)
        local data = self.listViewAdapter:getItem(event.itemPos)
        data.type = self.data.type
        data.from = self.data.from
        GlobalEventSystem:dispatchEvent(EquipEvent.SELECT_GOODS_SUCCESS,data)
        self:onCloseClick()
    end

end

function SelectItemsWin:setViewInfo(data)
    local list = {}

    if data.bodyEquiplist then
        for i=1,#data.bodyEquiplist do
            local good_id = data.bodyEquiplist[i].goods_id
            local subTypeName,subType = configHelper:getEquipTypeByEquipId(good_id)
            --屏蔽掉登陆戒指
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(good_id)

            --筛选勋章和翅膀
            
            if subType ~= 5 and subType ~= 13 and subType ~= 15 and not isLoginRing then
            list[#list + 1] = data.bodyEquiplist[i]
            end
        end
    end
    
    if data.bagEquipList then
        for k,v in pairs(data.bagEquipList) do
            local good_id = v.goods_id
            local subTypeName,subType = configHelper:getEquipTypeByEquipId(good_id)
            local isLoginRing = GoodsUtil.isLoginSpecialRingByGoodId(good_id)
            if v.num > 0 and subType ~= 5 and subType ~= 13 and subType ~= 15 and not isLoginRing then
                list[#list + 1] = v
            end
        end
    end
    self.listViewAdapter:setData(list)

    --[[
	if data.bodyEquiplist then
		for i=1,#data.bodyEquiplist do
            local subTypeName,subType = configHelper:getEquipTypeByEquipId(data.bodyEquiplist[i].goods_id)
            --筛选勋章和翅膀
            if subType ~= 5 and subType ~= 13 and subType ~= 15 then
			local content = require("app.modules.equip.view.SelectItem").new(data.bodyEquiplist[i])
            if self.data.type == 1 then
                local equipItem = configHelper:getEquipValidAttrByEquipId(data.bodyEquiplist[i].goods_id)
                if equipItem[1][1] == "hp" then
                    content:setDes(self:getName(equipItem[1][1])..":"..equipItem[1][2])
                else
                    content:setDes(self:getName(equipItem[1][1])..":"..equipItem[1][2].."-"..equipItem[2][2])
                end
                
            end
			self.itemList[#self.itemList + 1] = content
			local item = self.listView:newItem()
			item:addContent(content)
			item:setItemSize(content:getContentSize().width, content:getContentSize().height)
			self.listView:addItem(item)
            end
		end
	end
	
	if data.bagEquipList then
		for k,v in pairs(data.bagEquipList) do
            local subTypeName,subType = configHelper:getEquipTypeByEquipId(v.goods_id)
            if v.num > 0 and subType ~= 5 and subType ~= 13 and subType ~= 15 then
    			local content = require("app.modules.equip.view.SelectItem").new(v)
                if self.data.type == 2 then
                    content:setDes(configHelper:getGoodDescByGoodId(v.goods_id))
                elseif self.data.type == 1 then
                    local equipItem = configHelper:getEquipValidAttrByEquipId(v.goods_id)
                    if equipItem[1][1] == "hp" then
                        content:setDes(self:getName(equipItem[1][1])..":"..equipItem[1][2])
                    else
                        content:setDes(self:getName(equipItem[1][1])..":"..equipItem[1][2].."-"..equipItem[2][2])
                    end
                end
    			self.itemList[#self.itemList + 1] = content
    			local item = self.listView:newItem()
    			item:addContent(content)
    			item:setItemSize(content:getContentSize().width, content:getContentSize().height)
    			self.listView:addItem(item)
            end
		end
	end

	self.listView:reload()
    --]]
end


function SelectItemsWin:onCloseClick( )
    self.listView:onCleanup()
    if self:getParent() then
        --self:setVisible(false)
        self:removeSelfSafety()
    end
end

return SelectItemsWin