

local ConfigHelper = class("ConfigHelper")
local ConfigHelperInstance = nil

local function configFormat(config)
	local newConfig = {fields = config.fields, datas = {} }
	for k,v in pairs(config.datas) do
		for i=1, #v do
			if newConfig.datas[k] == nil then
				newConfig.datas[k] = {}
			end
			newConfig.datas[k][config.fields[i]] = v[i]
		end
	end
	return newConfig
end

function ConfigHelper:getPickUpSpItemTypeByID(id)
	if self.pickup_setting[id] then
		return self.pickup_setting[id]
	end
	return 0
end

function ConfigHelper:ctor()
	--拾取特殊物品表
	self.pickup_setting = configFormat(import("app.conf.pickup_settingConfig").new())
	for i=1,#self.pickup_setting.datas do
		local d = self.pickup_setting.datas[i].items
		for j=1,#d do
			self.pickup_setting[d[j]] = i
		end
	end
	--场景预加载表
	self.scenePreLoading = configFormat(import("app.conf.loadingmodelConfig").new())
	--人物升级经验表
	self.upgradeConfig = configFormat(import("app.conf.player_upgradeConfig").new())
	--装备表
	self.equipsConfig = configFormat(import("app.conf.equipsConfig").new())
	--道具表
	self.goodsConfig = configFormat(import("app.conf.goodsConfig").new())
	--装备强化消耗表
	self.equipStrengConfig = configFormat(import("app.conf.equips_strenConfig").new())
	--装备强化属性加成表
	self.equipPlusConfig = configFormat(import("app.conf.equips_plusConfig").new())
	--装备洗炼属性表
	self.equipBapTizeConfig = configFormat(import("app.conf.equips_baptizeConfig").new())
	--神器属性表
	self.artifactAttrConfig = configFormat(import("app.conf.artifact_attrConfig").new())
	--锻造表
	self.fusionConfig = configFormat(import("app.conf.fusionConfig").new())
	--神器经验表
	self.artExpConfig = configFormat(import("app.conf.artifact_expConfig").new())
	--战力系数表
	self.fightingConfig = configFormat(import("app.conf.fightingConfig").new())
	--游戏攻略表
	self.strategyConfig = configFormat(import("app.conf.strategyConfig").new())
	self.strategy_chapterConfig = configFormat(import("app.conf.strategy_chapterConfig").new())
	--公告表
	self.noticeConfig = configFormat(import("app.conf.noticeConfig").new())
	--世界boss表
	self.worldBossConfig = configFormat(import("app.conf.world_bossConfig").new())
	self.city_bossConfig = configFormat(import("app.conf.city_bossConfig").new())
	self.vip_bossConfig = configFormat(import("app.conf.vip_bossConfig").new())
	--公会表(公会经验,公会人数)
	self.guildConfig = configFormat(import("app.conf.guildConfig").new())
	self.guild_activityConfig = configFormat(import("app.conf.guild_activityConfig").new())
	self.guild_activity_bossConfig = configFormat(import("app.conf.guild_activity_bossConfig").new())

	--公会捐献表
	self.guildDonationConfig = configFormat(import("app.conf.guild_donationConfig").new())
	--行会商店表
	self.guildShopConfig = configFormat(import("app.conf.guild_shopConfig").new())
    
    self.groupConfig = configFormat(import("app.conf.groupConfig").new())
   	--日常任务表
	self.dailyTaskConfig = configFormat(import("app.conf.taskConfig").new())
	self.taskrewardConfig = configFormat(import("app.conf.taskrewardConfig").new())

	--玛雅神殿配置
	self.treasureConfig = configFormat(import("app.conf.treasureConfig").new())
	self.treasuredesConfig = configFormat(import("app.conf.treasuredesConfig").new())

	--副本配置
	self.instance_singleConfig = configFormat(import("app.conf.instance_singleConfig").new())
	self.instanceConfig = configFormat(import("app.conf.instanceConfig").new())

	--排位赛配置
	self.arena_shopConfig = configFormat(import("app.conf.arena_shopConfig").new())
	self.arena_rewardConfig = configFormat(import("app.conf.arena_rewardConfig").new())

	--沙巴克配置
	self.city_officerConfig = configFormat(import("app.conf.city_officerConfig").new())
	self.city_officer_qianConfig = configFormat(import("app.conf.city_officer_qianConfig").new())

	--随机名字库
	--TODO：个人认为应该把此数据当做一个WebService，不应该使用常驻内存配置文件。
	self.random_first_nameConfig = configFormat(import("app.conf.random_first_nameConfig").new())
	self.random_last_nameConfig = configFormat(import("app.conf.random_last_nameConfig").new())

	-- 地图表
	self.monster_areaConfig = configFormat(import("app.conf.monster_areaConfig").new())
	self.transferConfig = configFormat(import("app.conf.transferConfig").new())
	--勋章表
	self.medalConfig = configFormat(import("app.conf.medalConfig").new())
	--翅膀表
	self.wingConfig = configFormat(import("app.conf.wingConfig").new())
	--强化成功率表
	self.stren_rateConfig = configFormat(import("app.conf.stren_rateConfig").new())
	--物品分解表
	self.decomposeConfig = configFormat(import("app.conf.decomposeConfig").new())
	--商城售物表
	local storeConfig = configFormat(import("app.conf.shopConfig").new())

	--VIP表
	self.vipConfig = configFormat(import("app.conf.vipConfig").new())

	--充值表
	self.chargeConfig = configFormat(import("app.conf.chargeConfig").new())

	--充值表
	self.downloadConfig = configFormat(import("app.conf.downloadConfig").new())

	--充值表
	self.everyday_signConfig = configFormat(import("app.conf.everyday_signConfig").new())

	--购买菜单表
	self.sale_sortConfig = configFormat(import("app.conf.sale_sortConfig").new())
	--未知暗殿
	self.dark_palaceConfig = configFormat(import("app.conf.dark_palaceConfig").new())
	--道具cd表
	self.goods_typeConfig = configFormat(import("app.conf.goods_typeConfig").new())
	--开服活动配表
	self.active_service_typeConfig = configFormat(import("app.conf.active_service_typeConfig").new())
	self.active_serviceConfig = configFormat(import("app.conf.active_serviceConfig").new())

	--buff配表
	self.buffConfig = configFormat(import("app.conf.buffConfig").new())
	self.dailySignConfig = configFormat(import("app.conf.dailySignConfig").new())
	--怪物攻城奖励配表
	self.monster_attack_rewardConfig = configFormat(import("app.conf.monster_attack_rewardConfig").new())

	--背包格子配表
	self.cellConfig = configFormat(import("app.conf.cellConfig").new())
	--装备展示
	self.equips_exhibitionConfig = configFormat(import("app.conf.equips_exhibitionConfig").new())
	self.equips_exhibition_listConfig = configFormat(import("app.conf.equips_exhibition_listConfig").new())

	self.storeTable = {
		[1] = {fields = storeConfig.fields, datas = {}}, 			--元宝
		[2] = {fields = storeConfig.fields, datas = {}}, 			--绑元
		[3] = {fields = storeConfig.fields, datas = {}},			--VIP限购
		[4] = {fields = storeConfig.fields, datas = {}},			--稀有
		[5] = {fields = storeConfig.fields, datas = {}},			
		[6] = {fields = storeConfig.fields, datas = {}},			
		[7] = {fields = storeConfig.fields, datas = {}},			
		[8] = {fields = storeConfig.fields, datas = {}},			
		[9] = {fields = storeConfig.fields, datas = {}},			
		[10] = {fields = storeConfig.fields, datas = {}},			
		[11] = {fields = storeConfig.fields, datas = {}},			
		[12] = {fields = storeConfig.fields, datas = {}},			
		[13] = {fields = storeConfig.fields, datas = {}},			
		[14] = {fields = storeConfig.fields, datas = {}},			
		[15] = {fields = storeConfig.fields, datas = {}},			
		[16] = {fields = storeConfig.fields, datas = {}},			
	}

	for k,v in pairs(storeConfig.datas) do
		table.insert(self.storeTable[v.type].datas,v)
	end

	for i=1,#self.storeTable do
		table.sort(self.storeTable[i].datas,function(a,b) return a.key < b.key end)
	end

	--获取NPc传送点面板数据
	self.npctransportConfig = configFormat(import("app.conf.npctransportConfig").new())
	--场景传送点
	self.scene_transportConfig = configFormat(import("app.conf.scene_transportConfig").new())
	--npc功能配置表
	self.npcfunctionConfig = configFormat(import("app.conf.npcfunctionConfig").new())
	--自动喝药药品配置表
	self.autoDrugConfig = configFormat(import("app.conf.auto_drugConfig").new())
 
	--膜拜配置表
	self.worship_goodsConfig = configFormat(import("app.conf.worship_goodsConfig").new())

	-- 功能开放配置表
	self.functionConfig = configFormat(import("app.conf.functionConfig"):new())

	-- 活动列表配置
	self.activity_listConfig = configFormat(import("app.conf.activity_listConfig"):new())

	-- 顶部导航栏菜单配置表
	self.top_navigation_menuConfig = configFormat(import("app.conf.top_navigation_menuConfig"):new())

	-- 福利大厅左侧福利类型列表。
	self.welfare_typeConfig = configFormat(import("app.conf.welfare_typeConfig"):new())

	-- 福利大厅所有的奖励信息配置表
	self.active_rewardConfig = configFormat(import("app.conf.active_rewardConfig"):new())

	-- 世界地图配置表
	self.word_mapConfig = configFormat(import("app.conf.word_mapConfig"):new())
	--屠龙大会奖励配置表
	self.world_boss_rewardConfig = configFormat(import("app.conf.world_boss_rewardConfig"):new())
	--胜者为王奖励配置表
	self.szww_rewardConfig = configFormat(import("app.conf.szww_rewardConfig"):new())
	--屏蔽字库 
	self.sensitive_wordConfig = configFormat(import("app.conf.sensitive_wordConfig"):new())
	--套装配置表
	self.equips_suit_goodsConfig = configFormat(import("app.conf.equips_suit_goodsConfig"):new())

	self.equips_suitConfig = configFormat(import("app.conf.equips_suitConfig"):new())

	--pvr资源配置信息configHelper.pvrResConfig
	self.pvrResConfig = import("app.conf.pvrResConfig"):new()
	self.pvrResConfig.tampdatas = {}
	for k,v in pairs(self.pvrResConfig.datas) do
		self.pvrResConfig.tampdatas[tostring(v[2])] = v
	end
	self.pvrResConfig.datas = self.pvrResConfig.tampdatas
	self.pvrResConfig.tampdatas = nil

	--快速使用
	self.quick_medConfig = configFormat(import("app.conf.quick_medConfig"):new())

	self.ruleConfig = configFormat(import("app.conf.ruleConfig"):new())
	-- 
	self.rgbaConfig = configFormat(import("app.conf.rgbaConfig"):new())

	self.monthCardConfig = configFormat(import("app.conf.monthCardConfig"):new())
	
	self.mountSpeedConfig = configFormat(import("app.conf.mount_speedConfig"):new())

	self.equips_soulConfig = configFormat(import("app.conf.equips_soulConfig"):new())
	self.equips_soul_plusConfig = configFormat(import("app.conf.equips_soul_plusConfig"):new())

	self.equips_baptize_lockConfig = configFormat(import("app.conf.equips_baptize_lockConfig"):new())
	
	self.equip_not_decomposeConfig = configFormat(import("app.conf.equip_not_decomposeConfig"):new())

	self.markConfig = configFormat(import("app.conf.markConfig"):new())
	--装备子类洗练过滤
	self.equips_baptize_limitConfig = configFormat(import("app.conf.equips_baptize_limitConfig"):new())

	self.equips_baptize_numberConfig = configFormat(import("app.conf.equips_baptize_numberConfig"):new())
	
	self.mountsConfig = configFormat(import("app.conf.mountsConfig"):new())
	self.mount_jadeConfig = configFormat(import("app.conf.mount_jadeConfig"):new())

	self.shop_onceConfig = configFormat(import("app.conf.shop_onceConfig"):new())

	self.equipSouldArr = {}

	for k,v in pairs(self.equips_soulConfig.datas) do
		if self.equipSouldArr[v.goods_id] == nil then
			self.equipSouldArr[v.goods_id] = {}
		end
		self.equipSouldArr[v.goods_id][v.soul] = v.consume 
	end
	
	self.equips_suitArr = {}
	for k,v in pairs(self.equips_suitConfig.datas) do
		if self.equips_suitArr[v.key] == nil then
			self.equips_suitArr[v.key] = {}
		end
		table.insert(self.equips_suitArr[v.key], v)
		table.sort(self.equips_suitArr[v.key],function(a,b) return a.count < b.count end)
	end
	--装备洗炼属性最大值表
	self.equips_baptize_qianConfig = configFormat(import("app.conf.equips_baptize_qianConfig"):new())
	 
	-- 新手引导数据配置表
	self.guide_stepConfig                 = configFormat(import("app.conf.guide_stepConfig").new())
	self.guide_triggerConfig              = configFormat(import("app.conf.guide_triggerConfig").new())
	self.guide_operateConfig              = configFormat(import("app.conf.guide_operateConfig").new())
	self.guide_body_click_typeConfig      = configFormat(import("app.conf.guide_body_click_typeConfig").new())
	self.guide_target_abs_of_clickConfig  = configFormat(import("app.conf.guide_target_abs_of_clickConfig").new())
	self.guide_target_auto_of_clickConfig = configFormat(import("app.conf.guide_target_auto_of_clickConfig").new())
	self.guide_body_slide_typeConfig      = configFormat(import("app.conf.guide_body_slide_typeConfig").new())
    --动态表情
	self.faceConfig = configFormat(import("app.conf.expressionConfig").new())
	--趣味答题奖励
	self.answeringRewardConfig = configFormat(import("app.conf.examinationRankRewardConfig").new())
    self.questionConfig = configFormat(import("app.conf.examinationConfig").new())

	--洗炼转移费用
	self.equips_baptiz_change_jadeConfig = configFormat(import("app.conf.equips_baptiz_change_jadeConfig").new())
	--节日活动
	self.holidays_activeConfig = configFormat(import("app.conf.holidays_activeConfig"):new())
	--怪物技能提示
	self.monster_warningConfig = configFormat(import("app.conf.monster_warningConfig"):new())
	self.function_noticeConfig = configFormat(import("app.conf.function_noticeConfig"):new())

	self.display_equipConfig = configFormat(import("app.conf.display_equipConfig"):new())

	self.instance_dragonConfig = configFormat(import("app.conf.instance_dragonConfig"):new())
	self.instance_dragon_nativeConfig = configFormat(import("app.conf.instance_dragon_nativeConfig"):new())
	self.instance_dragon_weekenConfig = configFormat(import("app.conf.instance_dragon_weekenConfig"):new())

	self.model_play_speedConfig = configFormat(import("app.conf.model_play_speedConfig"):new())

	self.active_service_merge_typeConfig = configFormat(import("app.conf.active_service_merge_typeConfig"):new())
	self.active_service_mergeConfig = configFormat(import("app.conf.active_service_mergeConfig"):new())
    --礼包配置表
    self.bagConfig = configFormat(import("app.conf.bagConfig"):new())

    self.luckdraw_exchangeConfig = configFormat(import("app.conf.luckdraw_exchangeConfig"):new())
    self.luckydraw_displayConfig = configFormat(import("app.conf.luckydraw_displayConfig"):new())
    self.lottery_boxConfig = configFormat(import("app.conf.lottery_boxConfig"):new())
    
    self.activity_limitConfig = configFormat(import("app.conf.activity_limitConfig"):new())
    --元宝抽奖
    self.lottery_carnivalConfig = configFormat(import("app.conf.lottery_carnivalConfig"):new())
    --投资
    self.invest_displayConfig = configFormat(import("app.conf.invest_displayConfig"):new())
    self.collect_goodsConfig = configFormat(import("app.conf.collect_goodsConfig"):new())

    self.dreamland_rank = configFormat(import("app.conf.dreamland_rankConfig"):new())

    self.self_bossConfig = configFormat(import("app.conf.self_bossConfig"):new())
