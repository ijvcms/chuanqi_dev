--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-26 16:27:36
-- 注册登录场景

local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

function LoginScene:ctor()
    self.resList = {
      [1] = "common/login/login_bg.jpg",
      [2] = "common/login/login_logo.png"
    }
    local bg = display.newSprite(self.resList[1])
    bg:setPosition(display.cx,display.cy)
    self:addChild(bg)
    local logo = display.newSprite(self.resList[2])
    logo:setPosition(display.cx, display.height - 200)
    self:addChild(logo)

    self.mainLay = display.newNode()
    self.mainLay:setPosition(0, 0)
    self.mainLay:setTouchEnabled(true)
    self:addChild(self.mainLay) 

    self.msgLyr = display.newNode()
    self.msgLyr:setPosition(0, 0)
    self:addChild(self.msgLyr)
    -- local curAppVerLabel = display.newTTFLabel({size = 16, color = TextColor.TEXT_WHITE, text = "APP VERSION："..(APP_VERSION or "ERROR")})
    --         :align(display.CENTER_RIGHT, display.width - 25,45)
    --         :addTo(self)
    self.curGameVerLabel = display.newTTFLabel({size = 16, color = TextColor.TEXT_WHITE, text = "当前版本"..(GAME_VERSION or "1.0.0.0")})
            :align(display.CENTER_RIGHT, 120,display.height-15)
            :addTo(self)

    --监听事件
    --显示提示消息
    self.msgShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_MESSAGE, function(data)
        local view = data.data
        view:removeFromParent(false)
        self:addChild(data.data)
    end)
    --显示提示窗口
    -- self.noticeShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_NOTICE_BOX, function(data)
    --     if  self.enterGamePanel then
    --         self.enterGamePanel:addChild(data.data)
    --     end
    -- end)
    self.boxShowEventHandler = GlobalEventSystem:addEventListener(GlobalEvent.SHOW_BOX, function(data)
        self.msgLyr:addChild(data.data)
    end)
    GlobalEventSystem:addEventListener(LoginEvent.LOGIN_SHOW_ACCOUNT, handler(self,self.showDebugAccountPanel))
    GlobalEventSystem:addEventListener(LoginEvent.LOGIN_SHOW_ENTER,   handler(self,self.showEnterGamePanel))
    GlobalEventSystem:addEventListener(LoginEvent.LOGIN_SHOW_REGITER, handler(self,self.showCreatRolePanel))
    GlobalEventSystem:addEventListener(LoginEvent.LOGIN_SHOW_SELROLE, handler(self,self.showSelRolePanel))
    GlobalEventSystem:addEventListener(LoginEvent.LOGIN_SHOW_SELSERVER, handler(self,self.showSelServerPanel))

    GlobalEventSystem:addEventListener(LoginEvent.SELF_LOGIN_VIEW, function(data)
        self:showLoginView(data.data)
    end)

    self.serverCount = GlobalModel.serverCount
    self.serverList = GlobalModel.serverList
    self.fristLogin = false
    --注册登陆成功回调
    if DEBUG_LOGIN == false then
        ChannelAPI:setLoginCallbackHandler(handler(self,self.setLoginCallback))
        ChannelAPI:setLogoutCallbackHandler(handler(self,self.setLogoutCallback))
    end
    self:addBackEvent()


    --self:UserSprite() --13  48-53 13
    --self:UserAnimation() --26 34-38  27
    --self:UserMC() --20 40-43  18
    --self:UserArmature()

    self:addNodeEventListener(cc.NODE_EVENT, handler(self,self.onNodeEvent))
end

function LoginScene:onNodeEvent(data)
    --动作还没执行完就被移除,那么需要从tips队列里删掉这个tips
    if data.name == "cleanup" then
       --self:destory()
    end
end

