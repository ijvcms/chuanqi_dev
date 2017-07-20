--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-03-20 16:34:33
-- 训练结束面板

local TrainOverView = class("TrainOverView", function()
	  return display.newNode()
end)

function TrainOverView:ctor(width,height,parent,platform)
	self.parent = parent
	self.width = width
	self.height = height
    self.platform = platform

    local yy = (700 -self.height) /2 
    if yy > 0 then 
        yy = 0
    end
    self.resList={
        [1] = "game/pic_pub_line.png",
        [2] = "game/btn_yellow.png",
    }
	if self.bg == nil then
	  	self.bg = display.newColorLayer(cc.c4b(240,240,240,255))
	  	self.bg:setContentSize(self.width, self.height)
	  	self.bg:setTouchEnabled(true)
	  	self:addChild(self.bg)
  	end
    self.containerW = self.width
    self.containerH = self.height
    self.container = display.newNode()
    self:addChild(self.container)
    self.container:setPosition(0,0)
    local lab1 = display.newTTFLabel({
        text = "本次得分",      
        size = 26,
        color = cc.c3b(73, 73, 73),  
        -- align = cc.TEXT_ALIGNMENT_LEFT,     
        -- dimensions = cc.size(600, 60)      
    })
    self.container:addChild(lab1)
    lab1:setPosition(self.containerW/2,self.containerH - 12+yy)

    local font = "number/pic_num_yellow.fnt"
    self.labScore = display.newBMFontLabel({
        text = "0",
        font = font,
        color = cc.c3b(73, 73, 73),  
    })
    -- self.labScore:setColor(cc.c3b(73, 73, 73))
    self.container:addChild(self.labScore)
    self.labScore:setPosition(self.containerW/2,self.containerH - 60 - 12+yy)

    local data = {percent = 0,bgColor = cc.c3b(195, 195, 195),bgImage = "game/pic_circle_frame.png",barColor = cc.c3b(217, 108, 87),barImage = "game/pic_circle_frame.png",scale = 1}
    self.circleBar = require("app.gameui.CircleProgressBar").new(data)
    self.container:addChild(self.circleBar)
    self.circleBar:setPosition(self.containerW/2,self.containerH - 260+yy)

    local lab2 = display.newTTFLabel({
        text = "正确率",      
        size = 26,
        color = cc.c3b(73, 73, 73),  
        -- align = cc.TEXT_ALIGNMENT_LEFT,     
        -- dimensions = cc.size(600, 60)      
    })
    self.container:addChild(lab2)
    lab2:setPosition(self.containerW/2,self.containerH - 260 + 35+yy)

    self.rightPrecentLab = display.newTTFLabel({
        text = "0",      
        size = 70,
        color = cc.c3b(73, 73, 73),  
        -- align = cc.TEXT_ALIGNMENT_LEFT,     
        -- dimensions = cc.size(600, 60)      
    })
    self.container:addChild(self.rightPrecentLab)
    self.rightPrecentLab:setPosition(self.containerW/2,self.containerH - 260-10+yy)

    local dd = -40+yy
    if 485+150-self.containerH > -40 then
        dd = 485+150-self.containerH+yy
    end
    local lab3 = display.newTTFLabel({
        text = "错误答案",      
        size = 26,
        color = cc.c3b(73, 73, 73),      
    })
    self.container:addChild(lab3)
    lab3:setPosition(self.containerW/3/2,self.containerH - 430+dd)

    local lab4 = display.newTTFLabel({
        text = "正确答案",      
        size = 26,
        color = cc.c3b(73, 73, 73),      
    })
    self.container:addChild(lab4)
    lab4:setPosition(self.containerW/3+self.containerW/3/2,self.containerH - 430+dd)

    local lab5 = display.newTTFLabel({
        text = "平均作答时间",   
        size = 26,
        color = cc.c3b(73, 73, 73),     
    })
    self.container:addChild(lab5)
    lab5:setPosition(self.containerW*2/3+self.containerW/3/2,self.containerH - 430+dd)

    local line1 = display.newScale9Sprite(self.resList[1], 0, 0, cc.size(70, 1))
    line1:setPosition(self.containerW/3,self.containerH - 483+dd)
    line1:setRotation(90)
    self.container:addChild(line1)

    local line2 = display.newScale9Sprite(self.resList[1], 0, 0, cc.size(70, 1))
    line2:setPosition(self.containerW*2/3,self.containerH - 483+dd)
    line2:setRotation(90)
    self.container:addChild(line2)


    self.errorNumLab = display.newTTFLabel({
        text = "0",      
        size = 50,
        color = cc.c3b(101, 170, 223),      
    })
    self.container:addChild(self.errorNumLab)
    self.errorNumLab:setPosition(self.containerW/3/2,self.containerH - 485+dd)

    self.rightNumLab = display.newTTFLabel({
        text = "0",      
        size = 50,
        color = cc.c3b(71, 187, 124),      
    })
    self.container:addChild(self.rightNumLab)
    self.rightNumLab:setPosition(self.containerW/3+self.containerW/3/2,self.containerH - 485+dd)

    self.answerTimeLab = display.newTTFLabel({
        text = "0s",   
        size = 50,
        color = cc.c3b(240, 183, 91),     
    })
    self.container:addChild(self.answerTimeLab)
    self.answerTimeLab:setPosition(self.containerW*2/3+self.containerW/3/2,self.containerH - 485+dd)


    self.tryAgainBtn = display.newScale9Sprite(self.resList[2], 0, 0, cc.size(333, 93))
    -- self.tryAgainBtn:setColor(cc.c3b(249, 123, 85))   
    self.tryAgainBtn:setTouchEnabled(true)  
    self.container:addChild(self.tryAgainBtn)
    self.tryAgainBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)        
        if event.name == "began" then
            self.tryAgainBtn:setScale(1.2)
        elseif event.name == "ended" then
            self.tryAgainBtn:setScale(1) 
             self.tryAgainBtn:setTouchEnabled(false)  
            if self.parent then
                self.parent:onEnter()
                self:onExit()
                self.parent:removeChild(self)
                self.parent = nil
            end         
        end           
        return true
    end)
    local tryAgainLab = display.newTTFLabel({
        text = "再试一次",     
        size = 30,
        color = cc.c3b(255, 255, 255),         
    })
    tryAgainLab:setTouchEnabled(false)  
    tryAgainLab:setPosition(333/2,93/2)
    self.tryAgainBtn:addChild(tryAgainLab)
    yy = self.containerH - 485+dd -140
    if yy < 70 then
        yy = 70
    end  
    self.tryAgainBtn:setPosition(self.containerW/2,yy)
