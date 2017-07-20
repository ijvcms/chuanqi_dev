--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-26 16:27:36
-- 创建角色
local LoginCreatRole = class("LoginCreatRole", function()
	return display.newNode()
end)

function LoginCreatRole:ctor()
  
	local bg = display.newSprite("common/login/login_creatRoleBg3.png")
	bg:setPosition(display.cx,display.cy)
	bg:setScaleX(display.width/1136)
	bg:setScaleY(display.height/640)
	self:addChild(bg)

	local bottomBg = display.newSprite("common/login/login_creatBottom.png")
    self:addChild(bottomBg)
    bottomBg:setPosition(display.cx,175)
    --bottomBg:setVisible(false)

    local roleLay = display.newNode()
	self:addChild(roleLay)
	roleLay:setPosition(display.width/2,display.height/2-120)

    
	-- local txtSelRole = display.newSprite("common/login/login_creatRoleTipTxt.png")
	-- self:addChild(txtSelRole)
	-- txtSelRole:setPosition(display.cx-110,display.height-50)

	self.nameBg = display.newSprite("#login/login_creatNameBg.png")
	self.nameBg:setPosition(display.cx,80)
	self:addChild(self.nameBg)
    self.nameBg:setTouchEnabled(false)

    self.randomBtn = display.newSprite("#login/login_dice.png")
	self.nameBg:addChild(self.randomBtn)
	self.randomBtn:setPosition(310,28)
	self.randomBtn:setTouchEnabled(true)
    self.randomBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        	self.randomBtn:setScale(1.1)
        elseif event.name == "ended" then
        	self.randomBtn:setScale(1)
            self:randomName()
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
            GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_SELROLE)
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
    		self:startGame()
    	end
    	return true
    end)

    -- local selectTips = display.newTTFLabel({
    --     text = "选择角色/n\n(左右滑动选择职业和性别)",
    --     --font = "Arial",
    --     size = 20,
    --     color = TextColor.TEXT_R
    --     -- align = cc.TEXT_ALIGNMENT_LEFT,
    --     -- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    --    -- dimensions = cc.size(300, 40)
    -- })
    -- --selectTips:setAnchorPoint(0,0)
    -- selectTips:setPosition(display.cx,display.height - 50)
    -- self:addChild(selectTips)


	local options = {placeHolder = "请输入名称",
        UIInputType = 1,
        width = 200,
        height = 40,
        text = "",
        maxLength = 6,
        x = 0,y =50,
        maxLengthEnable = true,
        passwordEnable = false
    }

    self.nameLab = cc.ui.UIInput.new({
        listener = handler(self,self.onEdit),
        UIInputType = 1,
        size = cc.size(options.width, options.height),
        image = "common/input_opacity1Bg.png",
        align = cc.TEXT_ALIGNMENT_CENTER,
        font = display.DEFAULT_TTF_FONT,
        dimensions = cc.size(200, 40),
        })
    self.nameLab:setPlaceHolder(options.placeHolder)
    self.nameLab:setFontSize(options.fontSize or 22)
    self.nameLab:setText(options.text)
    self.nameLab:setReturnType(1)
    if options.passwordEnable then
        self.nameLab:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    end
    if options.maxLengthEnable then
        self.maxLength = options.maxLength
    end
    self.nameLab:setPosition(150, 31)
    self.nameLab:setColor(cc.c3b(50,50,50))
    self.nameBg:addChild(self.nameLab)

	self.careerSchoolTxt = display.newSprite()
	self:addChild(self.careerSchoolTxt)
	self.careerSchoolTxt:setPosition(display.width - 95,display.height - 195)




	self.touchX = 0
	self:setContentSize(display.width,display.height)

	self.pointList = {}

	self:creatPoint()
	self.stopPoint ={100,233,266 ,299,333,366}
	self.stopPoint ={25,62,102,142,182,222}

	self.carrerConfig = {
		{sex = 1,career = 1000},
		{sex = 2,career = 1000},
		{sex = 1,career = 2000},
		{sex = 2,career = 2000},
		{sex = 1,career = 3000},
		{sex = 2,career = 3000},
	}

	self.curSelectItem = nil

    self.roleList = {}
    for i=1,#self.stopPoint do
    	local registerbtn = require("app.login.item.LoginCreatRoleItem").new(self.pointList,i)
    	roleLay:addChild(registerbtn)
    	local index = self.stopPoint[i]
    	registerbtn:setIndex(index)
    	registerbtn:setRoleVO(self.carrerConfig[i])
    	--registerbtn:setPos(self.pointList[index][1]*3,self.pointList[index][2]*3)
    	table.insert(self.roleList,registerbtn)
    	if i == 1 then
    		self:onSetSelectItem(registerbtn)
    		self.roleList[i]:showGuangHuang(true)
    	else
    		self.roleList[i]:showGuangHuang(false)
    	end
    end
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.clickTime = socket.gettime()
            self.touchX = event.x
            self.moveX = event.x
            if self.scheduleTimerId == nil then
                self.scheduleTimerId = GlobalTimer.scheduleUpdateGlobal(handler(self,self.roleRound))
            end
        elseif event.name == "moved" then
        	--print(#self.pointList)
        	self.moveX = event.x
        elseif event.name == "ended" then
		    if self.scheduleTimerId then
		        GlobalTimer.unscheduleGlobal(self.scheduleTimerId)
		        self.scheduleTimerId = nil
		    end
		    local index = 0
		    local min = 10000
		    self.stopPoint2 ={100,233,266 ,299,333,366}
		    self.stopPoint2 ={25,65,102,142,182,235}
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

		     for i=1,#self.roleList do
		     	if self.roleList[i].index == self.stopPoint[1] then
		     		self:onSetSelectItem(self.roleList[i])
		     		self.roleList[i]:showGuangHuang(true)
		     	else
		     		self.roleList[i]:showGuangHuang(false)
		     	end
		     end
		    --self.battle:convertToNodeSpace(cc.p(event.x, event.y))
		    local isHit = self.roleList[self.middleRoleIndex]:hitTestPos(cc.p(event.x, event.y))
        	-- if socket.gettime() - self.clickTime < 0.1 and self.touchX == event.x then
        	-- 	SoundManager:playClickSound()
        	-- 	self:onItemClick()
        	-- end
        end     
        return true
    end)
    self.middleRoleIndex = 1
    --self:updateList()
