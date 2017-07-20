--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-17 16:15:43
-- 沙巴克规则界面
local ShaBaKeRuleWin = class("ShaBaKeRuleWin", BaseView)

function ShaBaKeRuleWin:ctor(winTag,data,winconfig)
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setContentSize(display.width, display.height)
    --self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    self.ccui = cc.uiloader:load("resui/shabakeruleWin.ExportJson")
  	self:addChild(self.ccui)

	--ShaBaKeRuleWin.super.ctor(self,winTag,data,winconfig)
  	self.data = data
 
  	local root = cc.uiloader:seekNodeByName(self.ccui, "root")
  	root:setTouchEnabled(true)
  	local size = root:getContentSize()
  	root:setPosition((display.width - size.width)/2,(display.height - size.height)/2)

  	self.Btn_confirm = cc.uiloader:seekNodeByName(self.ccui,"Btn_confirm")
	self.Btn_confirm:setTouchEnabled(true)
	self.Btn_confirm:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.Btn_confirm:setScale(1.1)
	        elseif event.name == "ended" then
	            self.Btn_confirm:setScale(1)
	            --GlobalWinManger:closeWin(self.winTag)
	            self:removeSelfSafety()
	        end
	        return true
	end)

	self.Btn_colose = cc.uiloader:seekNodeByName(self.ccui,"Btn_colose")
	self.Btn_colose:setTouchEnabled(true)
	self.Btn_colose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.Btn_colose:setScale(1.1)
	        elseif event.name == "ended" then
	            self.Btn_colose:setScale(1)
	            --GlobalWinManger:closeWin(self.winTag)
	            self:removeSelfSafety()
	        end
	        return true
	end)
end	


    
function ShaBaKeRuleWin:open()
    self.super.open(self)
end
	
function ShaBaKeRuleWin:close()
    self.super.close(self)
end

function ShaBaKeRuleWin:destory()
    self.super.destory(self)
end


return ShaBaKeRuleWin