--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-27 22:12:15
-- 
local mergeTotalChargeItem = class("mergeTotalChargeItem", BaseView)
function mergeTotalChargeItem:ctor(data)
	self.data = data
	self.active_service_id = data.active_service_id
	self.btnStates = data.is_receive
	self.conf = configHelper:getActiveServiceMerge(self.active_service_id)
	self.root = cc.uiloader:load("resui/mergeTotalChargeItem.ExportJson")
	self:addChild(self.root)
	self.itemLayer = self:seekNodeByName("itemLayer")
	self.root:setPosition(-329,-67)


    self.getBtn = self:seekNodeByName("getBtn")
    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.getBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.getBtn:setScale(1)
           	if self.btnStates == 0 then
                GlobalController.mergeActivity:send38013(self.active_service_id,self.conf.id)
            elseif self.btnStates == 1 then
                GlobalMessage:show("不可领取")
            elseif self.btnStates >= 2 then
                GlobalMessage:show("已领取")
            end
        end
        return true
    end)

    self.numLabel = self:seekNodeByName("numLabel")
    self.listItem = {}
    self:update()
end

function mergeTotalChargeItem:update()
    self.btnStates = self.data.is_receive
	self.numLabel:setString(self.conf.value)
	if #self.listItem == 0 then
		local itemVoList = self.conf["reward_"..RoleManager:getInstance().roleInfo.career]
		for i=1,#itemVoList do
			local item = self.listItem[i]
	        if item == nil then
	            item = CommonItemCell.new()
	            self.itemLayer:addChild(item)
	            self.listItem[i] = item
	        end
	        local d = itemVoList[i]
	        --110140,1,3
	        item:setData({goods_id = d[1], is_bind = d[2], num = d[3]})
	        item:setCount(d[3])
	        item:setPosition(85*(i-1)+50,40)
		end
	end
	if self.btnStates == 0 then
        self.getBtn:setButtonLabelString("领取")
        self.getBtn:setButtonEnabled(true)
    elseif self.btnStates == 1 then
        self.getBtn:setButtonLabelString("领取")
        self.getBtn:setButtonEnabled(false)
    elseif self.btnStates >= 2 then
        self.getBtn:setButtonLabelString("已领取")
        self.getBtn:setButtonEnabled(false)
    end
end

function mergeTotalChargeItem:open(datas)
    
end



function mergeTotalChargeItem:close()
   
end


--清理界面
function mergeTotalChargeItem:destory()
	
     for k,v in pairs(self.listItem) do
        v:destory()
        self.itemLayer:removeChild(v)
        self.listItem[k] = nil
    end
end

return mergeTotalChargeItem