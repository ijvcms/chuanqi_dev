--
-- Author: Yi hanneng
-- Date: 2016-01-22 14:47:32
--

--[[
close：关闭按钮
loading：VIP经验进度条框
ProgressBar_4：VIP经验进度条内容
scale：VIP经验进度条上的数字刻度
recharge：充值按钮
rechargenumber：再充值XXX元宝即可成为。XXX是升级还需元宝数量，需要根据位数不同调整位置。XXX颜色使用FFF29E19.
vip1number:上方VIP数字变动。 
attribute：vip属性框
vipname：VIP等级属性。
at:职业的攻击属性，战士物理攻击，法师魔法攻击，道士道术攻击。
atnumber：攻击属性数字，包括最小和最大攻击。
def:物理防御
defnumber：物防数字，包括最小和最大。
res:魔法防御
resnumber：物防数字，包括最小和最大。
hp:生命
hpnumber：生命数字
mp:生命
mpnumber：生命数字
goods1-goods4：物品框
vip2number: 下方vip数字 
vipbtn1：左上vip图标，1-15级
viplist ：vip列表框
vip3number：中间vip数字
jade：累计充值元宝数量。
text : 特权文本
receive:【可领取】状态。还有【未达成】，【已领取】，都是使用灰色的按钮。 
 
--]]
require("app.modules.vip.VipManager")
local VipView = VipView or class("VipView", BaseView)

function VipView:ctor(winTag,data,winconfig)
	VipView.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
	self.itemList = {}
	self.nextLevelData = {}
    self.clickInfo = nil
    self.effectList = {}
	self.preLevelData = {}
	self.currentLevelExp = 0
    GlobalEventSystem:addEventListener(VipEvent.VIP_STATE,handler(self,self.setState))
    GlobalEventSystem:addEventListener(VipEvent.VIP_RECEIVE,handler(self,self.receiveSuccess))

    self.vipLv = RoleManager:getInstance().roleInfo.vip
    self.career = RoleManager:getInstance().roleInfo.career
    self.viplist = VipManager:getInstance():getVipInfoList()
    self.showLv = self.vipLv
    if data.tab then
        self.showLv = data.tab
    end
    self.vipbtn1 = self:seekNodeByName("vipbtn1")
    self.vipbtn2 = self:seekNodeByName("vipbtn2")
	 
  	self.progressBar = self:seekNodeByName("ProgressBar_4")
  	self.scale = self:seekNodeByName("scale")

    self.recharge = self:seekNodeByName("recharge")

    self.vipLabel =  self:seekNodeByName("vip3")
    self.vipNum = display.newBMFontLabel({
        text = "0",
        font = "fonts/yellowNumber1.fnt",
    })
    self.vipNum:setPosition(self.vipLabel:getPositionX() + (self.vipLabel:getContentSize().width + self.vipNum:getContentSize().width) / 2, self.vipLabel:getPositionY() + (self.vipLabel:getContentSize().height - self.vipNum:getContentSize().height) / 2)
    self:getRoot():addChild(self.vipNum)

    self.vipTitle = self:seekNodeByName("vipTitle")
    self.receiveLbl = self:seekNodeByName("Label_8")
    self.receive = self:seekNodeByName("receive")

    self.Layer1 = self:seekNodeByName("Layer1")
    self.Layer2 = self:seekNodeByName("Layer2")
    self.Layer3 = self:seekNodeByName("Layer3")
    self.Layer4 = self:seekNodeByName("Layer4")
    self.Layer5 = self:seekNodeByName("Layer5")
    self.Layer6 = self:seekNodeByName("Layer6")

    self.goods1 = cc.uiloader:seekNodeByName(self.Layer1, "goods1")
    self.goods2 = cc.uiloader:seekNodeByName(self.Layer2, "goods2")
    self.goods3 = cc.uiloader:seekNodeByName(self.Layer3, "goods3")
    self.goods4 = cc.uiloader:seekNodeByName(self.Layer4, "goods4")
    self.goods5 = cc.uiloader:seekNodeByName(self.Layer5, "goods5")

    self.Label1 = cc.uiloader:seekNodeByName(self.Layer1, "Label1")
    self.Label2 = cc.uiloader:seekNodeByName(self.Layer2, "Label2")
    self.Label3 = cc.uiloader:seekNodeByName(self.Layer3, "Label3")
    self.Label4 = cc.uiloader:seekNodeByName(self.Layer4, "Label4")
    self.Label5 = cc.uiloader:seekNodeByName(self.Layer5, "Label5")

    self.vipBtn = cc.uiloader:seekNodeByName(self.Layer6, "vipBtn")
    self.buffName = cc.uiloader:seekNodeByName(self.Layer6, "buffName")
    self.popupWin = self:seekNodeByName("attribute")
    self.nameImg = self:seekNodeByName("nameImg")
    
    local leftLayer = self:seekNodeByName("leftLayer")
    local size  = leftLayer:getContentSize()
    self.listView = cc.ui.UIListView.new {
        viewRect = cc.rect(0,4,size.width, size.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(leftLayer)

    self.textLayer = self:seekNodeByName("textLayer")

    self:initView()
    self:addEvent()
    self.isCancelRemoveSpriteFrams = true
    
end

function VipView:initView()
    for i=1, #self.viplist do
        local item = self.listView:newItem()
        local content = require("app.modules.vip.VipItem").new(self.viplist[i])
        item:addContent(content)
        item:setItemSize(content:getContentSize().width, content:getContentSize().height)
        self.itemList[i] = content
        self.listView:addItem(item)
    end
    self.listView:reload()
    local size = self.textLayer:getContentSize()
    for i = 1, 10 do
        local textLabel = SuperRichText.new(nil, size.width)
        textLabel:setPosition(0, size.height - i * 22)
        self.textLayer:addChild(textLabel)
        self["text"..i] = textLabel
    end
    self.progressBar:setPercent(0)
    self.scale:setString("0/0")
end



function VipView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        local item =self.itemList[event.itemPos]
        for i=1,#self.itemList do
            self.itemList[i]:setSelected(false)
        end
        item:setSelected(true)
        self.clickInfo = item:getData()
        self.showLv = self.clickInfo.lv
        GlobalController.vip:getVipInfo(self.showLv)
 
    end
end

function VipView:addEvent()

	self.recharge:setTouchEnabled(true)
  	self.recharge:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.recharge:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.recharge:setScale(1.0)
            --GameNet:sendMsgToSocket(29006, {vip_exp = 100 })
            GlobalWinManger:openWin(WinName.RECHARGEWIN) 
        end     
        return true
    end)

    self.receive:setTouchEnabled(true)
  	self.receive:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.receive:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.receive:setScale(1.0)
           	GameNet:sendMsgToSocket(29002, {vip_lv = self.showLv })
        end     
        return true
    end)
     
    self.vipBtn:setTouchEnabled(true)
    self.vipBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.vipBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.vipBtn:setScale(1.0)
            self.popupWin:setVisible(true)
            self:initPopupWin()
        end     
        return true
    end)
