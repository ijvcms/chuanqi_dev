local TalkingData = class("TalkingData")


function TalkingData:ctor()
	GameNet:registerProtocal(14011, handler(self,self.onHandle14011))
	GameNet:registerProtocal(26008, handler(self,self.onHandle26008))
	-- local appId = ChannelAPI:getAppId()
	-- if device.platform == "android" and appId ~= "" and appId ~= "E9C6FEA902CCB9D9" then
	-- 	self.AnalyticsAdapterClass = "com/rongyao/chuanqi/analytics/AnalyticsAdapter"
	-- end
end

--统计物品消耗，购买
function TalkingData:onHandle14011(data)
	print("on14011")
	local at_type = data.type
	local name
	local goods_num = 1
	if at_type == 0 then
		local goods = data.goods_list[1]
	    if 1 == goods.goods_id then -- 体力
            name = "体力"
	    elseif 2 == goods.goods_id then -- 行会声望
            name = "行会贡献"
	    else
	        local goods_info = configHelper:getGoodsByGoodId(goods.goods_id)
            name = goods_info.name
	    end
	    goods_num = goods.num
    elseif at_type == 3 then
        name = "膜拜任务"
    elseif at_type == 4 then
        name = "功勋任务"
    elseif at_type == 5 then
        name = "老兵的挑战"
    elseif at_type == 6 then
    	name = "交易所购买扣除"
    elseif at_type == 7 then
    	name = "交易所获得"
    	self:GetReward(data.num, name);
    	return
	end
	if 110008 == data.goods_id then -- 元宝
        self:Buy(name, goods_num, data.num / goods_num)
    elseif 110009 == data.goods_id then -- 金币
        self:BuyWithGold(name, goods_num, data.num / goods_num)
    elseif 110045 == data.goods_id then -- 礼卷
        self:BuyWithToken(name, goods_num, data.num / goods_num)
    end
	
end

--统计每日任务的完成情况（开始与结束时间）
function TalkingData:onHandle26008(data)
	print("on26008")
	local task = data.record_task_info
	if 10 == task.state then--任务瞬间完成的
		self:MissionBegin(task.task_id)
		self:MissionCompleted(task.task_id)
	elseif 1 == task.state then--任务开始
		self:MissionBegin(task.task_id)
	elseif 2 == task.state then--任务结束
		self:MissionCompleted(task.task_id)
	end 
end

--统计玩家信息
function TalkingData:setPlayInfo(info)
	if TDGAAccount == nil then
		self:log("没有统计玩家信息")
		return
	end
	TDGAAccount:setAccount(info.player_id)--玩家ID
	TDGAAccount:setAccountName(info.name)--玩家名字
	TDGAAccount:setLevel(info.lv)--玩家等级
	if RoleSex.MAN == info.sex then
		TDGAAccount:setGender(TDGAAccount.kGenderMale)--玩家性别
	else
		TDGAAccount:setGender(TDGAAccount.kGenderFemale)
	end
	TDGAAccount:setGameServer(tostring(GlobalModel.selServerInfo.service_id))--区服
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "login", {info.player_id, info.lv, tostring(GlobalModel.selServerInfo.service_id)}, "(Ljava/lang/String;ILjava/lang/String;)V")
	end
end

function TalkingData:register(info)
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "register", {info.player_id, "unknown", info.sex, tostring(GlobalModel.selServerInfo.service_id)}, "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V")
	end
end

--统计等级升级
function TalkingData:updateLevel(lv)
	if TDGAAccount == nil then
		self:log("没有统计等级升级")
		return
	end
	TDGAAccount:setLevel(lv)--玩家等级
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "updateLevel", {lv}, "(I)V")
	end
end


--充值开始
-- function TalkingData:beginPay(goods)
-- 	local roleInfo = RoleManager:getInstance().roleInfo
-- 	local orderId = "order"..roleInfo.player_id..os.time()
-- 	if TDGAVirtualCurrency == nil then
-- 		self:log("没有统计充值开始")
-- 		return orderId
-- 	end
-- 	local data = goods:getData()
-- 	local gold = data.jade--元宝
-- 	local dec = data.jade .. "元宝"-- 描述
-- 	if data.finish then
-- 		gold = gold + data.common_giving
--         dec = dec .. data.common_desc
-- 	else
-- 		gold = gold + data.first_giving --首冲
-- 		dec = dec .. data.giving_desc
-- 	end
-- 	TDGAVirtualCurrency:onChargeRequest(orderId, dec, data.rmb, "CNY", gold, "测试")
-- 	return orderId, dec, data.rmb
-- end


