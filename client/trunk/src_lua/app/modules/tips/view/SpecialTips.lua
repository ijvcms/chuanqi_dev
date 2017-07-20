--
-- Author: Yi hanneng
-- Date: 2016-09-09 16:35:51
--

local SpecialTips = SpecialTips or class("SpecialTips", BaseView)

function SpecialTips:ctor()

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

	self.ccui = cc.uiloader:load("resui/tt_tips.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	
   	self.ccui:setPosition(display.width/2 - self.ccui:getContentSize().width/2, display.height/2 - self.ccui:getContentSize().height/2)
   	
   	self:init()

end

function SpecialTips:init()

	self.type = 0

	self.titleLabel = cc.uiloader:seekNodeByName(self.ccui, "titleLabel")
	 
	self.des = SuperRichText.new(nil,350):addTo(self.ccui)
	self.des:setAnchorPoint(0,1)
	self.des:setPosition(41, 115)
  
	self:setTouchEnabled(true)
  
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
    
        elseif event.name == "ended" then
      
            if not cc.rectContainsPoint(self.ccui:getBoundingBox(), event) then
                self:removeSelf()
            end
            
        end     
        return true
    end)

end

function SpecialTips:setData(data)
	
	if data.title ~= nil and data.title ~= "" then
		self.titleLabel:setString(data.title)
	end
	
	if data.content ~= nil and data.content ~= "" then
		self.des:renderXml("<font color='e7d3ad' size='18' opacity='255'>"..data.content.."</font>")
	end
end
 
function SpecialTips:open()

end

function SpecialTips:close()
	self:removeSelf()
end
 

return SpecialTips