end

function VipView:initPopupWin()
    if nil ~= self.at then
        return
    end
    self.at =  cc.uiloader:seekNodeByName(self.popupWin, "at")
    self.atnumber = cc.uiloader:seekNodeByName(self.popupWin, "atnumber")
    self.defnumber = cc.uiloader:seekNodeByName(self.popupWin, "defnumber")
    self.resnumber = cc.uiloader:seekNodeByName(self.popupWin, "resnumber")
    self.hpnumber = cc.uiloader:seekNodeByName(self.popupWin, "hpnumber")
    self.mpnumber = cc.uiloader:seekNodeByName(self.popupWin, "mpnumber")
    self.vipname = cc.uiloader:seekNodeByName(self.popupWin, "vipname")
    self.confirmBtn = cc.uiloader:seekNodeByName(self.popupWin, "confirmBtn")
    self.confirmBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.confirmBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.confirmBtn:setScale(1.0)
            self.popupWin:setVisible(false)
        end     
        return true
    end)
    self:setPopupWin()
end


function VipView:setPopupWin()
    if nil == self.at then
        return
    end
    local data = self.viplist[self.showLv]
    self.vipname:setString(data.buff_name)
    if self.career == 1000 then
        self.at:setString("物攻:")
        self.atnumber:setString(data.min_ac.."-"..data.max_ac)
    elseif self.career == 2000 then
        self.at:setString("魔攻:")
        self.atnumber:setString(data.min_mac.."-"..data.max_mac)
    elseif self.career == 3000 then
        self.at:setString("道攻:")
        self.atnumber:setString(data.min_sc.."-"..data.max_sc)
    end
    self.defnumber:setString(data.min_def.."-"..data.max_def)
    self.resnumber:setString(data.min_res.."-"..data.max_res)
    self.hpnumber:setString((data.hp_p/100).."%")
    self.mpnumber:setString((data.mp_p/100).."%")
end

function VipView:open()
	if self.vipLv == #self.viplist then
		self.nextLevelData = self.viplist[self.vipLv]
	else
		self.nextLevelData = self.viplist[self.vipLv + 1]
	end
	
    self.clickInfo = self.viplist[self.vipLv]

	self.preLevelData = self.viplist[self.vipLv]
    if self.showLv == 0 then
        self.showLv = 1 
        self.clickInfo = self.viplist[self.showLv]
    end
    GlobalController.vip:getVipInfo(self.showLv)
    self:setNavInfo()
    self:setCenterInfo()
    self:scrollNav()