function LoginScene:showLabTips(data)
    if LOGIN_SCNEE_LOG then
        if self.loginLabel == nil then
            self.loginLabel = display.newTTFLabel({
                text = "",
                size = 20,
                color = TextColor.TEXT_G,
                dimensions = cc.size(800,240)
            })
            -- display.setLabelFilter(self.ggContent)
            self.loginLabel:setAnchorPoint(0,1)
            self.loginLabel:setPosition(50,600)
            self.loginLabel:setTouchEnabled(false)
            self:addChild(self.loginLabel)
        end

        -- self.loginLabel = display.newTTFLabel({size = 16, color = TextColor.TEXT_WHITE, text = "当前版本"..(GAME_VERSION or "1.0.0.0")})
        --     :align(display.CENTER_RIGHT, 120,display.height-15)
        --     :addTo(self)
        if self.tips == nil then
            self.tips = data
        else
            self.tips = self.tips.."\n"..data
        end
        self.loginLabel:setString(self.tips)
    end
end




--第三方登陆成功
function LoginScene:setLoginCallback(data)

--     local dd = '{"code":1,"open_id":"ffsfdsdsd","plat":1000,"service_list":[{\"name\" : \"开天1服\",\"state\" : 1,\"service_id\" : 1001,\"service_port\" :10011,\"ip\" : \"123.206.203.28\"}]}'
-- local  jsonData = json.decode(dd)
-- dump(jsonData)
--登陆失败
    self:showLabTips("setLoginCallback_"..tostring(data))
    --data.ret = '{"code":1,"open_id":9663,"plat":1000,"service_list":[{"name":"1服","state":1,"service_id":1001,"service_port":10011,"ip":"123.206.203.28"}]}'
   -- DEBUG_SERVER_LIST2
   --'{"code":1,"open_id":"ffsfdsdsd","plat":1000,"service_list":[{\"name\" : \"开天1服\",\"state\" : 1,\"service_id\" : 1001,\"service_port\" :10011,\"ip\" : \"123.206.203.28\"}]}'
    local  jsonData = json.decode(data.ret)
    if jsonData.code == 1 then
        self.curServerId = GlobalModel.curServerId or 0
        self.serverList = jsonData.service_list
        table.sort(self.serverList, function (aa,bb)
            if aa.service_id < bb.service_id then  return true
            else  return false
            end
        end)
        table.sort(self.serverList, function (aa,bb)
            if aa.service_id < bb.service_id then  return true
            else  return false
            end
        end)

        self.serverCount = #self.serverList -- 服务器数量
        if self.serverCount == 0 then
            GlobalAlert:pop({tipTxt = "游戏区服暂未开放，请稍后再试！",hideBackBtn = true})
            return
        end

        for i=1,#self.serverList do
            if self.serverList[i].service_id == self.curServerId then
                self.fristLogin = false
                GlobalModel.selServerInfo = self.serverList[i]
                break
            else
                self.fristLogin = true
            end
        end
        if self.fristLogin then
            self.curServerId = self.serverList[#self.serverList].service_id
            GlobalModel.selServerInfo = self.serverList[#self.serverList]
        end 
        GlobalModel.curServerId = GlobalModel.selServerInfo.service_id
        GlobalModel.serverCount = self.serverCount
        GlobalModel.serverList = self.serverList
        self.selServerItem = nil
        GlobalModel.platform = jsonData.plat

        if GlobalModel.open_id ~= jsonData.open_id then
            self.fristLogin = true -- 玩家ID不一样，当为第一次登陆
        end
        GlobalModel.open_id = jsonData.open_id
        self:showLabTips(tostring(self.fristLogin).."_")
        if self.fristLogin  then
            GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
        else
            GlobalController.login:connectSocket()
        end
        self.msgLyr:removeAllChildren()
    else
        self.loginView:setVisible(true)
        local tip
        if  jsonData.code == 2 then
            tip = "您的账号已经被封，如有疑问可咨询客服QQ"
        else
            tip = "登陆失败[ERROR:"..jsonData.code.."]"
        end
        --登陆失败
        GlobalAlert:pop({tipTxt = tip,hideBackBtn = true})
    end
end

--第三方登出成功
function LoginScene:setLogoutCallback()
    self:showLabTips("setLogoutCallback_")
    self:showLoginView(true)
end



function LoginScene:onEnter()
    display.addSpriteFrames("common/login/login.plist", "common/login/login.png")
    self:showLabTips("onEnter_")
    self.curServerId = GlobalModel.curServerId or 0
    SoundManager:playMusicByType(SoundType.LOGIN_BG)
    if DEBUG_LOGIN == false then
        if not self.enterGamePanel and not self.creatRolePanel and not self.selRolePanel and not self.selServerPanel and not self.loginView then--这种写法坑
            -- 进入游戏触发公告显示。
            --GlobalController.notice:startSystemNoticeTask()
            self:showLabTips("showLoginView(false)_")
            self:showLoginView(false)
        end
        return
    end

    self.serverList = json.decode(DEBUG_SERVER_LIST)
    table.sort(self.serverList, function (aa,bb)
            if aa.service_id < bb.service_id then  return true
            else  return false
            end
        end)
    table.sort(self.serverList, function (aa,bb)
            if aa.service_id < bb.service_id then  return true
            else  return false
            end
        end)
    self.serverCount = #self.serverList -- 服务器数量

     for i=1,#self.serverList do
            if self.serverList[i].service_id == self.curServerId then
                self.fristLogin = false
                GlobalModel.selServerInfo = self.serverList[i]
                break
            else
                self.fristLogin = true
            end
    end
    if self.fristLogin then 
        self.curServerId = self.serverList[#self.serverList].service_id
         GlobalModel.selServerInfo = self.serverList[#self.serverList]
    end 
    GlobalModel.curServerId = GlobalModel.selServerInfo.service_id
    GlobalModel.serverCount = self.serverCount
    GlobalModel.serverList = self.serverList
    self.selServerItem = nil

    if not self.enterGamePanel and not self.creatRolePanel and not self.selRolePanel and not self.selServerPanel and not self.loginView then
        -- 进入游戏触发公告显示。
        --GlobalController.notice:startSystemNoticeTask()
        self:showLabTips("showDebugAccountPanel()_")
        self:showDebugAccountPanel()
    end

    -- local videoPlayer = ccexp.VideoPlayer:create()
    -- videoPlayer:setPosition(cc.p(display.widthInPixels/2, display.heightInPixels/2))
    -- videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
    -- videoPlayer:setContentSize(cc.size(display.widthInPixels, display.heightInPixels))
    -- videoPlayer:setFileName("res/test.mp4")
    -- videoPlayer:setKeepAspectRatioEnabled(true)
    -- videoPlayer:setFullScreenEnabled(true)
    -- videoPlayer:setVisible(true)
    -- self:addChild(videoPlayer)
    -- videoPlayer:play()

end



--登录界面------------------------------------------------------------------------------

function LoginScene:showLoginView(loginBtnVisible)
    self:showLabTips("showLoginView_")
    self:closeAllPanel()
    local channelId = ChannelAPI:getChannelId()
    if self.loginView == nil then
        self:showLabTips("self.loginView == nil")
        if  channelId == "D6A6806578B689C4" or channelId == "D74620B09C2CD765" then -- 腾讯
            self:initQQLoginView()
        elseif channelId == "1888" and string.sub(channelId, 1, 2) ~= "36" then --自营IOS
            self:initIOSLoginView()
            local loginType = self:getLoginType()
            if "" ~= loginType then --有登陆过自动登陆
                ChannelAPI:loginEx(loginType)
            end
        else
            self:showLabTips("new loginView")

            self.loginView = display.newNode()
            self.mainLay:addChild(self.loginView)
            self.loginView:setPosition(0, 0)
            self.loginBtn =  display.newSprite("#login/login_enter_sel.png")
            self.loginView:addChild(self.loginBtn)
            self.loginBtn:setPosition(display.cx,150)
            self.loginBtn:setTouchEnabled(true)
            self.loginBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                    SoundManager:playClickSound()
                    self.loginBtn:setScale(1.2)
                elseif event.name == "ended" then
                    self.loginBtn:setScale(1)
                    ChannelAPI:login()
                end     
                return true
            end)
        end
    else
        self.loginView:setVisible(true)
    end
    if self.loginBtn ~= nil then
        self.loginView:setVisible(loginBtnVisible)
        self:showLabTips("loginBtnVisible = "..tostring(loginBtnVisible))
        if not loginBtnVisible then
            self:showLabTips("ChannelAPI:login")
            ChannelAPI:login()
        end
    end
end

--保存登陆方式
function LoginScene:saveLoginType(loginType)
    cc.UserDefault:getInstance():setStringForKey("LoginType", loginType)
    cc.UserDefault:getInstance():flush()
end
--获取登陆方式
function LoginScene:getLoginType()
    return cc.UserDefault:getInstance():getStringForKey("LoginType")--默认空字符串

end
--IOS自营登录
function LoginScene:initIOSLoginView()
   self:showLabTips(tostring("initIOSLoginView").."_")
   self.loginView = display.newNode()
   self.mainLay:addChild(self.loginView)
   self.loginView:setPosition(0, 0)
   local padding = (display.width - 248 * 3) / 4
    --游客
    self.guestBtn =  display.newSprite("#login/login_guest.png")
    self.loginView:addChild(self.guestBtn)
    self.guestBtn:setPosition(padding + 124, 150)
    self.guestBtn:setTouchEnabled(true)
    self.guestBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.guestBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.guestBtn:setScale(1)
            self:saveLoginType("Guest")
            ChannelAPI:loginEx("Guest")
        end     
        return true
    end)
    --QQ
    self.qqBtn =  display.newSprite("#login/login_qq.png")
    self.loginView:addChild(self.qqBtn)
    self.qqBtn:setPosition(padding * 3 + 248 * 2 + 124, 150)
    self.qqBtn:setTouchEnabled(true)
    self.qqBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.qqBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.qqBtn:setScale(1)
            self:saveLoginType("Login")
            ChannelAPI:loginEx("Login")
        end     
        return true
    end)
    --微信
    self.wxBtn =  display.newSprite("#login/login_wx.png")
    self.loginView:addChild(self.wxBtn)
    self.wxBtn:setPosition(padding * 2 + 248 + 124, 150)
    self.wxBtn:setTouchEnabled(true)
    self.wxBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.wxBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.wxBtn:setScale(1)
            self:saveLoginType("Loginwx")
            ChannelAPI:loginEx("Loginwx")
        end     
        return true
    end)   
    local val = cc.UserDefault:getInstance():getStringForKey("FirstLogin") 
    if val == "" then
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, require("app.modules.tips.view.AgreementView").new())
    end                                 
    
