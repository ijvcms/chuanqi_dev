--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 16:36:11
-- 场景物品VO
SceneItemVO = SceneItemVO or class("SceneItemVO")

function SceneItemVO:ctor()
	self.id = 10003  --唯一id
	self.type = SceneRoleType.ITEM --场景角色类型
	self.num = 1 --物品数量
	self.name = "物品"
	
	self.playID = "0"  --属于玩家ID
	self.monsterID = 0 -- 所属怪物

	self.pos = nil
	self.mGrid = nil    --当前所在地图格子cc.p(x,y) or {x= 1,y = 1}
	self.teamId = "0"
	self.itemID = 0  --物品ID（读取配置信息用）
	self.belongTime = 1000--time_out
	
	self.modelID = "110009" --"1101"--"500"   --模型ID
	self.scaleParam = 1

	self.itemType = 0 --物品类型
	self.itemSubType = 0 --物品子类型
	self.quality = 0  --品质
end

function SceneItemVO:updateBaseInfo()
	local base = getConfigObject(self.itemID,GoodsConf)
	if base then
		self.modelID = base.icon
		self.name = base.name
		self.itemType = base.type
		self.itemSubType = base.sub_type
		self.quality = base.quality
	end
end

function SceneItemVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneItemVO:clear()
	--self.fightAtt:destory()
end	