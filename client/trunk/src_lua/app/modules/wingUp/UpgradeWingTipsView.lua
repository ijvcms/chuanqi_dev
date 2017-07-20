--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-18 15:39:22
-- 翅膀升阶提示界面
local UpgradeWingTipsView = class("UpgradeWingTipsView", BaseView)
function UpgradeWingTipsView:ctor(winTag,data,winconfig)
	self.data = data
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	UpgradeWingTipsView.super.ctor(self,winTag,data,winconfig)
	-- self.root = cc.uiloader:load("resui/storyInstanceWin.ExportJson")
	-- self:addChild(self.root)

    self.root:setPosition((display.width-852)/2,(display.height-550)/2)

    self.closeBtn = self:seekNodeByName("close")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	GlobalWinManger:closeWin(WinName.UPGRADEWINGTIPSVIEW)
        end
        return true
    end)
	
    self.btnwing2 = self:seekNodeByName("btnwing2")
    self.btnwing2:setTouchEnabled(true)
    self.btnwing2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnwing2:setScale(1.1)
        elseif event.name == "ended" then
            self.btnwing2:setScale(1)
            --GlobalWinManger:openWin(WinName.RECHARGEWIN)
            GlobalController.welfare:OpenFirstRechargeView()
        end
        return true
    end)    
end

function UpgradeWingTipsView:open()

end

function UpgradeWingTipsView:close()
    UpgradeWingTipsView.super.close(self)
end

--清理界面
function UpgradeWingTipsView:destory()
	
end

return UpgradeWingTipsView