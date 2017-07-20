--
-- Author: Yi hanneng
-- Date: 2016-04-22 10:27:27
--

--[[
福利中心－－－－兑换码
--]]
local WelfareRedeemCodeView = WelfareRedeemCodeView or class("WelfareRedeemCodeView", BaseView)

function WelfareRedeemCodeView:ctor()

	self.ccui = cc.uiloader:load("resui/welfareRedeemCodeWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function WelfareRedeemCodeView:init()
	self.InputBg = cc.uiloader:seekNodeByName(self.ccui, "InputBg")
	 
 	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(self.InputBg:getContentSize().width, 30),
          listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          --dimensions = cc.size(self:getContentSize().width, self:getContentSize().height)
        })
    
    self.ccui:addChild(self.inputLab)
    self.inputLab:setPosition(self.InputBg:getPositionX() + 10, self.InputBg:getPositionY()-18)
    self.inputLab:setFontSize(16)
    self.inputLab:setMaxLength(15)
    self.inputLab:setPlaceHolder("点击输入15位兑换码")


    local confirmBtn = cc.uiloader:seekNodeByName(self.ccui,"btn_RedeemCode")
    confirmBtn:setTouchEnabled(true)
    confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            confirmBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            confirmBtn:setScale(1.0)
            if self.inputLab:getText() ~= "" then
            	GameNet:sendMsgToSocket(22002,{ code = self.inputLab:getText() } )
            end
        end     
        return true
    end)

end

function WelfareRedeemCodeView:open()
end

function WelfareRedeemCodeView:close()
end

function WelfareRedeemCodeView:destory()
end

return WelfareRedeemCodeView