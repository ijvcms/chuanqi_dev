--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-02-21 17:22:55
-- boss之家
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BossHomeView = BossHomeView or class("BossHomeView", BaseView)

function BossHomeView:ctor()
	self.ccui = cc.uiloader:load("resui/bossHomeWin.ExportJson")
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function BossHomeView:init()
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "mainLayer")
	for i=1,6 do
		self["item"..i] = cc.uiloader:seekNodeByName(self.ccui, "item"..i)
	end
	self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "goBtn")
	self.time = cc.uiloader:seekNodeByName(self.ccui, "time")
	self.time:setString("")
	self.goBtn:setTouchEnabled(true)
	self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.selectItem then
            	local data = self.selectItem:getData()
            	GameNet:sendMsgToSocket(11033,{scene_id = data.scene_id})
            end
            -- if self.itemData then
            -- 	GlobalController.welfare:RequestReceiveReward(self.itemData.key)
            -- end
         end     
        return true
    end)
 	
 	self.timeDataDic = {}

	self.bossDatas = configHelper:getSelfBossConfig()
	self.itemList = {}
	self.itemListDic = {}

	self.listView = SCUIList.new {
        viewRect = cc.rect(0,0,366, 468),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer):pos(18,5)
    self.refreshTime = 0

    self.selectItem = nil

	self.prizeListItem = {}
    for i=1,6 do
            --local vo = goodsList[i]
            local item = CommonItemCell.new()
            self["item"..i]:addChild(item)
            --item:setData({goods_id = vo[1], is_bind = vo[2], num = vo[3]})
            --item:setCount(1)
            item:setPosition(37,37)
            item:setScale(0.9)
            self.prizeListItem[i] = item
    end
end




function BossHomeView:touchListener(event)
local listView = event.listView
	--dump(event)
    if "clicked" == event.name then
    	local index = 1
    	if event.point.x > 182 then
    		index = (event.itemPos - 1)*2+1;
    	else
    		index = (event.itemPos - 1)*2;
    	end
    	index = index +1;
    	if self.selectItem then
    		self.selectItem:setSelect(false)
    	end
    	self.selectItem = self.itemList[index]
    	self.selectItem:setSelect(true)
    	self:update()
    	-- if self.config then
    	-- 	self.currentIndex = event.itemPos

    	-- 	if self.lastClick then
    	-- 		if self.lastClick:getChildByTag(999) then
    	-- 			self.lastClick:removeChildByTag(999, true)
    	-- 		end
    	-- 	end

    	-- 	self.lastClick = self.itemList[event.itemPos]
 
    	-- 	if self.lastClick then
    	-- 		local tip = display.newScale9Sprite("#welfare_select.png",0,0,cc.size(186, 266))
    	-- 		self.lastClick:addChild(tip, 999)
    	-- 		tip:setTag(999)
    	-- 		tip:setPosition(tip:getContentSize().width/2 - 5, tip:getContentSize().height/2 - 4)
    	-- 	end

    	-- 	self:handlerReward(self.config[event.itemPos])
    	-- end
     elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function BossHomeView:update()
	local list = self.selectItem:getData().drop_list
	for i=1,#self.prizeListItem do
		local item = self.prizeListItem[i]
		if list[i] then
			item:setData({goods_id = list[i], is_bind = 1, num = 1})
	        item:setCount(1)
	        item:setVisible(true)
	    else
	    	item:setVisible(false)
    	end
	end
end

