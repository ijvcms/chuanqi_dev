--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-15 21:24:43
-- 技能VO

SkillVO = SkillVO or class("SkillVO")

function SkillVO:ctor()
	self.id = 0      -- 技能ID
	self.lv = 0      --级别
	self.posKey = 0  -- 快捷位置
	self.autoSet = 0 --自动释放是否激活 
	self.exp = 0     --技能熟练度

	self.conf = nil  --技能配置

	self.IsTopLv = false --是否顶级
	self.isLearn = false --是否学习
end
--"id", "lv", "type", "autoType", "career", "name", "pLv", "bookId", "bookNum", "nextLv", "desc
function SkillVO:init()
	if self.conf and self.conf.id == self.id and self.conf.lv == self.lv then
	else
		self.conf = FightModel:getSkillUiConfig(self.id,math.max(self.lv,1))
	end
	
	if self.conf.nextLv == 0 then
		self.IsTopLv = true
	else
		self.IsTopLv = false
	end
	if self.lv == 0 then
		self.isLearn = false
	else
		self.isLearn = true
	end
end





