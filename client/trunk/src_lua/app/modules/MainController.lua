--
-- Author: 21102585@qq.com
-- Date: 2014-11-04 18:25:24
-- 游戏主控制器
require("app.scenes.MainScene")
require("app.scenes.LoginScene")

require("app.modules.errorCode.ErrorCodeManager")
require("app.modules.BtnTipManager")
require("app.modules.fight.manager.ArmatureManager")

require("app.modules.role.RoleController")
require("app.modules.bag.BagController")
require("app.modules.social.SocialController")
require("app.modules.tips.NoticeController")
require("app.modules.store.StoreController")
require("app.modules.chat.ChatController")
require("app.modules.trade.TradeController")
require("app.modules.guild.GuildController")
require("app.modules.skill.controller.SkillController")
require("app.modules.fight.controller.ModelController")
require("app.modules.fight.controller.FightController")
require("app.gameScene.controller.SceneController")
require("app.login.LoginController")
require("app.modules.storage.StorageController")
require("app.modules.dailyTask.controller.DailyTaskController")
require("app.modules.team.TeamController")
require("app.modules.maya.controller.MayaController")
require("app.modules.shabake.controller.ShaBaKeController")
require("app.modules.qualifying.QualifyingController")
require("app.modules.copy.controller.CopyController")
require("app.modules.dailyTask.controller.TaskController")
require("app.modules.guide.GuideController")
require("app.modules.worship.controller.WorShipController")
require("app.modules.medalUp.MedalUpController")
require("app.modules.equip.EquipController")
require("app.modules.vip.VipController")
require("app.modules.activity.ActivityController")
require("app.modules.activity.HolidayActivityController")
require("app.modules.recharge.RechargeController")
require("app.modules.downloadReward.DLRewardController")
require("app.modules.welfare.WelfareController")
require("app.modules.sign.SignController")
require("app.modules.exChange.controller.ExchangeController")
require("app.modules.darkHouse.controller.DarkHouseController")
require("app.modules.dragon.controller.DragonController")
require("app.modules.winner.controller.WinnerController")
require("app.modules.buff.BuffController")
require("app.modules.luckTurnPlate.LuckTurnPlateController")
require("app.modules.luckTurnPlate2.LuckTurnPlate2Controller")
require("app.modules.invest.InvestController")
require("app.modules.luckDraw.LuckDrawController") 
require("app.modules.treasure.TreasureController") 
require("app.modules.changLine.ChangLineController")
require("app.modules.secure.SecureController")
require("app.modules.monsterAttack.MonsterAttackController")
require("app.modules.answeringSystem.AnsweringController")
require("app.modules.business.BusinessController")
require("app.modules.worldBoss.BossController")
require("app.modules.interService.InterServiseController")
require("app.modules.mergeActivity.controller.MergeActivityController")
require("app.modules.oneTimes.OneTimesController")
require("app.modules.shenghuangmj.ShengHuangMJController")
require("app.modules.union.UnionController")
require("app.modules.gvg.GvgController")
require("app.modules.dreamland.DreamlandController")

SCENE_LOADING = 0
SCENE_LOGIN = 1
SCENE_MAIN = 2
SCENE_UPDATE = 3

MainController = MainController or class("MainController",BaseController)

function MainController:ctor(app)
  self.app          = app
  self.curScene     = SCENE_LOADING
  self.errorManager = ErrorCodeManager:getInstance()
  self.sceneEventId = self:addEventListener(GlobalEvent.SCENE_SWITCH, handler(self, self.onSceneSwitch))
  self.curServer    = nil
  ArmatureManager:getInstance()
  -- 各模块控制器初始化
  self.skill      = SkillController.new()
  self.fight      = FightController.new()
  self.gameSceneCtrl      = SceneController.new()
  GameSceneCtrl = self.gameSceneCtrl
  self.model      = ModelController.new()
  self.login      = LoginController.new()
  self.role       = RoleController.new()
  self.bag        = BagController.new()
  self.social     = SocialController.new()
  self.guild      = GuildController.new()
  self.store      = StoreController.new()
  self.chat       = ChatController.new()
  self.trade      = TradeController.new()
  self.notice     = NoticeController.new()
  self.storage    = StorageController.new()
  self.dailyTask  = DailyTaskController.new()
  self.team       = TeamController.new()
  self.maya       = MayaController.new()
  self.qualifying = QualifyingController.new()
  self.copy = CopyController.new()
  self.task = TaskController.new()
  self.guide = GuideController.new()
  self.worship = WorShipController.new()
  self.medalUp = MedalUpController.new()
  self.equip = EquipController.new()
  self.vip = VipController.new()
  self.activity = ActivityController.new()
  self.recharge = RechargeController.new()
  self.dlReward = DLRewardController.new()
  self.welfare = WelfareController.new()
  self.sign = SignController.new()
  self.exchange = ExchangeController.new()
  self.darkHouse = DarkHouseController.new()
  self.dragon = DragonController.new()
  self.winner = WinnerController.new()
  self.buff = BuffController.new()
  self.luckTurnPlate = LuckTurnPlateController.new()
  self.luckTurnPlate2 = LuckTurnPlate2Controller.new()
  self.invest = InvestController.new()
  self.luckDraw = LuckDrawController.new()
  self.treasure = TreasureController.new()
  self.changLine = ChangLineController.new()
  self.SecureController = SecureController.new()
  self.monsterAttack = MonsterAttackController.new()
  self.answeringController = AnsweringController.new()
  self.business = BusinessController.new()
  self.boss = BossController.new()
  self.interServise = InterServiseController.new()
  self.wingUp = require("app.modules.wingUp.WingUpController").new()
  self.holiday = HolidayActivityController.new()
  self.mergeActivity = MergeActivityController.new()
  self.onetimes = OneTimesController.new()
  self.shenghuang = ShengHuangMJController.new()
  self.guildUnion = UnionController.new()
  self.gvg = GvgController.new()
  self.dreamland = DreamlandController.new()
 
  self.batteryMonitor = require("app.gameui.statusBar.BatteryMonitor").new()
  self.networkMonitor = require("app.gameui.statusBar.NetworkMonitor").new()

  ShaBaKeController:ctor()
  BtnTipManager:ctor()