end
--应用宝平台
function LoginScene:initQQLoginView()
    self:showLabTips(tostring("initQQLoginView").."_")
   self.loginView = display.newNode()
   self.mainLay:addChild(self.loginView)
   self.loginView:setPosition(0, 0)
   local padding = (display.width - 248 * 2) / 3
   --QQ
    self.qqBtn =  display.newSprite("#login/login_qq.png")
    self.loginView:addChild(self.qqBtn)
    self.qqBtn:setPosition(padding * 2 + 248 + 124, 150)
    self.qqBtn:setTouchEnabled(true)
    self.qqBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.qqBtn:setScale(1.2)
        elseif event.name == "ended" then
            self.qqBtn:setScale(1)
            ChannelAPI:loginEx("Login")
        end     
        return true
    end)
    --微信
    self.wxBtn =  display.newSprite("#login/login_wx.png")
    self.loginView:addChild(self.wxBtn)
    self.wxBtn:setPosition(padding + 124, 150)
    self.wxBtn:setTouchEnabled(true)
    self.wxBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            self.wxBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.wxBtn:setScale(1)
            ChannelAPI:loginEx("Loginwx")
        end     
        return true
    end)                                    

end








function LoginScene:closeAllPanel()
    if self.enterGamePanel then
        self.enterGamePanel:close()
    end
    if self.creatRolePanel then
        self.creatRolePanel:close()
    end
    if self.selRolePanel then
        self.selRolePanel:close()
    end
    if self.selServerPanel then
        self.selServerPanel:close()
    end
    if self.accountPanel then
        self.accountPanel:close()
    end

    if self.loginView then
        self.loginView:setVisible(false)
    end
