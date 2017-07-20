
require("config")
require("cocos.init")
require("framework.init")
require("app.utils.NodeExEx")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    if jit then
        print("Use jit ========>",jit.status())
    end
    
    --display.DEFAULT_TTF_FONT = nil
    local addSrc = cc.FileUtils:getInstance():getWritablePath().."src/"
    local addRes = cc.FileUtils:getInstance():getWritablePath().."res/"
    local platform = device.platform
    if platform == "ios" or platform == "android" then
        cc.FileUtils:getInstance():addSearchPath("src/", true)
    end
    cc.FileUtils:getInstance():addSearchPath("res/resui/", true)
    cc.FileUtils:getInstance():addSearchPath("res/", true)
    if platform == "ios" or platform == "android" then
        cc.FileUtils:getInstance():addSearchPath(addSrc, true)
    end
    cc.FileUtils:getInstance():addSearchPath(addRes.."resui/", true)
    cc.FileUtils:getInstance():addSearchPath(addRes, true)
    
     if device.platform == "ios" then
        GAME_FRAME_RATE = 60        
    end
    --dump(cc.FileUtils:getInstance():getSearchPaths())
    cc.Director:getInstance():setAnimationInterval(1 / GAME_FRAME_RATE)
    cc.net = import(cc.PACKAGE_NAME .. ".cc.net.init")

    if device.platform ~= "ios" and device.platform ~= "android" then
        self:GameStart()
        return
    end
    --self:GameStart()
    self:enterUpdateScene({self})
end

--进入更新场景
function MyApp:enterUpdateScene(args,transitionType, time, more)
    local scenePackageName = "common.update.UpdateScene"
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    display.replaceScene(scene, transitionType, time, more)
end

function MyApp:GameStart()
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)--cocos的Cocos2dConstants与framework的Cocos2dConstants  
    require("app.init")
    require("app.utils.osEx")
    require("app.const.GlobalEvent")
    require("app.const.GlobalConst")
    require("app.const.GlobalErrorCode")
    require("common.base.BaseController")
    require("common.base.BaseManager")
    require("common.base.BaseView")
    require("app.modules.GameModel")
  
    require("common.loadPackage.LoadingPackageManager")
    require("app.modules.sysOption.model.SysOptionModel")
    require("app.conf.init")
    require("app.utils.ArmatureDataManagerEx")
    require("app.utils.ResUtil")

    configHelper = require("app.utils.ConfigHelper").getInstance()
    SoundManager = SoundManager or require("common.gamesound.SoundManager").new()-->需要SysOptionModel
    GlobalModel = GlobalModel or GameModel.new() --全局Model

    GameSceneModel = GameSceneModel or require("app.gameScene.model.SceneModel").new()

    GameNet = GameNet or require("common.socket.CQGameSocket").new() --全局游戏网络
    GlobalEventSystem = GlobalEventSystem or require("common.event.EventSystem").new() --全局事件
    GlobalTimer = GlobalTimer or require(cc.PACKAGE_NAME .. ".scheduler")--require("app.com.timer.GameTimer") --全局计时器
    ChannelAPI = ChannelAPI or require("common.channel.ChannelApiHelper").new()
    GlobalWinManger = GlobalWinManger or require("app.com.manager.WinManager").new()
    require("app.modules.MainController")
    LoadingPackageManager:ctor()
    --提示
    GlobalAlert = GlobalAlert or require("common.alert.GlobalAlert").new()
    GlobalMessage = GlobalAlert
   
    SysOptionModel:ctor() -->需要FightModel->FightController->MainController
    require("app.modules.functionOpen.FunctionOpenManager")
    FunctionOpenManager:ctor()
    --ShowTipsManager = require("app.modules.tips.ShowTipsManager"):getInstance()
    SystemNotice = SystemNotice or require("app.com.systemNotice.SystemNoticeManager"):getInstance()
    --统计接口
    GlobalAnalytics = GlobalAnalytics or require("app.analytics.TalkingData").new()
 
    ResUtil.setResFormat()
    
    --ChatAPI = ChatAPI or require("app.modules.chat.model.YTXChatAPI").new()
    GlobalController = GlobalController or MainController.new(self) --全局主控制器
    GlobalController:playGame()
end


function MyApp:exit()
    MyApp.super.exit(self)
    ChannelAPI:destoryLua();
end

function MyApp:onEnterBackground()
    --print("MyApp:onEnterBackground")
    if not GlobalModel then
        return
    end
    GlobalModel.isForeground = false
    MyApp.super.onEnterBackground(self)
    -- if GlobalModel.isPaying then
    --     GlobalModel.showDisconnectTip = false
    --     GameNet:disconnect()
    --     GlobalModel.isPaying = false
    -- else
        GlobalTimer.performWithDelayGlobal(function(event)
        --print("MyApp:onEnterBackground:GlobalTimer"..GlobalModel.isForeground)
            if GlobalModel.isForeground == false then
                GameNet:disconnect()
            end
        end ,60)--1分钟断线
    --end

    
    
end

function MyApp:onEnterForeground()
    if not GlobalModel then
        return
    end
    --print("MyApp:onEnterForeground")
    GlobalModel.isForeground = true
    MyApp.super.onEnterForeground(self)
    if GlobalModel:getIsConnect() == false then
        GlobalController.login:connectSocket()
    end
end

return MyApp
