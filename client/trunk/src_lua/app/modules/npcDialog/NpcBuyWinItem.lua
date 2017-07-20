--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-18 15:23:00
--
local NpcBuyWinItem = NpcBuyWinItem or class("NpcBuyWinItem", function()
    return display.newNode()
end)

--构造
function NpcBuyWinItem:ctor(vo)
	self.vo = vo
	self:loadUI("resui/npcshopItem.ExportJson")
	self.itemBg = self:seekNodeByName("Image_27")
	self.goodsname = self:seekNodeByName("goodsname")
	self.coinnumber = self:seekNodeByName("coinnumber")
	self.surplus_0 = self:seekNodeByName("surplus_0")
	self.surplus = self:seekNodeByName("surplus")
	self.coin = self:seekNodeByName("coin")
	self.coin_0 = self:seekNodeByName("coin_0")
	self.coinnumber:setTouchEnabled(false)
	self.goodsname:setTouchEnabled(false)
	self.lv = self:seekNodeByName("lv")
	self.career = self:seekNodeByName("carrer")
	self.desc = self:seekNodeByName("desc")
	self.scroe = self:seekNodeByName("scroe")
	self.btnRedu = self:seekNodeByName("btnRedu_0")
	self.btnAdd = self:seekNodeByName("btnAdd_0")
	self.btnbuy = self:seekNodeByName("btnbuy_0")
	self.totalMoney = self:seekNodeByName("totalMoney")

	self.buyNumbg = self:seekNodeByName("Image_69_0")
    self.buynumber  = cc.ui.UIInput.new({
    		align = cc.TEXT_ALIGNMENT_CENTER,
    		valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
          UIInputType = 1,
          size = cc.size(40,32),
          listener = handler(self,self.onEdit),
          image = "common/input_opacity1Bg.png"
    })
    --self.buynumber:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    self.buynumber:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
    self.buynumber:setReturnType(1)
    self.buynumber:setFontSize(16)
    self.buynumber:setAnchorPoint(0, 0)
    self.buynumber:setPosition(10, 0)
    self.buyNumbg:addChild(self.buynumber)
    self.curBuyNum = 1
    --增加按钮
    self.btnAdd:setTouchEnabled(true)
    self.btnAdd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnAdd:setScale(1.1)
            SoundManager:playClickSound()
            --self.ctl:start(.5, true)
        elseif event.name == "ended" then
            self.btnAdd:setScale(1.0)
            --if not self.ctl:stop() then
                self.curBuyNum = self.curBuyNum+1
                self:updateBuyInfo()
           -- end
        end     
        return true
    end)

    --减少按钮
    self.btnRedu:setTouchEnabled(true)
    self.btnRedu:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnRedu:setScale(1.1)
            SoundManager:playClickSound()
            --self.ctl:start(.5, false)
        elseif event.name == "ended" then
            self.btnRedu:setScale(1.0)
            --if not self.ctl:stop() then
               self.curBuyNum = self.curBuyNum-1
                if self.curBuyNum <=0 then
                  self.curBuyNum = 1
                end
                self:updateBuyInfo()
            --end
        end     
        return true
    end)
   
    self.btnbuy:setTouchEnabled(true)
    self.btnbuy:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnbuy:setScale(1.1)
        elseif event.name == "ended" then
            self.btnbuy:setScale(1)
            --发送购买商城物品协议
            if self.vo == nil then
                return
            end
            if self.curBuyNum > self.max then
            	GlobalAlert:showTips("金币或元宝不足")
                return
            end
            local sendData = {
                id = self.vo.key,
                num = self.curBuyNum
            }
            GameNet:sendMsgToSocket(16001, sendData)
            
        end
        return true
    end)

	self.root:setPosition(-425,-50)
	self:setItemVo(vo)
end



