--
-- Author: Yi hanneng
-- Date: 2016-05-19 18:53:12
--

local AlertTipsII = AlertTipsII or class("AlertTipsII", function()
	return display.newNode()
end)


function AlertTipsII:ctor(param)
	self.width = param.width or 553
	self.height = param.height or 311
	self.enterTxt = param.enterTxt or "确定"
	self.backTxt = param.backTxt or "返回"
	self.tipTxt = param.tipTxt or ""
	self.enterFun = param.enterFun
	self.backFun = param.backFun
    self.titleTxt = param.title or "提示"
    self.tipShowMid = param.tipShowMid or false
    self.hideBackBtn = param.hideBackBtn or false

    self.hideCloseBtn = param.hideCloseBtn or false

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    self.ccui = cc.uiloader:load("resui/roleWin_attr.ExportJson")
    self:addChild(self.ccui)
   	--self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self.ccui:setPosition(display.width/2 - self.ccui:getContentSize().width/2,display.height/2 - self.ccui:getContentSize().height/2)
   	self:init()

end

function AlertTipsII:init()

	self.closeBtn = cc.uiloader:seekNodeByName(self.ccui, "close")
	self.description = cc.uiloader:seekNodeByName(self.ccui, "description")
	self.closeBtn:setTouchEnabled(true)

	self.scroll = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.description:getContentSize().width,self.description:getContentSize().height),direction=1}):addTo(self.description)
	local  layer = display.newNode()
	self.scroll:addScrollNode(layer)
	self.tipsLab = display.newTTFLabel({text = self.tipTxt,
        size = 19,color = TextColor.BTN_Y--[[,dimensions = cc.size(self.txtBg:getContentSize().width-10, 0)--]]})
            :align(display.TOP_CENTER,0,0)
            :addTo(layer)
    if self.tipsLab:getContentSize().width > self.description:getContentSize().width-10 then
        self.tipsLab:setDimensions(self.description:getContentSize().width-10,0)
    end

    self.tipsLab:setPosition(self.width/2,self.height-110)
    display.setLabelFilter(self.tipsLab)
    self.scroll:scrollAuto()
 
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)		
            if event.name == "began" then            	
                self.closeBtn:setScale(1.1)
            elseif event.name == "ended" then            	
                self.closeBtn:setScale(1)
                
                self:close()
            end
            return true
        end)
end


function AlertTipsII:show(tips)
	self.tipsLab:setString(tips)
end

function AlertTipsII:close()
    local parent = self:getParent()
    if parent ~= nil then
        parent:removeChild(self)
    end 

    self.enterFun = nil
    self.backFun = nil
end

return AlertTipsII