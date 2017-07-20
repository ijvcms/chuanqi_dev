--
-- Author: 21102585@qq.com
-- Date: 2014-11-25 14:13:21
-- 战斗AI VO

FightAiVO = FightAiVO or class("FightAiVO")

function FightAiVO:ctor()
	self.id = 10001 --id
	self.executeType = 1 --执行类型 兵种中扩展用的

	--
	self.enable = true --是否可用
	self.isAuto = false --是否自动执行
	self.lastTime = 0 --上一次执行时间，初始时是战斗开始时间

	self.aiType = 0 -- aiType AI类型 1.循环几秒播 2单次执行判定

	--condType 条件类型conditionType  
		--1 自身HP低于或者等于   百分比  怪物自身血量低于或者等于某一百分比值时。
		--2 每过时间触发（循环)   时间-毫秒  从战斗开始计算，可多次触发，循环释放技能
		--3	在某时间触发（一次）		时间-毫秒	某个时间点触发一次。				
		--4	是否有飞行单位		无					
		--5	是否有某类别单位		1、2、3对应幽能、生化、机械单位				
		--6	是否有某体积单位			1、2、3对应大型、中型、小型单位	
	self.condType = 0 --
	self.condValue = 0 --条件值 如时间就是时间的毫秒，如果是气血就是气血的值
	self.actionType = 1 --动作类型 1表示使用技能 以后有扩展加后面
	self.actionValue = "" --动作值 actionType=1时是技能前5位ID
end	