function NpcBuyWinItem:onEdit(event, editbox)
    if event == "changed" then
        --if device.platform == "ios" then
            local checkText = editbox:getText()
            local text = string.gsub(checkText,"[\\.]", "")
            local count = tonumber(text, 10) or 1
            self.curBuyNum = count
            if count > self.max then
                count = self.max
            end
            if count < 1 then
                count = 1
            end
            if checkText ~= text or self.curBuyNum ~= count then
                editbox:setText(tostring(count))
            end
            self:updatePrize(count * self.vo.price)
            self.curBuyNum = count
        --end
    end
end

function NpcBuyWinItem:updateMaxNum()
	self.max = math.floor(RoleManager:getInstance().wealth.coin / self.vo.price)
end


function NpcBuyWinItem:updateBuyInfo()
    if self.curBuyNum > self.max then
        self.curBuyNum = self.max
    end
    if self.curBuyNum < 1 then
        self.curBuyNum = 1
    end
    self.buynumber:setText(self.curBuyNum)
    self:updatePrize(self.curBuyNum * self.vo.price)
end

function NpcBuyWinItem:updatePrize(value)
    self.totalMoney:setString("总价:"..value)
end


--vo = {"key", "type", "goods_id", "is_bind", "num", "curr_type", "price"}
function NpcBuyWinItem:setItemVo(vo)
	if self.goods_id ~= vo.goods_id then
		self.goods_id = vo.goods_id
		if self.itemPic == nil then
			self.itemPic = CommonItemCell.new()
			self.itemPic:setBgVisible(true)
			self.itemBg:addChild(self.itemPic,200)
			--self.itemPic:setTouchEnabled(false)
			self.itemPic:setTouchSwallowEnabled(true)
			--self.itemPic:setData({goods_id=110060})
			-- local px,py = self.itemBg:getPosition()
			self.itemPic:setPosition(38,38)
		end
		self.itemPic:setData({goods_id=vo.goods_id})
	 	self.goodsConfig = configHelper.getInstance():getGoodsByGoodId(vo.goods_id)
		self.goodsname:setString(self.goodsConfig.name)

		self.desc:setString( self.goodsConfig.describe)
	    self.career:setString(RoleCareerName[ self.goodsConfig.limit_career] or "")
	    if self.goodsConfig.limit_career == RoleManager:getInstance().roleInfo.career then
	    	self.career:setColor(cc.c3b(16, 222, 28))
	    else
	    	self.career:setColor(cc.c3b(222, 36, 16))
	    end
	    local equip = EquipUtil.formatEquipItem({goods_id = vo.goods_id})
	    self.scroe:setString("评分:"..equip.fighting)
	end
	self.itemPic:setCount(vo.num)
	self.coinnumber:setString(vo.price)
	self.lv:setString(self.goodsConfig.limit_lvl)

	if vo.curr_type == 1 then
		self.coin:setVisible(true)
		self.coin_0:setVisible(false)
	elseif vo.curr_type == 2 then
		self.coin:setVisible(false)
		self.coin_0:setVisible(true)
	end

	if vo.count then
		self.surplus_0:setVisible(true)
		self.surplus:setVisible(true)
		self.surplus:setString(vo.count)
	else
		self.surplus_0:setVisible(false)
		self.surplus:setVisible(false)
	end
	self.curBuyNum = 1

	self:updateMaxNum()
    self:updateBuyInfo()
end

function NpcBuyWinItem:getVo()
	return self.vo 
end

function NpcBuyWinItem:getGoodsConfig()
	return self.goodsConfig 
end

function NpcBuyWinItem:loadUI(jsonurl)
	self.root = cc.uiloader:load(jsonurl)
	self:addChild(self.root)
	--self.root:setPosition(display.width-960/2,display.height/2)
end

function NpcBuyWinItem:seekNodeByName(name)
	return cc.uiloader:seekNodeByName(self.root, name)
end	

function NpcBuyWinItem:destory()
	
end	

return NpcBuyWinItem