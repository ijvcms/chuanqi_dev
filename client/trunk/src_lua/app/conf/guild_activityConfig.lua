-- 自动生成，请勿修改 
-- 时间：2016/10/12
-- 21102585@qq.com

local guild_activityConfig = class("guild_activityConfig")
function guild_activityConfig:ctor()
	self.fields = {"id", "name", "desc", "isopen", "ruledesc"}
	self.datas = {
		[1] = {1, "行会BOSS", "行会等级越高可挑战的BOSS难度越高", 1},
		[2] = {2, "行会秘境", "几率获得稀有装备", 1, "<font color='0xe4d6c5' size='18' opacity='255'>1.行会等级达到3级时开启，人物等级达到35级才能进入；<br/>2.每日14：00-14：30自动开启；<br/>3.秘境分为4层，行会等级达到5级开启第二层，7级开启第三层，9级开启第四层；<br/>4.进入下一层，需要通过上一层的传送门进入。</font>"},
		[3] = {3, "沙城秘境", "几率获得高级稀有装备", 1, "<font color='0xe4d6c5' size='18' opacity='255'>1.秘境只对沙巴克行会开启，人物等级达到35级才能进入；<br/>2.秘境开放时间为攻城战次日至下次攻城战前日；<br/>3.在开放时间内，沙巴克行会最多可开启3次，每天最多开启1次；<br/>4.秘境开启需要消耗1000行会资金，资金不足无法开启；<br/>5.只有城主可开启秘境。</font>"},

	}
end
return guild_activityConfig
