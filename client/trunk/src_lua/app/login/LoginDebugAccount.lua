--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-27 14:43:13
-- DEBUG 帐户登陆
local LoginDebugAccount = class("LoginDebugAccount", function()
	return display.newNode()
end)

function LoginDebugAccount:ctor()
	display.addSpriteFrames("common/login/login.plist", "common/login/login.png")

	self.nameBg = display.newSprite("#login/login_creatNameBg.png")
	self.nameBg:setPosition(display.cx,display.cy)
	self:addChild(self.nameBg)
    self.nameBg:setTouchEnabled(false)

    local options = {placeHolder = "输入帐号",
        UIInputType = 1,
        width = 250,
        height = 40,
        text = "",
        maxLength = 10,
        x = 0,y =50,
        maxLengthEnable = true,
        passwordEnable = false
    }

    local function onEdit(textfield, eventType)
        SoundManager:playSoundByType(SoundType.INPUT_CHAR) 
        if event == 0 then
            -- ATTACH_WITH_IME
        elseif event == 1 then
            -- DETACH_WITH_IME
        elseif event == 2 then
            -- INSERT_TEXT
        elseif event == 3 then
            -- DELETE_BACKWARD
        end
    end

    self.nameLab = cc.ui.UIInput.new({
        listener = handler(self,onEdit),
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

    self.enterBtn = display.newSprite("common/com_PicBtnY1.png")
    self.enterBtn:setTouchEnabled(true)	
    self:addChild(self.enterBtn)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then            	
                self.enterBtn:setScale(1.1)
            elseif event.name == "ended" then            	
                self.enterBtn:setScale(1)
                self:onEnterBtnClick()
            end
            return true
        end)
    local enterLab = display.newTTFLabel({
        	text = "确  定",    	
        	size = 22,
        	color = cc.c3b(238, 196,142), 
   	})
    --display.setLabelFilter(enterLab)
    enterLab:setTouchEnabled(false)	
    enterLab:setPosition(69,30)
    self.enterBtn:addChild(enterLab)

    self.enterBtn:setPosition(display.cx+250,display.cy)
end

function LoginDebugAccount:onEnterBtnClick()
	self.fristLogin = false
	local userAccount = ""
    if self.nameLab then
        userAccount = StringUtil.trim(self.nameLab:getText())
        local params = StringUtil.split(userAccount, "@")
        if #params > 1 then
            GlobalModel.platform = params[1]
            userAccount = params[2]
        else
            local params = StringUtil.split(userAccount, ":")
            if #params > 1 then
                 local InputIP = params[2]
                userAccount = params[1]
                GlobalModel.selServerInfo = {name= "IP服",state = 1,service_id = 102,service_port = 10011,ip = InputIP}
            end
        end

        -- {\"name\" : \"内网服\",\"state\" : 1,\"service_id\" : 103,\"service_port\" : 10011, \"ip\" : \"192.168.0.222\"},
    else
        math.randomseed(socket.gettime())
        if userAccount == "" then userAccount = tostring(math.random(1,100000)) end
    end
    if userAccount ~= "" then
        if GlobalModel.open_id ~= userAccount then
            self.fristLogin = true
        end
        GlobalModel.open_id = userAccount
        if self.fristLogin  then
            GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
        else
            GlobalController.login:connectSocket()
        end
    else
        GlobalAlert:showTips("帐号不正确,请重新输入！")
    end 
end

--开启
function LoginDebugAccount:open()
	self:setVisible(true)
	if GlobalModel.open_id ~= "" then
        self.nameLab:setText(GlobalModel.open_id)
    end
end

--关闭
function LoginDebugAccount:close()
	self:setVisible(false)
end

--销毁
function LoginDebugAccount:destory()
	
end

return LoginDebugAccount