function BossHomeView:refreshItem(data)
	if data.type == 5 then
		for i=1,#data.boss_list do
			self.timeDataDic[data.boss_list[i].monster_id] = data.boss_list[i]
		end
		local newData = {}
		for i=1,#self.bossDatas do
			local d = self.bossDatas[i]
			if self.timeDataDic[d.boss_id] then
				table.insert(newData,d)
			end
		end

		self.bossDatas = newData

		local num = 0
		for i=1,math.ceil(#self.bossDatas/2) do
			local item = self.listView:newItem()
			local node = display.newNode()
			node:setContentSize(366,190)
			num = num +1
			if num <= #self.bossDatas then
				local content = require("app.modules.worldBoss.view.BossHomeViewItem").new(self.bossDatas[num])
				node:addChild(content)
				self.itemList[num] = content
				content:setPosition(0,0)
				self.itemListDic[self.bossDatas[num].boss_id] = content
			end
			if num <= #self.bossDatas then
				num = num +1
				local content2 = require("app.modules.worldBoss.view.BossHomeViewItem").new(self.bossDatas[num])
				content2:setPosition(180, 0)
				node:addChild(content2)
				self.itemList[num] = content2
				self.itemListDic[self.bossDatas[num].boss_id] = content2
			end

			item:addContent(node)
		    item:setItemSize(366, 190)
			self.listView:addItem(item)
		end
		self.listView:reload()

		if self.selectItem == nil then
		    self.selectItem = self.itemList[1]
		    self.selectItem:setSelect(true)
		    self:update()
		end

		for i=1,#self.itemList do
			local monster_id = self.itemList[i]:getData().boss_id
			if self.timeDataDic[monster_id] then
				self.itemList[i]:updateTime(self.timeDataDic[monster_id].refresh_time)
			end
		end
	end
end

-- function BossHomeView:refreshCopyTime()
-- 	-- for i=1,#self.itemList do
-- 	-- 	local monster_id = self.itemList[i]:getData().boss_id
-- 	-- 	if self.timeDataDic[monster_id] then
-- 	-- 		self.timeDataDic[monster_id].refresh_time = self.timeDataDic[monster_id].refresh_time -1
-- 	-- 		if self.timeDataDic[monster_id].refresh_time < 0 then
-- 	-- 			self.timeDataDic[monster_id].refresh_time = 0
-- 	-- 		end
-- 	-- 		self.itemList[i]:updateTime(self.timeDataDic[monster_id].refresh_time)
-- 	-- 	end
-- 	-- end
-- 	self.refreshTime = self.refreshTime -1
-- 	if self.refreshTime < 0 then
-- 		self.refreshTime = 0
-- 	end
-- 	self.time:setString(StringUtil.convertTime(self.refreshTime))
-- end

function BossHomeView:setTimeInfo(data)
	self.refreshTime = data.data.instance_left_time
	self.time:setString(StringUtil.convertTime(self.refreshTime))
end

function BossHomeView:open()
	GlobalController.boss:requestGZBossList(5)

 	-- if self.timeSches == nil then
  --   	self.timeSches = scheduler.scheduleGlobal(handler(self, self.refreshCopyTime), 1)
  --   end
    GlobalEventSystem:removeEventListener(CopyEvent.COPY_BOSS_INFO)
    GlobalEventSystem:addEventListener(CopyEvent.COPY_BOSS_INFO,handler(self,self.setTimeInfo))
	GameNet:sendMsgToSocket(10016)

end

function BossHomeView:close()
 	if self._change_handle then
		GlobalEventSystem:removeEventListenerByHandle(self._change_handle)
		self._change_handle = nil
	end
	-- if self.timeSches then
 --        scheduler.unscheduleGlobal(self.timeSches)
 --        self.timeSches = nil
 --    end
    GlobalEventSystem:removeEventListener(CopyEvent.COPY_BOSS_INFO)
end

function BossHomeView:destory()

	if self.itemList and #self.itemList > 0 then
		for i=1,#self.itemList do
			self.itemList[i]:destory()
		end
	end
	self.selectItem = nil
	self.itemList = {}
	self.itemListDic = {}
	self.listView:removeAllItems()

	self:close()
	BossHomeView.super.destory(self)

	-- if self.timeSches then
 --        scheduler.unscheduleGlobal(self.timeSches)
 --        self.timeSches = nil
 --    end
end

return BossHomeView