end

function VipView:scrollNav()
    if self.showLv > 8 then
        local maxH = self.listView.scrollNode:getContentSize().height
        local pos = self.itemList[self.showLv - 1]:getPositionY()
        if pos > maxH then
            pos = maxH
        end
        self.listView:scrollTo(0, -pos)
    end
end

function VipView:setNavInfo()
    self.vipbtn1:setSpriteFrame("vip_icon"..self.vipLv..".png")
    self.itemList[self.showLv]:setSelected(true)
    if self.vipLv == #self.viplist then
        if self.topTip ~= nil then
            self.topTip:setVisible(false)
        end
        
        self.progressBar:setPercent(100)
        self.vipbtn2:setVisible(false)
    else
        self.vipbtn2:setVisible(true)
        self.vipbtn2:setSpriteFrame("vip_icon"..(self.vipLv + 1)..".png")
    end
end

function VipView:close()
    self.buffEffectId = nil
    self.modelId = nil 
	GlobalEventSystem:removeEventListener(VipEvent.VIP_STATE)
	GlobalEventSystem:removeEventListener(VipEvent.VIP_RECEIVE)
    for k,v in pairs(self.effectList or {}) do
        ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(ResUtil.getEffect(v))
    end
    self.effectList = {}
end

function VipView:destory()
    self:close()
    self.super.destory(self)
end

function VipView:setState(data)
    if not self.receive then return end

	if data.data.flag == 0  then
		self.receive:setTouchEnabled(true)
		self.receive:setSpriteFrame("com_labBtn2.png")
		self.receiveLbl:setString("可领取")
		self.receiveLbl:setColor(cc.c3b(231, 211, 173))
	else
		self.receive:setTouchEnabled(false)
		self.receive:setSpriteFrame("com_labBtn2.png")
		self.receiveLbl:setString("未达成")
		self.receiveLbl:setColor(cc.c3b(255, 255, 255))
		if data.data.flag == 6001 then
			self.receiveLbl:setString("已领取")
		end
	end
 
	  self.currentLevelExp = data.data.exp
    if self.topTip == nil then
        local barBg = self:seekNodeByName("loading")
        self.topTip = SuperRichText.new()
        self.topTip:setAnchorPoint(0.5, 0)
        self.topTip:setPosition(barBg:getPositionX(), barBg:getPositionY() - 40)
        self:getRoot():addChild(self.topTip)
    end
    --self.topTip:renderXml("<font color='0xffffff' size='20' opacity='255'>再充值<font color='0xFFF29E19' size='20' opacity='255'>"..(self.nextLevelData.exp - self.currentLevelExp).."元宝</font>成VIP"..(self.vipLv + 1).."</font>")
    
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    if self.clickInfo.lv > roleInfo.vip then
        self.topTip:renderXml("<font color='0xffffff' size='20' opacity='255'>再充值<font color='0xFFF29E19' size='20' opacity='255'>"..(self.clickInfo.exp - self.currentLevelExp).."元宝</font>成VIP"..self.clickInfo.lv.."</font>")
    else
        self.topTip:renderXml("<font color='0xffffff' size='20' opacity='255'>您已获得尊贵的<font color='0xFFF29E19' size='20' opacity='255'>VIP"..self.showLv.."</font>特权</font>")
    end

    self.scale:setString(self.currentLevelExp.."/"..self.nextLevelData.exp)
    self.progressBar:setPercent((self.currentLevelExp - self.preLevelData.exp)/(self.nextLevelData.exp- self.preLevelData.exp)*100)
    self:setNavInfo()
    self:setCenterInfo()
    self:setPopupWin()
end
 
