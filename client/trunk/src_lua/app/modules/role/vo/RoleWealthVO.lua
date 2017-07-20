--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-07-22 18:07:01
--
RoleWealthVO = RoleWealthVO or class("RoleWealthVO")

function RoleWealthVO:ctor()
	self.energy = 0 --uint;体力
	self.energyMax = 20 --uint;体力上限
	self.energyCountDown = 3600 --	体力倒计时（秒）
	self.energyJade = 0-- 购买需要元宝
	self.energyCanBuyTimes = 0-- 可以购买剩余次数

	self.coin = 0 --uint; 金币
	self.jade = 0 -- 元宝
	self.smelt_value = 0 		--熔炼值
	self.feats = 0 		--功勋值
	

	self.lev = 0 --uint;角色等级
	self.expNeed = 0 --uint;升级所需经验
	self.exp = 0 --uint;当前经验
	-- self.coin = 0 --uint; 铜币
	-- self.gold = 0 --uint; 元宝
	self.psychic = 0 --uint;灵力
	self.attainment = 0 --uint;阅历
	self.evil = 0 --uint;罪恶值
	self.charm = 0 --uint;魅力值
	self.charge = 0 --uint;当前已充值金额（元宝）
	self.donate = 0 --帮贡
	self.friendship = 0 --友情值
	self.gift = 0		--礼券
	self.xl = 0	--uint 仙令

	--印记消耗
	self.markValue = {}
 
end


function RoleWealthVO:updateFrom10003(data)
	local moneyInfo = data.money
	self.coin = moneyInfo.coin
	self.jade = moneyInfo.jade
	self.gift = moneyInfo.gift
	self.smelt_value = moneyInfo.smelt_value
	self.feats = moneyInfo.feats

	self.markValue[1] = moneyInfo.hp_mark_value
	self.markValue[2] = moneyInfo.atk_mark_value
	self.markValue[3] = moneyInfo.def_mark_value
	self.markValue[4] = moneyInfo.res_mark_value

end