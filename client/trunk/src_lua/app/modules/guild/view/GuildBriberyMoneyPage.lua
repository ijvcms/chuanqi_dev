--
-- Author: shine
-- Date: 2016-05-11
-- 
-- 行会商红包
--
--
local GuildBasePage = import(".GuildBasePage")
local GuildBriberyMoneyView = import(".GuildBriberyMoneyView")

local GuildBriberyMoneyPage = class("GuildBriberyMoneyPage", GuildBasePage)

function GuildBriberyMoneyPage:ctor()
	self.root = cc.uiloader:load("resui/guildmoney_1.ExportJson")
	self:addChild(self.root)
	self:initComponents()
	self:setPosition(210, 4)
end

function GuildBriberyMoneyPage:initComponents()
	self:createRecordList()
	self:createBriberyMoneyList()
	self.ruleBtn = cc.uiloader:seekNodeByName(self.root, "rulebtn")--红包规则
	self.ruleBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.ruleBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.ruleBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(12),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)
    self.luckyBtn = cc.uiloader:seekNodeByName(self.root, "luckybtn")--手气红包
    self.luckyBtn:setTouchEnabled(true)
    self.luckyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.luckyBtn:setScale(1.2, 1.2)
        elseif event.name == "ended" then
            self:onSendBriberyMoney(1)
            self.luckyBtn:setScale(1, 1)
        end     
        return true
    end)
    self.fixedBtn = cc.uiloader:seekNodeByName(self.root, "fixedbtn")--定额红包
    self.fixedBtn:setTouchEnabled(true)
    self.fixedBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.fixedBtn:setScale(1.2, 1.2)
        elseif event.name == "ended" then
            self:onSendBriberyMoney(2)
            self.fixedBtn:setScale(1, 1)
        end     
        return true
    end)
    self.BriberyMoneyView = GuildBriberyMoneyView.new()
    self.BriberyMoneyView:retain()

end

--打开发送红包界面
--type ： 1 拼手气 2 固定额度
function GuildBriberyMoneyPage:onSendBriberyMoney(bm_type)
   self.BriberyMoneyView:showWithSendModel(bm_type)
end



--红包记录
function GuildBriberyMoneyPage:createRecordList()
    local recordLayer = cc.uiloader:seekNodeByName(self.root, "getmoney")
    local size = recordLayer:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
    self.recordList = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.recordList:setContentSize(size)
    self.recordList:setPosition(0, 0)
    self.recordListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapter").new("app.modules.guild.view.RecordItem", 20)
    self.recordList:setAdapter(self.recordListAdapter)
    self.recordListAdapter:setRequestDataFunc(handler(self,self.requestRecordData))
    recordLayer:addChild(self.recordList)
end

--红包列表
function GuildBriberyMoneyPage:createBriberyMoneyList()
	local layer = cc.uiloader:seekNodeByName(self.root, "sendmoney")
	local size = layer:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
    self.briberyMoneyList = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.briberyMoneyList:setContentSize(size)
    self.briberyMoneyList:setPosition(0, 0)
    self.briberyMoneyAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/guildmoney_2.ExportJson", "app.modules.guild.view.BriberyMoneyItem", 20)
    self.briberyMoneyList:setAdapter(self.briberyMoneyAdapter)
    self.briberyMoneyList:onTouch(handler(self, self.onGetBriberyMoney))
    self.briberyMoneyAdapter:setRequestDataFunc(handler(self,self.requestBriberyMoneyData))
    layer:addChild(self.briberyMoneyList)
end

--领取红包
function GuildBriberyMoneyPage:onGetBriberyMoney(event)
  
    if "clicked" == event.name then
    	self.selectBriberyMoney = self.briberyMoneyAdapter:getItem(event.itemPos)
    	if self.selectBriberyMoney.state == 1 then--红包当前状态  0正常，1，已结领取过了，2，已结领取完了
            GlobalController.guild:handleResultCode(403)--你已经领取过该红包了
    		return
        elseif self.selectBriberyMoney.state == 2 then
            GlobalController.guild:handleResultCode(402)--该红包已经被领取完了
            return
    	end
    	GlobalController.guild:getBriberyMoney(self.selectBriberyMoney.red_id)
    	local content = event.item:getChildByTag(11)--UIListViewItem.CONTENT_TAG
    	self.selectItem = content
    elseif "moved" == event.name then
         
    elseif "ended" == event.name then
        
    end
