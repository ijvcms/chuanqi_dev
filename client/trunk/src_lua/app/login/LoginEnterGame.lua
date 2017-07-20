--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-25 17:57:19
-- 进入游戏
local LoginEnterGame = class("LoginEnterGame", function()
	return display.newNode()
end)

function LoginEnterGame:ctor()
	display.addSpriteFrames("common/login/login.plist", "common/login/login.png")
	--display.width
	--display.height
	--健康提示
	local tips = display.newSprite()
    self:addChild(tips)
    tips:setPosition(display.width / 2,30)
    tips:setSpriteFrame("login/login_healthTip.png")


    self.noticesBtn = display.newSprite("#login/login_noticesBtn.png")
    self.noticesBtn:setPosition(60,100)
    self:addChild(self.noticesBtn)
    self.noticesBtn:setTouchEnabled(true)
    self.noticesBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
                self.noticesBtn:setScale(1.1)
            elseif event.name == "ended" then
                self.noticesBtn:setScale(1)
                -- 进入游戏触发公告显示。
                GlobalController.notice:startSystemNoticeTask()
            end
            return true
    end)

    --选择服务器
	self.serverBar = display.newSprite("#login/login_serverBg.png")
    self:addChild(self.serverBar)
    self.serverBar:setPosition(display.width/2,230)
    self.serverBar:setTouchEnabled(true)
    self.serverBar:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_SELSERVER)
        end     
        return true
    end)

    self.serverLab = display.newTTFLabel({
        text = "",
        size = 28,
        color = cc.c3b(238, 228, 208), -- 使用纯红色
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    })
    self.serverLab:setTouchEnabled(false)
    self.serverLab:setPosition(160,22)
    self.serverBar:addChild(self.serverLab)
    self.serverLab:setString("服务器名称")

    self.serverStausIcon = display.newSprite("#login/login_statusGreen.png")
    self.serverBar:addChild(self.serverStausIcon)
    self.serverStausIcon:setPosition(50,20)

    --进入按钮
	self.enterBtn = display.newSprite("#login/login_enter.png")
    self:addChild(self.enterBtn)
    self.enterBtn:setPosition(display.width/2,150)

    self.enterBtn:setTouchEnabled(true)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.enterBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.enterBtn:setScale(1)
            if GlobalModel.selServerInfo and GlobalModel.selServerInfo.state == 0 then
                GlobalAlert:pop({tipTxt = "服务器正在维护中",hideBackBtn = true})
            else
                GlobalController.login:connectSocket()
            end
        end     
        return true
    end)


    local backBtn = display.newSprite("#login/login_backLeft.png")
    self:addChild(backBtn)
    backBtn:setPosition(50,display.height-60)
    backBtn:setTouchEnabled(true)
    backBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            backBtn:setScale(1.1)
        elseif event.name == "ended" then
            backBtn:setScale(1)
            GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ACCOUNT)
        end
    return true
    end)
    self.showNotice = false
end

--开启
function LoginEnterGame:open()
	self:setVisible(true)
	self.serverLab:setString(GlobalModel.selServerInfo.name)
	if GlobalModel.selServerInfo.state == 0 then
        self.serverStausIcon:setSpriteFrame("login/login_statusGrag.png")
        self.serverLab:setColor(cc.c3b(126, 126, 126))
    elseif GlobalModel.selServerInfo.state == 1 then
        self.serverStausIcon:setSpriteFrame("login/login_statusRed.png")
        self.serverLab:setColor(cc.c3b(238, 228, 208))
    elseif GlobalModel.selServerInfo.state == 2 then  
        self.serverStausIcon:setSpriteFrame("login/login_statusGreen.png")
        self.serverLab:setColor(cc.c3b(238, 228, 208))
    end

     SoundManager:playMusicByType(SoundType.LOGIN_BG)
    if self.noticeShowEventHandler == nil then
        self.noticeShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NOTICE_BOX, function(data)
            self:addChild(data.data)
        end)
    end
    if self.showNotice == false then
        self.showNotice = true
        GlobalController.notice:startSystemNoticeTask()
    end
end

--关闭
function LoginEnterGame:close()
    GlobalEventSystem:removeEventListenerByHandle(self.noticeShowEventHandler)
     self.noticeShowEventHandler = nil
	self:setVisible(false)
    --self.showNotice = false
end

--销毁
function LoginEnterGame:destory()
	
end

return LoginEnterGame
