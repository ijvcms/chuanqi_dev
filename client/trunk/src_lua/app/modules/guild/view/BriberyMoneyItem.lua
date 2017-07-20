--行会红包列表

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local BriberyMoneyItem =  class("RecordItem", UIAsynListViewItemEx)


function BriberyMoneyItem:ctor(loader, layoutFile)
	self.root = loader:BuildNodesByCache(layoutFile)
	self:addChild(self.root)
	self:setContentSize(self.root:getContentSize())
	self:initComponents()
end

function BriberyMoneyItem:initComponents()
	self.flag =  cc.uiloader:seekNodeByName(self.root, "none") --红包状态标签
	self.describe = cc.uiloader:seekNodeByName(self.root, "describe") --红包描述
	self.count = cc.uiloader:seekNodeByName(self.root, "number") --红包数量
	self.describe2 = cc.uiloader:seekNodeByName(self.root, "describe2") --红包留言
end

--guildmoney_qg：已抢光
--guildmoney_ylq：已领取
--职位:0非会员,1会长,2长老,3会员
--红包当前状态  0正常，1，已结领取过了，2，已结领取完了
function BriberyMoneyItem:setData(params)
	self.data = params
	local t = "会员"
	if params.position == 1 then
		t = "会长"
	elseif params.position == 2 then
		t = "长老"
	end
	self.describe:setString(t .. "【"..params.name.."】")
	dump(params)
	self.describe2:setString(params.des)
	self.count:setString(tostring(params.num))
	if params.state == 0 then
		self.flag:setVisible(false)
	elseif params.state == 1 then
		self.flag:setVisible(true)
		self.flag:setSpriteFrame("guildmoney_ylq.png")
	else
		self.flag:setVisible(true)
		self.flag:setSpriteFrame("guildmoney_qg.png")
	end
end

function BriberyMoneyItem:setState(state)
	self.data.state = state
	if state == 0 then
		self.flag:setVisible(false)
	elseif state == 1 then
		self.flag:setVisible(true)
		self.flag:setSpriteFrame("guildmoney_ylq.png")
	else
		self.flag:setVisible(true)
		self.flag:setSpriteFrame("guildmoney_qg.png")
	end
end

function BriberyMoneyItem:getData()
	return self.data
end

return BriberyMoneyItem

