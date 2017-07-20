--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-18 17:53:13
-- 外观宠物VO

SceneBabyVO = SceneBabyVO or class("SceneBabyVO")
vosceneBabyId = 100
function SceneBabyVO:ctor()
	vosceneBabyId = vosceneBabyId +1
	self.id = vosceneBabyId  --唯一id
	self.type = SceneRoleType.BABY --场景角色类型
	self.name = ""
	
	self.playID = ""  --属于玩家ID

	self.pos = nil
	self.mGrid = nil    --当前所在地图格子cc.p(x,y) or {x= 1,y = 1}

	self.modelID = 0
	self.scaleParam = 1
	self.speed = 8
	self.totalhp = 1
	self.hp = 1
	self.beginBuffList= {}
	self.buffDic = {}
	self.states = RoleActivitStates.STAND
	self.direction = 1
	self.weapon = ""
	self.wing = 0
end

function SceneBabyVO:updateBaseInfo()
	
end

function SceneBabyVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneBabyVO:addToScene()
	GlobalController.fight:addBabyModel(self)
end

function SceneBabyVO:removeFromScene()
	GlobalController.fight:delBabyModel(self.id)
end

function SceneBabyVO:clear()
	--self.fightAtt:destory()
end	
