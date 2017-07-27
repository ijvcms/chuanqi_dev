--
-- Author: Yi hanneng
-- Date: 2016-01-26 09:54:03
--

--[[
充值界面：chargeWin
当前拥有元宝：coinown
VIP特权按钮：btnvip
当前VIP等级：viplvnow
VIP经验进度：progressbar
VIP经验值：vipexp
在充值元宝：chargenum
下一VIP等级：viplvnext
--]]
require("app.modules.vip.VipManager")
require("app.modules.recharge.RechargeManager")
local GameUILoaderUtils = import("app.utils.GameUILoaderUtils")
local RechargeView = RechargeView or class("RechargeView", BaseView)


function RechargeView:ctor(winTag,data,winconfig)
	RechargeView.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
    self.itemList = {}
    self:init()
    self.roleBaseAttEventId = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_ROLE_BASE_ATTR,handler(self,self.onUpdate))
	
end

--基础信息更新了
function RechargeView:onUpdate()
	self:setMainViewInfo()
	for _,v in pairs(self.itemList) do
	    v:setVipLevel(self.vipLv)
    end
end

--初始界面及绑定
function RechargeView:init()
    self.loader = GameUILoaderUtils.new()
	self.loader:AddUIEditorCache("resui/chargeWin_2.ExportJson")
	self.coinown = self:seekNodeByName("coinown")
	self.viplvnow = self:seekNodeByName("viplvnow")
	self.progressbarSP = self:seekNodeByName("progressbar")
	self.vipexp = self:seekNodeByName("vipexp")
	self.chargenum = self:seekNodeByName("chargenum")
	self.viplvnext = self:seekNodeByName("viplvnext")

	self.lbl1 = self:seekNodeByName("Label_13")
	self.lbl2 = self:seekNodeByName("Label_15")
	self.icon = self:seekNodeByName("Image_14")

	self.btnvipBtn = self:seekNodeByName("btnvip")
	
	self.mainLayer = self:seekNodeByName("mainLayer")
	--
	self.jadeLbl = display.newBMFontLabel({
    text = "0",
    font = "fonts/yellowNumber1.fnt",
  	}):addTo(self:getRoot())

  	self.rightVipLbl = display.newBMFontLabel({
    text = "0",
    font = "fonts/yellowNumber1.fnt",
  	}):addTo(self:getRoot())

  	self.leftVipLbl = display.newBMFontLabel({
    text = "0",
    font = "fonts/yellowNumber1.fnt",
  	}):addTo(self:getRoot())

 	self.jadeLbl:setAnchorPoint(0,0.5)
  	self.rightVipLbl:setAnchorPoint(0,0.5)
  	self.leftVipLbl:setAnchorPoint(0,0.5)

  	self.jadeLbl:setPosition(self.coinown:getPositionX()+5, self.coinown:getPositionY() - 5 )
  	self.rightVipLbl:setPosition(self.viplvnow:getPositionX(), self.viplvnow:getPositionY() - 5 )
  	self.leftVipLbl:setPosition(self.viplvnext:getPositionX(), self.viplvnext:getPositionY() - 5 )

  	local layer = cc.Node:create()
  	layer:setAnchorPoint(0,0)
  	 self.scrollView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.mainLayer:getContentSize().width,self.mainLayer:getContentSize().height)})
        :addScrollNode(layer)   
        :addTo(self.mainLayer)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)

    self.scrollView:setPosition(2,0)
    self.scrollView:setTouchSwallowEnabled(false)

	display.addSpriteFrames("resui/chargeWin0.plist", "resui/chargeWin0.png")
	local config = RechargeManager:getInstance():getList()
 	local channelId = ChannelAPI:getChannelId()

 	if config then
		for i=#config,1,-1 do
			if config[i].rmb == 328 then
				table.remove(config,i)
				break
			end
		end
	end

	if #config > 1 then
		table.sort(config,function(a,b) return a.number < b.number end )
	end

 	local w = 0
 	local h = 0
	if config then
		local vipLv = RoleManager:getInstance().roleInfo.vip
		for i=1,#config do
			local item = require("app.modules.recharge.RechargeItem").new(self.loader)
			config[i].finish = false
			item:setVipLevel(vipLv)
			item:setData(config[i])
			item:setItemClick(handler(self,self.itemClick))
			layer:addChild(item)
			w = item:getContentSize().width + 4
			h = item:getContentSize().height + 10
			item:setPosition(((i-1)%4)*w+6,h*math.ceil(#config/4) - math.ceil((i)/4)*h+8)
		
			self.itemList[config[i].key] = item
		end
	end

	layer:setContentSize(cc.size(w*4, h*math.ceil(#config/4)))
	layer:setPosition(0, 0)
	--self.scrollView:scrollAuto()
	--self.progressbarSP:setPercent(0)
	self:addEvent()

end
--设置界面信息
function RechargeView:setViewInfo(data)

	if not data then return end

	self:setMainViewInfo()
 	data = data.data
	for i=1,#data.key_list do
		local item = self.itemList[data.key_list[i]]
		if item then
			local info = item:getData()
		    info.finish = true
		    self.itemList[data.key_list[i]]:setData(info)
		end
		
	end

	

end

function RechargeView:setMainViewInfo()
	local preVipLv = self.vipLv
	self.vipLv = RoleManager:getInstance().roleInfo.vip
	self:showVip8Win(preVipLv, self.vipLv)
	self.career = RoleManager:getInstance().roleInfo.career
	self.viplist = VipManager:getInstance():getVipInfoList()
	if self.vipLv == #self.viplist then
		  self.nextLevelData = self.viplist[self.vipLv]
	else
		self.nextLevelData = self.viplist[self.vipLv + 1]
	end
	self.preLevelData = self.viplist[self.vipLv]
	self.jadeLbl:setString(RoleManager:getInstance().wealth.jade)

	self.vipexp:setString(RoleManager:getInstance().roleInfo.vip_exp.."/"..self.nextLevelData.exp)
  	self.chargenum:setString(self.nextLevelData.exp - RoleManager:getInstance().roleInfo.vip_exp)
  	self.progressbarSP:setPercent((RoleManager:getInstance().roleInfo.vip_exp - self.preLevelData.exp)/(self.nextLevelData.exp - self.preLevelData.exp)*100)

  	self.rightVipLbl:setString(self.vipLv)
  	self.leftVipLbl:setString(self.vipLv + 1)

  	if self.vipLv == #self.viplist then
   
	    self.chargenum:setVisible(false)
	    self.progressbarSP:setPercent(100)

	    self.lbl1:setVisible(false)
		self.lbl2:setVisible(false)
		self.icon:setVisible(false)
		self.viplvnext:setVisible(false)
		self.leftVipLbl:setVisible(false)
 
  	end	
end

--达到Vip8显示
function RechargeView:showVip8Win(previousVip, currentVip)
	if  previousVip ~= nil and previousVip < 8 and currentVip >= 8 then
		self.tipWin = cc.uiloader:load("resui/RechargeTipsWin.ExportJson")
		local confirmBtn = cc.uiloader:seekNodeByName(self.tipWin, "confirmBtn")
		confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
                confirmBtn:setScale(1.2, 1.2)
            elseif event.name == "ended" then
                confirmBtn:setScale(1, 1)
                self:closeVip8Win()
            end     
            return true
        end)
        local closeBtn = cc.uiloader:seekNodeByName(self.tipWin, "closeBtn")
        closeBtn:setTouchEnabled(true)
		closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
                closeBtn:setScale(1.2, 1.2)
            elseif event.name == "ended" then
                closeBtn:setScale(1, 1)
                self:closeVip8Win()
            end     
            return true
        end)
		self:addChild(self.tipWin)
	end
end

function RechargeView:closeVip8Win()
	self.tipWin:removeSelf()
end

function RechargeView:addEvent()

	self.btnvipBtn:setTouchEnabled(true)
    self.btnvipBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnvipBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnvipBtn:setScale(1.0)
            GlobalWinManger:openWin(WinName.VIPWIN) 
        end     
        return true
    end)

end

function RechargeView:itemClick(item)
	if not item then return end
	local tipTxt  = "确定要充值"..item:getData().jade.."元宝？"
	--月卡特殊处理
	if item:getData().key == 1 then
		tipTxt  = "确定要购买月卡？"
	end
          
    GlobalMessage:alert({
	    enterTxt = "确定",
	    backTxt= "取消",
	    tipTxt = tipTxt,
	    enterFun = function() 
	    	--开始充值统计
--	        local orderId, name, price = GlobalAnalytics:beginPay(item)--订单号
		dump(item:getData())
            RechargeManager:getInstance():setChargeItemData(item:getData())
	        GameNet:sendMsgToSocket(30001,{key = item:getData().key, order_id = ""}) 

	    end,
	    tipShowMid = true,
    })
	
end

function RechargeView:open()
	GlobalEventSystem:addEventListener(RechargeEvent.RECHARGE_LIST,handler(self,self.setViewInfo))
 
	GameNet:sendMsgToSocket(30002)
end

function RechargeView:close()
	GlobalEventSystem:removeEventListener(RechargeEvent.RECHARGE_LIST)
end

function RechargeView:destory()
	self:close()
	if self.itemList then
		for k,v in pairs(self.itemList) do
			v:destory()
		end
	end
	self.itemList = {}
	RechargeView.super.destory(self)
	GlobalEventSystem:removeEventListenerByHandle(self.roleBaseAttEventId)
	self.roleBaseAttEventId = nil
	if self.tipWin then
		self:removeSpriteFrames("resui/RechargeTipsWin.ExportJson")
	end
	if self.loader then
		self.loader:Clear()
		self.loader = nil
	end
	ArmatureManager:getInstance():unloadEffect("shiningEffect")
end

return RechargeView