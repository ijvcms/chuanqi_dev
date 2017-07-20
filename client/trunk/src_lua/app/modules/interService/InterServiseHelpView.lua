--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-04 19:49:07
--
local InterServiseHelpView = class("InterServiseHelpView", BaseView)
function InterServiseHelpView:ctor(winTag,data,winconfig)
	
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	self.root = cc.uiloader:load("resui/serverBossInfo.ExportJson")
	self:addChild(self.root)

    --self.root:setPosition((display.width)/2,(display.height)/2)

    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	self:setVisible(false)
        end
        return true
    end)

    --self.mainLayer = self:seekNodeByName("mainLayer")

end


function InterServiseHelpView:open(datas)
   
end



function InterServiseHelpView:close()
    
end


--清理界面
function InterServiseHelpView:destory()
	
end

return InterServiseHelpView