end

function LoginScene:destoryAllPanel()
    if self.enterGamePanel then
        self.enterGamePanel:destory()
        self.enterGamePanel:removeSelf()
        self.enterGamePanel = nil
    end
    if self.creatRolePanel then
        self.creatRolePanel:destory()
        self.creatRolePanel:removeSelf()
        self.creatRolePanel = nil
    end
    if self.selRolePanel then
        self.selRolePanel:destory()
        self.selRolePanel:removeSelf()
        self.selRolePanel = nil
    end
    if self.selServerPanel then
        self.selServerPanel:destory()
        self.selServerPanel:removeSelf()
        self.selServerPanel = nil
    end
    if self.accountPanel then
        self.accountPanel:destory()
        self.accountPanel:removeSelf()
        self.accountPanel = nil
    end
end

--DEBUG帐号登陆
function LoginScene:showDebugAccountPanel()
    self:showLabTips(tostring("showDebugAccountPanel").."_")
    self:closeAllPanel()
    if self.accountPanel == nil then
        self.accountPanel = require("app.login.LoginDebugAccount").new()
        self.mainLay:addChild(self.accountPanel)
    end
    self.accountPanel:open()
end
--进入游戏面板
function LoginScene:showEnterGamePanel()
    self:showLabTips(tostring("showEnterGamePanel").."_")
    self:closeAllPanel()
    if self.enterGamePanel == nil then
        self.enterGamePanel = require("app.login.LoginEnterGame").new()
        self.mainLay:addChild(self.enterGamePanel)
    end
    self.enterGamePanel:open()