end

--获取个人boss配置信息
function ConfigHelper:getSelfBossConfig()
	return self.self_bossConfig.datas
end

function ConfigHelper:getInvestDisplayConfig(type)
	local arr = {}
	for i=1,#self.invest_displayConfig.datas do
		if self.invest_displayConfig.datas[i].type == type then
			table.insert(arr,self.invest_displayConfig.datas[i])
		end
	end
	return arr
end

function ConfigHelper:getLotteryCarnivalConfig(key)
	return self.lottery_carnivalConfig.datas[key]
end

function ConfigHelper:getDreamland_rankByType(type)
	local arr = {}
	for i=1,#self.dreamland_rank.datas do
		if self.dreamland_rank.datas[i].type == type then
			table.insert(arr, self.dreamland_rank.datas[i])
		end
	end
	return arr
end

function ConfigHelper:getCollect_goodsConfigById(id)
	return self.collect_goodsConfig.datas[id]
end

function ConfigHelper:getActivity_limitConfig()
	return self.activity_limitConfig.datas
end

--
function ConfigHelper:getLottery_boxConfigByGroup(type)
	local arr = {}
	local endIndex = 1
	for i=1,#self.lottery_boxConfig.datas do
		if self.lottery_boxConfig.datas[i].type == type then
			arr[i] = self.lottery_boxConfig.datas[i]
		end
	end
	return arr,endIndex
end

--获取礼包对应的物品数据
function ConfigHelper:getLuckydraw_displayConfigByGroup(group)
	local arr = {}
	local endIndex = 1
	for i=1,#self.luckydraw_displayConfig.datas do
		if self.luckydraw_displayConfig.datas[i].group == group then
			arr[i] = self.luckydraw_displayConfig.datas[i]
		end
	end
	return arr,endIndex
end

--获取礼包对应的物品数据
function ConfigHelper:getLuckydraw_displayConfig()
	return self.luckydraw_displayConfig.datas
end

--获取礼包对应的物品数据
function ConfigHelper:getLuckdraw_exchangeConfig()
	return self.luckdraw_exchangeConfig.datas
end

