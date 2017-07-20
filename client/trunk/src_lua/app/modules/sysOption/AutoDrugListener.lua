local LocalDatasManager = require("common.manager.LocalDatasManager")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local AutoDrugListener = AutoDrugListener or class("AutoDrugListener", function()
    return display.newNode()
end)

function AutoDrugListener:ctor()
    print("AutoDrugListener!!!!!!!!!!!!")
	-- self.localData = LocalDatasManager:getLocalData("autoDrug") 
    -- self.localData = self.localData==nil and {} or self.localData
    -- 改为后端下发自动喝药配置
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.localData = roleInfo.autoDrugOption
	--node event
    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function AutoDrugListener:onNodeEvent(data)
    if data.name == "enterTransitionFinish" then
        self:registerEvent()
    elseif data.name == "cleanup" then
        self:unregisterEvent()
    end
end

function AutoDrugListener:registerEvent()
    self.registerEventId = {}
    self.cdEventId = {}
    --自动喝药的配置改变
    -- local function onAutoDrugChange(data)
    -- 	self.localData = LocalDatasManager:getLocalData("autoDrug")
    -- end
    -- self.registerEventId[1] = GlobalEventSystem:addEventListener(AutoDrugEvent.AUTO_DRUG_DATA_CHANGE, onAutoDrugChange)

    --人物红蓝改变
    local function onHealthChange(data)
        if 20017 == GameSceneModel.sceneId then return end --竞技场不能喝药
    	local roleManager = RoleManager:getInstance()
		local roleInfo = roleManager.roleInfo
		local bagManager = BagManager:getInstance()
    	for k,v in pairs(data.data) do
    		if v.key == 3 then 			--当前血量
    			if self.localData.normalDrug==1 and self.localData.drugType1 then 		--开启了普通自动喝药并且红药有id
    				--如果到了percent值
    				local curPercent = math.ceil(roleInfo.cur_hp/roleInfo.hp*100)
    				if curPercent<=self.localData.redBarPercent then
    					--如果背包里有这个id的药
    					local count = bagManager:findItemCountByItemId(self.localData.drugType1)
    					if count > 0 then
    						local data = {
						        goods_id = self.localData.drugType1
						    }
							--GameNet:sendMsgToSocket(14007, data)
                            self:useGoods(data)
    					end
    				end
    			end
    			if self.localData.momentDrug==1 and self.localData.drugType3 then 		--开启了自动喝瞬回药并且瞬回药有id
    				--如果到了percent值
    				local curPercent = math.ceil(roleInfo.cur_hp/roleInfo.hp*100)
    				if curPercent<=self.localData.momentBarPercent then
    					--如果背包里有这个id的药
    					local count = bagManager:findItemCountByItemId(self.localData.drugType3)
    					if count > 0 then
    						local data = {
						        goods_id = self.localData.drugType3
						    }
							--GameNet:sendMsgToSocket(14007, data)
                            self:useGoods(data)
    					end
    				end
    			end
    		elseif v.key == 4 then 		--当前魔量

    			if  self.localData.normalDrug==1 and self.localData.drugType2 then 		--开启了普通自动喝药并且蓝药有id
    				--如果到了percent值
    				local curPercent = math.ceil(roleInfo.cur_mp/roleInfo.mp*100)

    				if curPercent <= self.localData.blueBarPercent then

    					--如果背包里有这个id的药
    					local count = bagManager:findItemCountByItemId(self.localData.drugType2)

    					if count > 0 then
    						local data = {
						        goods_id = self.localData.drugType2
						    }
							--GameNet:sendMsgToSocket(14007, data)
                            self:useGoods(data)
    					end
    				end
    			end
    		end
    	end
    end
    -- self.registerEventId[2] = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_ROLE_BASE_ATTR, onHealthChange)
    self.registerEventId[1] = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_ROLE_BASE_ATTR, onHealthChange)
end

function AutoDrugListener:useGoods(data)

    if self.cdEventId[data.goods_id] then
        if self.cdEventId[data.goods_id].cdOk == true then
            self.cdEventId[data.goods_id] = nil
            self:use(data)
        else
            self.cdEventId[data.goods_id].use = true
            self.cdEventId[data.goods_id].data = data
        end
    else
       self:use(data)
    end

end

function AutoDrugListener:use(data)
        dump(data.goods_id)
        local type = configHelper:getGoodTypeByGoodId(data.goods_id)
        local subType = configHelper:getGoodSubTypeByGoodId(data.goods_id)
        local cdTime = configHelper:getGoodCDTime(type, subType)

        if cdTime == nil then
            cdTime = 5
        end
        BagController:getInstance():requestUseGoods(data)
        --GameNet:sendMsgToSocket(14007, data)
        self.cdEventId[data.goods_id] = {}
        self.cdEventId[data.goods_id].use = false
        self.cdEventId[data.goods_id].cdOk = false
        self.cdEventId[data.goods_id].eventId = scheduler.performWithDelayGlobal(function()

            if self.cdEventId[data.goods_id].eventId then
                scheduler.unscheduleGlobal(self.cdEventId[data.goods_id].eventId)
                self.cdEventId[data.goods_id].eventId = nil
            end
            self.cdEventId[data.goods_id].cdOk = true
            if self.cdEventId[data.goods_id].use then
                self:useGoods(self.cdEventId[data.goods_id].data)
            end
            
        end,cdTime)
end

function AutoDrugListener:destory()
    if self.cdEventId then
        for k,v in pairs(self.cdEventId) do
            if v.eventId then
                scheduler.unscheduleGlobal(v.eventId)
            end
            self.cdEventId[k] = nil
        end
    end
end

function AutoDrugListener:unregisterEvent()
    if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

return AutoDrugListener