end
--选服面板
function LoginScene:showSelServerPanel()
    if self.selServerPanel == nil then
        self.selServerPanel = require("app.login.LoginSelServer").new(GlobalModel.serverCount,GlobalModel.serverList,self)
        self.mainLay:addChild(self.selServerPanel)
    end
    self.selServerPanel:open()
end
--创角面板
function LoginScene:showCreatRolePanel()
    self:closeAllPanel()
    if self.creatRolePanel == nil then
        self.creatRolePanel = require("app.login.LoginCreatRole").new()
        self.mainLay:addChild(self.creatRolePanel)
    end
    self.creatRolePanel:open()
end
--选角面板
function LoginScene:showSelRolePanel()
    self:closeAllPanel()
    if self.selRolePanel == nil then
        self.selRolePanel = require("app.login.LoginSelRole").new()
        self.mainLay:addChild(self.selRolePanel)
    end
    self.selRolePanel:open()
end


function LoginScene:onExit()
    GlobalAlert:destory()
    SoundManager:stopMusic()
    display.removeSpriteFramesWithFile("common/login/login.plist", "common/login/login.png")
    if self.msgShowEventHandler then
        GlobalEventSystem:removeEventListenerByHandle(self.msgShowEventHandler)
        GlobalEventSystem:removeEventListenerByHandle(self.boxShowEventHandler)
        --GlobalEventSystem:removeEventListenerByHandle(self.noticeShowEventHandler)
        self.msgShowEventHandler = nil
        self.boxShowEventHandler = nil
       -- self.noticeShowEventHandler = nil
        GlobalEventSystem:removeEventListener(LoginEvent.LOGIN_SHOW_ENTER)
        GlobalEventSystem:removeEventListener(LoginEvent.LOGIN_SHOW_ACCOUNT)
        GlobalEventSystem:removeEventListener(LoginEvent.LOGIN_SHOW_REGITER) 
        GlobalEventSystem:removeEventListener(LoginEvent.LOGIN_SHOW_SELROLE)  
        GlobalEventSystem:removeEventListener(LoginEvent.LOGIN_SHOW_SELSERVER)
        GlobalEventSystem:removeEventListener(LoginEvent.SELF_LOGIN_VIEW)
    end
    self.msgLyr:removeAllChildren()
    self:destoryAllPanel()
    for i=1,#self.resList do
        display.removeSpriteFrameByImageName(self.resList[i])
    end
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end



function LoginScene:addBackEvent()
  if device.platform == "android" then
    self.mainLay:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        if event.key == "back" then
            local exitFun = function()
                local function enterFun()
                    os.exit()
                end
                GlobalAlert:pop({tipTxt = "确定退出游戏?",enterFun = handler(self, enterFun),alertName = "hasExitGame"})
            end
            if DEBUG_LOGIN then
                exitFun()
            else
                ChannelAPI:exit(exitFun)
            end
        end
    end)
    self.mainLay:setKeypadEnabled(true)
  end 
end








--test -----------------------------------------------------------------------------------------------------------------------------------------------------------


