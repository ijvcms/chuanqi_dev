--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:17:12
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--更多操作列表
local AppointView = import(".AppointView")
local MoreOperateList = class("moreOperateList", function()
	return display.newNode()
end)

local MPL_OP={
	[1] = "查看信息",
	[2] = "加为好友",
	[3] = "移交会长",
	[4] = "更改职位",
	[5] = "踢出行会"
}
local MPL_GAP = 10
function MoreOperateList:ctor(itemOpenTable,data,modifyFunc,isCorps)
	self.data = data
	if not itemOpenTable then return end
	local height = #itemOpenTable*44+(#itemOpenTable-1)*MPL_GAP
	self:setContentSize(140,height)
	self:setAnchorPoint(0,0)
	if height<0 then
		return 
	end
	self.isCorps = isCorps
	if isCorps then
		MPL_OP[3] = "移交团长"
		MPL_OP[5] = "踢出军团"
	end

	--吞噬页
	local maskbg = display.newLayer()
	-- local maskbg = cc.LayerColor:create(cc.c4b(0,0,0,100))
	maskbg:setAnchorPoint(0,0)
	maskbg:setContentSize(display.width,display.height)
    self:addChild(maskbg)
    maskbg:setTouchEnabled(true)
    maskbg:setPosition((-display.width)/2,(-display.height)/2)
    maskbg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:removeSelfSafety()
        end     
        return true
    end)
	--背景
	local bg = display.newScale9Sprite("#com_panelBg3.png", 0, 0, cc.size(140+10,height+10))
	bg:setAnchorPoint(0.5,0)
	bg:setPosition(0,-5-22)
	self:addChild(bg)

	--操作项
	for i=1,#itemOpenTable do
		local btn = display.newSprite("#com_labBtn1.png")
		btn:setTouchEnabled(true)
	    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            btn:setScale(1.2)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            self:onBtnClick(itemOpenTable[i])
	        end     
	        return true
	    end)
	    btn:setPosition(0,(#itemOpenTable-i)*(btn:getContentSize().height+MPL_GAP))
	    local label = display.newTTFLabel({
	    	text = MPL_OP[itemOpenTable[i]],
	    	size = 22,
	    	color = TextColor.TEXT_W
		})
		label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
		btn:addChild(label)
		display.setLabelFilter(label)
		self:addChild(btn) 
	end
	--自定义按钮点击回调
	self.modifyFunc = modifyFunc
end

function MoreOperateList:onBtnClick(index)
	if self.modifyFunc and self.modifyFunc[index] then 
		self.modifyFunc[index]()
	else
		if index == 1 then 			--查看信息
			GameNet:sendMsgToSocket(10011, {player_id = self.data.player_id})
		elseif index == 2 then 		--加为好友
			--yjc
		elseif index == 3 then 		--移交会长

		elseif index == 4 then 		--更改职位
			local roleManager = RoleManager:getInstance()
		    local guildInfo
		    if self.isCorps then
		    	guildInfo = roleManager.corpsInfo
		    else
		        guildInfo = roleManager.guildInfo
		    end
		    local node
		    if guildInfo.position == 1 then 			--会长
		    	node = AppointView.new({2,3,4,5},self.data, self.isCorps)
		    elseif guildInfo.position == 2 then 		--副会长
		    	node = AppointView.new({3,4,5},self.data, self.isCorps)
		    else
		    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"无处理权限")
		    end
		    if node then
		    	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)  
		    end	
		elseif index == 5 then 		--踢出行会
			local playerId = self.data.player_id
			local function enterFun()
				local proto = 17018
				if self.isCorps then
					proto = 37018
				end
	            GameNet:sendMsgToSocket(proto, {player_id = playerId}) 
	        end
	        GlobalMessage:alert({
	            enterTxt = "确定",
	            backTxt= "取消",
	            tipTxt = "是否将玩家"..self.data.player_name.."踢出?",
	            enterFun = handler(self, enterFun),
	            -- backFun = handler(self, backFun),
	            tipShowMid = true,
	        })
		end
	end
	self:removeSelfSafety()
end

return MoreOperateList