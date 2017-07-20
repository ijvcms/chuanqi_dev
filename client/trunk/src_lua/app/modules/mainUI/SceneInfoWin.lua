--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-06-16 16:11:25
-- 场景信息面板
local SceneInfoWin = class("SceneInfoWin", function()
	return display.newNode()
end)


SceneInfoItem = class("SceneInfoItem", function()
	return display.newNode()
end)

function SceneInfoItem:ctor(data)
	self.selBg = display.newScale9Sprite("#com_listBg2.png", 0, 0, cc.size(200,50))
    self.selBg:setAnchorPoint(0,0)
    self:addChild(self.selBg)
    self.selBg:setVisible(false)
    self.nameLab = display.newTTFLabel({
                text = "",
                size = 22,color = cc.c3b(255, 255, 255)})
                :align(display.CENTER,0,0)
                :addTo(self)
    self.nameLab:setPosition(100,25)

    
end

function SceneInfoItem:getVO()
	return self.vo
end

function SceneInfoItem:setData(vo)
	self.vo = vo
	local color = TextColor.MONSTER_W
	if vo.type == SceneRoleType.MONSTER then
		if vo.mConf.type == 3 then --boss
			color = TextColor.MONSTER_R
		elseif vo.mConf.type == 2 then --精英
			color = TextColor.MONSTER_Y
		elseif vo.mConf.type == 1 then 
			color = TextColor.MONSTER_W
		end
	elseif vo.type == SceneRoleType.PLAYER then
		color = vo:getNameColor(vo.nameColor)
	--elseif vo.type == SceneRoleType.MONSTER then
	--elseif vo.type == SceneRoleType.MONSTER then
	end
	self.nameLab:setColor(color)
	self.nameLab:setString(vo.name)
end

function SceneInfoItem:setSelect(bool)
	self.selBg:setVisible(bool)
end






function SceneInfoWin:ctor(data)
	self.parent= data
	self.black = display.newColorLayer(cc.c4b(0, 0, 0, 70))
    -- black:setAnchorPoint(0.5,0.5)
    self.black:setPosition(0,0)
    self:addChild(self.black)
    self.black:setTouchEnabled(true)
    self.black:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            if self.parent then
            	self.parent:showSceneinfoWin(false)
            end
        end
        return true
    end)

    self.bg = display.newScale9Sprite("#com_panelBg5.png", 0, 0, cc.size(217,270))
    self:addChild(self.bg)
    self.bg:setAnchorPoint(0,0)
    self.bg:setPosition((display.width-217)/2,(display.height-270)/2)

    local function listTouchListener(event)
    	if event.name == "clicked" then
    		if self.curSelectId ~= event.itemPos then
    			local selItem = self.itemList[self.curSelectId]
    			if selItem then
	    			selItem.item:setSelect(false)
	    		end
	    		self.curSelectId = event.itemPos
		    	local item = self.itemList[event.itemPos]
		    	if item then
	    			item.item:setSelect(true)
	    			local vo = item.item:getVO()
	    			if GlobalController.fight.monsterViewArr[vo.id] or GlobalController.fight.playerViewArr[vo.id] then
		    			FightModel:setSelAtkTarVO(vo)
		    		else
		    			
		    		end

		    		if self.parent then
		            	self.parent:showSceneinfoWin(false)
		            end
	    		end
		    end
	    end
    end

    self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 200, 250),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(listTouchListener)
        :addTo(self.bg)
    self.listView:setPosition(8,10)
    self.curSelectId = 0
    self.itemList = {}
    self.itemIndexList = {}
end

function SceneInfoWin:open(data)
	-- if self.mapAddRoleEventId == nil then
 --        self.mapAddRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_ADD_ROLE,handler(self,self.onMapAddRole))
 --    end
 --    if self.mapDelRoleEventId == nil then
 --        self.mapDelRoleEventId = GlobalEventSystem:addEventListener(SceneEvent.MAP_DEL_ROLE,handler(self,self.onMapDelRole))
 --    end
    self:update()
end


