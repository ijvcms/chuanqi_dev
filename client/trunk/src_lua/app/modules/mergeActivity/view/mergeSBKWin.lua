--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-26 16:18:25
-- 合服沙巴克
local mergeSBKWin = mergeSBKWin or class("mergeSBKWin", BaseView)

function mergeSBKWin:ctor(winTag,data,winconfig)
    self.data = data
	  mergeSBKWin.super.ctor(self,winTag,data,{url = "resui/"..data.viewType..".ExportJson"})
   	self.root:setPosition(0,0)
    
    self.itemLayer = self:seekNodeByName("itemLayer")
    self.itemLayer2 = self:seekNodeByName("itemLayer2")
    --self.timeLabel = self:seekNodeByName("timeLabel")

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
	self.listItem = {}
end

function mergeSBKWin:update()
    self.serverData = MergeActivityModel:getInstance():getActivityTypeData(self.data.id)
    --self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",self.serverData.start_time).."-"..os.date("%Y年%m月%d日%H:%M",self.serverData.end_time))

    local list = self.serverData.active_service_list
    if #self.listItem == 0 then
        local itemDatalist
        if list[1] then
            itemDatalist =  configHelper:getActiveServiceMerge(list[1].active_service_id)["reward_"..RoleManager:getInstance().roleInfo.career]
        else
            itemDatalist =  configHelper:getActiveServiceMerge(73)["reward_"..RoleManager:getInstance().roleInfo.career]
        end
        for i=1,math.min(#itemDatalist,6) do
            local item = nil
            if item == nil then
                item = CommonItemCell.new()
                self.itemLayer:addChild(item)
                table.insert(self.listItem,item)
                
            end
            local d = itemDatalist[i]
            --110140,1,3
            item:setData({goods_id = d[1], is_bind = d[2], num = d[3]})
            item:setCount(d[3])
            item:setPosition(85*(i-1) +40,60)
        end
        if list[2] then
            itemDatalist =  configHelper:getActiveServiceMerge(list[1].active_service_id)["reward_"..RoleManager:getInstance().roleInfo.career]
        else
            itemDatalist =  configHelper:getActiveServiceMerge(74)["reward_"..RoleManager:getInstance().roleInfo.career]
        end
        for i=1,math.min(#itemDatalist,6) do
            local item = nil
            if item == nil then
                item = CommonItemCell.new()
                self.itemLayer2:addChild(item)
                table.insert(self.listItem,item)
                
            end
            local d = itemDatalist[i]
            --110140,1,3
            item:setData({goods_id = d[1], is_bind = d[2], num = d[3]})
            item:setCount(d[3])
            item:setPosition(85*(i-1) +40,60)
        end
    end

end

function mergeSBKWin:open()
    mergeSBKWin.super.open(self)
end

function mergeSBKWin:close()
    mergeSBKWin.super.close(self)
end

function mergeSBKWin:destory()
    mergeSBKWin.super.destory(self)
    for k,v in pairs(self.listItem or {}) do
        v:destory()
        self.listItem[k] = nil
    end

end

return mergeSBKWin
