--
-- Author: Yi hanneng
-- Date: 2016-03-16 20:44:23
--

--[[
兑换码
--]]
local ExchangeMarkView = class("ExchangeMarkView", function()
    return display.newNode()
end)

function ExchangeMarkView:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  	self.bg:setContentSize(display.width, display.height)
  	self:setTouchEnabled(true)
  	self:setTouchSwallowEnabled(true)
  	self:addChild(self.bg)

    local win = cc.uiloader:load("resui/RedeemCodeWin.ExportJson")
    self:addChild(win)
 	win:setPosition((display.width-win:getContentSize().width)/2,(display.height-win:getContentSize().height)/2)

    local inputBg = cc.uiloader:seekNodeByName(win,"inputBg")
 	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(inputBg:getContentSize().width, 30),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          --dimensions = cc.size(self:getContentSize().width, self:getContentSize().height)
        })
    
    win:addChild(self.inputLab)
    self.inputLab:setPosition(inputBg:getPositionX() + 4, inputBg:getPositionY())
    self.inputLab:setFontSize(8)
    self.inputLab:setMaxLength(15)
    self.inputLab:setPlaceHolder("点击输入15位兑换码")
    -- 
    local confirmBtn = cc.uiloader:seekNodeByName(win,"confirmBtn")
    confirmBtn:setTouchEnabled(true)
    confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            confirmBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            confirmBtn:setScale(1.0)
            if self.inputLab:getText() ~= "" then
            	GameNet:sendMsgToSocket(22002,{ code = self.inputLab:getText() } )
            	self:removeSelf()
            end
        end     
        return true
    end)
    --退出游戏
    local closeBtn = cc.uiloader:seekNodeByName(win,"closeBtn")
    closeBtn:setTouchEnabled(true)
    closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            closeBtn:setScale(1.0)
            self:removeSelfSafety()
        end
        return true
    end)
end

function ExchangeMarkView:destory()
   
end

return ExchangeMarkView