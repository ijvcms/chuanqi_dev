--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-14 16:36:11
-- 场景采集物品VO
SceneCollectionItemVO = SceneCollectionItemVO or class("SceneCollectionItemVO")

function SceneCollectionItemVO:ctor()
	self.id = 0  --唯一id
	self.type = SceneRoleType.COLLECTIONITEM --场景采集物品类型
	self.num = 1 --物品数量
	self.name = "物品"

	self.pos = nil
	self.mGrid = nil    --当前所在地图格子cc.p(x,y) or {x= 1,y = 1}
	
	self.collectionTime = 1000--time_out
	
	self.modelID = "110" --"1101"--"500"   --模型ID
	self.scaleParam = 1

	self.itemType = 0 --物品类型
	self.itemSubType = 0 --物品子类型
	self.quality = 0  --品质
end

function SceneCollectionItemVO:updateBaseInfo()
	self.mConf = getConfigObject(self.monster_id,MonsterConf)--BaseMonsterConf[self.monster_id]
	if self.mConf then
		self.modelID = self.mConf.resId
		if self.name == "" then
			self.name = self.mConf.name
		end
	end
end


function SceneCollectionItemVO:getPosition()
	if self.pos ~= nil then
		return self.pos.x,self.pos.y
	end	
	return 0,0
end

function SceneCollectionItemVO:clear()
	--self.fightAtt:destory()
end	