end

function LoginCreatRole:onEdit(event, editbox)
     if event == "ended" then
        local checkText = editbox:getText()
        if StringUtil.Utf8strlen(checkText) > self.maxLength then
            editbox:setText(StringUtil.SubUTF8String(checkText, 1, self.maxLength))
        end
    end   
end

--
--s 源字符串
--t 屏蔽字符表
function LoginCreatRole:replaceStr(s,t)
 
    for i=1,#t do
        local _,n = string.find(s,t[i].word)
        if n ~= nil and n > 0 then
            return true
        end
    end
 
    return false
end
--特殊字符，表情等
function LoginCreatRole:replaceStr2(s,t)
 
    for i=1,#t do
        local _,n = string.find(s,t[i])
        if n ~= nil and n > 0 then
            return true
        end
    end
 
    return false
end

--开始游戏
function LoginCreatRole:startGame()
	local nickname = StringUtil.trim(self.nameLab:getText())
    if self:replaceStr(nickname,configHelper:getSensitiveWord()) or self:replaceStr2(nickname,{"\\","<"}) then
        GlobalAlert:showTips("含有非法字符,请重新输入!")
        return
    end
 
	local sex = self.curSelectItem.vo.sex
  	local career = self.curSelectItem.vo.career
  	if nickname ~= "" and nickname ~= nil then
        GlobalModel.nickName = nickname
        GlobalController.login.gameAccount = nickname 

        if GlobalModel:getIsConnect() then
            local param = {
                open_id = GlobalModel.open_id,
                platform = GlobalModel.platform,
                name = nickname,
                sex = sex,
                career = career,
                server_id = GlobalModel.selServerInfo.service_id
            }
            GameNet:sendMsgToSocket(10001, param)
        else
        end
   	else
   		GlobalAlert:showTips("请输入昵称!")
  	end  
end


function LoginCreatRole:onSetSelectItem(item)
	if item ~= self.curSelectItem then
		self.curSelectItem = item
		self.careerSchoolTxt:setSpriteFrame("login/login_school"..item.vo.career..".png")
		-- = display.newSprite("#login/login_school"..item.vo.career..".png")
        self:randomName()
	end
end

function LoginCreatRole:randomName()
    local current = self.curSelectItem
    if current then
        local isMan = current.vo.sex == 1
        self.nameLab:setText(configHelper:getRandomName(isMan))
    end
end


function LoginCreatRole:updateList(list)
	for i=1,#self.stopPoint do
	 	self.roleList[i]:setRoleVO(list[i])
    	local index = self.stopPoint[i]
    	self.roleList[i]:setIndex(index)
    end
    self.middleRoleIndex = 1
    local bb = false
	if #list >0 then
		bb = true
	else
		bb = false
	end
end


function LoginCreatRole:roleRound()
	local offset = self.touchX -self.moveX
	self.touchX = self.moveX
	for i=1,#self.roleList do
		self.roleList[i]:update(0-math.floor(offset/5))
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
end



function LoginCreatRole:creatPoint()
	local a = 100
	local b = 20

	for i=-99,0,4 do
	 	y = math.sqrt((a*a*b*b-b*b*i*i)/(a*a))
	 	--print(i,0-math.floor(y))
	 	table.insert(self.pointList,{i,0-math.floor(y)})
	end
	for i=1,100,4 do
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

function LoginCreatRole:open()
	self:setVisible(true)
    SoundManager:playMusicByType(SoundType.CREATE_ROLE_BG)
end

function LoginCreatRole:close()
	self:setVisible(false)
end

function LoginCreatRole:destory()
	if self.scheduleTimerId then
        GlobalTimer.unscheduleGlobal(self.scheduleTimerId)
        self.scheduleTimerId = nil
    end
    for i=1,#self.roleList do
    	local item = self.roleList[i]
    	item:destory()
    	if item:getParent() then
    		item:getParent():removeChild(item)
    	end
    end
    self.roleList = {}
end

return LoginCreatRole