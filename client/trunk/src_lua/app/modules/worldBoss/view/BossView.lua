--
-- Author: Yi hanneng
-- Date: 2016-08-04 14:26:07
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")


local BossItem = BossItem or class("BossItem", BaseView)
local BossHomeItem = BossHomeItem or class("BossHomeItem", BaseView)
--local HomelessBossItem = HomelessBossItem or class("HomelessBossItem", UIAsynListViewItemEx)
 
local BossView = BossView or class("BossView", BaseView)

function BossView:ctor(winTag,data,winconfig)
	BossView.super.ctor(self,winTag,data,winconfig)
    self:init()
    self.isCancelRemoveSpriteFrams = true
end

function BossView:init()

	self.currentTabIndex = 0
	self.lastTab = nil
    self.currentClickItem = nil
	self.currentSelectData = nil
	self.itemTimeList = {}
    self.timeNum = 0

	local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")
    --
    self.rightLayer4 = cc.uiloader:seekNodeByName(win,"rightLayer4")
    self.rightLayer2 = cc.uiloader:seekNodeByName(win,"rightLayer2")
    self.rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")
    self.leftBottomLayer = cc.uiloader:seekNodeByName(win,"leftBottomLayer")
    self.rateLabel = cc.uiloader:seekNodeByName(win,"rateLabel")
    self.locationLabel = cc.uiloader:seekNodeByName(win,"locationLabel")
    self.checkBox = cc.uiloader:seekNodeByName(win,"checkBox")

    if self.checkBox then
    	self.checkBox:onButtonClicked(handler(self, self.checkBoxClick))
    end
    self.rewardItemList = {}
    self.rightLayer3 = cc.uiloader:seekNodeByName(win,"rightLayer3")
    self.mainLayer = cc.uiloader:seekNodeByName(win,"mainLayer")
    ----------导航菜单
    self.btnList = {}
    self.btnList[1] = cc.uiloader:seekNodeByName(win,"Btn1")
    self.btnList[2] = cc.uiloader:seekNodeByName(win,"Btn2")
    self.btnList[3] = cc.uiloader:seekNodeByName(win,"Btn3")
    self.btnList[4] = cc.uiloader:seekNodeByName(win,"Btn4")
    self.btnList[5] = cc.uiloader:seekNodeByName(win,"Btn5")
    ----------
    self.dataList = {} --数据列表
    self.itemList = {}	--item列表
    self.layerList = {}	
    self.scrollViewList = {}

    for i=1,#self.btnList do
    	self.btnList[i]:setTouchEnabled(true)
    	self.btnList[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	        	self:onClick(i)
	        end     
	        return true
	    end)
    end

    self:onClick(1)

end

--刷新通知
function BossView:checkBoxClick(evt)
	
	if self.currentSelectData == nil then
		return
	end
 
	if self.checkBox:isButtonSelected() then
		GlobalController.boss:requestGZBoss(self.currentSelectData.scene_id,self.currentSelectData.boss_id,1)
	else
		GlobalController.boss:requestGZBoss(self.currentSelectData.scene_id,self.currentSelectData.boss_id,0)
	end

