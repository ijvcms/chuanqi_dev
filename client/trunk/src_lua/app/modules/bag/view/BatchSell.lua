

-- BatchSell = BatchSell or class("BatchSell",function()
-- 	return cc.uiloader:load("resui/batchSell.ExportJson")
-- end)

--2016-5-12前是批量出售，现在改为批量分解

BatchSell = BatchSell or class("BatchSell", function()
	return display.newNode()
end)

--构造
function BatchSell:ctor()
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    local ccui = cc.uiloader:load("resui/batchSell.ExportJson")
    self:addChild(ccui)
    ccui:setPosition((display.width-486)/2,(display.height-458)/2)
    
	local root = cc.uiloader:seekNodeByName(ccui, "root")
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
    end)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    local winbg = cc.uiloader:seekNodeByName(win, "bg")
    winbg:setTouchEnabled(true)
    winbg:setTouchSwallowEnabled(true)

    --关闭按钮
    local btnClose = cc.uiloader:seekNodeByName(win, "btnClose")
    self.btnClose = btnClose
    btnClose:setTouchEnabled(true)
    btnClose:onButtonPressed(function ()
        btnClose:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnClose:onButtonRelease(function()
        btnClose:setScale(1.0)
    end)
    btnClose:onButtonClicked(function ()
        btnClose:setScale(1.0)
        self:onCloseClick()
    end)

    --
    self.labCounts = {}
    for i=1,4 do
    	self.labCounts[i] = cc.uiloader:seekNodeByName(win, "labValue"..i)
    end

    --
    self.btnSells = {}
    for i=1,4 do
    	local btn = cc.uiloader:seekNodeByName(win, "btnSell"..i)
    	self.btnSells[i] = btn
    	btn:setTouchEnabled(true)
	    btn:onButtonPressed(function ()
	        btn:setScale(1.1)
	        SoundManager:playClickSound()
	    end)
	    btn:onButtonRelease(function()
	        btn:setScale(1.0)
	    end)
	    btn:onButtonClicked(function ()
	        btn:setScale(1.0)
	        self:onSell(i)
	    end)
    end

    --
    self.coinValues = {}
    for i=1,4 do
    	self.coinValues[i] = cc.uiloader:seekNodeByName(win, "coinValue"..i)
    end

    self.handler = GlobalEventSystem:addEventListener(EquipEvent.DECOMPOSE_SUCCESS, handler(self,self.refreshData))
    self:refreshData()
end



function BatchSell:refreshData()
	local bagManager = BagManager:getInstance()
	local bagItemList = bagManager.bagInfo:getEquipList()
	--物品总价
	local v = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0}
	--物品总数
	local c = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0}
	
	-- local configHelper = import("app.utils.ConfigHelper").getInstance()
	for i=1,#bagItemList do

        if configHelper:getCanBatchDecomposeById(bagItemList[i].goods_id) then
   
    		local quality = configHelper:getGoodQualityByGoodId(bagItemList[i].goods_id)
            --橙色装备不能批量出售的
            --橙色装备和强化过的装备不能分解
            if quality <= 3 and bagItemList[i].stren_lv < 1 then
                --神器不能出售
                --if (not bagItemList[i].artifact_star) or (bagItemList[i].artifact_star<1) then
                    c[quality] = c[quality] + 1
                    v[quality] = v[quality] + configHelper:getGoodSaleByGoodId(bagItemList[i].goods_id)*bagItemList[i].num
                --end
            elseif quality == 4 and bagItemList[i].stren_lv < 1 then
                c[quality] = c[quality] + 1
                v[quality] = v[quality] + configHelper:getDecomposeById(bagItemList[i].goods_id).goods_list[1][3]
            end

        end
	end

	for i=1,3 do
		self.labCounts[i]:setString(c[i])
		self.coinValues[i]:setString("铜钱:"..v[i])
	end

    self.labCounts[4]:setString(c[4])
    self.coinValues[4]:setString("铸魂精华:"..v[4])
end

function BatchSell:onCloseClick( )
	if self:getParent() then
		--self:setVisible(false)
		self:removeSelfSafety()
        GlobalEventSystem:removeEventListenerByHandle(self.handler)
	end
end

function BatchSell:onSell(btnId)
    --20160512批量出售改为批量分解
	--GameNet:sendMsgToSocket(14004, {quality = btnId})
    GlobalController.equip:requestBathDecompose(btnId)
    self.labCounts[btnId]:setString("")
    self.coinValues[btnId]:setString("")
	--self:onCloseClick()
end