--
-- Author: zhangshunqiu
-- Date: 2015-02-09 17:41:46
-- 训练窗口
local TrainWin = class("TrainWin", BaseView)

function TrainWin:ctor(winTag,data,winconfig)
	TrainWin.super.ctor(self,winTag,data,winconfig)

    self.colorBg = display.newRect(cc.rect(0, 0, display.width,display.height - 10),
                {fillColor = display.BG_COLOR_WHITE, borderColor = display.BG_COLOR_GREEN, borderWidth = 0})
    self:addChild(self.colorBg)

    self.gameLay = display.newNode()
    self:addChild(self.gameLay)
    self.gameLay:setPosition(0,0)

    self.isCancelRemoveSpriteFrams = true
    
	-- local title = display.newTTFLabel({
 --    	text = "其他页面",
 --    	-- font = "Arial",
 --    	size = 30,
 --    	color = display.COLOR_WHITE,
 --    	-- align = cc.TEXT_ALIGNMENT_LEFT,
 --    	-- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
 --    	-- dimensions = cc.size(400, 200)    
	-- })
	-- title:setTouchEnabled(false)
	-- title:setPosition(display.width/2,display.height/2)
	-- self:addChild(title)
end

--打开
function TrainWin:open(data)
    -- local callback = function ()
    --     GlobalWinManger:openWin(WinName.FIGHTOVER)
    --     GlobalWinManger:closeWin(WinName.FIGHT)
    -- end

    -- local bottomSequence = transition.sequence({
    --                 -- cc.MoveTo:create(0.5, cc.p(0, 0)),
    --                 -- cc.FadeOut:create(0.2),
    --                 cc.DelayTime:create(1.5),
    --                 -- cc.FadeIn:create(0.3),
    --                 cc.CallFunc:create(callback),
    --                 })   
    -- self:runAction(bottomSequence)

    local onSingleGameOver = function(data)
        local tipStr = "正确次数："..data.data.rightCount.."<br>/n".."错误次数："..data.data.errorCount
        --{gameId = self.gameID, beginTime = self.beginTime,rightCount = self.rightNum,errorCount = self.wrongNum}
        GlobalMessage:alertTips({title = "标题",tipText = tipStr,backFun = handler(self,self.gameOver)})
        
    end

    local onSingleUpdateScore = function(data)    
        local totalScore = data.data.total        
    end

    GlobalEventSystem:addEventListener(FightEvent.SINGLE_GAME_OVER,onSingleGameOver)
    GlobalEventSystem:addEventListener(FightEvent.SINGLE_UPDATE_SCORE,onSingleUpdateScore)

    self:playGame()
end

function TrainWin:gameOver()
    self.gameLay:removeChild(self.curGame)
    GlobalWinManger:openWin(WinName.FIGHTOVER)
    GlobalWinManger:closeWin(WinName.FIGHT)
    self.curGame = nil
end    

function TrainWin:playGame()    
    self.curGame = require("app.scenes.DJSKScene").new()
    --self.curGame:onEnter()
    self.gameLay:addChild(self.curGame)
    
    self.gameTime = 21
    self.endTime = socket.gettime()+self.gameTime
end    

--关闭
function TrainWin:close()
    GlobalEventSystem:removeEventListener(FightEvent.SINGLE_GAME_OVER)
    GlobalEventSystem:removeEventListener(FightEvent.SINGLE_UPDATE_SCORE)   
    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end 
end 

--销毁
function TrainWin:destory()
    self:close()
    self.super.destory(self)
end

return TrainWin