end
--菜单点击
function BossView:onClick(index)
	if self.currentTabIndex == index then
        return
    end
    if self.lastTab then
        self.lastTab:setSpriteFrame("com_labBtn4.png")
    end
    self.currentTabIndex = index
    self.btnList[index]:setSpriteFrame("com_labBtn4Sel.png")
    self.lastTab = self.btnList[index]

    if self.selfBossView then
        self.selfBossView:destory()
        self.rightLayer4:removeChild(self.selfBossView)
        self.selfBossView = nil
    end
    if index == 1 or index == 2 then
    	self.rightLayer3:setVisible(false)
    	self.rightLayer2:setVisible(true)
    	self.rightLayer:setVisible(true)
        self.rightLayer4:setVisible(false)
        if self.selfBossView then
            self.selfBossView:setVisible(false)
            self.selfBossView:close()
        end

    elseif index == 3 or index == 4 then

    	self.rightLayer3:setVisible(true)
    	self.rightLayer2:setVisible(false)
    	self.rightLayer:setVisible(false)
        self.rightLayer4:setVisible(false)
        if self.selfBossView then
            self.selfBossView:setVisible(false)
            self.selfBossView:close()
        end
     elseif index == 5 then
        self.rightLayer3:setVisible(false)
        self.rightLayer2:setVisible(false)
        self.rightLayer:setVisible(false)
        self.rightLayer4:setVisible(true)
        if self.selfBossView == nil then
            self.selfBossView = require("app.modules.worldBoss.view.BossHomeView").new()--735*522
            self.rightLayer4:addChild(self.selfBossView)
            --self.mainLayer:setVisible(true)
            --print(self.mainLayer:getPosition())
            self.selfBossView:setPosition(6,5)
        end
        if self.selfBossView then
            self.selfBossView:setVisible(true)
            self.selfBossView:open()
        end
    end

    self:handle(index)

end

function BossView:handle(index)

 	if self.scroll then
 		self.scroll:setVisible(false)

 	end

	self.scroll = self.scrollViewList[index]
	 
	if self.scroll then
		self.scroll:setVisible(true)
	else
		if index == 1 then
			self.layerList[index] = display.newNode()
			self.layerList[index]:setContentSize(cc.size(self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 10))
			self.scrollViewList[index] = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 10)}):addScrollNode(self.layerList[index]):pos(0,5)
			self.rightLayer:addChild(self.scrollViewList[index])
		elseif index == 2 then
			self.layerList[index] = display.newNode()
			self.layerList[index]:setContentSize(cc.size(self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 10))
			self.scrollViewList[index] = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.rightLayer:getContentSize().width - 10 , self.rightLayer:getContentSize().height - 10)}):addScrollNode(self.layerList[index]):pos(10,5)
			self.rightLayer:addChild(self.scrollViewList[index])
		elseif index == 3 then
            local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
            self.scrollViewList[index] = require("app.gameui.listViewEx.UIAsyncListView").new(params)
            self.scrollViewList[index]:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
            --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
            self.scrollViewList[index]:setPosition(5,4)
            self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/homelessBossItem.ExportJson", "app.modules.worldBoss.view.HomelessBossItem", 6)
            self.scrollViewList[index]:setAdapter(self.rankListAdapter)
            self.mainLayer:addChild(self.scrollViewList[index])
		elseif index == 4 then

            local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10)}
            self.scrollViewList[index] = require("app.gameui.listViewEx.UIAsyncListView").new(params)
            self.scrollViewList[index]:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height - 10))
            --self.scrollViewList[index]:onTouch(handler(self, self.touchListener))
            self.scrollViewList[index]:setPosition(5,8)

            self.rankListAdapter2 = require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.worldBoss.view.BossDLItem", 6)
            self.scrollViewList[index]:setAdapter(self.rankListAdapter2)
            self.mainLayer:addChild(self.scrollViewList[index])
		end

		self.scroll = self.scrollViewList[index]
        if self.scroll then
    		self.scroll:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
    		self.scroll:setTouchSwallowEnabled(false)
           
    		self:buildItem(index)
        end
	end

	if index == 3 or index == 4 then
        self:request(index)
    end
    
end
--------请求数据
function BossView:request(index)
    if index == 1 or index == 2 then
        GlobalController.boss:requestGZBossList(index)
    elseif index == 4 then
        GlobalController.boss:requestGZBossDL()
    end

end

