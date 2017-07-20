--
-- Author: Your Name
-- Date: 2014-11-21 15:42:20
--

MonsterVO = MonsterVO or class("MonsterVO")

function MonsterVO:ctor()
	self.id = 10003
	self.name = "牛逼怪物"
	self.gridType = RoleGridNum.ONE	--英雄格子类型 1-占一个格子，2占两个格子，3占四个格子
	self.grid = {{7,2}}	    	--当前所在的格子 1格单位只有一个，两格单位记录两个，从左到右，四格单位从左到右顺时针方向
	self.group = FightGroupType.ONE     	--当前所在的阵营，见FightGroupType
	self.direction = FightDirectionType.RIGHT --当前模型的方向，-1为向右，1为向左
	self.pos = nil 		--当前位置cc.p(x,y)
	self.states = RoleActivitStates.STAND     --当前角色的状态，见RoleConst表
	self.atkDis = 1 --攻击距离是多少格子
	self.speed = 1     --移动速度

	-- self.grid = {{3,1}}			
	-- self.gridType = 1
	-- self.attackDis = 2

	self.roleType = 1

	self.atk = 500--攻击力
	self.hp = 5000 --当前气血
	self.totalhp = 5000 --总气血
	self.def = 200 --防御
end

--获取真实坐标位置
function MonsterVO:getPosition()
	if self.pos == nil then
		local pp = FightModel:getGridCenterPos(self.grid)
		self.pos = cc.p(pp[1],pp[2])
	end	
	return self.pos.x,self.pos.y
end	