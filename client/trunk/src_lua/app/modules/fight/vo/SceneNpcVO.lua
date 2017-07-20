--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 16:36:11
-- 场景物品VO
SceneNpcVO = SceneNpcVO or class("SceneNpcVO")

function SceneNpcVO:ctor()
	self.id = 10003  --唯一id
	self.type = SceneRoleType.NPC --场景角色类型
	self.name = "NPC"

	self.pos = nil
	self.mGrid = nil    -- 当前所在地图格子cc.p(x,y) or {x= 1,y = 1}
	self.desc = ""
	self.dialogue = ""   --对话
	self.npcType = 0  -- NPC类型
	self.param = ""
	self.show = 0

	self.order = 1000
	
	self.modelID = "6025" --"1101"--"500"   --模型ID
	self.scaleParam = 1
	self.isTask = 0
	self.showTaskTip = -1 -- -1:没任务；0任务进行中；1:任务完成；2:任务可接取

	self.lv = 0 --级别限制 传送点用
	self.powerlimit = 0 --战力限制 传送点用
	self.guild_lv_limit = 0 --行会等级限制 传送点用
end

function SceneNpcVO:updateBaseInfo()
	
end

function SceneNpcVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneNpcVO:clear()

end	