--获取礼包对应的物品数据
function ConfigHelper:getBagData(bagId)
	return self.bagConfig.datas[bagId].goods
end

--获取模型`动作速率
--career 职业
--act 动作
function ConfigHelper:getModelActionSpeed(career)
	return self.model_play_speedConfig.datas[career]
end

function ConfigHelper:getInstanceDragonConfig()
	return self.instance_dragonConfig.datas
end
function ConfigHelper:getInstance_dragon_nativeConfig()
	return self.instance_dragon_nativeConfig.datas
end
function ConfigHelper:getInstance_dragon_weekenConfig()
	return self.instance_dragon_weekenConfig.datas
end

function ConfigHelper:getWashSpGoodsAttById(id)
	return self.display_equipConfig.datas[id]
end

function ConfigHelper.getInstance()
	if ConfigHelperInstance==nil then
		ConfigHelperInstance = ConfigHelper.new()
	end
	return ConfigHelperInstance
end

--获取怪物技能提示
function ConfigHelper:getFunctionNotice()
	return self.function_noticeConfig.datas
end


--获取怪物技能提示
function ConfigHelper:getMonsterWarningById(id)
	return self.monster_warningConfig.datas[id]
end

--获取传送点配置 ConfigHelper.getInstance():getScenePreLoadingBySceneId(id)
function ConfigHelper:getScenePreLoadingBySceneId(id)
	local conf = self.scenePreLoading.datas[id]
	if conf and conf.modelId ~= "" then
		local list = string.split(conf.modelId, ",")
		return list
	end
    return {}
end

--根据当前NPC功能ID获取当前NPC传送面板配置配置
function ConfigHelper:getNpcTransportArrByNpcID(id)
	local arr = {}
	for k,v in pairs(self.npctransportConfig.datas) do
		if v.npcId == id then
			table.insert(arr,v)
		end
	end
    return arr
end

--获取传送点配置
function ConfigHelper:getSceneTransportConfigByID(id)
    return self.scene_transportConfig.datas[id]
end

--根据当前NPC功能ID获取当前功能配置
function ConfigHelper:getNpcFunctionByID(id)
    return self.npcfunctionConfig.datas[id]
end

--取得人物升到下一级需要多少经验
--curLevel:人物当前等级
function ConfigHelper:getLevelUpgradeExp(curLevel)
    return self.upgradeConfig.datas[curLevel]["need_exp"]
end

--获取套装id
function ConfigHelper:getSuitIdByGoodId(id)
	return self.goodsConfig.datas[id]["suit_id"]
end

--获取goods配置buff_id
function ConfigHelper:getGoodsBuffIdByGoodsId(id)
	return self.goodsConfig.datas[id]["buffid"]
end

--获取goods配置buff_id
function ConfigHelper:getGoodsSecurePriceByGoodsId(id)
	return self.goodsConfig.datas[id]["secure_price"]
end

--获取goods配置is_special
function ConfigHelper:getGoodsSpecialByGoodsId(id)
	return self.goodsConfig.datas[id]["is_special"]
end

function ConfigHelper:getGoodsExtraByGoodsId(id)
	local goodConfig = self.goodsConfig.datas[id]
	if not goodConfig then return nil end
	return goodConfig["extra"]
end

--获取goods配置bygoodid
function ConfigHelper:getGoodsByGoodId(id)
	return self.goodsConfig.datas[id]
end

--根据物品id取得对应图标id
--id: 物品id
function ConfigHelper:getIconByGoodId(id)
	if not id then return end


	if id>=100000 and id <110000 then 				--宝石
		return self.goodsConfig.datas[id]["icon"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return self.goodsConfig.datas[id]["icon"]
	elseif id>=200000 and id<500000 then 			--装备
		return self.goodsConfig.datas[id]["icon"]
	else 											--其他

	end
end

--根据物品id取得对应物品名称
--id: 物品id
function ConfigHelper:getGoodNameByGoodId(id)
	if not id then return end
	if id>=100000 and id <110000 then 				--宝石
		return self.goodsConfig.datas[id]["name"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return self.goodsConfig.datas[id]["name"]
	elseif id>=200000 and id<500000 then 			--装备
		return self.goodsConfig.datas[id]["name"]
	else 											--其他

	end
end

--根据物品的id取得物品的描述
--id: 物品id
function ConfigHelper:getGoodDescByGoodId(id)
	if not id then return end

	if id>=100000 and id <110000 then 				--宝石
		return self.goodsConfig.datas[id]["describe"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return self.goodsConfig.datas[id]["describe"]
	elseif id>=200000 and id<500000 then 			--装备
		return self.goodsConfig.datas[id]["describe"]
	else 											--其他

	end
end

--根据物品id取得对应等级限制
--id: 物品id
function ConfigHelper:getGoodLVByGoodId(id)
	if not id then return end
	if not self.goodsConfig.datas[id] then return 1 end
	if id>=100000 and id <110000 then 				--宝石
		return self.goodsConfig.datas[id]["limit_lvl"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return self.goodsConfig.datas[id]["limit_lvl"]
	elseif id>=200000 and id<500000 then 			--装备
		return self.goodsConfig.datas[id]["limit_lvl"]
	else 											--其他

	end
end

--根据物品id取得对应类型
--id: 物品id
--return : 1道具,2装备,3宝石,nil其他
function ConfigHelper:getGoodTypeByGoodId(id)
	if not id then return 0 end
	if not self.goodsConfig.datas[id] then return 0 end
	return self.goodsConfig.datas[id]["type"]
	--[[ 不知道以前为何要这样写，但现在按需要改成上面那样，可能会各种错
	if id>=100000 and id <110000 then 				--宝石
		return 3
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return 1
	elseif id>=200000 and id<500000 then 			--装备
		return 2
	else 											--其他

	end
	--]]
end

--根据物品id取得对应iconEffect
function ConfigHelper:getGoodIconEffectByGoodId(goods_id)
	if not goods_id then return 0 end
	if not self.goodsConfig.datas[goods_id] then return 0 end
	return self.goodsConfig.datas[goods_id]["icon_effect"]
end
--获取是不是时效性装备
function ConfigHelper:getGoodTimeLinessByGoodId(goods_id)
	if not goods_id then return 0 end
	if not self.goodsConfig.datas[goods_id] then return 0 end
	return self.goodsConfig.datas[goods_id]["is_timeliness"]
end

--获取装备职业
function ConfigHelper:getGoodCareerByGoodId(goods_id)
	if not goods_id then return 0 end
	if not self.goodsConfig.datas[goods_id] then return 0 end
	return self.goodsConfig.datas[goods_id]["limit_career"]
end


--根据物品的id取得物品的出售价格
--id: 物品id
function ConfigHelper:getGoodSaleByGoodId(id)
	if not id then return end

	if id>=100000 and id <110000 then 				--宝石
		return self.goodsConfig.datas[id]["sale"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		return self.goodsConfig.datas[id]["sale"]
	elseif id>=200000 and id<500000 then 			--装备
		return self.goodsConfig.datas[id]["sale"]
	else 											--其他

	end
end

--根据物品的id取得物品的部位
--id: 物品id
function ConfigHelper:getGoodSubTypeByGoodId(id)
	if not id then return end
	return self.goodsConfig.datas[id]["sub_type"]
end

--根据物品id取得物品的物品类型string
--id: 物品id
function ConfigHelper:getGoodTypeStringByGoodId(id)
	if not id then return end

	local ttpye 
	if id>=100000 and id <110000 then 				--宝石
		ttpye = self.goodsConfig.datas[id]["type"]
	elseif id>=110000 and id<200000 then 			--道具(包括普通物品,其他,货币类)
		ttpye = self.goodsConfig.datas[id]["type"]
	elseif id>=200000 and id<500000 then 			--装备
		return self:getEquipTypeByEquipId(id)
	else 											--其他

	end

	if ttpye == 1 then
		return "道具"
	elseif ttpye == 2 then
		return "装备"
	elseif ttpye == 3 then
		return "宝石"
	elseif ttpye == 4 then
		return "消耗"
	elseif ttpye == 5 then
		return "货币"
	elseif ttpye == 6 then
		return "礼包"
	elseif ttpye == 7 then
		return "道具"
	end
end

--根据物品id取得物品的品质
--id: 物品id
--return: 1白色 2绿色 3蓝色 4紫色 5橙色
function ConfigHelper:getGoodQualityByGoodId(id)
	if not id then return end
	if not self.goodsConfig.datas[id] then return 1 end
	return self.goodsConfig.datas[id]["quality"]
end
--获取物品sortid
function ConfigHelper:getGoodSortIdByGoodId(id)
	if not id then return end
	if not self.goodsConfig.datas[id] then return 1 end
	return self.goodsConfig.datas[id]["sort"]
end

--获取物品能否可以批量使用
function ConfigHelper:checkBatchUseByGoodId(id)
	if not id then return false end
	if not self.goodsConfig.datas[id] then return false end
	return tonumber(self.goodsConfig.datas[id]["batch"]) > 0
end

--根据物品id取得物品资源id
--id: 物品id
function ConfigHelper:getGoodResId(id)
	return self.goodsConfig.datas[id]["res"]
end

function ConfigHelper:getGoodSkip(id)
	return self.goodsConfig.datas[id]["skip"]
end

function ConfigHelper:getGoodSExchangeBy(id)
	return self.goodsConfig.datas[id]["exchange"]
end

function ConfigHelper:getGoodSCanExchangeBy(id)
	return self.goodsConfig.datas[id]["sale_sort"] ~= 0
end

--
-- 判断这个物品ID是否属于技能书。
--
function ConfigHelper:isSkillBookByGoodsId(goods_id)
	local goodsData = self.goodsConfig.datas[goods_id]
	return goodsData.type == 4 and goodsData.sub_type == 4
end


-----------------------------------------------------------------------------------------------------------------------

--根据装备id取得装备的对应类型的最小和最大攻击
--id: 装备id
--etype: 攻击类型,1物理攻击,2法术攻击,3道术攻击 
function ConfigHelper:getAtkByEquipId(id,etype)
	if not id or not etype then return end
	if etype == 1 then 			--物理攻击
		return self.equipsConfig.datas[id]["min_ac"],self.equipsConfig.datas[id]["max_ac"]
	elseif etype == 2 then 		--法术攻击
		return self.equipsConfig.datas[id]["min_mac"],self.equipsConfig.datas[id]["max_mac"]
	elseif etype ==3 then 		--道术攻击
		return self.equipsConfig.datas[id]["min_sc"],self.equipsConfig.datas[id]["max_sc"]
	end
end

--根据装备id取得装备的对应类型的最小和最大防御
--id:装备id
--etype:防御类型,1物防,2法防
function ConfigHelper:getDefByEquipId(id,etype)
	if not id or not etype then return end
	if etype == 1 then
		return self.equipsConfig.datas[id]["min_def"],self.equipsConfig.datas[id]["max_def"]
	elseif etype == 2 then
		return self.equipsConfig.datas[id]["min_res"],self.equipsConfig.datas[id]["max_res"]
	end
end

--根据装备id取得装备的生命
--id:装备id
function ConfigHelper:getHpByEquipId(id)
	if not id then return end
	return self.equipsConfig.datas[id]["hp"]
end

--根据装备id取得装备的装备类型string和类型id
--id: 装备id
function ConfigHelper:getEquipTypeByEquipId(id)--请看getEquipTypeByEquipId，200000外以后才行
	if not id then return end
	
	local t = self.goodsConfig.datas[id]["sub_type"]
	if t then
		if t==1 then
			return "武器",1
		elseif t==2 then
			return "衣服",2
		elseif t==3 then
			return "头盔",3
		elseif t==4 then
			return "项链",4
		elseif t==5 then
			return "勋章",5
		elseif t==6 then
			return "手镯",6
		elseif t==7 then
			return "戒指",7
		elseif t==8 then
			return "腰带",8
		elseif t==9 then 
			return "裤子",9
		elseif t==10 then
			return "鞋子",10
		elseif t==13 then
			return "翅膀",13
		elseif t==14 then
			return "宠物",14
		elseif t==15 then
			return "坐骑",15
		elseif t==21 then
			return "特武",21
		elseif t==22 then
			return "特甲",22
		elseif t==23 then
			return "护符",23
		elseif t==24 then
			return "护腿",24
		elseif t==25 then
			return "面具",25
		elseif t==26 then
			return "头巾",26
		elseif t==27 then
			return "耳环",27
		elseif t==28 then
			return "护肩",28
		elseif t==29 then
			return "特戒",29
		else
			return "",t
		end	
	end
end

--根据装备id取得装备的职业string,职业值
--id: 装备id
function ConfigHelper:getEquipCareerByEquipId(id)
	if not id then return end

	local roleManager = RoleManager:getInstance()
	local roleInfo = roleManager.roleInfo
	if not self.goodsConfig.datas[id] then return "无职业",roleInfo.career end
	local t = self.goodsConfig.datas[id]["limit_career"]
	if t then
		if t==1000 then
			return "战士",RoleCareer.WARRIOR
		elseif t==2000 then
			return "法师",RoleCareer.MAGE
		elseif t==3000 then
			return "道士",RoleCareer.TAOIST
		else
			return "无职业",roleInfo.career
		end	
	end
end

--根据装备id取得装备的有效基础属性(注意,只有基础属性)
--id: 装备id
function ConfigHelper:getEquipValidAttrByEquipId(id)
	if not id then return end
	local attrs = {}
	for i=2,15 do
		local key = self.equipsConfig.fields[i]
		if self.equipsConfig.datas[id] and self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key, self.equipsConfig.datas[id][key]})
		end
	end
	return attrs
end
function ConfigHelper:getEquipValidAttrByEquipIdSPJZ(id)
	if not id then return end
	local attrs = {}
	if self.equipsConfig.datas[id]  then
		local key = self.equipsConfig.fields[31]
		if self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key, self.equipsConfig.datas[id][key]})
		end
		key = self.equipsConfig.fields[32]
		if self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key, self.equipsConfig.datas[id][key]})
		end
		key = self.equipsConfig.fields[33]
		if self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key, self.equipsConfig.datas[id][key]})
		end
	end
	return attrs
end
--根据装备id取得装备的所有基础属性(注意,只有基础属性，所有)
--id: 装备id
function ConfigHelper:getEquipValidAllAttrByEquipId(id)
	if not id then return end 
	if self.equipsConfig.datas[id] then
		return self.equipsConfig.datas[id]
	end
	return nil
end

--根据装备id取得装备的有效基础属性(注意,包括加成的百分比)-- by yhn
--id: 装备id
function ConfigHelper:getEquipConfigByEquipId(id)
	if not id then return end
	if not self.equipsConfig.datas[id] then return end
 
	return self.equipsConfig.datas[id]
end

--根据装备id取得装备的有效基础属性(注意,只有基础属性)--加上职业限制 by shine
--id: 装备id
function ConfigHelper:getEquipValidAttrByEquipId2(id, career)
	if not id then return end
	if not self.equipsConfig.datas[id] then return end
	attrs = {}
	for i=2,3 do
		local key = self.equipsConfig.fields[i]
		if self.equipsConfig.datas[id] and self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key,self.equipsConfig.datas[id][key]})
		end
	end
    if career == 1000 then --战士
    	if self.equipsConfig.datas[id]["min_ac"]>0 then
			table.insert(attrs,{"min_ac", self.equipsConfig.datas[id]["min_ac"]})
		end
		if self.equipsConfig.datas[id]["max_ac"]>0 then
			table.insert(attrs,{"max_ac", self.equipsConfig.datas[id]["max_ac"]})
		end
    elseif career == 2000 then --法师
    	if self.equipsConfig.datas[id]["min_mac"]>0 then
			table.insert(attrs,{"min_mac",self.equipsConfig.datas[id]["min_mac"]})
		end
		if self.equipsConfig.datas[id]["max_mac"]>0 then
			table.insert(attrs,{"max_mac", self.equipsConfig.datas[id]["max_mac"]})
		end
    elseif career == 3000 then --道士
    	if self.equipsConfig.datas[id]["min_sc"]>0 then
			table.insert(attrs,{"min_sc",self.equipsConfig.datas[id]["min_sc"]})
		end
		if self.equipsConfig.datas[id]["max_sc"]>0 then
			table.insert(attrs,{"max_sc",self.equipsConfig.datas[id]["max_sc"]})
		end
    end
	for i=10,15 do
		local key = self.equipsConfig.fields[i]
		if self.equipsConfig.datas[id][key]>0 then
			table.insert(attrs,{key,self.equipsConfig.datas[id][key]})
		end
	end
	return attrs
end

--根据装备id获取外形
function ConfigHelper:getShowByEquipId(goods_id)
	return self.equipsConfig.datas[goods_id].res
end


--根据装备id和强化等级取得强化消耗
--id: 装备id
--strengLv: 强化等级
function ConfigHelper:getStrengCByEquipId(strengLv)
	return self.equipStrengConfig.datas[strengLv]
end

--根据强化等级取得强化加成
--strengLv: 强化等级
function ConfigHelper:getStengPlusStrengLv(strengLv,subType)
	for i=1,#self.equipPlusConfig.datas do
		if tonumber(self.equipPlusConfig.datas[i].stren_lv) == strengLv and  tonumber(self.equipPlusConfig.datas[i].sub_type) == subType then
			return self.equipPlusConfig.datas[i]
		end
	end
	return nil
end

--根据装备id取得洗炼消耗
--id: 装备id
function ConfigHelper:getBaptizeCByEquipId(id)
	local lv = self:getGoodLVByGoodId(id)
	local a = math.ceil(lv/10)
	local b = 9 * (self:getGoodQualityByGoodId(id) - 2)
	return self.equipBapTizeConfig.datas[a+b]
end

--根据装备id取得洗炼属性条数
--id: 装备id
function ConfigHelper:getBapBNByEquipId(id)
	local cb = self:getBaptizeCByEquipId(id)
	return cb.branch_num
end

--取得神器属性
--sub_type: 装备类型
--starLv: 神器属性条数
--lv:神器等级,默认为1级
function ConfigHelper:getArtifactAttr(sub_type,starLv,lv)
	if not lv then lv = 1 end
	for i=1,#self.artifactAttrConfig.datas do
		if self.artifactAttrConfig.datas[i].sub_type == sub_type and self.artifactAttrConfig.datas[i].star == starLv and self.artifactAttrConfig.datas[i].lv == lv then
			local result = self.artifactAttrConfig.datas[i].attr_list
			return result
		end
	end
	return {}
end

--取得神器显示属性
--sub_type: 装备类型
--starLv: 神器属性条数
--lv:神器等级,默认为1级
function ConfigHelper:getShowArtAttr(sub_type,starLv,lv)
	if not lv then lv = 1 end
	for i=1,#self.artifactAttrConfig.datas do
		if self.artifactAttrConfig.datas[i].sub_type == sub_type and self.artifactAttrConfig.datas[i].star == starLv and self.artifactAttrConfig.datas[i].lv == lv then
			local result = self.artifactAttrConfig.datas[i].content_list
			return result
		end
	end
	return {}
end

-----------------------------------------------------------------------------------------------------------------------

--根据道具id取得道具的道具类型string
--id: 道具id
-- function ConfigHelper:getPropTypeByPropId(id)
-- 	if not id then return end
	
-- 	local t = self.goodsConfig.datas[id][5]
-- 	if t then
-- 		return "未知物品类型"
-- 	end
-- end

--根据道具Id取得道具是否可以使用
--id: 道具id
function ConfigHelper:getPropCanUseByPropId(id)
	if not id then return end

	local t = self.goodsConfig.datas[id]["is_use"]
	if t and t>0 then
		return true
	else
		return false
	end
end

-----------------------------------------------------------------------------------------------------------------------
--装备打造列表
function ConfigHelper:getAFByCareer(career)
	if not career then return end
	local AFs = {}
	for i=1,#self.fusionConfig.datas do
		local con = self.fusionConfig.datas[i]
		--type 1\5:打造用，3:提纯用
		if con.type == 1 or con.type == 5 or con.type == 7 then
			local c = math.floor(career/1000)
			local r = math.floor(con.sub_type/100)
			local s = con.sub_type%100

			if not AFs[s] then
				AFs[s] = {}
			end

			if c == r then
				AFs[s][#AFs[s] + 1] = con
		 	end
		 	
		end
	end
  	return AFs
end
--装备打造道具列表
function ConfigHelper:getProductGoodsyCareer(career)
	if not career then return end
	local AFs = {}
	for i=1,#self.fusionConfig.datas do
		local con = self.fusionConfig.datas[i]
		--type 1:打造用，3:提纯用
		if con.type == 1 then
			local c = math.floor(career/1000)
			local r = math.floor(con.sub_type/100)
			if c == r then
				AFs[#AFs + 1] = con
		 	end
		end
	end
  	return AFs
end

--获取道具提纯
function ConfigHelper:getPur()
	local AFs = {}
	for i=1,#self.fusionConfig.datas do
		local con = self.fusionConfig.datas[i]
		--type 1:打造用，3:提纯用
		if con.type == 3 then
			AFs[#AFs + 1] = con
		end
	end
  	return AFs
end

--取得有多少种级别的神器
function ConfigHelper:getAFRankCount()
	local AFRankCount = 0 
	local AFRank = {}
	for i=1,#self.fusionConfig.datas do
		local con = self.fusionConfig.datas[i]
		if con.type == 1 then
			--神器打造的配置表sub_type为101时代表战士的1-10级装备(称为10级神器)
			--203时代表法师的21-30级装备(称为30级神器)
			local rank = con.sub_type%102
			if not AFRank[rank] then
				AFRank[rank] = {min=rank*10-9,max=rank*10}
			end
		end
	end
	-- dump(AFRank)
	return #AFRank
end

--取得相应职业和级别的神器装备
--career:职业 1000战士,2000法师,3000道士
--rank:神器级别 1代表10级神器,2代表20级神器,......
function ConfigHelper:getAFByCareerAndRank(career,rank)
	if not career then return end
	if not rank then return end
	local AFs = {}
	for i=1,#self.fusionConfig.datas do
		local con = self.fusionConfig.datas[i]
		if con.type == 1 then
			--神器打造的配置表sub_type为101时代表战士的1-10级装备(称为10级神器)
			--203时代表法师的21-30级装备(称为30级神器)
			local c = math.floor(con.sub_type/100)
			local r = con.sub_type%100
			if c*1000 == career and r == rank then
				for k,v in pairs(con.product) do
					if v[1] == "goods" then
						--artifact_star=2 通过打造的生成的神器固定为2条神器属性
						table.insert(AFs,{fusionKey=con.key,goods_id=v[2],is_bind=v[3],num=v[4],artifact_star=2})

						break
					end
				end
			end
		end
	end
	return AFs
end

--取得合成材料(神器锻造也在合成表中)
--fusionKey: 合成表key
function ConfigHelper:getFusionStuffByKey(fusionKey)
	local con = self.fusionConfig.datas[fusionKey]
	if con then
		return con.stuff
	end
	return {}
end

--取得合成品
--fusionKey: 合成表key
function ConfigHelper:getFusionProductByKey(fusionKey)
	local con = self.fusionConfig.datas[fusionKey]
	if con then
		return con.product
	end
	return {}
end

--获取合成config
function ConfigHelper:getFusionProductConfigByKey(fusionKey)
	return self.fusionConfig.datas[fusionKey]
end
---------------------------------------------------------------------------------------------------------
--取得神器升级所需的经验
--lv:神器等级
--starLv:神器属性条数
function ConfigHelper:getArtExp(lv,starLv)
	for i=1,#self.artExpConfig.datas do
		if self.artExpConfig.datas[i].lv==lv and self.artExpConfig.datas[i].star_lv==starLv then
			return self.artExpConfig.datas[i].exp
		end
	end
	return 0
end

--取得神器的铜钱消耗系数
--lv:神器等级
--starLv:神器属性条数
function ConfigHelper:getArtCoin(lv,starLv)
	for i=1,#self.artExpConfig.datas do
		if self.artExpConfig.datas[i].lv==lv and self.artExpConfig.datas[i].star_lv==starLv then
			return self.artExpConfig.datas[i].coin
		end
	end
	return 0
end

---------------------------------------------------------------------------------------------------------
--取得属性的战力系数
--key:属性的key
function ConfigHelper:getAttrFight(key)
	if self.fightingConfig.datas[key] then
		return self.fightingConfig.datas[key]["fight"]
	end
	return 0
end


---------------------------------------------------------------------------------------------------------
--取得商城出售商品
--storeType:商城类型 1:热销 2:元宝 3:绑定元宝 4:稀有
function ConfigHelper:getStoreItemsByType(storeType)
	if self.storeTable[storeType] then
		return self.storeTable[storeType].datas
	end
	return {}
end

---------------------------------------------------------------------------------------------------------
--取得游戏攻略
function ConfigHelper:getStrategyList()
	return self.strategyConfig.datas
end

function ConfigHelper:getStrategyChaptersByType(strategyId)
	local chapters = {}

	for _, v in pairs(self.strategy_chapterConfig.datas) do
		if v.chapter_type == strategyId then
			chapters[#chapters + 1] = v
		end
	end

	table.sort(chapters, function(a, b) return a.id < b.id end)
	return chapters
end

-- 取得攻略章节列表
function ConfigHelper:getStrategyChaptersById(strategyId)
	local chapters = {}

	for _, v in pairs(self.strategy_chapterConfig.datas) do
		if v.strategy_id == strategyId then
			chapters[#chapters + 1] = v
		end
	end

	table.sort(chapters, function(a, b) return a.id < b.id end)
	return chapters
end
---------------------------------------------------------------------------------------------------------
--取得公告内容
--id:公告id
--args:公告参数
function ConfigHelper:getNoticeContent(id,args)
	if not self.noticeConfig.datas[id] then return end
	local str = self.noticeConfig.datas[id].content
	if not str then return "" end
	local params = args or {}
	local temp = str
	local result = ""
	local index=1
	while(true) do
		local s,e = string.find(temp,"%%s")
		if s then
			local part1 = string.sub(temp,1,s-1)
			temp = string.sub(temp,e+1)
			result = result..part1
			if params[index] then
				result = result..params[index]
			else
				result = result.."%s"..temp
				break
			end
			
		else
			result = result..temp
			break
		end
		index = index + 1
	end
	return result
end


function ConfigHelper:getNoticePriority(id)
	if not self.noticeConfig.datas[id] then return 1 end
	return self.noticeConfig.datas[id].priority
end

---------------------------------------------------------------------------------------------------------
--取世界boss列表
function ConfigHelper:getWorldBossList()
	return self.worldBossConfig.datas
end

function ConfigHelper:getVipBossList()
	local arr = {}
	local obj
	for i=1,#self.vip_bossConfig.datas do
		obj = self.vip_bossConfig.datas[i]
		if obj.is_open and obj.is_open == 0 then
		else
			table.insert(arr,obj)
		end 
	end
	return arr
end

function ConfigHelper:getCityBossList()
	return self.city_bossConfig.datas
end

function ConfigHelper:getWorldBossConfigById(scene_id,boss_id)
	if boss_id == nil or scene_id == nil then
		return nil
	end

	for i=1,#self.worldBossConfig.datas do
		if self.worldBossConfig.datas[i].scene_id == scene_id and self.worldBossConfig.datas[i].boss_id == boss_id then
			return self.worldBossConfig.datas[i]
		end
	end

	for i=1,#self.vip_bossConfig.datas do
		if self.vip_bossConfig.datas[i].scene_id == scene_id and self.vip_bossConfig.datas[i].boss_id == boss_id then
			return self.vip_bossConfig.datas[i]
		end
	end
	
	return nil
end

--取怪物名
--id: 怪物id
function ConfigHelper:getMonsterNameById(id)
	local config = getConfigObject(id,MonsterConf)
	if not config then return "" end
	return config.name
end

--取怪物等级
--id: 怪物id
function ConfigHelper:getMonsterLvById(id)
	local config = getConfigObject(id,MonsterConf)
	if not config then return 1 end
	return config.lv
end

--取怪物发现敌人音效
--id: 怪物id
function ConfigHelper:getMonsterDiscoverSound(id)
	return self:getMonsterSoundOfField(id, "findsound_id")
end

--取怪物攻击音效
--id: 怪物id
function ConfigHelper:getMonsterAttckSound(id)
	return self:getMonsterSoundOfField(id, "atksound_id")
end

--取怪物受击音效
--id: 怪物id
function ConfigHelper:getMonsterHurtSound(id)
	return self:getMonsterSoundOfField(id, "gethitsound_id")
end

--取怪物死亡音效
--id: 怪物id
function ConfigHelper:getMonsterDeathSound(id)
	return self:getMonsterSoundOfField(id, "deathsound_id")
end

--取怪物音效
--id: 怪物id
--field: 音效字段
function ConfigHelper:getMonsterSoundOfField(id, field)
	local config = getConfigObject(id,MonsterConf)
	if config and config[field] and config[field] ~= "null" then
		return config[field]
	end
end

function ConfigHelper:getMonsterResById(id)
	local config = getConfigObject(id,MonsterConf)
	if not config then return 1 end
	return config.resId
end

---------------------------------------------------------------------------------------------------------

--取场景等级限制
--sceneId:场景id
function ConfigHelper:getSceneLvLimit(sceneId)
	local config = getConfigObject(sceneId,ActivitySceneConf)
	if not config then return 0 end
	return config.lv_limit
end

--取场景名
--sceneId:场景id
function ConfigHelper:getSceneName(sceneId)
	local config = getConfigObject(sceneId,ActivitySceneConf)
	if not config then return "" end
	return config.name
end

---------------------------------------------------------------------------------------------------------
-- self.guildConfig
-- self.guild_activityConfig
-- self.guild_activity_bossConfig

--取公会升级经验
--guildLV:公会等级
function ConfigHelper:getGuildExp(guildLV)
	return self.guildConfig.datas[guildLV].exp
end

--取公会成员限制
--guildLV:公会等级
function ConfigHelper:getGuildMemberLimit(guildLV)
	return self.guildConfig.datas[guildLV].member_limit
end

--取军团成员限制
--corpsLv:军团等级
function ConfigHelper:getCorpsMemberLimit(corpsLv)
	return self.groupConfig.datas[corpsLv].member_limit
end

--取公会捐献
--donationType:捐献类型
function ConfigHelper:getGuildDonation(donationType)
	return self.guildDonationConfig.datas[donationType]
end

--取公会商店物品列表
function ConfigHelper:getGuildStoreItems()
	local goods = {}
	for _, v in pairs(self.guildShopConfig.datas) do
		goods[#goods + 1] = v
	end
	table.sort(goods,function(a,b) return a.order < b.order end)
	return goods
end

--取公会活动列表
function ConfigHelper:getGuildActivityList()
	return self.guild_activityConfig.datas
end

--取公会活动BOSS列表
function ConfigHelper:getGuildActBossList()
	return self.guild_activity_bossConfig.datas
end
---------------------------------------------------------------------------------------------------------

--取自动喝药药品Id列表
--drugType:药品类型 1红药 2蓝药 3瞬回药
function ConfigHelper:getAutoDrugIdList(drugType)
	return self.autoDrugConfig.datas[drugType].list
end

---------------------------------------------------------------------------------------------------------
--获取日常任务配置
function ConfigHelper:getTask(taskId)
	return self.dailyTaskConfig.datas[taskId]
end

function ConfigHelper:getDailyTaskReward()
	local backArr = {}
	local playLv = RoleManager:getInstance().roleInfo.lv;
	local lv = 0
	for i=1,#self.taskrewardConfig.datas do
		if self.taskrewardConfig.datas[i].lv <= playLv then
			lv = self.taskrewardConfig.datas[i].lv
			break
		end
	end
	for i=1,#self.taskrewardConfig.datas do
		if self.taskrewardConfig.datas[i].lv == lv then
			table.insert(backArr,self.taskrewardConfig.datas[i])
		end
	end
	return backArr
end

---------------------------------------------------------------------------------------------------------
--玛雅神殿
function ConfigHelper:getMayaItems()
	return self.treasureConfig.datas
end
function ConfigHelper:getMayaDes(index)
	return self.treasuredesConfig.datas[index]
end

---------------------------------------------------------------------------------------------------------
--副本
function ConfigHelper:getCopyList()

	local list = {}
	for k,v in pairs(self.instanceConfig.datas) do
		if tonumber(v.instanceType) == 1 then
		 	list[k] = v
		end
	end
	return list

end
 
function ConfigHelper:getCopyInfo(copyId)
	return self.instanceConfig.datas[copyId]
end

---------------------------------------------------------------------------------------------------------
--排位赛
function ConfigHelper:GetQualifyingStoreGoodsList()
	-- self.arena_shopConfig
	local goodsList = {}
	for _, v in ipairs(self.arena_shopConfig.datas) do
		local goodsName = self:getGoodNameByGoodId(v.goods_id)
		goodsList[#goodsList + 1] = {storeid = v.key, goods_id = v.goods_id, fame = v.reputation, limit = v.limit_count, goodsName = goodsName}
	end
	return goodsList
end

function ConfigHelper:GetQualifyingRewardByRank(rank)
	-- self.arena_rewardConfig
	local reward = nil
	for k, v in ipairs(self.arena_rewardConfig.datas) do
		if rank >= v.min_rank and rank <= v.max_rank then
			reward = v
			break
		end
	end

	if reward then
		local goodsData = reward.goods_list[1]
		local goodsItem = {goods_id = goodsData[1], is_bind = goodsData[2], num = goodsData[3]}
		return {fame = reward.reputation, glod = reward.coin, goodsItem = goodsItem}
	end

	return nil
end

---------------------------------------------------------------------------------------------------------
--沙巴克 
function ConfigHelper:GetShabakeRewardsInfo()
	local configs = self.city_officerConfig.datas
	local info = {}
	local formatGoodsData = function(table)
		return {goods_id = table[1], is_bind = table[2], num = table[3]}
	end
	local convertGoodsList = function(list)
		local goodsList = {}
		for _, v in ipairs(list) do
			goodsList[#goodsList + 1] = formatGoodsData(v)
		end
		return goodsList
	end

	local convertInfo = function(configInfo)
		local info = {}
		info.num    = configInfo.num
		info.isshow = configInfo.isshow
		info.day_reward_goods = convertGoodsList(configInfo.day_reward_goods)
		info.frist_reward_goods = convertGoodsList(configInfo.frist_reward_goods)
		return info
	end

	info.master = convertInfo(configs[1])
	info.deputy = convertInfo(configs[2])
	info.elder  = convertInfo(configs[3])
	info.menber = convertInfo(configs[4])

	return info
end

function ConfigHelper:getShabakeOfficer()
	local configs = self.city_officer_qianConfig.datas
	local list = {}
	for i=1,#configs do
		local info = {officer_id = configs[i].officer_id, name = configs[i].name}
		list[i] = info
	end

	return list
end

---------------------------------------------------------------------------------------------------------
--随机名库
function ConfigHelper:getRandomName(isMan)
	local gender = isMan and 0 or 1

	local function getContinueTable(libs)
		local continueTable = {}
		for _, v in pairs(libs) do
			continueTable[#continueTable + 1] = v
		end
		return continueTable
	end

	local function filterGender(libs, gender)
		local filters = {}
		for _, v in ipairs(libs) do
			if v.gender == gender then
				filters[#filters + 1] = v
			end
		end
		return filters
	end

	local firstLibs = getContinueTable(self.random_first_nameConfig.datas)
	local lastLibs  = filterGender(getContinueTable(self.random_last_nameConfig.datas), gender)

	math.randomseed(tostring(require("socket").gettime()):reverse():sub(1, 6))
	local firstName = firstLibs[math.random(#firstLibs)].name
	local lastName  = lastLibs[math.random(#lastLibs)].name

	return firstName .. lastName
end

---------------------------------------------------------------------------------------------------------
--地图配置
--self.monster_areaConfig
--self.transferConfig

function ConfigHelper:getTransferConfig()
	return self.transferConfig.datas
end

function ConfigHelper:getMapTransferListBySceneId(sceneId)
	local datas = self.transferConfig.datas
	local list = {}
	for _, v in pairs(datas) do
		if v.fromScene == sceneId then
			if not v.fromPos_c then
				local posStr = string.gsub(v.fromPos, "[{|}]", "")
				local pointArr = string.split(posStr, ",")
				v.fromPos_c = cc.p(tonumber(pointArr[1]), tonumber(pointArr[2]))
			end
			list[#list + 1] = v
		end
	end
	table.sort(list, function(a, b) return a.id < b.id end)
	return list
end

function ConfigHelper:getMapMonsterListBySceneId(sceneId)
	local datas = self.monster_areaConfig.datas
	local list = {}
	for _, v in pairs(datas) do
		if v.scene_id == sceneId then
			if not v.point_c then
				local pointArr = string.split(v.point, ",")
				v.point_c = cc.p(tonumber(pointArr[1]), tonumber(pointArr[2]))
			end
			list[#list + 1] = v
		end
	end
	table.sort(list, function(a, b) return a.id < b.id end)
	return list
end
 
---------------------------------------------------------------------------------
--获取膜拜信息
function ConfigHelper:getWorShipInfo(lv)
	for i=1,#self.worship_goodsConfig.datas do
		if lv >= self.worship_goodsConfig.datas[i].min_lv and lv <= self.worship_goodsConfig.datas[i].max_lv then
			return self.worship_goodsConfig.datas[i]
		end
	end
	return nil
end

function ConfigHelper:checkWorShip(lv)
 
	if lv < self.worship_goodsConfig.datas[1].min_lv then
		return 0
	elseif lv > self.worship_goodsConfig.datas[#self.worship_goodsConfig.datas].max_lv then
		return 1
	else
		return -1
	end
end

---------------------------------------------------------------------------------
--功能开放配置表
--functionConfig

function ConfigHelper:getFunctionConfigById(id)
	return self.functionConfig.datas[id]
end

---------------------------------------------------------------------------------
--活动配置表
--activity_listConfig

-- 根据活动类型获取活动集合
function ConfigHelper:getActivitysByType(activityType)
	local activitys = {}

	for _, v in pairs(self.activity_listConfig.datas) do
		if v.type == activityType then
			activitys[#activitys + 1] = v
		end
	end

	table.sort(activitys, function(a, b) return a.id < b.id end)

	return activitys
end

---------------------------------------------------------------------------------
-- 顶部导航栏菜单配置表
-- top_navigation_menuConfig
function ConfigHelper:getTopNavigationMenus()
	return self.top_navigation_menuConfig.datas
end

---------------------------------------------------------------------------------
-- 福利中心配置表
-- welfare_typeConfig  福利大厅左侧福利类型列表。
-- active_rewardConfig 福利大厅所有的奖励信息配置表

-- 获取所有的福利类型列表。
function ConfigHelper:getWelfareTypes()
	return self.welfare_typeConfig.datas
end

-- 根据福利类型获取这个类型下的奖励列表。
function ConfigHelper:getWelfareRewardsByType(type)
	local reward_list = {}
	for _, v in pairs(self.active_rewardConfig.datas) do
		if v.type == type then
			--[[
			if not v.goods_info and RoleManager:getInstance().roleInfo.lv >= v.min_lv and RoleManager:getInstance().roleInfo.lv <= v.max_lv then
				local reward = v.reward[1]
				v.goods_info = {goods_id = reward[1], is_bind = reward[2], num = reward[3]}
			end
			
			reward_list[#reward_list + 1] = v
			--]]
			if RoleManager:getInstance().roleInfo.lv >= v.min_lv and RoleManager:getInstance().roleInfo.lv <= v.max_lv then
				reward_list[#reward_list + 1] = v
			end
		end
	end

	table.sort(reward_list, function(a, b) return a.key < b.key end)
	return reward_list
end

-- 获取指定的奖励信息。
function ConfigHelper:getWelfareRewardById(reward_id)
	if not reward_id then return end
	for _, v in pairs(self.active_rewardConfig.datas) do
		if v.key == reward_id then
			if not v.goods_info then
				local reward = v.reward[1]
				v.goods_info = {goods_id = reward[1], is_bind = reward[2], num = reward[3]}
			end
			return v
		end
	end
end

-- 获取首冲的奖励Id
function ConfigHelper:getFirstRewardId()
	local rewards = self:getWelfareRewardsByType(3)
	if rewards and #rewards > 0 then
		return rewards[1].key
	end
end

---------------------------------------------------------------------------------
-- 世界地图配置表
-- self.word_mapConfig
function ConfigHelper:getWorldMapPlaces()
	return self.word_mapConfig.datas
end

---------------------------------------------------------------------------------------------------------
-- 新手引导数据配置表
-- self.guide_stepConfig
-- self.guide_triggerConfig
-- self.guide_operateConfig
-- self.guide_body_click_typeConfig
-- self.guide_target_abs_of_clickConfig
-- self.guide_target_auto_of_clickConfig
-- self.guide_body_slide_typeConfig

--
-- 根据触发类型获取该类型的所有触发数据。
-- type = 1任务接受，2.完成任务，3系统开启，4等级，5初次进入游戏
--
function ConfigHelper:getGuideTriggerByType(type)
	local cache = self.guide_triggerConfig.cacheRef or {}
	local triggers = cache[type]

	if not triggers then
		triggers = {}
		for _, v in pairs(self.guide_triggerConfig.datas) do
			if v.type == type then
				triggers[#triggers + 1] = v
			end
		end

		cache[type] = triggers
		self.guide_triggerConfig.cacheRef = cache
	end
	return triggers
end


--
-- 根据步骤ID获取该步骤所附带的所有信息。
--
function ConfigHelper:getGuideDataByStepId(step_id)
	-- ============================================================
	-- //////////////////////////////////////////
	-- 点击类型
	-- ------------------------------------------
	local function getGuideBodyWithType1(body_id)
		local function getTargetBodyWithType1(target_id)
			return self.guide_target_abs_of_clickConfig.datas[target_id]
		end

		local function getTargetBodyWithType2(target_id)
			return self.guide_target_auto_of_clickConfig.datas[target_id]
		end

		local function getTargetBodyWithTargetType(target_type, target_id)
			if target_type == 1 then
				return getTargetBodyWithType1(target_id)
			elseif target_type == 2 then
				return getTargetBodyWithType2(target_id)
			end
		end

		local guide_body  = self.guide_body_click_typeConfig.datas[body_id]

		if not guide_body.target_body_data then
			local target_type = guide_body.target_type
			local target_id   = guide_body.target_body
			guide_body.target_body_data = getTargetBodyWithTargetType(target_type, target_id)
		end
		return guide_body
	end

	-- //////////////////////////////////////////
	-- 滑动类型
	-- ------------------------------------------
	local function getGuideBodyWithType3(body_id)
		local guide_body = self.guide_body_slide_typeConfig.datas[body_id]
		return guide_body
	end

	local function getGuideBodyWithGuideType(guide_type, body_id)
		if guide_type == 1 then
			return getGuideBodyWithType1(body_id)
		elseif guide_type == 3 then
			return getGuideBodyWithType3(body_id)
		end
	end

	-- ============================================================
	local function getOperateDataByOperateId(operate_id)
		local operate_data = self.guide_operateConfig.datas[operate_id]

		if not operate_data.guide_body_data then
			local type      = operate_data.guide_type
			local body_id   = operate_data.guide_body
			operate_data.guide_body_data = getGuideBodyWithGuideType(type, body_id)
		end

		return operate_data
	end

	local function getStepDataByStepId(step_id)
		local stepData = self.guide_stepConfig.datas[step_id]
		if not stepData.operate_data then
			local guide_operate_id = stepData.guide_operate_id
			stepData.operate_data = getOperateDataByOperateId(guide_operate_id)
		end
		return stepData
	end

	local stepData = getStepDataByStepId(step_id)
	-- dump(stepData, "", 4)
	return stepData
 end

 -------------------------------------------------------------------------------------------------

function ConfigHelper:getMedal(career)
	local list = {}
 
	for _, v in pairs(self.medalConfig.datas) do
			if v.career == career then
				list[#list + 1] = v
			end
	end
	table.sort(list,function(a,b) return  a.key < b.key end )
	return list
end

--根据翅膀ID获取翅膀强化信息
function ConfigHelper:getWing(goods_id)
	for _, v in pairs(self.wingConfig.datas) do
		if v.goods_id == goods_id then
			local goods_info = self:getGoodsByGoodId(goods_id)
			v.goods_info = goods_info
			return v
		end	
	end
	return 0
end



--获取道具强化成功率
function ConfigHelper:getStrenRate(id,lv)
	 for i=1,#self.stren_rateConfig.datas do
	 	if self.stren_rateConfig.datas[i].goods_id == id and self.stren_rateConfig.datas[i].stren_lv == lv then
	 		return self.stren_rateConfig.datas[i].rate
	 	end
	 end
	 return 0
end
--获取强化道具列表
function ConfigHelper:getStrenGoodsList(lv)
	local list = {}
	 for i=1,#self.stren_rateConfig.datas do
	 	if self.stren_rateConfig.datas[i].stren_lv == lv then
	 		list[#list + 1] = self.stren_rateConfig.datas[i].goods_id
	 	end
	 end
	 return list
end
--判断物品是否可以分解
function ConfigHelper:canDecompose(id)
	return self.decomposeConfig.datas[id] ~= nil
end
--获取分解物品
function ConfigHelper:getDecomposeById(id)
	return self.decomposeConfig.datas[id]
end

--获取对应职业的vip信息
function ConfigHelper:getVipInfo(career)
	local list = {}

	for k,v in pairs(self.vipConfig.datas) do
		if v.career == career then
			list[v.lv] = v
		end
	end
 	
	return list
end
--获取对应职业和VIP级别的信息
function ConfigHelper:getVipLvInfo(career,lV)
	for k,v in pairs(self.vipConfig.datas) do
		if v.career == career and lV == v.lv then
			return v;
		end
	end
 	
	return nil
end

--获取充值配置表
function ConfigHelper:getChargeList()

	return self.chargeConfig.datas
end

--获取分包下载奖励配置表
function ConfigHelper:getDownLoadConfig()

	return self.downloadConfig.datas
end

--获取月签到表
function ConfigHelper:getSignConfig(year, month)
	local data = {}

	for i=1,#self.everyday_signConfig.datas do
		if self.everyday_signConfig.datas[i].year == tonumber(year) and tonumber(month) == self.everyday_signConfig.datas[i].month then
			table.insert(data, self.everyday_signConfig.datas[i])
		end
	end

	return data 
end
--获取交易所左侧菜单栏
function ConfigHelper:getBuyMenu()
 
	return self.sale_sortConfig.datas
end

--未知暗殿
--id 1:未知暗殿；2:屠龙大会
function ConfigHelper:getDarkHouseGoods(id)
 
	return self.dark_palaceConfig.datas[id]
end

function ConfigHelper:getGoodCDTime(type,subType)
 	for i=1,#self.goods_typeConfig.datas do
		if self.goods_typeConfig.datas[i].type == tonumber(type) and tonumber(subType) == self.goods_typeConfig.datas[i].sub_type then
			return self.goods_typeConfig.datas[i].cd
		end
	end
end

--获取屠龙大会奖励
function ConfigHelper:getDragonRewardByRank(rank)
 	for i=1,#self.world_boss_rewardConfig.datas do
		if self.world_boss_rewardConfig.datas[i].min_rank >= rank and rank <= self.world_boss_rewardConfig.datas[i].max_rank then
			return self.world_boss_rewardConfig.datas[i].rewaed_item
		end
	end
	return nil
end

--获取胜者为王奖励
function ConfigHelper:getWinnerRewardByRank(rank)
 	for i=1,#self.szww_rewardConfig.datas do
		if self.szww_rewardConfig.datas[i].min_rank >= tonumber(rank) and tonumber(rank) <= self.szww_rewardConfig.datas[i].max_rank then
			return self.szww_rewardConfig.datas[i].rewaed_item
		end
	end
	return nil
end

--怪物攻城奖励
function ConfigHelper:getMonsterAttackRewardByRank(rank,win)
 	for i=1,#self.monster_attack_rewardConfig.datas do
		if self.monster_attack_rewardConfig.datas[i].min_rank >= tonumber(rank) and tonumber(rank) <= self.monster_attack_rewardConfig.datas[i].max_rank then
			return win == 1 and self.monster_attack_rewardConfig.datas[i].rewaed_item or self.monster_attack_rewardConfig.datas[i].fail_item 
		end
	end
	return nil
end
--获取屏蔽字库
function ConfigHelper:getSensitiveWord()
	return self.sensitive_wordConfig.datas
end

--获取套装列表
function ConfigHelper:getSuitArr(id)
 
	return self.equips_suit_goodsConfig.datas[id]
end

--获取套装属性
function ConfigHelper:getSuitProperById(id)
	return self.equips_suitArr[id]
end

function ConfigHelper:getEquipBaptizeMaxById(id)
	return self.equips_baptize_qianConfig.datas[id].max
end

function ConfigHelper:getQuickUseList()
	local list = {}
 	for i=1,#self.quick_medConfig.datas do
		list[#list + 1] = self.quick_medConfig.datas[i].goodsId
	end
	return list
end

--开服活动
function ConfigHelper:getServiceActivityTypeConfig(id)
	return self.active_service_typeConfig.datas[id]
end

function ConfigHelper:getServiceActivityConfig(id)
	
	local list = {}
	for k,v in pairs(self.active_serviceConfig.datas) do
		if id == v.type then
			list[v.id] = v
		end
	end
 
	return list
	
end

function ConfigHelper:getRgbaConfig()
	return self.rgbaConfig.datas
end

function ConfigHelper:getBuffConfigById(id)

	if not id then return end
	return self.buffConfig.datas[id]
end

function ConfigHelper:getDailyConfig()
	return self.dailySignConfig.datas
end

function ConfigHelper:getMonthCardConfig()

	return self.monthCardConfig.datas

end

function ConfigHelper:getRuleByKey(key)
	if self.ruleConfig.datas[key] then
		return self.ruleConfig.datas[key].des
	end
	return ""
end

function ConfigHelper:canSoulByGoodsId(goods_id)
	return self.equipSouldArr[goods_id] ~= nil
end

function ConfigHelper:getSoulConfigByIdAndLv(goods_id,lv)
	if self.equipSouldArr[goods_id] and self.equipSouldArr[goods_id][lv] then
		return self.equipSouldArr[goods_id][lv]
	end
	return nil
end

function ConfigHelper:getSoulAddConfig(lv)
	if self.equips_soul_plusConfig.datas[lv] then
		return self.equips_soul_plusConfig.datas[lv]
	end
	return nil
end

function ConfigHelper:getEquipBaptizeLockStone(num)
	return self.equips_baptize_lockConfig.datas[num].cost
end

function ConfigHelper:getBagConfig()
	return self.cellConfig.datas
end

function ConfigHelper:getFaceConfig()
	return self.faceConfig.datas
end

function ConfigHelper:getAnsweringRewardConfig()
	return self.answeringRewardConfig.datas
end

function ConfigHelper:getQuestionConfig()
	return self.questionConfig.datas
end

--是否在不可分解表里
function ConfigHelper:getCanDecomposeById(id)
	return self.equip_not_decomposeConfig.datas[id] ~= nil
end

--是否可以批量分解 ：is_decompose字段  1不能进行批量分解，0可以进行批量分解
function ConfigHelper:getCanBatchDecomposeById(id)
	return self.goodsConfig.datas[id]["is_decompose"] == 0
end

function ConfigHelper:getMarkByTypeCareerLv(type,career,lv)

	if type == nil or career == nil or lv == nil then
		return nil
	end

	for i=1,#self.markConfig.datas do
		if type == self.markConfig.datas[i].type and career == self.markConfig.datas[i].career and lv == self.markConfig.datas[i].lv then
			return self.markConfig.datas[i]
		end
	end

	return nil
end
--装备展示
function ConfigHelper:getEquipShowByCareer(career)
	if career == nil then
		return nil
	end

	local list = {}

	for i=1,#self.equips_exhibitionConfig.datas do
		if self.equips_exhibitionConfig.datas[i].career_id == career then
			list[#list + 1] = self.equips_exhibitionConfig.datas[i]
		end
	end
	return list
end
--装备展示获取途径
function ConfigHelper:getEquipShowExhibition()
	return self.equips_exhibition_listConfig.datas 
end

function ConfigHelper:getBaptizeFee(num)
	if num == nil then
		return 0
	end

	for i=1,#self.equips_baptiz_change_jadeConfig.datas do
		if num*100 >= self.equips_baptiz_change_jadeConfig.datas[i].min_percent and num*100 <= self.equips_baptiz_change_jadeConfig.datas[i].max_percent then
			return self.equips_baptiz_change_jadeConfig.datas[i].jade
		end
	end
	
 	return 0
end

function ConfigHelper:getHolidayConfigById(id)
	return self.holidays_activeConfig.datas[id]
end
--获取装备是否在过滤列表
function ConfigHelper:getEquipCanBaptizeBySubType(subType)
	return self.equips_baptize_limitConfig.datas[subType] == nil
end

--获取装备洗练条数
function ConfigHelper:getEquipBaptizeNumByQuality(quality)
	if self.equips_baptize_numberConfig.datas[quality] then
		return self.equips_baptize_numberConfig.datas[quality].number
	else
		return 0
	end
	
end

function ConfigHelper:getRideConfigById(id)
	if id == nil then
		return nil
	end

	for k,v in pairs(self.mountsConfig.datas) do
		if id == v.goods_id then
			return v
		end
	end
	
 	return nil
end
 
function ConfigHelper:getMoutJadeList()
	 
	local list = {}
	for k,v in pairs(self.mount_jadeConfig.datas) do
		table.insert(list, v)
	end
	table.sort(list,function(a,b) return a.key < b.key end)
 	return list
end

function ConfigHelper:getShopOneList()
 	return self.shop_onceConfig.datas
end


--获取合服类型配置
function ConfigHelper:getActiveServiceMergeType(id)
 	return self.active_service_merge_typeConfig.datas[id]
end

--获取合服类型配置
function ConfigHelper:getActiveServiceMerge(id)
 	return self.active_service_mergeConfig.datas[id]
end

function ConfigHelper:getActiveServiceMergeByType(type)
	local cache = {}
	for k,v in pairs(self.active_service_mergeConfig.datas) do
		if v.type == type then
			cache[k] = v
		end 
	end
	return cache
end





return ConfigHelper