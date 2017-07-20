--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-12 09:29:34
-- 技能控制器
require("app.modules.skill.model.SkillModel")
require("app.modules.skill.view.SkillVO")
SkillController = SkillController or class("SkillController",BaseController)

function SkillController:ctor()
	self.roleManager = RoleManager:getInstance()
	self:registerProto()

	self.autoGroupSkillSwitch = true
end


function SkillController:registerProto()
	self:registerProtocal(12001,handler(self,self.onHandle12001))
	self:registerProtocal(12003,handler(self,self.onHandle12003))
	self:registerProtocal(12004,handler(self,self.onHandle12004))
	self:registerProtocal(12005,handler(self,self.onHandle12005))
	self:registerProtocal(12006,handler(self,self.onHandle12006))
	self:registerProtocal(12007,handler(self,self.onHandle12007))
	self:registerProtocal(12008,handler(self,self.onHandle12008))
	self:registerProtocal(12009,handler(self,self.onHandle12009))
end

function SkillController:onHandle12001(data)
	if data.result == 0 then 
		local item
		self.roleManager.skillDic = {}
		local careerSkillList = self.roleManager.carrerSkill
		for i=1,#careerSkillList do
			item = data.skill_list[i]
			local skillVO = SkillVO.new()
			skillVO.id = careerSkillList[i]
			self.roleManager.skillDic[skillVO.id] = skillVO
			skillVO:init()
		end
		for i=1,#data.skill_list do
			item = data.skill_list[i]
			local skillVO = self.roleManager.skillDic[item.skill_id]
			skillVO.id = item.skill_id
			skillVO.lv = item.lv
			skillVO.posKey = item.pos
			skillVO.autoSet = item.auto_set
			skillVO.exp = item.exp
			skillVO:init()
		end
		--dump(self.roleManager.skillDic)
		self.roleManager:updateSkill()
		if GlobalController:getScene() ~= SCENE_MAIN then
			GlobalModel.initDataOK = true
			GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_MAIN)
		else
			GlobalWinManger:destory()
			GlobalModel.initDataOK = true
			if GlobalModel.initDataOK and GlobalModel.initViewOK then
				GameNet:sendMsgToSocket(11001, {})--11001, {scene_id = 0}
			end
		end
		LoadingPackageManager:checkToLoadPackage()
	end
end

--推送技能信息变更
function SkillController:onHandle12003(data)
	print("SkillController:onHandle12003(data)")
	if data.skill_info then
		item = self.roleManager.skillDic[data.skill_info.skill_id]
		if item then
			if item.lv == 0 and data.skill_info.lv > 0 then
				GlobalMessage:show("恭喜你，学会了技能:"..item.conf.name)
			elseif item.lv < data.skill_info.lv then
				GlobalMessage:show("恭喜你，技能"..item.conf.name.."升级成功")
			end
			
			item.lv = data.skill_info.lv
			item.posKey = data.skill_info.pos
			item.autoSet = data.skill_info.auto_set
			item.exp = data.skill_info.exp
			item:init()
		end
	end
	self.roleManager:updateSkill(data.skill_info.skill_id)
	GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_SKILL_LIST)
end

--升级与学习技能
function SkillController:onHandle12004(data)
	print("onHandle12004",data.result)
	if data.result == 0 then
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

--技能设置快捷键
function SkillController:onHandle12005(data)
	--print("onHandle12005",data.result)
	if data.result == 0 then
		
	end
end

--清空快捷键
function SkillController:onHandle12006(data)
end

--激活自动技能
function SkillController:onHandle12007(data)

end

--自动群体技能是否开启
function SkillController:onHandle12008(data)
	if data.type == 1 then
		self.autoGroupSkillSwitch = true
		--GlobalMessage:show("自动群体技能开启")
	elseif data.type == 0 then
		self.autoGroupSkillSwitch = false
		--GlobalMessage:show("自动群体技能关闭")
	end
	GlobalEventSystem:dispatchEvent(SkillEvent.UPDATE_AUTO_GROUP_SWITCH)
end

--吃经验丹
-- <Param name="skill_id" type="int32" describe="技能id"/>
-- <Param name="goods_id" type="int32" describe="道具id"/>
-- <Param name="num" type="int16" describe="数量"/>
-- GameNet:sendMsgToSocket(12009, {skill_id = 11221,goods_id=1212,num = 10})
function SkillController:onHandle12009(data)
	if data.result == 0 then
		GlobalMessage:show("技能经验增加")
	end
end