function SceneInfoWin:update(data)
	local index = 1
	self.voList = {}
    for k,v in pairs(GlobalController.fight.monsterViewArr) do
    	if v.vo.mConf and v.vo.mConf.type > 1 then
    		if v.vo.mConf.type == 2 then
    			table.insert(self.voList,#self.voList,v.vo)
    		elseif v.vo.mConf.type == 3 then
    			table.insert(self.voList,1,v.vo)
    		end
    	end
    end
    local pkMode = RoleManager:getInstance():getPKMode()
    local playerVO =  GameSceneModel:getPlayerVO()
    local vo
    for k,v in pairs(GlobalController.fight.playerViewArr) do
        vo = v.vo
        if vo.type == SceneRoleType.PLAYER and vo.id ~= GlobalModel.player_id then
            if vo.states ~= RoleActivitStates.DEAD and  FightModel:curPlayerCanPK(pkMode,playerVO,vo) then
                table.insert(self.voList,vo)
            end
        end
        -- 老的备份
        -- local isTeam = (playerVO.teamId == "0" or vo.teamId == "0" or playerVO.teamId ~= vo.teamId) 
        -- local isguildId = (playerVO.guildId == "0" or vo.guildId == "0" or playerVO.guildId ~= vo.guildId) 
        -- if vo.type == SceneRoleType.PLAYER and vo.id ~= GlobalModel.player_id  and isguildId and isTeam and RoleManager:getInstance():getHasUnion(vo.guildId)== false  then
        --     if vo.states ~= RoleActivitStates.DEAD and  FightModel:curPlayerCanPK(pkMode,playerVO,vo) then
        --     	table.insert(self.voList,vo)
        --     end
        -- end
    end
    for i=1,#self.voList do
        if self.itemList[index] == nil then
		        local item = self.listView:newItem()
		        local btnItem = SceneInfoItem.new()
		        btnItem:setAnchorPoint(0,0)
		        btnItem:setContentSize(200, 50)
		        item:addContent(btnItem)
		        item:setItemSize(200, 50)
		        self.listView:addItem(item)
		        item.item = btnItem
		    	self.itemList[index] = item
		end
		local btnitem = self.itemList[index].item
		btnitem:setData(self.voList[i])
		index = index+1
    end
    self.listView:reload()
end


function SceneInfoWin:onMapAddRole(data)
    if data.data.type == SceneRoleType.PLAYER then
        if data.data.id ~= GlobalModel.player_id then
            if self.itemList[data.data.id] == nil then
                local item = self.listView:newItem()
		        local btnItem = SceneInfoItem.new()
		        btnItem:setAnchorPoint(0,0)
		        btnItem:setContentSize(200, 50)
		        item:addContent(btnItem)
		        item:setItemSize(200, 50)
		        self.listView:addItem(item)
		        item.item = btnItem
		    	self.itemList[data.data.id] = item
            end
            local btnitem = self.itemList[data.data.id].item
		    btnitem:setData(data.data)
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        if self.itemList[data.data.id] == nil then
                local item = self.listView:newItem()
		        local btnItem = SceneInfoItem.new()
		        btnItem:setAnchorPoint(0,0)
		        btnItem:setContentSize(200, 50)
		        item:addContent(btnItem)
		        item:setItemSize(200, 50)
		        self.listView:addItem(item)
		        item.item = btnItem
		    	self.itemList[data.data.id] = item
        end
        local btnitem = self.itemList[data.data.id].item
		btnitem:setData(data.data)
    end

    self.listView:reload()
end

function SceneInfoWin:onMapDelRole(data)
     if data.data.type == SceneRoleType.PLAYER then
        if self.itemList[data.data.id] then
            self.listView:removeItem(self.itemList[data.data.id])
            self.itemList[data.data.id] = nil
        end
    elseif data.data.type == SceneRoleType.MONSTER then
        if self.itemList[data.data.id] then
            self.listView:removeItem(self.itemList[data.data.id])
            self.itemList[data.data.id] = nil
        end
    end
end

function SceneInfoWin:close(data)
	if self.mapAddRoleEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.mapAddRoleEventId)
        self.mapAddRoleEventId = nil
    end
    if self.mapDelRoleEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.mapDelRoleEventId)
        self.mapDelRoleEventId = nil
    end
end

function SceneInfoWin:destory(data)

end


return SceneInfoWin