--充值结束
-- function TalkingData:endPay(orderId)
--     if TDGAVirtualCurrency == nil then
-- 		self:log("没有统计充值完成")
-- 		return
-- 	end
-- 	TDGAVirtualCurrency:onChargeSuccess(orderId)
-- end


--购买了什么，记录付费点，只限元宝
--name:名字
--count:数量
--one_price:单价(元宝)
function TalkingData:Buy(name, count, one_price)
	if TDGAItem == nil then
		self:log("没有统计购买了"..name..",数量"..count..",单价"..one_price)
		return
	end
	TDGAItem:onPurchase(name, count, one_price)
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "buy", {name, count, one_price}, "(Ljava/lang/String;II)V")
	end
end

--通过金币进行购买
--name:名字
--count:数量
function TalkingData:BuyWithGold(name, count, one_price)
	if TalkingDataGA == nil then
		self:log("没有统计使用金币购买" .. name..",数量"..count..",单价"..one_price)
		return
	end
	local eventData = {name = name, count = count, price = one_price} 
	TalkingDataGA:onEvent("BuyWithGold", eventData)
end

--通过礼券进行购买
--name:名字
--count:数量
function TalkingData:BuyWithToken(name, count, one_price)
	if TalkingDataGA == nil then
		self:log("没有统计使用礼券购买" .. name..",数量"..count..",单价"..one_price)
		return
	end
	local eventData = {name = name, count = count, price = one_price} 
	TalkingDataGA:onEvent("BuyWithToken", eventData)
end

--统计奖励领取记录
function TalkingData:Reward(reward_id)
	local reward = configHelper.getInstance():getWelfareRewardById(reward_id)
	local goods_name = configHelper.getInstance():getGoodNameByGoodId(reward.goods_info.goods_id)
	if TalkingDataGA == nil then
		self:log("没有统计领取" .. reward.desc)
		return
	end
	local eventData = {reward_id = reward_id, reward_desc = reward.desc, goods_id = reward.goods_info.goods_id, goods_name = goods_name} 
	TalkingDataGA:onEvent("Reward", eventData)
end


--统计活动事件次数：排位赛，功勋任务，膜拜任务，个人副本
--active_name:事件名称
--scene_id:场景id
--result:挑战结果, 1 成功， 2失败
function TalkingData:setActiveEvent(active_name, scene_id, result)
	if TalkingDataGA == nil then
		self:log("没有统计参与度事件" .. active_name)
		return
	end
	local eventData = {name = active_name, scene_id = scene_id, result = result} 
	TalkingDataGA:onEvent("ActiveEvent", eventData)
end


--消耗物品或服务
--name:名字
--count:数量
function TalkingData:Use(name,count)
	if TDGAItem == nil then
		self:log("没有统计消耗了"..name)
		return
	end
	TDGAItem:onUse(name, count)
end

--任务统计
function TalkingData:MissionBegin(id)
	if TDGAMission == nil then
		self:log("没有统计任务开始"..id)
		return
	end
	TDGAMission:onBegin(tostring(id))
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "missionBegin", {tostring(id)}, "(Ljava/lang/String;)V")
	end
end

function TalkingData:MissionCompleted(id)
	if TDGAMission == nil then
		self:log("没有统计任务完成"..id)
		return
	end
	TDGAMission:onCompleted(tostring(id))
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "missionCompleted", {tostring(id)}, "(Ljava/lang/String;)V")
	end
end

function TalkingData:MissionFailed(id)
	if TDGAMission == nil then
		self:log("没有统计任务失败"..id)
		return
	end
	TDGAMission:onFailed(tostring(id))
	if self.AnalyticsAdapterClass then
		require("framework.luaj").callStaticMethod(self.AnalyticsAdapterClass, "missionFailed", {tostring(id)}, "(Ljava/lang/String;)V")
	end
end

--获取元宝的记录
function TalkingData:GetReward(count, name)
	if TDGAVirtualCurrency == nil then
		self:log("没有统计通过"..name.."获得".. count.."元宝")
		return
	end
    TDGAVirtualCurrency:onReward(count, name)
end

function TalkingData:log(str)
	if false then return end
	print(str)

end






return TalkingData