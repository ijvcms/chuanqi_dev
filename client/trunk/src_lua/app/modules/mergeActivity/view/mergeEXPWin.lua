--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服双倍经验
local mergeEXPWin = mergeEXPWin or class("mergeEXPWin", BaseView)

function mergeEXPWin:ctor(winTag,data,winconfig)
    self.data = data
	  mergeEXPWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)
    
    -- self.leftLayer = self:seekNodeByName("leftLayer")
    -- self.rightLayer = self:seekNodeByName("rightLayer")

   --  self.closeBtn = self:seekNodeByName("btnClose")
  	-- self.closeBtn:setTouchEnabled(true)
  	-- self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
   --      if event.name == "began" then
   --          self.closeBtn:setScale(1.1)
   --      elseif event.name == "ended" then
   --          self.closeBtn:setScale(1)
   --          GlobalWinManger:closeWin(self.winTag)
   --      end
   --      return true
  	-- end)
  self.timeLabel = self:seekNodeByName("timeLabel")
end

function mergeEXPWin:update()
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)
    self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))
end

function mergeEXPWin:open()
    mergeEXPWin.super.open(self)

end

function mergeEXPWin:close()
    mergeEXPWin.super.close(self)

end

function mergeEXPWin:destory()
    mergeEXPWin.super.destory(self)

end

return mergeEXPWin