end

function GuildBriberyMoneyPage:onGetBriberyMoneyCompleted(data)
	if data.data.result == 0 then
		if data.data.red_id == self.selectBriberyMoney.red_id then--异步，判断界面与数据是否一致
			self.selectItem:setState(1)
		elseif data.data.red_id == self.selectItem:getData().red_id then
			self.selectBriberyMoney.state = 1
		else
			self:setState(data.data.red_id, 1)
		end
		self.BriberyMoneyView:showWithReceiveModel(data.data.jade)
	elseif data.data.result == 402 then
		if data.data.red_id == self.selectBriberyMoney.red_id then--异步，判断界面与数据是否一致
		    self.selectItem:setState(2)
		elseif data.data.red_id == self.selectItem:getData().red_id then
		    self.selectBriberyMoney.state = 2
		else
			self:setState(data.data.red_id, 2)
		end
	end
	
end

function GuildBriberyMoneyPage:setState(id, state)
	local data = self.briberyMoneyAdapter:getData()
	for _, var in ipairs(data) do
		if var.red_id == id then
			var.state = state
			return
		end
	end
end


function GuildBriberyMoneyPage:requestRecordData()
	local lastRecord = self.recordListAdapter:getItem(self.recordListAdapter:getCount())
	GlobalController.guild:requestBriberyMoneyRecordList(lastRecord.id)
end

function GuildBriberyMoneyPage:requestBriberyMoneyData()
	local lastBriberyMoney = self.briberyMoneyAdapter:getItem(self.briberyMoneyAdapter:getCount())
	GlobalController.guild:requestBriberyMoneyList(lastBriberyMoney.red_id)
end

function GuildBriberyMoneyPage:registerEvent()
    --取得行会详细信息
    local function onGuildDetailedInfo(data)
    	if  self.peopleNumLabel  then
    		self.peopleNumLabel:setString(tostring(data.data.number))
    	end
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_DETAILED_INFO, onGuildDetailedInfo)
    self.registerEventId[2] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_BRIBERY_MONEY_INFO, handler(self,self.onGetBriberyMoneyList))
    self.registerEventId[3] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_BRIBERY_MONEY_LOG, handler(self,self.onGetBriberyMoneyLogList))
    self.registerEventId[4] = GlobalEventSystem:addEventListener(GuildEvent.GUILD_BRIBERY_MONEY_GET, handler(self,self.onGetBriberyMoneyCompleted))
    
end

--获取红包列表
function GuildBriberyMoneyPage:onGetBriberyMoneyList(data)
	local list = data.data.list
	local data_type = data.data.type
	if data_type == 1 then -- 第一页数据
		self.briberyMoneyAdapter:setData(list)
	elseif data_type == 2 then
		self.briberyMoneyAdapter:addData(list)
	else
		self.briberyMoneyAdapter:insertData(list, 1, true)
	end
end

--获取红包记录列表
function GuildBriberyMoneyPage:onGetBriberyMoneyLogList(data)
	local list = data.data.list
	local data_type = data.data.type
	if data_type == 1 then -- 第一页数据
		self.recordListAdapter:setData(list)
	elseif data_type == 2 then
		self.recordListAdapter:addData(list)
	else
		self.recordListAdapter:insertData(list, 1, true)
	end
end

function GuildBriberyMoneyPage:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function GuildBriberyMoneyPage:onShow()
	if 	self.registerEventId == nil then
		self.registerEventId = {}
		self:registerEvent()
	end
	GlobalController.guild:requestBriberyMoneyData()--获取红包相关信息

end

function GuildBriberyMoneyPage:onHide()
    GlobalController.guild:stopPushBriberyMoneyData()
end

function GuildBriberyMoneyPage:onDestory()
    GlobalController.guild:stopPushBriberyMoneyData()
	self.recordList:onCleanup()
	self.briberyMoneyList:onCleanup()
	self:unregisterEvent()
    if self.BriberyMoneyView:getParent() then
        self.BriberyMoneyView:removeFromParent(false)
    end
	self.BriberyMoneyView:onCleanup()
	self.BriberyMoneyView:release()
    self.briberyMoneyAdapter:destory()
end




return GuildBriberyMoneyPage