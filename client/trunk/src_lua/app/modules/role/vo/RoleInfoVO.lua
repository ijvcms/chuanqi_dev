--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-22 18:12:56
--
RoleInfoVO = RoleInfoVO or class("RoleInfoVO",RoleBaseAttrVO)

function RoleInfoVO:ctor()
	RoleInfoVO.super.ctor(self)
	self.os_type = 0 --系统类型：1 ios, 2 android

	self.player_id = "1" --玩家唯一id
	self.name = "1" --玩家名
	self.sex = 1 --性别
	self.career = 1000 --职业 战士1000 法师 2000 道士 3000
	self.lv = 1 --等级
	self.exp = 0 --经验
	-- self.atk = 1 --战斗力
	self.fighting = 1 --战斗力

	self.hookSceneId = 0 --当前挂机场景
	self.passHookSceneId = 0 --当前通关场景ID

	self.weapon = 0 --武器外观
	self.clothes = "10" --衣服外观
	self.wing = 0	--翅膀外观
	self.wing_state = 0 ---翅膀状态 0显示 1隐藏
	self.weapon_state = 0 ---特武状态 0显示 1隐藏
	self.pet = 0 	--宠物外观
	self.petStates = 1 --宠物攻击模式" 1表示攻击2表示防守
	self.petNum = 0 --宠物数量

	self.nameColor = 1   --名字颜色  1，2，3，4是白黄红灰色
	self.pkValue = 0     --pk值

	self.pkMode = FightModelType.PEACE--pk模式: 1 和平，2 全体，3 帮派，4 队伍，5 善恶"/>

	self.equip = {} --玩家装备

	self.vip = 0
	self.honorId = 0 --荣誉称号ID
	self.vip_exp = 0 		--vip经验值

	self.challengeBossNum = 0 --Boss挑战次数
	self.challengeBossJade = 0 --增加次数需要的金币

	self.bag = 0 --背包格子数
	self.create_time = 0 --角色创建时间

	self.autoDrugOption = {} 	--自动吃药设置

	self.teamId = 0
	self.corpsId = 0 --军团

	self.rideInfo = nil --坐骑id

	self.unionList = {} --结盟列表
	------------------印记-----------------
	self.mark = {}
 
end