-- function LoginScene:UserSprite()
--     display.addSpriteFrames("model/110/110.plist", "model/110/110.pvr.ccz")
--     display.addSpriteFrames("model/111/111.plist", "model/111/111.pvr.ccz")
--     --local animation = display.newAnimation(self.framesr1, 6 / 60)
--     self.framesr1 = display.newFrames("110".."%03d.png", 211, 6)
--     self.people = {}
--     for i=1,4000 do
--        local sprite = display.newSprite()
--         self:addChild(sprite)
--         sprite:setPosition(math.random(0,1000),math.random(0,600))
--         --sharedSpriteFrameCache:getSpriteFrame(frameName)
--         sprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("110211.png"))
--         table.insert(self.people,sprite)
--     end
--     self.list = {}
--     self.list[211] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110211.png")
--     self.list[212] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110212.png")
--     self.list[213] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110213.png")
--     self.list[214] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110214.png")
--     self.list[215] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110215.png")
--     self.list[216] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110216.png")

--     self.ssss = cc.SpriteFrameCache:getInstance()
--     self.index = 211
--     --sprite:runAction(cc.Animate:create(animation))
--     self.cache = cc.SpriteFrameCache:getInstance()

--     local listenerFun = function()
--         self.index = self.index +1 
--         if self.index > 216 then
--             self.index = 211
--         end

--         if self.index > 216 then
--             self.index = 211
--         end
--         --local frame211 = cc.SpriteFrameCache:getInstance():getSpriteFrame("110"..self.index..".png")
       
--         for i=1,#self.people do
--             local aa = self.index +1
--             if aa > 216 then
--                 aa = 211
--             end
--             local ap = self.people[i]
--             local xx,yy = ap:getPosition()
--             ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))
--             ap:setSpriteFrame(self.list[self.index])
--             --ap:setSpriteFrame(self.ssss:getSpriteFrame("110"..self.index..".png"))
--         end

--     end
--     if self.scheduleTimeId == nil  then
--         self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
--      end
-- end


-- function LoginScene:UserAnimation()
--     display.addSpriteFrames("model/110/110.plist", "model/110/110.pvr.ccz")

--     display.addSpriteFrames("model/111/111.plist", "model/111/111.pvr.ccz")
--     local framess1 = display.newFrames("110".."%03d.png", 111, 4)
--     local framess2 = display.newFrames("110".."%03d.png", 121, 4)
--     local framess3 = display.newFrames("110".."%03d.png", 131, 4)
--     local framess4 = display.newFrames("110".."%03d.png", 141, 4)
--     local framess5 = display.newFrames("110".."%03d.png", 151, 4)

--     self.framesr1 = display.newFrames("110".."%03d.png", 211, 6)
--     self.framesr2 = display.newFrames("110".."%03d.png", 221, 6)
--     self.framesr3 = display.newFrames("110".."%03d.png", 231, 6)
--     self.framesr4 = display.newFrames("110".."%03d.png", 241, 6)
--     self.framesr5 = display.newFrames("110".."%03d.png", 251, 6)

--     local animation = display.newAnimation(self.framesr1, 6 / 60)

--     self.people = {}
--     for i=1,4000 do
--        local sprite = display.newSprite()
--         self:addChild(sprite)
--         sprite:setPosition(math.random(0,1000),math.random(0,600))
--         sprite:playAnimationForever(animation)
--         table.insert(self.people,sprite)
--     end
--     --sprite:runAction(cc.Animate:create(animation))

--     local listenerFun = function()
--         for i=1,#self.people do
--             local ap = self.people[i]
--             local xx,yy = ap:getPosition()
--             ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))
        
--             -- if math.random(0,100)>90 then
--             --     local animation = display.newAnimation(self["framesr"..math.random(1,5)], 6 / 60)
--             --     ap:stopAllActions()
--             --     ap:playAnimationForever(animation)
--             -- end
--         end

--     end
--     if self.scheduleTimeId == nil  then
--         self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
--      end
-- end

