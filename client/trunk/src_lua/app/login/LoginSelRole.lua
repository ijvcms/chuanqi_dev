--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-25 17:57:19
-- 选择角色
local LoginSelRole = class("LoginSelRole", function()
	return display.newNode()
end)

function LoginSelRole:ctor()
	display.addSpriteFrames("common/login/login.plist", "common/login/login.png")
	local bg = display.newSprite("common/login/login_creatRoleBg3.png")
	bg:setPosition(display.cx,display.cy)
	bg:setScaleX(display.width/1136)
	bg:setScaleY(display.height/640)
	self:addChild(bg)

	local bottomBg = display.newSprite("common/login/login_creatBottom.png")
    self:addChild(bottomBg)
    bottomBg:setPosition(display.cx,175)
    bottomBg:setVisible(false)

	-- local leftZuzi = display.newSprite("common/login/login_taiziPic.png")
    -- self:addChild(taizi)
    -- taizi:setPosition(display.cx,63)

	local roleLay = display.newNode()
	self:addChild(roleLay)
	roleLay:setPosition(display.width/2,display.height/2-180)


	self.delBtn = display.newSprite("#login/login_roleDelete.png")
	self.delBtn:setPosition(display.cx,80)
	self:addChild(self.delBtn)
    self.delBtn:setTouchEnabled(true)
    self.delBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.delBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.delBtn:setScale(1)
            local vo = self.roleList[self.middleRoleIndex].vo
            if vo then
	            GlobalAlert:pop({tipTxt = "       确定要删除该角色?",enterFun = handler(self, self.sendDelectRole)})
	        else
	        	GlobalAlert:showTips("账号错误")
	        end
        end
        return true
    end)


	local backBtn = display.newSprite("#login/login_backBtn.png")
    self:addChild(backBtn)
    --backBtn:setAnchorPoint(0.5,0.5)
    backBtn:setPosition(180,80)
    backBtn:setTouchEnabled(true)
    backBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            backBtn:setScale(1.1)
        elseif event.name == "ended" then
            backBtn:setScale(1)
            GlobalModel.showDisconnectTip = false
            GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
        end
        return true
    end)


	self.startBtn = display.newSprite("#login/login_beginEnter.png")
	self:addChild(self.startBtn)
	self.startBtn:setPosition(display.width-180,80)
	self.startBtn:setTouchEnabled(true)
    self.startBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name == "began" then
    		SoundManager:playClickSound()
    		self.startBtn:setScale(1.1)
    	elseif event.name == "ended" then
    		self.startBtn:setScale(1)
    		if GlobalModel.isConnect then
                local role = self.roleList[self.middleRoleIndex].vo
				GlobalModel.player_id = role.player_id
				GlobalModel.name = role.name
				GlobalModel.sex = role.sex
				GlobalModel.career = role.career
				GlobalModel.lv = role.lv
				GlobalController.login:sendMsg10002()
            else
                GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_MAIN)
            end
    	end
    	return true
    end)


	self.touchX = 0
	self:setContentSize(display.width,display.height)

	self.pointList = {}

	self:creatPoint()
	self.stopPoint ={100,233,366}

    self.roleList = {}
    for i=1,3 do
    	local registerbtn = require("app.login.item.LoginSelRoleItem").new(self.pointList)
    	roleLay:addChild(registerbtn)
    	local index = self.stopPoint[i]
    	registerbtn:setIndex(index)
    	--registerbtn:setPos(self.pointList[index][1]*3,self.pointList[index][2]*3)
    	table.insert(self.roleList,registerbtn)
    end
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	--print("=====>began"..event.x..","..event.y)
            self.touchX = event.x
            self.touchBeganX = event.x
            self.touchBeganY = event.y
            self.moveX = event.x
            if self.scheduleTimerId == nil then
                self.scheduleTimerId = GlobalTimer.scheduleUpdateGlobal(handler(self,self.roleRound))
            end
        elseif event.name == "moved" then
        	--print("=====>moved"..event.x..","..event.y)
        	--print(#self.pointList)
        	self.moveX = event.x
        elseif event.name == "ended" then
            --print("=====>ended"..event.x..","..event.y)
		    if self.scheduleTimerId then
		        GlobalTimer.unscheduleGlobal(self.scheduleTimerId)
		        self.scheduleTimerId = nil
		    end
		    local index = 0
		    local min = 10000
		    self.stopPoint2 ={100,233,366}
		    for i=1,#self.roleList do
		    	min = 10000
		    	index = 0
		    	for j=1,#self.stopPoint2 do
		    		local ii = math.abs(self.roleList[i]:getIndex() - self.stopPoint2[j])
		    		if ii < min then
		    			index = j
		    			min = ii
		    		end 
		    	end
		    	self.roleList[i]:setIndex(self.stopPoint2[index])
		    	table.remove(self.stopPoint2,index)
		    end
		    --self.battle:convertToNodeSpace(cc.p(event.x, event.y))
		    local isHit = self.roleList[self.middleRoleIndex]:hitTestPos(cc.p(event.x, event.y))
        	if  isHit and math.abs(self.touchBeganX - event.x) < 6 and math.abs(self.touchBeganY - event.y) < 6 then
        		SoundManager:playClickSound()
        		self:onItemClick()
        	end
        end     
        return true
    end)
    self.middleRoleIndex = 1
    --self:updateList()

    local onDelectRole = function(data)
        self:delectRole(data.data)
    end
    GlobalEventSystem:addEventListener(LoginEvent.DELECT_ROLE,onDelectRole)
