--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-18 17:48:26
-- 场景外观宠物
require("app.modules.fight.view.BaseRole")
SceneBaby = SceneBaby or class("SceneBaby",BaseRole)


function SceneBaby:ctor(roleVO)
	SceneBaby.super.ctor(self,roleVO)
end

function SceneBaby:playStand()
	if self.vo.states == RoleActivitStates.DEAD then return end
	if self.armature and self.activityStates ~= RoleActivitStates.STAND then		
		self.activityStates = RoleActivitStates.STAND
	end
	if self.armature:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then        
		self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
	end
	if FightModel:getFTime()-self.preAttackTime < 1 then
		if self.armature and self.armature:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then        
			self.armature:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
		end 
        if self.armatureWeapon and self.armatureWeapon:getAnimation():getCurrentMovementID() ~= FightAction.STAND.."_"..self.actionIndex then        
            self.armatureWeapon:getAnimation():play(FightAction.STAND.."_"..self.actionIndex)
        end
		return
    else
    	--设置这个时间的目的是让他在没有事情做得时候隔多久去看看有没有事情做
    	--如果有事情做一定要设回来
        self.preAttackTime = FightModel:getFTime()
	end 

  
        local ower = GameSceneModel:getSceneObjVO(self.vo.playID,SceneRoleType.PLAYER)
        if math.abs(ower.mGrid.x - self.vo.mGrid.x) + math.abs(ower.mGrid.y - self.vo.mGrid.y) >4 then
                local list = GlobalController.fight.aStar:find(self.vo.mGrid,ower.mGrid,true)
                local arr = {}
                if list then
                    for i=1,#list do
                        local p = FightUtil:gridToPoint(list[i].x,list[i].y)
                        table.insert(arr,{p.x,p.y})
                    end
                    self:roleMoveTo(arr)
                end
            return
        end

end



--角色普通攻击
function SceneBaby:playAttack(targerId,targerType,skillId,hurtList)
    
end	



--执行伤害
function SceneBaby:playHurt(skillId,targerId,targerType)

end