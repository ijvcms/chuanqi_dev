--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-03-23 17:44:48
-- 游戏开始介绍界面
local GameBeginView = class("GameBeginView", function()
	return display.newNode()
end)

function GameBeginView:ctor(width,height,parent,gameId,gameType,platform)
	self.gameId = gameId
	self.width = width
	self.height = height
	self.parent = parent
    self.platform = platform
    self.gameType = gameType	

    self.isMouseEnable = true

    self.bg =  cc.LayerColor:create(cc.c4b(142,142,142,255))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(self.width, self.height)
    self.bg:setTouchEnabled(true)
    self.bg:setTouchSwallowEnabled(true)
    self:addChild(self.bg)
    
	self.pic = "game/img_tip_game_1.png"
    local curGameConfig = GameBaseConfig[self.gameId]
    if curGameConfig then
        self.pic = curGameConfig.introPic
    end
	self.instructionPic = display.newScale9Sprite("game/pic_round_rect3.png", 0, 0,cc.size(520,562))
    self:addChild(self.instructionPic)
    self.instructionPic:setPosition(self.width/2,self.height/2 + 60)

    self.gameTipPic = display.newSprite(self.pic)
    self.instructionPic:addChild(self.gameTipPic)
    local size = self.gameTipPic:getContentSize()
    self.gameTipPic:setPosition(520/2, 562- (size.height/2))--562- (size.height/2) - 50

	self.gameTime = 0 --游戏时间
    local introTime = 0  --显示介绍时间

    local gameRules = display.newTTFLabel({
            text = "游戏规则",       
            size = 36,
            color = cc.c3b(255, 255, 255), 
          })
    gameRules:setTouchEnabled(false) 
    self:addChild(gameRules)
    gameRules:setPosition(self.width/2,self.height/2 + 60 + 281+30)

    if GameType.PVP == self.gameType then  
        if self.scheduleId then 
            GlobalTimer.unscheduleGlobal(self.scheduleId)
        end           
        self.instructionPic:setPosition(self.width/2,self.height/2)
        gameRules:setPosition(self.width/2,self.height/2 + 281 +30)
        self.scheduleId = GlobalTimer.scheduleGlobal(handler(self,self.onClose), 5)
        introTime = 5
        self.gameTime = 20
    elseif GameType.TRAIN == self.gameType then
        introTime = 0
        self.gameTime = 20
    	self.enterBtn = display.newScale9Sprite("game/btn_white.png", 0, 0, cc.size(333, 93))
    	self.enterBtn:setColor(cc.c3b(217, 108, 87))  	
      	self.enterBtn:setTouchEnabled(true)	
      	self:addChild(self.enterBtn)
      	self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)			
            if event.name == "began" then            	
                self.enterBtn:setScale(1.2)
            elseif event.name == "ended" then            	
                self.enterBtn:setScale(1)
                if self.isMouseEnable then
                    self.isMouseEnable = false
                    self:onClose()
                end
            end  

            return true
        end)
      	local tryAgainLab = display.newTTFLabel({
        	text = "开 始",    	
        	size = 40,
        	color = cc.c3b(255, 255, 255), 
    	  })
    	tryAgainLab:setTouchEnabled(false)	
    	tryAgainLab:setPosition(333/2,93/2)
    	self.enterBtn:addChild(tryAgainLab)
        local yy = self.height/2 - size.height/2-10
        if yy < 100 then 
            yy = 100
        end
    	self.enterBtn:setPosition((self.width + size.width - 333-68)/2,yy)

        self.backBtn = display.newScale9Sprite("game/btn_trainBack.png", 0, 0, cc.size(93, 93))
        self.backBtn:setTouchEnabled(true) 
        self:addChild(self.backBtn)
        self.backBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
            if event.name == "began" then               
                self.backBtn:setScale(1.2)
            elseif event.name == "ended" then               
                self.backBtn:setScale(1)
                if self.isMouseEnable then
                    --self.isMouseEnable = false
                    local enterFun = function()
                        if self.tips then
                            self.tips:setVisible(false)
                        end
                        --self:onClose()
                    end
                    local backFun = function()
                        --self.isMouseEnable = false
                        self:callFuntion("GameOut","{\"type\":train}")
                        if self.tips then
                            self.tips:setVisible(false)
                        end
                    end
                    backFun()
                    -- local p  = {enterTxt = "继续训练",backTxt="退出",tipTxt = "",enterFun = handler(self, enterFun),backFun = handler(self, backFun)}
                    -- if self.tips == nil then
                    --     self.tips = require("app.gameui.AlertTips").new(p)
                    --     self:addChild(self.tips)
                    -- end
                    -- self.tips:show("  你确定要退出训练吗？")
                    -- self.tips:setVisible(true)

                end
            end  

            return true
        end)
        self.backBtn:setPosition((self.width-size.width +93+68)/2,yy)
    end      
    
    self:callFuntion("GameBegan","{\"time\":"..introTime.."}") 
end

function GameBeginView:callFuntion(key,param)  
    local platform = self.platform
    if platform == PlatformType.ios or platform == PlatformType.android then
        cc.CBrigde:callFuntion(key,param)
    elseif platform == PlatformType.windows or platform == PlatformType.mac  then
        
    end
end

function GameBeginView:onClose()  
    if self.scheduleId then 
        GlobalTimer.unscheduleGlobal(self.scheduleId)
    end 
    
    self:callFuntion("GameBegan","{\"time\":"..self.gameTime.."}")

    if self.parent then 
        ---self.enterBtn:setTouchEnabled(false)
        self.parent:setGameOverTimeOut(self.gameTime)
        self.parent:onGameStart()
        self:setVisible(false)
        self.parent:removeChild(self)
    end
end    

return GameBeginView