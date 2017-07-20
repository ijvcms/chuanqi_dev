--
-- Author: Yi hanneng
-- Date: 2016-03-31 18:54:28
--

--[[
	-----------附近------------
--]]
local NearView = NearView or class("NearView", function() return display.newNode()end)
function NearView:ctor()
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,80))
	self.bg:setContentSize(display.width, display.height)
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addChild(self.bg)
	self.ccui = cc.uiloader:load("resui/NearByWin.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self.ccui:setPosition(0-230,84+88)
    self.ccui:setPosition(0,84+88)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            self:close()
        end
        return true
    end)
    --transition.moveTo(self.ccui, {x =0, time = 0.1})
    self:init()
end

function NearView:init()
 
 	self.lastClickItem = nil
    self.mainbg2 = cc.uiloader:seekNodeByName(self.ccui, "mainbg2")

    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0,0,210, 214)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,210, 214))
    self.listView:onTouch(handler(self, self.touchListener))
    self.listView:setPosition(4, 3)

    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/NearByItem.ExportJson", "app.modules.near.view.NearItem", 6)
    self.listView:setAdapter(self.rankListAdapter)
    self.mainbg2:addChild(self.listView)
	
	self.btnList = {}
	self.btnList[1] = cc.uiloader:seekNodeByName(self.ccui, "btnPlayer")
	self.btnList[2] = cc.uiloader:seekNodeByName(self.ccui, "btnMonster")
	-- self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "btnClose")
    
	-- self.closeBtn:setTouchEnabled(true)
	-- self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
 --        if event.name == "began" then
 --            self.closeBtn:setScale(1.1)
 --        elseif event.name == "ended" then
 --            self.closeBtn:setScale(1)
 -- 			self:close()
 --        end
 --        return true
 --    end)


    for i=1,#self.btnList do
		
		self.btnList[i]:setTouchEnabled(true)
		self.btnList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
             
        elseif event.name == "ended" then
            if self.lastClickMenu ~= nil then
            	self.lastClickMenu:setSpriteFrame("com_labBtn1.png")
            end

            self.btnList[i]:setSpriteFrame("com_labBtn1Sel.png")
        	self.lastClickMenu  = self.btnList[i]
        	self:btnTag(i)
        end     
		return true
	    end)
  	end

  	self.btnList[1]:setSpriteFrame("com_labBtn1Sel.png")
    self.lastClickMenu  = self.btnList[1]
    self:btnTag(1)

end

function NearView:btnTag(index)
	self.currentIndex = index
--1:玩家。2:怪
	if index == 1 then
		self:setViewInfo(GlobalController.fight.playerViewArr)
	elseif index == 2 then
 		self:setViewInfo(GlobalController.fight.monsterViewArr)
	end
end

function NearView:setViewInfo(data)
	if data == nil then
		return 
	end
 	self.lastClickItem = nil
	local list = {}

	for k,v in pairs(data) do
	 
 		if v.vo.monster_id > 0 and v.vo.mConf.type > 1 or ( v.vo.career > 0 and v.vo.id ~= RoleManager:getInstance().roleInfo.player_id )then
			
			table.insert(list, v.vo)
		end
	end

	self.rankListAdapter:setData(list)

end

function NearView:touchListener(event)
	local listView = event.listView
 
    if "clicked" == event.name then

    	local item = event.item:getChildByTag(11)

    	if item ~= self.lastClickItem then
    		if  self.lastClickItem then
    			self.lastClickItem:setSelect(false)
    		end
    		
    		self.currentPos = event.itemPos
        	self.lastClickItem = item
	 		item:setSelect(true)

	 		FightModel:setSelAtkTarVO(item:getData())
            local role = GlobalController.fight:getRoleModel(item:getData().id,item:getData().type)
            if role then
            	role:setSelect(true)
            end
	 		
    	end
    elseif "moved" == event.name then
         
    elseif "ended" == event.name then

    end
end

function NearView:open()
	 
end

function NearView:close()
 
	self:removeSelf()
end

return NearView