end

--[[
  {{GLOBAL EVENT HANDLER}}
  全局事件处理 - 场景切换。
]]
function MainController:onSceneSwitch(data)
  local requireScene = data.data
  local sceneName = requireScene
  local sceneFlag = requireScene

  if requireScene == SCENE_LOADING then    
    sceneName = "LoadingScene"
    local scenePackageName = "common.loadPackage.LoadingScene"
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    display.replaceScene(scene, transitionType, time, more)

  elseif requireScene == SCENE_LOGIN then
      sceneName = "LoginScene"
      self.app:enterScene(sceneName)
  elseif requireScene == SCENE_MAIN then
      sceneName = "MainScene"
      self.app:enterScene(sceneName)
  elseif requireScene == SCENE_UPDATE then
      sceneName = "UpdateScene"
      local scenePackageName = "common.update.UpdateScene"
      local sceneClass = require(scenePackageName)
      local scene = sceneClass.new(unpack(checktable(args)))
      display.replaceScene(scene, transitionType, time, more)
  end
  self.curScene = sceneFlag
end

function MainController:getScene()
	return self.curScene
end

function MainController:playGame()
  -- if DEBUG_LOGIN == false then
  --     ChannelAPI:setLoginCallbackHandler(handler(self,self.setLoginCallback))
  --     ChannelAPI:setLogoutCallbackHandler(handler(self,self.setLogoutCallback))
  -- end
  GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)	--SCENE_LOGIN)--
end

--第三方登陆成功
function MainController:setLoginCallback(data)
    local  jsonData = json.decode(data.ret)
    if self.curScene == SCENE_LOGIN then
        if jsonData.code == 1 then
            local curServerId = GlobalModel.curServerId or 0
            local serverList = jsonData.service_list
            table.sort(serverList, function (aa,bb)
                if aa.service_id < bb.service_id then  return true
                else  return false
                end
            end)
            table.sort(serverList, function (aa,bb)
                if aa.service_id < bb.service_id then  return true
                else  return false
                end
            end)

            local serverCount = #serverList -- 服务器数量
            if serverCount == 0 then
                GlobalAlert:pop({tipTxt = "游戏区服暂未开放，请稍后再试！",hideBackBtn = true})
                return
            end
            local fristLogin = false
            for i=1,#serverList do
                if serverList[i].service_id == curServerId then
                    fristLogin = false
                    GlobalModel.selServerInfo = serverList[i]
                    break
                else
                    fristLogin = true
                end
            end
            if fristLogin then 
                curServerId = serverList[#serverList].service_id
                GlobalModel.selServerInfo = serverList[#serverList]
            end 
            GlobalModel.curServerId = GlobalModel.selServerInfo.service_id
            GlobalModel.serverCount = serverCount
            GlobalModel.serverList = serverList
            GlobalModel.platform = jsonData.plat
            if GlobalModel.open_id ~= jsonData.open_id then
                fristLogin = true -- 玩家ID不一样，当为第一次登陆
            end
            GlobalModel.open_id = jsonData.open_id
            if fristLogin  then
                GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
            else
                GlobalController.login:connectSocket()
            end
        else
            --self.loginView:setVisible(true)
            local tip
            if  jsonData.code == 2 then
                tip = "您的账号已经被封，如有疑问可咨询客服QQ"
            else
                tip = "登陆失败[ERROR:"..jsonData.code.."]"
            end
            --登陆失败
            GlobalAlert:pop({tipTxt = tip,hideBackBtn = true})
        end
    elseif self.curScene == SCENE_MAIN  then
        if jsonData.code == 1 then
            if GlobalModel.open_id ~= jsonData.open_id then
                GlobalModel.open_id = jsonData.open_id
                GlobalController.login:connectSocket()
                GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
            end
        else
            GlobalEventSystem:dispatchEvent(GlobalEvent.SCENE_SWITCH,SCENE_LOGIN)
        end
    end
end

--第三方登出成功
function MainController:setLogoutCallback()
    if self.curScene == SCENE_LOGIN then
        GlobalEventSystem:dispatchEvent(LoginEvent.SELF_LOGIN_VIEW,true)
    elseif self.curScene == SCENE_MAIN  then
        GameNet:sendMsgToSocket(10007,{flag=2})
    end
end



function MainController:addBackEvent()
  if device.platform == "android" then
    self.main:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
        if event.key == "back" then
            local exitFun = function()
                local function enterFun()
                    os.exit()
                end
                GlobalMessage:alert({
                    enterTxt = "确定",
                    backTxt= "取消",
                    tipTxt = "是否确定退出游戏?",
                    enterFun = handler(self, enterFun),
                    tipShowMid = true,
                })
            end
            if DEBUG_LOGIN then
                exitFun()
            else
                ChannelAPI:exit(exitFun)
            end
        end
    end)
    self.main:setKeypadEnabled(true)
  end 
end

--执行加载更新包功能
function MainController:playLoading()
end


function MainController:destory()

end