--更新数据From协议10003
function RoleInfoVO:updateFrom10003(data)
	 
	self.player_id = data.player_id
	self.name = data.name
	self.sex = data.sex
	self.career = data.career
	self.lv = data.lv
	self.exp = data.exp
	-- self.atk = data.atk
	self.fighting = data.fighting
	self.vip_exp = data.vip_exp
	self.vip = data.vip
	self.weapon = data.guise.weapon
	self.clothes = data.guise.clothes
	self.wing = data.guise.wing
	self.wing_state = data.wing_state
	self.weapon_state = data.weapon_state
	self.pet = data.guise.pet
	self.petStates = data.pet_att_type 
	self.petNum = data.pet_num

	self.hookSceneId = data.hook_scene_id --当前挂机场景
	self.passHookSceneId = data.pass_hook_scene_id --当前通关场景ID
	self.bag = data.bag
	self.pkMode = data.pk_mode
	self.nameColor = data.name_colour
	self.pkValue = data.pk_value
	self.honorId = data.career_title or 0
    self.create_time = data.register_time or 0
 
	self.teamId = data.team_id
    self.corpsId = data.legion_id -- 军团
	local baseAtt = data.attr_base
	self.cur_hp = baseAtt.cur_hp
	self.cur_mp = baseAtt.cur_mp
	self.hp = baseAtt.hp
	self.mp = baseAtt.mp
	self.min_ac = baseAtt.min_ac
	self.max_ac = baseAtt.max_ac
	self.min_mac = baseAtt.min_mac
	self.max_mac = baseAtt.max_mac
	self.min_sc = baseAtt.min_sc
	self.max_sc = baseAtt.max_sc
	self.min_def = baseAtt.min_def
	self.max_def = baseAtt.max_def
	self.min_res = baseAtt.min_res
	self.max_res = baseAtt.max_res
	self.crit = baseAtt.crit
	self.crit_att = baseAtt.crit_att
	self.hit = baseAtt.hit
	self.dodge = baseAtt.dodge
	self.damage_deepen = baseAtt.damage_deepen
	self.damage_reduction = baseAtt.damage_reduction
	self.holy = baseAtt.holy
	self.skill_add = baseAtt.skill_add
	self.m_hit = baseAtt.m_hit
	self.m_dodge = baseAtt.m_dodge
	self.hp_recover = baseAtt.hp_recover
	self.mp_recover = baseAtt.mp_recover
	self.resurgence = baseAtt.resurgence
	self.damage_offset = baseAtt.damage_offset

    self.hp_p  					= baseAtt.hp_p					--血量百分比加成
    self.mp_p  					= baseAtt.mp_p					--魔法百分比加成
    self.min_ac_p  				= baseAtt.min_ac_p				--最小物理攻击百分比加成
    self.max_ac_p  				= baseAtt.max_ac_p				--最大物理攻击百分比加成
    self.min_mac_p  			= baseAtt.min_mac_p				--最小魔法攻击百分比加成
    self.max_mac_p  			= baseAtt.max_mac_p 			--最大魔法攻击百分比加成
    self.min_sc_p  				= baseAtt.min_sc_p				--最小道术攻击百分比加成
    self.max_sc_p  				= baseAtt.max_sc_p				--最大道术攻击百分比加成
    self.min_def_p  			= baseAtt.min_def_p				--最小物防百分比加成
    self.max_def_p  			= baseAtt.max_def_p				--最大物防百分比加成
    self.min_res_p  			= baseAtt.min_res_p				--最小魔防百分比加成
    self.max_res_p  			= baseAtt.max_res_p				--最大魔防百分比加成
    self.crit_p  				= baseAtt.crit_p				--暴击百分比加成
    self.crit_att_p  			= baseAtt.crit_att_p			--暴击伤害百分比加成
    self.hit_p  				= baseAtt.hit_p					--准确百分比加成
    self.dodge_p 				= baseAtt.dodge_p 				--敏捷百分比加成
    self.damage_deepen_p  		= baseAtt.damage_deepen_p		--伤害加深百分比加成
    self.damage_reduction_p  	= baseAtt.damage_reduction_p	--伤害减免百分比加成
    self.holy_p  				= baseAtt.holy_p				--神圣百分比加成
    self.skill_add_p  			= baseAtt.skill_add_p			--技能伤害追加百分比加成
    self.m_hit_p  				= baseAtt.m_hit_p				--魔法命中百分比加成
    self.m_dodge_p  			= baseAtt.m_dodge_p				--魔法闪避百分比加成
    self.hp_recover_p  			= baseAtt.hp_recover_p			--生命恢复百分比加成
    self.mp_recover_p  			= baseAtt.mp_recover_p			--魔法恢复百分比加成
    self.resurgence_p  			= baseAtt.resurgence_p			--死亡恢复百分比加成
    self.damage_offset_p  		= baseAtt.damage_offset_p		--伤害抵消百分比加成

    self.lucky 					= baseAtt.luck 					--幸运(负值时就是诅咒)

    --自动喝药设置
   	self.autoDrugOption.normalDrug = data.hp_set.isuse --开启自动喝药
   	self.autoDrugOption.drugType1 = data.hp_set.hp_goods_id --自动红药id
   	self.autoDrugOption.redBarPercent = data.hp_set.hp 		--红百分比
   	self.autoDrugOption.drugType2 = data.hp_set.mp_goods_id 		--自动蓝药id
   	self.autoDrugOption.blueBarPercent = data.hp_set.mp  			--蓝百分比
   	self.autoDrugOption.momentDrug = data.hpmp_set.isuse 			--开启自动喝瞬回药
   	self.autoDrugOption.drugType3 = data.hpmp_set.hp_mp_goods_id	--自动瞬回药id
   	self.autoDrugOption.momentBarPercent = data.hpmp_set.hp --瞬回药百分比
   	--
   	--dump(self.autoDrugOption,"roleInfo!@!!!!")

   	-----印记-----------------
 
   	local mark = data.mark
   	self.mark[1] = mark.hp_mark
	self.mark[2] = mark.atk_mark
	self.mark[3] = mark.def_mark
	self.mark[4] = mark.res_mark
	self.mark[5] = mark.holy_mark

	self.mark[6] = mark.mounts_mark_1
	self.mark[7] = mark.mounts_mark_2
	self.mark[8] = mark.mounts_mark_3
	self.mark[9] = mark.mounts_mark_4
 
end


--更新装备列表From协议14020
function RoleInfoVO:updateFrom14020(data)
 
	local equipList = {}
	for i=1,#data do
		if data[i].location == 1 then--身上装备
			table.insert(equipList,data[i])
		end
		--保存坐骑id
		if data[i].grid == 15 then
			self.rideInfo = data[i]
		end
	end
	self.equip = equipList
end

--更新装备列表From协议14021
function RoleInfoVO:updateFrom14021(data)

	if data.location ~= 1 then--身上装备
		return
	end
	for i=1,#self.equip do
		if self.equip[i].id == data.id then
			if data.num == 0 then --数量零删除
				table.remove(self.equip, i)
			else 
				self.equip[i] = data
			end
			return 
		end
	end
	--保存坐骑id
	if data.grid == 15 then
		self.rideInfo = data
	end
	table.insert(self.equip, data)
end

function RoleInfoVO:getEquipByGoodsId(goods_id)
	if self.equip then
		for i=1,#self.equip do
			if self.equip[i].goods_id == goods_id then
				return true
			end
		end
	end

	return false
end




--获取武器ID
function RoleInfoVO:getWeaponResId()
    local comWeapon = nil
    local spWeapon = nil  
    for i=1,#self.equip do
        local item = self.equip[i]
        if item.grid == 1 and item.num > 0 then
            comWeapon = item
        elseif item.grid == 21 and item.num > 0 then
            spWeapon = item
        end
    end
    local weaponGoodsId = 0
    if spWeapon == nil then
        return self.weapon
    else
        if self.wing_state == 1 then
            if comWeapon then
                weaponGoodsId = comWeapon.goods_id
            end
            --显示普通武器
        else
            --显示特武
            if spWeapon then
                weaponGoodsId = spWeapon.goods_id
            end
        end
    end
    if weaponGoodsId ~= 0 then
        return configHelper:getGoodResId(weaponGoodsId)
        --return FightUtil:getRoleWeaponID(configHelper:getGoodResId(weaponGoodsId),RoleManager:getInstance().roleInfo.sex)
    end
    return self.weapon
end