--设置中间面板信息
function VipView:setCenterInfo()
    self.vipNum:setString(self.showLv)
    self.vipNum:setPosition(self.vipLabel:getPositionX() + (self.vipLabel:getContentSize().width + self.vipNum:getContentSize().width) / 2, self.vipLabel:getPositionY() + (self.vipLabel:getContentSize().height - self.vipNum:getContentSize().height) / 2)
    self.vipTitle:setString("VIP"..self.showLv.."特权")
    local data = self.viplist[self.showLv]
    local index = 1
    local strArray = string.split(data.text, "\n")
    while index <= #strArray do
        self["text"..index]:setVisible(true)
        self["text"..index]:renderXml(strArray[index])
        index = index + 1
    end
    while index <=  10 do
        self["text"..index]:setVisible(false)
        index = index + 1
    end
    index = 1

    while  index <= #data.goods do
        self["Layer"..index]:setVisible(true)
        local commonItem = self["goods"..index]:getChildByTag(10)
        if nil == commonItem then
			      commonItem = CommonItemCell.new()
            self["goods"..index]:addChild(commonItem, 10, 10)
            commonItem:setPosition(commonItem:getContentSize().width/2 , commonItem:getContentSize().height/2)
		    end
        local goodsId = data.goods[index][1]
		    commonItem:setData({goods_id = goodsId,is_bind = data.goods[index][2]})
		    commonItem:setCount(data.goods[index][3])
        self["Label"..index]:setString(configHelper:getGoodNameByGoodId(goodsId))
        index = index + 1
	end
    self.nameImg:setVisible(false)
    if nil ~= self.armature then
        self.armature:getAnimation():stop()
        self.armature:setVisible(false)
    end
    local showBuff = (data.buff_txt ~= nil and data.buff_txt ~= "")
    if not showBuff and index <= 5  then
        self.Layer1:setPosition(250+6, 235)
        self.Layer2:setPosition(453+6, 235)
        self.Layer3:setPosition(250+6, 70)
        self.Layer4:setPosition(453+6, 70)
        self.Label1:setVisible(true)
        self.Layer6:setVisible(false)
    else
        if showBuff then
            self.Layer6:setVisible(true)
            self.buffEffectId = data.buff
            ArmatureManager:getInstance():loadEffect(self.buffEffectId, handler(self, self.onLoadEffectCompleted))
            self.buffName:setSpriteFrame(data.buff_txt)
        else
            self.Layer6:setVisible(false)
        end
        
        if index <= 5 then -- 四个
            self.Layer6:setPosition(357+6, 234)
            self.Layer1:setPosition(197+6, 37)
            self.Layer2:setPosition(302+6, 37)
            self.Layer3:setPosition(407+6, 37)
            self.Layer4:setPosition(512+6, 37)
            self.Label1:setVisible(true)
            self.Layer5:setVisible(false)
            return
        end
        self.Label1:setVisible(false)
        if data.describe ~= nil and data.describe ~= "" then
            self.nameImg:setSpriteFrame(data.describe)
            self.nameImg:setVisible(true)
        end
        -- if data.goods[1][1] == 308001 then--坐骑
        --     self.Layer1:setPosition(88, 237)
        --     self.Layer6:setPosition(487, 237)
        --     if nil == self.armature then
        --         self.modelId = 9201
        --         ArmatureManager:getInstance():loadModel(self.modelId, handler(self, self.onLoadModelCompleted))
        --     else
        --         self.armature:getAnimation():play("stand_3")
        --         self.armature:setVisible(true)
        --     end
        -- else
            if not showBuff then
                self.Layer1:setPosition(287+6, 220)
            else
                self.Layer1:setPosition(248+6, 235)
            end
            self.Layer6:setPosition(457+6, 235)
        --end
        self.Layer2:setPosition(197+6, 37)
        self.Layer3:setPosition(302+6, 37)
        self.Layer4:setPosition(407+6, 37)
        self.Layer5:setPosition(512+6, 37)
    end

    while index <= 5 do
        self["Layer"..index]:setVisible(false)
        index = index + 1
    end
    
    

end

-- function VipView:onLoadModelCompleted(armatureData, mid)
--     if self.modelId == nil then
--         return
--     end
--     if self.showLv ~= #self.viplist then
--         return
--     end
--     if self.armature then
--         return
--     end
--     self.armature = ccs.Armature:create(mid)
--     self.armature:setScale(1.3)
--     self.armature:setPosition(276, 180)
--     self.itemLayer:addChild(self.armature)
--     self.armature:getAnimation():play("stand_3")
-- end

function VipView:onLoadEffectCompleted(effectID)
    if self.isDestory then return end
    self.effectList[effectID] = effectID
    if self.buffEffectId == nil then
        return 
    end
    if self.bufArmature then
        self.bufArmature:removeSelf()
    end
    self.bufArmature = ccs.Armature:create(effectID)
    local size = self.vipBtn:getContentSize()
    self.bufArmature:setPosition(size.width / 2, size.height / 2)
    self.vipBtn:addChild(self.bufArmature)
    self.bufArmature:getAnimation():play("effect")
end

--领取成功
function VipView:receiveSuccess()
	self.receive:setTouchEnabled(false)
	self.receive:setSpriteFrame("com_labBtn2.png")
	self.receiveLbl:setColor(cc.c3b(255, 255, 255))
	self.receiveLbl:setString("已领取")
end

return VipView