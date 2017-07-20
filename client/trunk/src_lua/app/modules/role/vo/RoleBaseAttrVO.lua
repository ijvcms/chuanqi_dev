--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-22 17:42:40
-- 角色基础属性VO
RoleBaseAttrVO = RoleBaseAttrVO or class("RoleBaseAttrVO")

function RoleBaseAttrVO:ctor()
	self.cur_hp = 1 --当前血量
	self.cur_mp = 1 --当前魔法
	self.hp = 1 --血量
	self.mp = 1 --魔法
	self.min_ac = 0 --最小物理攻击
	self.max_ac = 0 --最大物理攻击
	self.min_mac = 0 --最小魔法攻击
	self.max_mac = 0 --最大魔法攻击
	self.min_sc = 0 --最小道术攻击
	self.max_sc = 0 --最大道术攻击
	self.min_def = 0 --最小物防
	self.max_def = 0 --最大物防
	self.min_res = 0 --最小魔防
	self.max_res = 0 --最大魔防
	self.crit = 0 --暴击
	self.crit_att = 0 --暴击伤害
	self.hit = 0 --准确
	self.dodge = 0 --敏捷
	self.damage_deepen = 0 --伤害加深
	self.damage_reduction = 0 --伤害减免
	self.holy = 0 --神圣
	self.skill_add = 0 --技能伤害追加
	self.m_hit = 0 --魔法命中
	self.m_dodge = 0 --魔法闪避
	self.hp_recover = 0 --生命恢复
	self.mp_recover = 0 --魔法恢复
	self.resurgence = 0 --死亡恢复
	self.damage_offset = 0 --伤害减免

	self.lucky = 0 --幸运值
	self.curse = 0 --诅咒值

    self.hp_p  					= 0		--血量百分比加成
    self.mp_p  					= 0		--魔法百分比加成
    self.min_ac_p  				= 0		--最小物理攻击百分比加成
    self.max_ac_p  				= 0		--最大物理攻击百分比加成
    self.min_mac_p  			= 0		--最小魔法攻击百分比加成
    self.max_mac_p  			= 0		--最大魔法攻击百分比加成
    self.min_sc_p  				= 0		--最小道术攻击百分比加成
    self.max_sc_p  				= 0		--最大道术攻击百分比加成
    self.min_def_p  			= 0		--最小物防百分比加成
    self.max_def_p  			= 0		--最大物防百分比加成
    self.min_res_p  			= 0		--最小魔防百分比加成
    self.max_res_p  			= 0		--最大魔防百分比加成
    self.crit_p  				= 0		--暴击百分比加成
    self.crit_att_p  			= 0		--暴击伤害百分比加成
    self.hit_p  				= 0		--准确百分比加成
    self.dodge_p 				= 0 	--敏捷百分比加成
    self.damage_deepen_p  		= 0		--伤害加深百分比加成
    self.damage_reduction_p  	= 0		--伤害减免百分比加成
    self.holy_p  				= 0		--神圣百分比加成
    self.skill_add_p  			= 0		--技能伤害追加百分比加成
    self.m_hit_p  				= 0		--魔法命中百分比加成
    self.m_dodge_p  			= 0		--魔法闪避百分比加成
    self.hp_recover_p  			= 0		--生命恢复百分比加成
    self.mp_recover_p  			= 0		--魔法恢复百分比加成
    self.resurgence_p  			= 0		--死亡恢复百分比加成
    self.damage_offset_p  		= 0		--伤害抵消百分比加成
end