end

--开启
function LoginSelRole:open()
	self:setVisible(true)
	local array = GlobalModel.curServerRoleArr
	self:updateList(array)

	 SoundManager:playMusicByType(SoundType.LOGIN_BG)
end

--关闭
function LoginSelRole:close()
	self:setVisible(false)
end


function LoginSelRole:sendDelectRole()
	local vo = self.roleList[self.middleRoleIndex].vo
    if vo then
	    GameNet:sendMsgToSocket(10009, {player_id = vo.player_id})

	end
end

function LoginSelRole:delectRole(value)
	for i=1,#self.roleList do
		local item = self.roleList[i]
		if item.vo and value == item.vo.player_id then
			item:setRoleVO(nil)
			self.delBtn:setVisible(false)
			self.startBtn:setVisible(false)
			--table.remove(self.roleList,i)
			for i=1,#GlobalModel.curServerRoleArr do
				local vo = GlobalModel.curServerRoleArr[i]
				if vo.player_id == value then
					table.remove(GlobalModel.curServerRoleArr,i)
					break
				end
			end
		end
	end
end


function LoginSelRole:onItemClick()
	local vo = self.roleList[self.middleRoleIndex].vo
	if vo then
		--self.roleList[self.middleRoleIndex]
	else
		GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_REGITER)
	end 
end

function LoginSelRole:updateList(list)
	local selIdx = 1
	if GlobalModel.player_id ~= "" then --读取之前选中的角色
        for i=1,3 do

    	    local role = list[i]
    	    if role ~= nil and GlobalModel.player_id == role.player_id then
    	    	break;
    	    end
    	    selIdx = selIdx + 1
        end
	end
	for i = 1,3 do
		if selIdx > 3 then
    		selIdx = 1
    	end
	 	self.roleList[i]:setRoleVO(list[selIdx])
    	local index = self.stopPoint[i]
    	self.roleList[i]:setIndex(index)
    	selIdx = selIdx + 1
    end

    self.middleRoleIndex = 1
    local bb = false
	if #list >0 then
		bb = true
	else
		bb = false
	end
	self.delBtn:setVisible(bb)
	self.startBtn:setVisible(bb)
	--self.creatBtn:setVisible(bb == false)
end

function LoginSelRole:roleRound()
	local offset = self.touchX -self.moveX
	self.touchX = self.moveX
	for i=1,#self.roleList do
		self.roleList[i]:update(0-math.floor(offset/2))
	end

	local index = 0
	local min = 10000
	for i=1,#self.roleList do
		local ii = math.abs(self.roleList[i]:getIndex() - self.stopPoint[1])
		if ii < min then
		    index = i
		    min = ii
		end
	end
	self.middleRoleIndex = index
	local vo = self.roleList[index].vo

	local bb = false
	if vo then
		bb = true
	else
		bb = false
	end
	self.delBtn:setVisible(bb)
	self.startBtn:setVisible(bb)
end

function LoginSelRole:creatPoint()
	 local a = 100
	 local b = 20
	 for i=-99,0 do
	 	y = math.sqrt((a*a*b*b-b*b*i*i)/(a*a))
	 	--print(i,0-math.floor(y))
	 	table.insert(self.pointList,{i,0-math.floor(y)})
	 end
	 for i=1,100 do
	 	y = math.sqrt((a*a*b*b-b*b*i*i)/(a*a))
	 	--print(i,0-math.floor(y))
	 	table.insert(self.pointList,{i,0-math.floor(y)})
	 end
	 for i=98,-100,-1 do
	 	y = math.sqrt((a*a*b*b-b*b*i*i)/(a*a))
	 	--print(i,math.floor(y))
	 	table.insert(self.pointList,{i,math.floor(y)})
	 end
end

function LoginSelRole:destory()
	if self.scheduleTimerId then
        GlobalTimer.unscheduleGlobal(self.scheduleTimerId)
        self.scheduleTimerId = nil
    end
    GlobalEventSystem:removeEventListener(LoginEvent.DELECT_ROLE)
    for i=1,#self.roleList do
    	local item = self.roleList[i]
    	item:destory()
    	item:removeFromParent(true)
    end
    self.roleList = nil
end

return LoginSelRole
