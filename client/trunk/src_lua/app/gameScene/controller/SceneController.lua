--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-05 21:15:34
-- 场景控制器，控制场景相关
SceneController = SceneController or class("SceneController", BaseController)

function SceneController:ctor()	
	self:registerProto()

	--场景对象模型，应该放到显示对象里面去的吧
	self.npcViewArr = {}  --NPC视图字典  transferPointArr 传送点放这里面
	self.babyViewArr = {}  --baby视图字典 外观宠物 (已删除)
	self.petViewArr = {}  --宠物视图字典
	self.playerViewArr = {}  --玩家视图字典
	self.playerCopyViewArr = {}  --玩家视图字典
	self.monsterViewArr = {} --怪物字典
	self.itemViewArr = {} --物品字典
	self.collectionItemViewArr = {} --采集物品字典
	self.fireWallViewArr = {} --火墙字典
	self.soldierViewArr = {} --士兵字典   = SOLDIER

end

function SceneController:registerProto()
	self:registerProtocal(11024,handler(self,self.onHandle11024))
	self:registerProtocal(11025,handler(self,self.onHandle11025))
	self:registerProtocal(29005,handler(self,self.onHandle29005))
	self:registerProtocal(16002,handler(self,self.onHandle16002))
end	

























--传送点传送
-- <Packet proto="11024" type="c2s" name="req_transport" describe="传送点传送">
-- 				<Param name="id" type="int16" describe="传送点id"/>
-- 			</Packet>
-- 			<Packet proto="11024" type="s2c" name="rep_transport" describe="传送点传送">
-- 				<Param name="result" type="int16" describe="结果: 0 成功, 非零失败"/>
-- 			</Packet>
function SceneController:onHandle11024(data)
	if data.result == 0 then
		GlobalWinManger:closeWin(WinName.NPCTRANSFER)
	else
		GlobalAlert:show("跳转失败")
	end
end

--获取npc状态
-- <Packet proto="11025" type="c2s" name="req_get_npc_state" describe="获取npc状态">
-- 				<Param name="id" type="int32" describe="npcId"/>
-- 			</Packet>
-- 			<Packet proto="11025" type="s2c" name="rep_get_npc_state" describe="获取npc状态">
-- 				<Param name="type" type="int32" describe="0:开启对应功能  其他:任务id"/>
-- 			</Packet>
function SceneController:onHandle11025(data)
	GlobalEventSystem:dispatchEvent(SceneEvent.NPC_OPEN_DIALOG,data.type)
end

--云旅商人购买
function SceneController:onHandle16002(data)
	GlobalEventSystem:dispatchEvent(SceneEvent.NPC_15_BUY,data)
end

--小飞鞋传送
function SceneController:onHandle29005(data)
	if data.result ~= 0 then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	else
		if SceneManager.npcId ~= nil then
			local player = GlobalController.fight:getSelfPlayerModel()
    	
	    	local offsetY = math.random(-1,1)
	        if offsetY == 0 then
	            offsetY = -1
	        end
		    local npcVo = GameSceneModel:getSceneObjVO(SceneManager.npcId,SceneRoleType.NPC)
		    player.vo.mGrid = cc.p(npcVo.mGrid.x+math.random(-1,1),npcVo.mGrid.y+offsetY)
		    if npcVo then
		        SceneManager:playerMoveToNPCByVO(npcVo,false)
		    end
		else
			SceneManager:updateTranferArrByFlyShoe()
		end
		GlobalEventSystem:dispatchEvent(SceneEvent.SHOW_AUTO_ROAD,false)
	end
end