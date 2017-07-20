--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-06 15:27:15
-- 火墙VO
SceneFireWallVO = SceneFireWallVO or class("SceneFireWallVO")

function SceneFireWallVO:ctor()
	self.id = 0  --唯一id
	self.type = SceneRoleType.FIREWALL --场景火墙类型

	self.pos = nil
	self.mGrid = nil    --当前所在地图格子cc.p(x,y) or {x= 1,y = 1}

	self.itemID = 0  --物品ID（读取配置信息用）
	self.endTime = 100000000
	
	self.modelID = "8204" --"1101"--"500"   --模型ID
	self.scaleParam = 1
	self.duration = 0 --持续时间
	self.interval = 2 --
	self.beginTime = 0 
	self.endTime = 0 
end

function SceneFireWallVO:updateBaseInfo()
	self.beginTime =  FightModel:getFTime()
	self.endTime =  FightModel:getFTime() + self.duration
end

function SceneFireWallVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneFireWallVO:clear()
	--self.fightAtt:destory()
end	