function LoginScene:UserMC()

  
    require("common.MCSourceCache")
    MCSourceCache = MCSourceCache.new()
   
    require("app.modules.fight.const.FightUtil")
    require("common.SFMovieClip")
    require("common.testMc")
    --local load = MCSourceCache.new()
    self.bodyList = {110,210,1102,1104,1105,1106,1107,1108,1114,1202,1204,1206,1207,1208,1211,1214,1302,1304,1306,1307,1308,1311,1314,2102,2104,2105,2106,2107,2208,2211,2214,2302,2304,2306,2307,2308,2311,2314}
    self.wingList = {5101,5102,5103,5104,5105,5106,5107,5108,5109,5110,5111,5112,5113}
    self.weapList = {310,311,411,3101,3102,3103,3104,3105,3106,3107,3108,3111,3114,3201,3202,3203,3204,3206,3207,3208,3209,3211,3212,3214,3302,3304,3305,3306,3307,3308,3311,3312,3313,4102,4103,4104,4105,4106,4107,4108,4111,4201,4202,4203,4204,4206,4207,4208,4211,4214,4302,4304,4305,4306,4307,4308,4311,4312}
    self.actList = {"stand","walk","attack"}
    self.people = {}
    for i=1,500 do
       local sprite = testMc.new()
        self:addChild(sprite)
        sprite:setPosition(math.random(50,1000),math.random(10,630))
        --sprite:addNodeEventListener(SFMovieClip.COMPLETE,listenerFun)
        --sharedSpriteFrameCache:getSpriteFrame(frameName)
        tostring(self.bodyList[math.random(1,#self.bodyList)])
        sprite:setModel(tostring(self.bodyList[math.random(1,#self.bodyList)]),tostring(self.wingList[math.random(1,#self.wingList)]),tostring(self.weapList[math.random(1,#self.weapList)]))
        table.insert(self.people,sprite)
    end
    self.cur = 1
    self.index = 211

    local listenerFun = function()
        for i=1,#self.people do
            local ap = self.people[i]
            local xx,yy = ap:getPosition()
            ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))

            ap:setLocalZOrder(10000-yy)

            if math.random(0,1000)>950 then
                ap:setDirect(math.random(1,8))
            end

            if math.random(0,1000)>950 then
                ap:setAction(self.actList[math.random(1,#self.actList)])
            end
        end
    end
    if self.scheduleTimeId == nil  then
        self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
     end
    











     local btnQQFriend = display.newSprite("#login/qq1.png")
    -- local filter = filter.newFilter("GRAY")
    -- filter:initSprite(nil)
    -- btnQQFriend:setGLProgramState(filter:getGLProgramState()) --使用
    -- btnQQFriend:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")) --清除

    self:addChild(btnQQFriend)
    btnQQFriend:setAnchorPoint(0.5,0.5)
    btnQQFriend:setPosition(display.width/4 * 3,0)
    btnQQFriend:setTouchEnabled(true)
    btnQQFriend:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then

            for i=1,10 do
               local sprite = testMc.new()
                self:addChild(sprite)
                sprite:setPosition(math.random(50,1000),math.random(10,630))
                --sprite:addNodeEventListener(SFMovieClip.COMPLETE,listenerFun)
                --sharedSpriteFrameCache:getSpriteFrame(frameName)
                tostring(self.bodyList[math.random(1,#self.bodyList)])
                sprite:setModel(tostring(self.bodyList[math.random(1,#self.bodyList)]),tostring(self.wingList[math.random(1,#self.wingList)]),tostring(self.weapList[math.random(1,#self.weapList)]))
                table.insert(self.people,sprite)
            end
        end     
        return true
    end)





    if true then return end


    -- self.aaa = "AAAA"

    -- local listenerFun = function(textureId,type)
    --     print(self.aaa)
    --     print(self.aaa,textureId,type)
    -- end

    -- local listener = function(data)
    --     dump(data)
    -- end



    -- load:addEventListener(MCSourceCache.LOADCOMPLETE, listener)
    -- load:load("110",0,listenerFun)

    -- load:load("111",0,listenerFun)
    self.people = {}
    for i=1,3000 do
       local sprite = SFMovieClip.new()
        self:addChild(sprite)
        sprite:setPosition(math.random(50,1000),math.random(10,630))
        --sprite:addNodeEventListener(SFMovieClip.COMPLETE,listenerFun)
        --sharedSpriteFrameCache:getSpriteFrame(frameName)
        sprite:goPlayAction("110","walk_1",true,0.1)
        table.insert(self.people,sprite)
    end
    self.cur = 1
    self.index = 211

    local listenerFun = function()
        self.index = self.index +1 
        if self.index > 216 then
            self.index = 211
        end

        if self.index > 216 then
            self.index = 211
        end
        self.cur = self.cur +1
        if self.cur > 6 then
            self.cur = 1
        end
        
        for i=1,#self.people do
            local ap = self.people[i]
            local xx,yy = ap:getPosition()
            ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))
            if math.random(0,1000)>970 then
            ap:goPlayAction("110","walk_"..math.random(1,5),true,0.1)
            end
        end
    end
    if self.scheduleTimeId == nil  then
        self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
     end
    




    if true then return end

    display.addSpriteFrames("model/110/110.plist", "model/110/110.pvr.ccz")
    display.addSpriteFrames("model/111/111.plist", "model/111/111.pvr.ccz")
    --local animation = display.newAnimation(self.framesr1, 6 / 60)
    self.framesr1 = display.newFrames("110".."%03d.png", 211, 6)
    self.framesr2 = display.newFrames("111".."%03d.png", 211, 6)

    self.list = {}
    self.list[211] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110211.png")
    self.list[212] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110212.png")
    self.list[213] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110213.png")
    self.list[214] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110214.png")
    self.list[215] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110215.png")
    self.list[216] = cc.SpriteFrameCache:getInstance():getSpriteFrame("110216.png")

    self.people = {}
    for i=1,4000 do
       local sprite = SFMovieClip.new()
        self:addChild(sprite)
        sprite:setPosition(math.random(0,1000),math.random(0,600))
        --sprite:addNodeEventListener(SFMovieClip.COMPLETE,listenerFun)
        --sharedSpriteFrameCache:getSpriteFrame(frameName)
        if math.random(0,1000)>-10 then
            sprite:setSpriteFrameArr(self.framesr1)
        else
            sprite:setSpriteFrameArr(self.framesr2)
        end
        sprite:gotoAndPlay(1,true,nil,nil,nil)
        table.insert(self.people,sprite)
    end
    self.cur = 1
    self.index = 211

    local listenerFun = function()
        self.index = self.index +1 
        if self.index > 216 then
            self.index = 211
        end

        if self.index > 216 then
            self.index = 211
        end
        self.cur = self.cur +1
        if self.cur > 6 then
            self.cur = 1
        end
        
        for i=1,#self.people do
            local ap = self.people[i]
            local xx,yy = ap:getPosition()
            ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))
            --ap.currentFrame = self.cur
            --ap:step()
            --ap:setSpriteFrame(self.list[self.index])
            --ap:setCurrentFrame(self.cur)
            --ap:step2(self.cur)
        end
    end
    if self.scheduleTimeId == nil  then
        self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
     end
end


return LoginScene
-- function LoginScene:UserArmature()
--     ArmatureManager:getInstance():loadModel(110)
--     self.people = {}
--     for i=1,1000 do
--        local sprite = ccs.Armature:create(110)
--         self:addChild(sprite)
--         sprite:setPosition(math.random(0,1000),math.random(0,600))
--         sprite:stopAllActions()
--         sprite:getAnimation():play("walk_1")
       
--         table.insert(self.people,sprite)
--     end

--     local listenerFun = function()
--     -- self.index = self.index +1 
--     --     if self.index > 216 then
--     --         self.index = 211
--     --     end

--     --     if self.index > 216 then
--     --         self.index = 211
--     --     end
--     --     self.cur = self.cur +1
--     --     if self.cur > 6 then
--     --         self.cur = 1
--     --     end
--         --self.index = self.index +1 
--         for i=1,#self.people do
--             local ap = self.people[i]
--             local xx,yy = ap:getPosition()
--             ap:setPosition(xx+math.random(-2,2),yy+math.random(-2,2))
--             --ap.currentFrame = self.cur
--             --ap:update()
--              --ap:setSpriteFrame(self.list[self.index])
--         end
--     end
--     if self.scheduleTimeId == nil  then
--         self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,0.1)
--      end

-- end