end


function TrainOverView:getWidth() 
	  return self.width
end

function TrainOverView:getHeight() 
	  return self.height
end

function TrainOverView:open(totalScore,rightNum,errorNum,beginTime,endTime)
	  -- self.rightNumLab:setString("正确数：           "..rightNum)
	  -- self.errorNumLab:setString("错误数：           "..errorNum)
	  local precent = math.floor((rightNum/(rightNum+errorNum))*100)

    local t= (endTime - beginTime)/(rightNum+errorNum)  
    t = math.floor(t*100)

    if errorNum == 0 and rightNum == 0 then
        precent = 0
        t = 0
    end  

	  -- self.rightPreLab:setString("正确率：           "..precent.."%")	
	  -- self.answerTimeLab:setString("平均作答时间：     "..(t/100).."s")
    self.labScore:setString(math.round(totalScore))
    self.rightPrecentLab:setString(precent)
    self.errorNumLab:setString(errorNum)
    self.rightNumLab:setString(rightNum)
    self.answerTimeLab:setString((t/100).."s")
    self.circleBar:autoToPercent(precent,1)
end

function TrainOverView:onEnter()
	
end

function TrainOverView:onExit()
	  if self.tryAgainBtn then
		    self.tryAgainBtn:stopAllActions()
		    self.tryAgainBtn:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
	  end
end	

return TrainOverView