function BossView:buildItem(index)

 
	self.itemList[index] = {}
    self.dataList[index] = {}

	if index == 1 then
        self:request(index)
	elseif index == 2 then

		local bossDataList = configHelper:getVipBossList()
 
    	local itemWidth = 0
        local itemHeight = 0

        local len = #bossDataList
        local loaded = 0

        self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
            
            if bossDataList and  loaded < len then
                loaded = loaded + 1
                local info = bossDataList[loaded]
                info.index = index
                if info then
                    local item = BossHomeItem.new()
                    item:setData(info)
                    self:selectFunc(item)
                    self.layerList[index]:addChild(item)
                    self.itemList[index][loaded] = item
                    self.dataList[index][loaded] = bossDataList[loaded]
                    itemWidth = item:getContentSize().width + 10
                    itemHeight = item:getContentSize().height + 10

                    item:setPosition(((loaded-1)%2)*itemWidth + 0,itemHeight*math.ceil(#bossDataList/2) - math.floor((loaded-1)/2)*itemHeight - itemHeight/2)
                end
            end

            if loaded == len then
                self:request(index)
                self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
                self.layerList[index]:setContentSize(cc.size(itemWidth*2, itemHeight*math.ceil(#bossDataList/2)))
                self.layerList[index]:setPosition(0, self.rightLayer:getContentSize().height - self.layerList[index]:getContentSize().height - itemHeight/2 - 10 )
            end
        end)
        self:scheduleUpdate()

	elseif index == 3 then

		local bossDataList = configHelper:getCityBossList()
        self.rankListAdapter:setData(bossDataList)
       
	elseif index == 4 then
 
	end

end
--创建掉落item
--（玩家名）在（boss死亡地点）将（boss名字）打倒在地，掉落（装备名）!
function BossView:buildDL(data)
 
    if data == nil then
        return 
    end

    data = data.data
    if #data.drop_list > 1 then
        table.sort( data.drop_list, function(a,b)return a.kill_time > b.kill_time end )
    end
    local lastTime = 0
 
    for i=1,#data.drop_list do
        if os.date("%Y-%m-%d",data.drop_list[i].kill_time) ~= os.date("%Y-%m-%d",lastTime) and #data.drop_list[i].monster_goods > 0 then
            data.drop_list[i].date = 1
            lastTime = data.drop_list[i].kill_time
        end
    end
 
    self.rankListAdapter2:setData(data.drop_list)
end

function BossView:refreshItem(data)
 
	local index = data.type
    if index == 5 then
        if self.selfBossView then
            self.selfBossView:refreshItem(data)
        end
        return 
    end
    if index == 1 then
        local list = configHelper:getWorldBossList()
        local bossDataList = {}

        for j=1,#list do

            local info = list[j]
            for i=1,#data.boss_list do
                if data.boss_list[i].monster_id == info.boss_id then
                    
                    info.time = data.boss_list[i].refresh_time
                    info.follow = data.boss_list[i].follow
                    info.index = index
                    table.insert(bossDataList, info)
                end
           end

        end
        --[[ 
        if #bossDataList > 1 then
            table.sort(bossDataList,function(a,b) return a.lv_limit < b.lv_limit end )
        end
        --]]
        --getWorldBossConfiById
        local itemWidth = 0
        local itemHeight = 0
        local len = #bossDataList
        local loaded = 0

        self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function()
            
            if bossDataList and  loaded < len then
                loaded = loaded + 1
                local info = bossDataList[loaded]
                if info then
                    info.index = index
                    local item = BossItem.new()
                    item:setData(info)
                    self:selectFunc(item)
                    self.layerList[index]:addChild(item)
                    self.itemList[index][loaded] = item
                    self.dataList[index][loaded] = bossDataList[loaded]
                    itemWidth = item:getContentSize().width + 10
                    itemHeight = item:getContentSize().height + 10

                    item:setPosition(((loaded-1)%2)*itemWidth + 10,itemHeight*math.ceil(#bossDataList/2) - math.floor((loaded-1)/2)*itemHeight - itemHeight/2)
                    
                    if self.itemTimeList[item] == nil then
                        if info.time > 0 then
                            self.itemTimeList[item] = item
                        end
                    else
                        if info.time <= 0 then
                            self.itemTimeList[item] = nil
                        end
                    end

                end
            end

            if loaded == len then
                --self:request(index)
                self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
                self.layerList[index]:setContentSize(cc.size(itemWidth*2, itemHeight*math.ceil(#bossDataList/2)))
                self.layerList[index]:setPosition(0, self.rightLayer:getContentSize().height - self.layerList[index]:getContentSize().height - itemHeight/2 - 10 )
            end
        end)
        self:scheduleUpdate()


    elseif index == 2 then
 
        for i=1,#data.boss_list do

           for j=1,#self.itemList[index] do
 
                local info = self.itemList[index][j]:getData()
                if data.boss_list[i].monster_id == info.boss_id then
                    
                    info.time = data.boss_list[i].refresh_time
                    info.follow = data.boss_list[i].follow
                    info.index = index

                    self.itemList[index][j]:setData(info)

                    if self.itemTimeList[self.itemList[index][j]] == nil then
                        if info.time > 0 then
                            self.itemTimeList[self.itemList[index][j]] = self.itemList[index][j]
                        end
                    else
                        if info.time <= 0 then
                            self.itemTimeList[self.itemList[index][j]] = nil
                        end
                    end

                end
                
           end

        end
 
    end
    --[[ 取消刷新倒计时排序
	if index == 1 or index == 2 then
 
		for i=1,#data.boss_list do

	       for j=1,#self.dataList[index] do
 
                local info = self.dataList[index][j]
                if data.boss_list[i].monster_id == info.boss_id then
                    info.time = data.boss_list[i].refresh_time
                    info.follow = data.boss_list[i].follow
                    info.index = index
                end
                
           end

	    end
 
    end
    
    table.sort( self.dataList[index], function(a,b)
        local alv = configHelper:getMonsterLvById(a.boss_id)
        local blv = configHelper:getMonsterLvById(b.boss_id)

        if a.time < b.time then
            return true
        elseif a.time > b.time then
            return false
        elseif a.time == b.time then
            if alv < blv then
                return true
            else
                return false
            end
        end
 
        end )
    
    for j=1,#self.itemList[index] do
        local item = self.itemList[index][j]
        local info = self.dataList[index][j]
         
        item:setData(info)

        if self.itemTimeList[item] == nil then
            if info.time > 0 then
                self.itemTimeList[item] = item
            end
        else
            if info.time <= 0 then
                self.itemTimeList[item] = nil
            end
        end
 
    end
    --]]

    --倒计时
    if self.timeSches == nil then
    	self.timeSches = scheduler.scheduleGlobal( handler(self, self.refreshTime), 1)
    end
   
	--默认选中第一个
    if (index == 1 or index == 2) and self.itemList[index][1] then
		if self.lastClickItem then
			self.lastClickItem:setSelect(false)
		end

		self.lastClickItem = self.itemList[index][1]
			
		if self.lastClickItem then
			self.lastClickItem:setSelect(true)
		end
        self:setViewInfo(self.itemList[index][1]:getData())
	end

end

function BossView:refreshTime()

    self.timeNum = 0

	for k,v in pairs(self.itemTimeList) do

        v:getData().time = v:getData().time - 1
        if v:getData().time > 0 then
            self.timeNum = self.timeNum + 1
            v:refreshTime(v:getData().time)
        else

            v:getData().time = 0
            self.timeNum = self.timeNum - 1
            v:refreshTime(v:getData().time)
            self.itemTimeList[k] = nil

            self.itemTimeList = {}
            scheduler.unscheduleGlobal(self.timeSches)
            self.timeSches = nil

            self:request(v:getData().index)

        end
        
    end

    if self.timeNum == 0 then
        self.itemTimeList = {}
        scheduler.unscheduleGlobal(self.timeSches)
        self.timeSches = nil
    end

end

function BossView:selectFunc(item)

	if item ~= nil then

        item:setItemBtnClickFunc(handler(self, self.itemClick))
		item:setTouchEnabled(true)
		item:setTouchSwallowEnabled(false)
    	item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
	        if self.lastClickItem then
				self.lastClickItem:setSelect(false)
			end

			self.lastClickItem = item
			
			if self.lastClickItem then
				self.lastClickItem:setSelect(true)
			end
            self:setViewInfo(item:getData())
        end     
        return true
    end)
	end

end

function BossView:itemClick(info)
 
    if info then

        if  RoleManager:getInstance().roleInfo.lv < info.lv_limit then
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"等级需要达到"..info.lv_limit.."级才能进入!")
            return
        end

        local flyShoesNum = BagManager:getInstance():findItemCountByItemId(110078)
 
        if info.index == 1 then
           
            local posArr = string.split(info.point, ",")
            local pos = cc.p(tonumber(posArr[1]),tonumber(posArr[2]))

            if flyShoesNum > 0 then
                GameNet:sendMsgToSocket(11033,{scene_id = info.scene_id})
            else
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送失败，小飞鞋不足，已开启自动寻路!")
                SceneManager:playerMoveTo(info.scene_id,pos,nil,true)
                GlobalWinManger:closeWin(self.winTag)
            end
        
        elseif info.index == 2 then
            
            local  vip = RoleManager:getInstance().roleInfo.vip
            
            if vip < info.vip_lv then
                GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"VIP等级不足"..info.vip_lv.."级，请提升VIP等级。")
            else
                if flyShoesNum > 0 then
                    GameNet:sendMsgToSocket(11033,{scene_id = info.scene_id})
                else
                    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"传送失败，小飞鞋不足!")
                end
            end
        end
    end

end

function BossView:setViewInfo(data)
	
	if data == nil then
		return 
	end
 
	self.currentSelectData = data

	self.rateLabel:setString(data.refresh_time)
	self.locationLabel:setString(data.desc)
 
	local itemWidth = 0
    local itemHeight = 0

    if #self.rewardItemList > 0 then

        for i=#self.rewardItemList,#data.drop_list + 1, -1 do
            self.rewardItemList[i]:setVisible(false)
        end

        for i=1,#data.drop_list do
            if self.rewardItemList[i] == nil then
                local item = CommonItemCell.new()
                item:setData({goods_id = data.drop_list[i]})
                item:setTouchSwallowEnabled(false)
                self.leftBottomLayer:addChild(item)
                self.rewardItemList[#self.rewardItemList+1] = item
                
                itemWidth = item:getContentSize().width + 16
                itemHeight = item:getContentSize().height + 16

                item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2)
            else
                self.rewardItemList[i]:setData({goods_id = data.drop_list[i]})
                
            end
 
        end
    else
        for i=1,#data.drop_list do
            
            local item = CommonItemCell.new()
            item:setData({goods_id = data.drop_list[i]})
            item:setTouchSwallowEnabled(false)
            self.leftBottomLayer:addChild(item)
            self.rewardItemList[#self.rewardItemList+1] = item
            
            itemWidth = item:getContentSize().width + 16
            itemHeight = item:getContentSize().height + 16

            item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2)
    
        end
    end

    

    --[[ 取消拖动
        for i=1,#data.drop_list do
            
            local item = CommonItemCell.new()
            item:setData({goods_id = data.drop_list[i]})
            item:setTouchSwallowEnabled(false)
            self.rewardLayer:addChild(item)
            self.rewardItemList[#self.rewardItemList+1] = item
 			
 			itemWidth = item:getContentSize().width + 20
 			itemHeight = item:getContentSize().height + 10

            item:setPosition((i-1)*itemWidth + itemWidth/2,itemHeight/2)
    
        end

        self.rewardLayer:setContentSize(cc.size(itemWidth*#data.drop_list, itemHeight))
        self.rewardLayer:setPosition(0 ,0)
    --]]
    self.checkBox:setButtonSelected(self.currentSelectData.follow == 1)

end

function BossView:open()
	GlobalEventSystem:addEventListener(BossEvent.BOSS_DL,handler(self,self.buildDL))
	GlobalEventSystem:addEventListener(BossEvent.BOSS_GZLIST,function(data) self:refreshItem(data.data) end)
	GlobalEventSystem:addEventListener(BossEvent.BOSS_GZSUCCESS,function(data)
        if self.lastClickItem then
            if self.checkBox:isButtonSelected() then
                GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt = "取消",
                  tipTxt = "关注成功，在线时BOSS刷新后将立即提醒您。",
                  tipShowMid = true,
                  hideBackBtn = true,
              })
                self.lastClickItem:getData().follow = 1 
            else
                self.lastClickItem:getData().follow = 0
            end
        end
    end)
end

function BossView:close()
	GlobalEventSystem:removeEventListener(BossEvent.BOSS_DL)
	GlobalEventSystem:removeEventListener(BossEvent.BOSS_GZLIST)
	GlobalEventSystem:removeEventListener(BossEvent.BOSS_GZSUCCESS)
    if self.selfBossView then   
        self.selfBossView:close()
        self.selfBossView = nil
    end
    if self.timeSches then
        scheduler.unscheduleGlobal(self.timeSches)
        self.timeSches = nil
    end
end


function BossView:destory()
    if self.selfBossView then   
        self.selfBossView:destory()
        self.selfBossView = nil
    end
    self:close()
    self.super.destory(self)
end

-----------------------------------------
--世界boss item
function BossItem:ctor()
	self.ccui = cc.uiloader:load("resui/bossItem.ExportJson")
     
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function BossItem:init()

	self.headIcon = cc.uiloader:seekNodeByName(self.ccui, "headIcon")
    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
    self.existLabel = cc.uiloader:seekNodeByName(self.ccui, "existLabel")
    self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
    self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "goBtn")
    self.lvLabel = cc.uiloader:seekNodeByName(self.ccui, "lvLabel")
    self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
    self.bgSel = cc.uiloader:seekNodeByName(self.ccui, "bgSel")
    self.bgSel:setVisible(false)
    self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.itemBtnClickFunc then
                self.itemBtnClickFunc(self.data)
            end
        end     
        return true
    end)

    --self.goBtn:setVisible(false)
 
    self.itembg = display.newSprite()--display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png")
    self.headIcon:addChild(self.itembg)
    self.itembg:setTag(100)
    self.itembg:setPosition(self.headIcon:getContentSize().width/2, self.headIcon:getContentSize().height/2)
end

function BossItem:setData(data)
 
	if data == nil or (data ~= nil and self.data == data) then
        return 
    end
    
    self.data = data

    self.nameLabel:setString(configHelper:getMonsterNameById(data.boss_id))
    self.lvLabel:setString(configHelper:getMonsterLvById(data.boss_id).."级")
 
    local path = "res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png"
 
    local fileUtil = cc.FileUtils:getInstance()
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
    self.itembg:setNodeEventEnabled(true, function(event)
        if name == "cleanup" then
            cc.Director:getInstance():getTextureCache():removeTextureForKey(path)
        end
    end)
    self:refreshTime(0)

end

function BossItem:refreshTime(times)
    if times == nil then
        times = 0
    end

    self.timeLabel:setString(StringUtil.convertTime(times))

	if times > 0 then
		self.timeLabel:setVisible(true)
		self.existLabel:setVisible(false)
        self.goBtn:setButtonLabelString("前往等待")
		--self.goBtn:setVisible(false)
	else
		self.timeLabel:setVisible(false)
		self.existLabel:setVisible(true)
		--self.goBtn:setVisible(true)
        self.goBtn:setButtonLabelString("立即前往")
	end
end

function BossItem:setItemClickFunc(func)
	self.itemClickFunc = func
end

function BossItem:setItemBtnClickFunc(func)
    self.itemBtnClickFunc = func
end

function BossItem:setSelect(b)
	if b then
		self.bgSel:setVisible(true)
	else
		self.bgSel:setVisible(false)
	end
end

function BossItem:getData()
	return self.data
end

function BossItem:destory()
end
-----------------------------
--boss 之家 BossHomeItem
function BossHomeItem:ctor()
	self.ccui = cc.uiloader:load("resui/bossHomeItem.ExportJson")
     
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
    self:init()
end

function BossHomeItem:init()

	self.headIcon = cc.uiloader:seekNodeByName(self.ccui, "headIcon")
	self.headFrame = cc.uiloader:seekNodeByName(self.ccui, "headFrame")
    self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
    self.existLabel = cc.uiloader:seekNodeByName(self.ccui, "existLabel")
    self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
    self.goBtn = cc.uiloader:seekNodeByName(self.ccui, "goBtn")
    self.lvLabel = cc.uiloader:seekNodeByName(self.ccui, "lvLabel")
    self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
    self.bgSel = cc.uiloader:seekNodeByName(self.ccui, "bgSel")
    self.bgSel:setVisible(false)
    self.itembg = display.newSprite()--display.newSprite("res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png")
    self.headIcon:addChild(self.itembg)
    self.itembg:setTag(100)
    self.itembg:setPosition(self.headIcon:getContentSize().width/2, self.headIcon:getContentSize().height/2)

    self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.goBtn:setScale(1.0)
            if self.itemBtnClickFunc then
                self.itemBtnClickFunc(self.data)
            end
            
        end     
        return true
    end)

    --self.goBtn:setVisible(false)
end

function BossHomeItem:setData(data)
	if data == nil or (data ~= nil and self.data == data) then
        return 
    end
    
    self.data = data

    self.nameLabel:setString(configHelper:getMonsterNameById(data.boss_id))
    self.lvLabel:setString(configHelper:getMonsterLvById(data.boss_id))

    local path = "res/icons/worldBoss/".. configHelper:getMonsterResById(data.boss_id) ..".png"
 
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

    self:refreshTime(0)

    local  vip = RoleManager:getInstance().roleInfo.vip
            
    if vip < data.vip_lv then
        self.goBtn:setButtonLabelString("VIP"..data.vip_lv.."开启")
        self.goBtn:setButtonImage("normal", "#com_labBtn1Dis.png")
        self.goBtn:setButtonImage("pressed", "#com_labBtn1Dis.png")
    else
        self.goBtn:setButtonLabelString("立即前往")
        self.goBtn:setButtonImage("normal", "#com_labBtn1.png")
        self.goBtn:setButtonImage("pressed", "#com_labBtn1.png")
    end

end

function BossHomeItem:refreshTime(times)

    if times == nil then
        times = 0
    end

    self.timeLabel:setString(StringUtil.convertTime(times))

	if times > 0 then
		self.timeLabel:setVisible(true)
		self.existLabel:setVisible(false)
		--self.goBtn:setVisible(false)
        
        if RoleManager:getInstance().roleInfo.vip >= self.data.vip_lv then
            self.goBtn:setButtonLabelString("前往等待")
        end
	else
		self.timeLabel:setVisible(false)
		self.existLabel:setVisible(true)
		--self.goBtn:setVisible(true)
        if RoleManager:getInstance().roleInfo.vip >= self.data.vip_lv then
            self.goBtn:setButtonLabelString("立即前往")
        end

	end
end

function BossHomeItem:setItemClickFunc(func)
	self.itemClickFunc = func
end

function BossHomeItem:setItemBtnClickFunc(func)
    self.itemBtnClickFunc = func
end

function BossHomeItem:setSelect(b)
	if b then
        self.bgSel:setVisible(true)
	else
        self.bgSel:setVisible(false)
	end
end

function BossHomeItem:getData()
	return self.data
end

function BossHomeItem:destory()
end

-----------------------------
--  homelessBossItem

 

return BossView