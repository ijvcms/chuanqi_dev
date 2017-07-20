--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-28 14:16:20
--
local scenePeopleTest = scenePeopleTest or class("scenePeopleTest", function()
	return display.newNode()
end)

function scenePeopleTest:ctor(ctype)
	self.playerInfo = RoleManager:getInstance().roleInfo
	self.fightCon = GlobalController.fight
	self.beginid = "122121" 
	self.indexId = 0

	self.carrerCloth = {}
	self.carrerCloth[1000] = {102,103,104,105,106} --战士
	self.carrerCloth[2000] = {202,203,204,205,206} --法师
	self.carrerCloth[3000] = {302,303,304,305,306} --道士

	self.carrerW = {}
	self.carrerW[1000] = {101,102,103,104,105,106} --战士
	self.carrerW[2000] = {201,202,203,204,205,206} --法师
	self.carrerW[3000] = {301,302,303,304,305,306} --道士

	self.wing = {5101,5102,5103,5104,5105,5106,5107,5108,5109,5110} --战士

	self.addRoleBtn = display.newSprite("#com_btnStyle2N.png")
        -- self.addRoleBtn:setColor(cc.c3b(217, 108, 87))   
        self.addRoleBtn:setTouchEnabled(true)   
        self:addChild(self.addRoleBtn)
        self.addRoleBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)           
                if event.name == "began" then 
                    self.addRoleBtn:setScale(1.1)
                elseif event.name == "ended" then         
                    self.addRoleBtn:setScale(1)
                    self:creatRole()
                    self.addlab:setString("add("..self.indexId..")")
                end
                return true
            end)
        self.addlab = display.newTTFLabel({
                text = "add(0)",      
                size = 20,
                color = TextColor.BTN_W, 
        })
        display.setLabelFilter(self.addlab)
        self.addlab:setTouchEnabled(false)   
        self.addlab:setPosition(71,22)
        self.addRoleBtn:addChild(self.addlab)
        self.addRoleBtn:setPosition(0,0)

    if self.updateTimeEventId == nil then
        self.updateTimeEventId =  GlobalTimer.scheduleGlobal(handler(self,self.update),2)
    end

end

function scenePeopleTest:update()
	local playerInfo = RoleManager:getInstance().roleInfo
	local curGrid =  GameSceneModel:getPlayerVO().mGrid
	for k,v in pairs(self.fightCon.playerViewArr) do
		local mGrid = cc.p(curGrid.x+math.random(-8,8),curGrid.y+math.random(-5,5))
		if math.random(-5,5) >0 and playerInfo.player_id ~= v.vo.id and GameSceneModel:getMapGridIsOpen(mGrid) and v.vo.states == RoleActivitStates.STAND then
			local list = self.fightCon.aStar:find(v.vo.mGrid,mGrid)
			if list == nil then 
		        return 
		    end

		    local arr = {}
		    for i=1,#list do
		        local p = FightUtil:gridToPoint(list[i].x,list[i].y)
		        table.insert(arr,{p.x,p.y})
		   	end
		    v:roleMoveTo(arr)

		end
	end
end


function scenePeopleTest:creatRole()
	local roleVo = self:creatRoleVO()
	self.fightCon:addSceneRole(roleVo)
end

function scenePeopleTest:creatRoleVO()
	self.indexId = self.indexId +1
	local curGrid =  GameSceneModel:getPlayerVO().mGrid
	local vo = SceneRoleVO.new()
	vo.mGrid = cc.p(curGrid.x+math.random(-8,8),curGrid.y+math.random(-5,5))
	vo.pos = FightUtil:gridToPoint(vo.mGrid.x,vo.mGrid.y)
	vo.direction = RoleDirect.DOWN  --模型方向
	vo.movePos = vo.pos

	vo.id = "343"..self.indexId  --唯一id
	vo.type = SceneRoleType.PLAYER--场景角色类型
	
	vo.name = "name"..self.indexId
	vo.sex = math.random(1,2)
	vo.career = math.random(1,3)*1000
	vo.lv = 40

	vo.hp = 1000 --当前气血
	vo.hp_limit = 1000
	vo.totalhp = 1000 --总气血
	vo.mp = 1000
	vo.mp_limit = 1000

	local weaponList = self.carrerW[vo.career]
	vo.weapon = weaponList[math.random(1,#weaponList)]
	local clothList = self.carrerCloth[vo.career]
	vo.clothes = clothList[math.random(1,#clothList)]
	vo.wing = 0--self.wing[math.random(1,#self.wing)]
	vo.pet = 0
	vo:updateBaseInfo()
	return vo
end


return scenePeopleTest