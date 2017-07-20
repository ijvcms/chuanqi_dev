--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-02-22 11:29:54
--

--
-- 世界地图视图。
--
local WorldMapItem = import(".WorldMapItem")
local WorldMapView = class("WorldMapView", display.newNode)

function WorldMapView:ctor()
	self:initialization()
end

function WorldMapView:initialization()
	self:initComponents()
	self._places = configHelper:getWorldMapPlaces()
	self:invalidatePlaces()
end

function WorldMapView:initComponents()
	local container = display.newNode()
		:pos(0, 2)
		:addTo(self)
	local bg = display.newSprite("#wm_background.png") --
		:addTo(container)
	bg:setAnchorPoint(cc.p(0, 0))

	local mapWidth = bg:getContentSize().width
    self.worldMapName = display.newTTFLabel({text = "大陆", size = 24,color = TextColor.TEXT_W})
    	:align(display.CENTER,0,0)
    	:addTo(self)
    	:pos(20, 488+30)
    display.setLabelFilter(self.worldMapName)

	self._placesContainer = display.newNode()
		:addTo(container)

	GameNet:sendMsgToSocket(11055)

	if self.getOpenMapEventId == nil then
        self.getOpenMapEventId = GlobalEventSystem:addEventListener(SceneEvent.GET_MAP_ISOPEN,handler(self,self.setOpenMapId))
    end
end

function WorldMapView:invalidatePlaces()
	self._placesContainer:removeAllChildren()

	local click_handler = handler(self, self.onItemClickHandler)
	for _, v in pairs(self._places) do
		local place = WorldMapItem.new()
		place:setData(v)
		place:setOnClickHandler(click_handler)
		self._placesContainer:addChild(place)
	end
end

function WorldMapView:setOpenMapId(data)
	-- <Param name="scene_id" type="int32" describe="场景id"/>
	-- 		<Param name="state" type="int16" describe="1,表示合服地图没有开启"/>
	self.openMapList = data.data
end

function WorldMapView:onItemClickHandler(item)
	local itemData = item:getData()
	if self.openMapList == nil then
		return 
	else
		for i=1,#self.openMapList do
			if itemData.scene_id == self.openMapList[i].scene_id then
				if self.openMapList[i].state == 1 then
					GlobalMessage:alert({
						hideBackBtn = true,
						enterTxt = "确定",
						tipTxt = itemData.limit_text or "地图未开放",
						
					})
					return
				end
			end
		end
	end

	if itemData.scene_id == 0 then
		GlobalMessage:show("当前地图暂未开放，请耐心等候哦！")
		return
	end

	
	-- local mapConf = getConfigObject(itemData.scene_id,ActivitySceneConf)
	-- if mapConf.lv_limit > RoleManager:getInstance().roleInfo.lv then
	-- 	GlobalMessage:show(itemData.limit_text)
	-- 	return
	-- end

	if itemData then
		local flyShoesNum = BagManager:getInstance():findItemCountByItemId(110078)
		local function confirmGotoScene()
			if flyShoesNum <= 0 then
				GlobalMessage:show("当前小飞鞋数量不足，无法传送！")
				return
			end

			local sceneId = itemData.scene_id
			GameNet:sendMsgToSocket(29005, {scene_id = sceneId, x = 0, y = 0,is_equip = 0})
			--GlobalWinManger:closeWin(WinName.MAP)
		end

		local function gotoScene()
			local sceneId = itemData.scene_id
			local mapConf = getConfigObject(sceneId,ActivitySceneConf)
			if mapConf and mapConf.birth and #mapConf.birth > 0 then
				local birthPoint = mapConf.birth[1][1]
				SceneManager:playerMoveTo(sceneId,{x=birthPoint[1],y=birthPoint[2]},nil,true)
			end
			--GlobalWinManger:closeWin(WinName.MAP)
		end

		GlobalMessage:alert({
			enterTxt = "传送",
			backTxt = "寻路",
			tipTxt = string.format("您确认传送至%s吗？\n传送消耗：小飞鞋X1\n当前剩余：小飞鞋X%d",itemData.name ,flyShoesNum ),
			enterFun = confirmGotoScene,
			backFun = gotoScene,
		})
	end
end

function WorldMapView:destory()

end

return WorldMapView