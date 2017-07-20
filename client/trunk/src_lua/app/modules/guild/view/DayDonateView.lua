--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:14:19
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--
--每日捐献
local DayDonateView = class("DayDonateView", function()
	return display.newNode()
end)

function DayDonateView:ctor()
	local maskBg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    maskBg:setContentSize(display.width, display.height)
    self:addChild(maskBg)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "ended" then
	            self:close()
	        end     
	        return true
	    end)

    --背景
	local bg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(550,390),cc.rect(63, 49,1, 1))
	bg:setAnchorPoint(0,0)
	self:addChild(bg)
	bg:setPosition((display.width-550)/2,(display.height-390)/2)
	bg:setTouchEnabled(true)
	bg:setTouchSwallowEnabled(true)

	--标题背景
	local titleBg = display.newSprite("#com_alertTitleBg.png")
	bg:addChild(titleBg)
	titleBg:setPosition(275,350)

	--标题
	local labHHJX = display.newTTFLabel({
    	text = "行会捐献",
    	size = 24,
    	color = TextColor.TEXT_O
	})
	display.setLabelFilter(labHHJX)
	labHHJX:setPosition(titleBg:getContentSize().width/2,titleBg:getContentSize().height/2)
	titleBg:addChild(labHHJX)

	--tips
	local labTips = display.newTTFLabel({
    	text = "三种捐献每天可各捐一次",
    	size = 20,
    	color = TextColor.TEXT_R
	})
	display.setLabelFilter(labTips)
	labTips:setPosition(275,310)
	bg:addChild(labTips)

	--三种捐赠类型 
	local donation = 
	{
		[1] = configHelper:getGuildDonation(1),
		[2] = configHelper:getGuildDonation(2),
		[3] = configHelper:getGuildDonation(3),
	}
	local consumeType = 
	{
		[1] = "金币",
		[2] = "元宝"
	}
	local texts = 
	{
		[1] = {title=donation[1].content.."捐献", titleColor=TextColor.TEXT_W, consume=donation[1].consume_value..consumeType[donation[1].consume_type] , icon="#guild_coin1.png", income={[1]="个人贡献："..donation[1].contribution,[2]="行会经验："..donation[1].guild_exp,[3]="行会资金："..donation[1].guild_capital}, vip=donation[1].vip_limit},
		[2] = {title=donation[2].content.."捐献", titleColor=TextColor.ITEM_P, consume=donation[2].consume_value..consumeType[donation[2].consume_type] , icon="#guild_yuanbao1.png", income={[1]="个人贡献："..donation[2].contribution,[2]="行会经验："..donation[2].guild_exp,[3]="行会资金："..donation[2].guild_capital}, vip=donation[2].vip_limit},
		[3] = {title=donation[3].content.."捐献", titleColor=TextColor.TEXT_O, consume=donation[3].consume_value..consumeType[donation[3].consume_type] , icon="#guild_yuanbao2.png", income={[1]="个人贡献："..donation[3].contribution,[2]="行会经验："..donation[3].guild_exp,[3]="行会资金："..donation[3].guild_capital}, vip=donation[3].vip_limit},
	}
	self.typeBtns = {}	
	for i=1,3 do
		--背景
		local bgg = display.newScale9Sprite("#com_propBg1.png", 0, 0, cc.size(165,235))
		bgg:setPosition(100+(i-1)*(175),180)
		bg:addChild(bgg)
		--标题
		local labTitle = display.newTTFLabel({
	    	text = texts[i].title,
	    	size = 20,
	    	color = texts[i].titleColor
		})
		display.setLabelFilter(labTitle)
		labTitle:setPosition(100+(i-1)*(175),280)
		bg:addChild(labTitle)
		--消耗
		local labConsume = display.newTTFLabel({
	    	text = texts[i].consume,
	    	size = 20,
	    	color = TextColor.TEXT_G
		})
		display.setLabelFilter(labConsume)
		labConsume:setPosition(100+(i-1)*(175),250)
		bg:addChild(labConsume)
		--图标
		local icon = display.newSprite(texts[i].icon)
		bg:addChild(icon)
		icon:setPosition(100+(i-1)*(175),200)
		--收益
		for j=1,#texts[i].income do
			local lab = display.newTTFLabel({
		    	text = texts[i].income[j],
		    	size = 20,
		    	color = TextColor.TEXT_W
			})
			display.setLabelFilter(lab)
			lab:setPosition(100+(i-1)*(175),160-(j-1)*25)
			bg:addChild(lab)
		end
		--人物的vip等级
		local curVip = RoleManager:getInstance().roleInfo.vip

		if texts[i].vip <= curVip then
			--捐献按钮
			local btn = display.newSprite("#com_labBtn1.png")
			btn:setTouchEnabled(true)
		    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "began" then
		            btn:setScale(1.2)
		            SoundManager:playClickSound()
		        elseif event.name == "ended" then
		            btn:setScale(1.0)
		            self:onDonateClick(i)
		        end     
		        return true
		    end)
		    btn:setPosition(100+(i-1)*(175),35)
		    local label = display.newTTFLabel({
		    	text = "捐 献",
		    	size = 20,
		    	color = TextColor.TEXT_W
			})
			label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
			btn:addChild(label)
			display.setLabelFilter(label)
			label:setTag(10)
			bg:addChild(btn)
			self.typeBtns[i] = btn 
		else
			--vip tips
			local labVipTips = display.newTTFLabel({
		    	text = "VIP"..texts[i].vip.."可捐献",
		    	size = 20,
		    	color = TextColor.TEXT_R
			})
			display.setLabelFilter(labVipTips)
			labVipTips:setPosition(100+(i-1)*(175),35)
			bg:addChild(labVipTips)
		end
	end

	--注册事件
	self:registerEvent()

	--取捐献状态
	GameNet:sendMsgToSocket(17052, {})
end

function DayDonateView:onDonateClick(index)
	-- if index == 1 then 			
 		GameNet:sendMsgToSocket(17050, {["type"]=index})
	-- elseif index == 2 then
	-- elseif index == 3 then
	-- end
end

function DayDonateView:close()
	self:unregisterEvent()
	self:removeSelfSafety()
end

function DayDonateView:registerEvent()
	self.registerEventId = {}
    --取得行会捐献状态
    local function onGuildDonInfo(data)
       	for i=1,#data.data do
       		if data.data[i].count >= 1 then
       			if self.typeBtns[data.data[i].type] then
       				self.typeBtns[data.data[i].type]:setSpriteFrame("com_labBtn1Dis.png")
       				self.typeBtns[data.data[i].type]:getChildByTag(10):setString("已捐")
       				self.typeBtns[data.data[i].type]:setTouchEnabled(false)
       			end
       		end
       	end
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(GuildEvent.REQ_GUILD_DONATION_INFO, onGuildDonInfo)
end

function DayDonateView:unregisterEvent()
	if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

return DayDonateView