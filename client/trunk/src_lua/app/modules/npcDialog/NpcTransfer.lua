--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-06 18:21:03
-- npc传送界面

local NpcTransfer = class("NpcTransfer", BaseView)


function NpcTransfer:ctor(winTag,data,winconfig)
  	NpcTransfer.super.ctor(self,winTag,data,winconfig)
  	self.npcVO = data

  	self.root:setPosition((display.width-459)/2,(display.height-517)/2)
  	-- self.titile = self:seekNodeByName("name")
  	-- self.contentLab = self:seekNodeByName("speak")
  	self.closeBtn = self:seekNodeByName("close")
  	self.closeBtn:setTouchEnabled(true)
  	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
  	end)
  	local transportList = configHelper.getInstance():getNpcTransportArrByNpcID(self.npcVO.id)

  	--local transportList = configHelper.getInstance():getNpcTransportArrByNpcID(7507)
  	self.configType1 = {}
  	self.configType2 = {}
  	for k,v in pairs(transportList) do
  		if v.type == 1 then
  			table.insert(self.configType1,v)
  		elseif v.type == 2 then
  			table.insert(self.configType2,v)
  		end
  	end
  	self:creatLink(self.configType1,83,343)
  	self:creatLink(self.configType2,83,167)
end

function NpcTransfer:creatLink(arr,beginX,beginY,rawNum)
	rawNum = rawNum or 4
	
	for i=1,#arr do
		local config = configHelper.getInstance():getSceneTransportConfigByID(arr[i].transportId)
		local label = display.newTTFLabel({text = config.name,
        size = 24,color = TextColor.ROLE_G})
            :align(display.CENTER,0,0)
            :addTo(self.root)
    	label:setPosition(410,410)
    	display.setLabelFilter(label)
    	label:setTouchEnabled(true)
  		label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	        elseif event.name == "ended" then
	            self:onLinkClick(config)
	        end
	        return true
	  	end)
	  	label:setPosition(beginX+((i-1)%rawNum)*95,beginY-math.floor((i-1)/rawNum)*66)
	end
end

function NpcTransfer:onLinkClick(config)
	GameNet:sendMsgToSocket(11024,{id = config.key})
	GlobalWinManger:closeWin(self.winTag)
	--GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(config.transportId)})
end

--执行下一关
function NpcTransfer:initView(data)
	-- if data.data == 0 then --npc功能
	-- 	self.contentLab:setString(self.npcVO.dialogue)
	-- 	self.functionLay:setVisible(true)
	-- 	local functionArr = StringUtil.split(tostring(self.npcVO.param), ",")
	-- 	local item
	-- 	local functioinId
	-- 	for i=1,3 do
	-- 		functioinId = functionArr[i]
	-- 		item = self["function"..i.."Lab"]
	-- 		if functioinId ~= nil then
	-- 			local functionConf = configHelper.getInstance():getNpcFunctionByID(tonumber(functioinId))
	-- 			if functionConf then
	-- 				item:setVisible(true)
	-- 				item:setString(functionConf.btnlab)
	-- 				item:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
	-- 				item:setTouchEnabled(true)
	-- 			  	item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	-- 			        if event.name == "began" then
	-- 			        elseif event.name == "ended" then
	-- 			            self:onNpcFunctionBtnClick(functionConf)
	-- 			        end
	-- 			        return true
	-- 			  	end)
	-- 		  	end
	-- 		else
	-- 			item:setVisible(false)
	-- 		end
	-- 	end
	-- else
	-- 	local taskId = data.data
	-- 	self.taskLay:setVisible(true)
	-- 	self:onNpcFunctionBtnClick(taskId)
	-- end
  	
end

--处理任务相关功能
function NpcTransfer:onNpcFunctionBtnClick(taskId)
	--self.npcVO.id

end

--处理Npc默认功能
function NpcTransfer:onNpcFunctionBtnClick(functionConf)
	-- GlobalWinManger:closeWin(self.winTag)
	-- if functionConf.win ~= "" then
	-- 	GlobalWinManger:openWin(functionConf.win)
	-- end
	
end

function NpcTransfer:open()
	-- if self.npcOpenDialogEventId == nil then
 --        self.npcOpenDialogEventId = GlobalEventSystem:addEventListener(SceneEvent.NPC_OPEN_DIALOG,handler(self,self.initView))
 --    end
 --    GameNet:sendMsgToSocket(11025,{id = self.npcVO.id})
	-- self.titile:setString("对话框")
 --  	self.contentLab:setString("")
 --  	self.taskLay:setVisible(false)
 --  	self.functionLay:setVisible(false)
end

function NpcTransfer:close()
  	if self.npcOpenDialogEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.npcOpenDialogEventId)
        self.npcOpenDialogEventId = nil
    end
    self.super.close(self)
end



function NpcTransfer:destory()
	self:close()
	self.super.destory(self)
end

return NpcTransfer



