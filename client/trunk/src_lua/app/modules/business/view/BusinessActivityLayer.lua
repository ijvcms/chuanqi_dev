--
-- Author: Yi hanneng
-- Date: 2016-06-29 18:29:51
--
local BusinessActivityLayer = BusinessActivityLayer or class("BusinessActivityLayer", function() return display.newNode()end)

function BusinessActivityLayer:ctor(w,h)
	self.w = w
	self.h = h
    self:setAnchorPoint(0,0)
	self:init(w,h)
end

function BusinessActivityLayer:setData(data)

	if data == nil then
		return 
	end

	self.data = data
    
	self.activityTimeValue:setString(os.date("%Y年%m月%d日%H:%M",data.start_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
	self.activityDes:renderXml("<font color='ffffff' size='18' opacity='255'>"..data.content.."</font>")

    function ttt(v)
        if v then
            dump(v:getBoundingBox())
        end

        for k,v in pairs(v:getChildren()) do
            ttt(v)
        end

    end
 
    --ttt(self)

	if #self.itemList > 0 then

		for i=1,#self.itemList do
			self.itemList[i]:removeFromParent()
		end
	 
	end

	self.itemList = {}
 	local info

	for i=1,#data.show_reward do
		info = data.show_reward[i]
		local commonItem = CommonItemCell.new():addTo(self.container)
	    commonItem:setData(info)
	    commonItem:setTouchSwallowEnabled(false)
		commonItem:setPosition(80*(i-1), 0)
		self.itemList[i] = commonItem
	end

	self.container:setContentSize(cc.size(80*#data.show_reward, 80))

 
    --按钮
 
    self.btnLabel:setString(data.button_content)
    self.btn:setVisible(data.is_button ~= 0)
    self:setButtonEnabled( data.state == 1)
 
    self.activityTimeTitle:setPositionY(-self.activityTimeTitle:getContentSize().height/2 - 4)
 
    self.activityTimeValue:setPositionY(self.activityTimeTitle:getPositionY() - self.activityTimeTitle:getContentSize().height- 4)
    
    self.activityTitle:setPositionY(self.activityTimeValue:getPositionY()- self.activityTimeValue:getContentSize().height- 4)
    self.activityDes:setPositionY(self.activityTitle:getPositionY() - self.activityDes:getContentSize().height - 16)
    
    self.container:setPosition(self.w/2 - self.container:getContentSize().width/2 + 40,self.activityDes:getPositionY() - self.container:getContentSize().height - 4)
    self.btn:setPosition(self.w/2 - self.btn:getContentSize().width/2, self.container:getPositionY() - self.container:getContentSize().height/2 - self.btn:getContentSize().height - 40)

    --[[
    local h = math.abs(self.btn:getPositionY()) + self.btn:getContentSize().height/2
    self:setContentSize(cc.size(self.w, h))
    
    self.bg =  cc.LayerColor:create(cc.c4b(255,255,0,100))
    self.bg:setContentSize(self.w, self:getContentSize().height)
   
    self:addChild(self.bg)
   
    ------------------------------------
 
    self.activityTimeTitle:setPositionY(h-self.activityTimeTitle:getContentSize().height/2 - 4)
 
    self.activityTimeValue:setPositionY(self.activityTimeTitle:getPositionY() - self.activityTimeTitle:getContentSize().height- 4)
    
    self.activityTitle:setPositionY(self.activityTimeValue:getPositionY()- self.activityTimeValue:getContentSize().height- 4)
    self.activityDes:setPositionY(self.activityTitle:getPositionY() + self.activityDes:getContentSize().height - 16)
    
    self.container:setPosition(self.w/2 - self.container:getContentSize().width/2 + 40,self.activityTitle:getPositionY() - self.activityDes:getContentSize().height - self.container:getContentSize().height - 4)
    self.btn:setPosition(self.w/2 - self.btn:getContentSize().width/2, self.container:getPositionY() - self.container:getContentSize().height/2 - self.btn:getContentSize().height - 40)
     --]]
end

function BusinessActivityLayer:init(w,h)
	--设置标题

	self.itemList = {}
 	
	self.activityTimeTitle = self:createTxtItem("活动时间:",20,TextColor.TEXT_O)
	self.activityTimeValue = self:createTxtItem("",18,TextColor.TEXT_G)
	self.activityTitle = self:createTxtItem("活动内容:",20,TextColor.TEXT_O)

	self.activityDes = SuperRichText.new(nil,w)
 	--self.activityDes:setAnchorPoint(0,1)
 	self.container = display.newNode():addTo(self)
 	self.container:setAnchorPoint(0,0)
	 
    --按钮
    self.btn = cc.ui.UIPushButton.new({
        normal = "#com_labBtn1.png",
        disabled = "#com_labBtn1Dis.png",
        })
    self.btnLabel = cc.ui.UILabel.new({
            text = "",
            size = 18,
            color = cc.c3b(219, 174, 103)
            })

    self.btn:setButtonLabel(self.btnLabel)

    self:addChild(self.activityTimeTitle)
    self:addChild(self.activityTimeValue)
    self:addChild(self.activityTitle)
    self:addChild(self.activityDes)
    self:addChild(self.btn)
   
	self.btn:setTouchEnabled(true)
  	self.btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.btn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.btn:setScale(1.0)
            if self.data then
            	if self.data.is_window == 0 then
            		GlobalController.business:requestBusinessById(self.data.active_id)
            	elseif self.data.is_window == 1 then
            		function exfunc()
				        GlobalController.business:requestBusinessById(self.data.active_id)
				    end

			        GlobalMessage:alert({
			                enterTxt = "确定",
			                backTxt= "取消",
			                tipTxt = self.data.window_content,
			                enterFun = exfunc,
			                tipShowMid = true,
			        })
            	end
            end
        end
        return true
    end)
end

function BusinessActivityLayer:createTxtItem(str,size,color)
	return cc.ui.UILabel.new({text = str, size = size, color = color})
end

function BusinessActivityLayer:setButtonEnabled(enabled)

	if self.btn then
		self.btn:setButtonEnabled(enabled)
	end

end
 
function BusinessActivityLayer:destory()
end

return BusinessActivityLayer