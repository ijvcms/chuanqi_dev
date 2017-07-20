--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-27 22:20:01
--
local mergeBossItem = class("mergeBossItem", BaseView)
function mergeBossItem:ctor(data)
	self.data = data
	self.active_service_id = data.active_service_id
	self.btnStates = data.is_receive
	self.conf = configHelper:getActiveServiceMerge(self.active_service_id)
	self.root = cc.uiloader:load("resui/mergeBossItem.ExportJson")
	self:addChild(self.root)

	
	self.stateLayer = self:seekNodeByName("stateLayer")
	self.playerNameLabel = self:seekNodeByName("playerNameLabel")

	self.itemLayer = self:seekNodeByName("itemLayer")
	self.root:setPosition(-329,-67)


    self.getBtn = self:seekNodeByName("getBtn")
    self.getBtn:setTouchEnabled(true)
    self.getBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" and self.btnStates == 0 then
            self.getBtn:setScale(1.1)
        elseif event.name == "ended" and self.btnStates == 0 then
            self.getBtn:setScale(1)
           	if self.btnStates == 0 then
                GlobalController.mergeActivity:send38013(self.active_service_id,self.conf.id)
            elseif self.btnStates == 1 then
                GlobalMessage:show("不可领取")
            elseif self.btnStates >= 2 then
                GlobalMessage:show("已经领取")
            end
        end
        return true
    end)

    self.killImg = self:seekNodeByName("killImg")
    self.killLabel = self:seekNodeByName("killLabel")
    self.BossNameLabel = self:seekNodeByName("BossNameLabel")
    self.bossBg = self:seekNodeByName("bossBg")
    self.listItem = {}
    self:update()
end

function mergeBossItem:update()
	self.btnStates = self.data.is_receive
	self.BossNameLabel:setString(self.conf.desc)
	if self.bossHead == nil then
		self.bossHead = display.newSprite(ResUtil.getWorldBossIcon(configHelper:getMonsterResById(self.conf.value)))
	    self.bossBg:addChild(self.bossHead)
	    self.bossHead:setPosition(46,41)
	end
				--ResUtil.getWorldBossIcon(self.conf.value)
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
	self.stateLayer:setVisible(true)
	self.playerNameLabel:setString(self.data.name)
	

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

    -- local filter = filter.newFilter("GRAY")
    -- filter:initSprite(nil)
    -- self.getBtn:setGLProgramState(filter:getGLProgramState()) --使用
    -- self.getBtn:setGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")) --清除

    if self.data.name ~= "" then
    	self.killImg:setVisible(true)
    	self.killLabel:setVisible(false)

        self.stateLayer:setVisible(true)
		self.playerNameLabel:setString(self.data.name)
	else
		self.killImg:setVisible(false)
    	self.killLabel:setVisible(true)
		self.stateLayer:setVisible(false)
	end
end

function mergeBossItem:open(datas)
    
end



function mergeBossItem:close()
   
end


--清理界面
function mergeBossItem:destory()
	
     for k,v in pairs(self.listItem) do
        v:destory()
        self.itemLayer:removeChild(v)
        self.listItem[k] = nil
    end
end

return mergeBossItem