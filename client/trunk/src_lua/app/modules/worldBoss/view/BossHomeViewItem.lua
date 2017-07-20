--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-02-21 17:22:55
-- boss之家item 243 112

local BossHomeViewItem = BossHomeViewItem or class("BossHomeViewItem", BaseView)

function BossHomeViewItem:ctor(data)
	self.data = data
	self.ccui = cc.uiloader:load("resui/bossHomeItem2.ExportJson")
  	self:addChild(self.ccui)
  	self.ccui:setPosition(0,0)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function BossHomeViewItem:init()
	self.nameLabel = cc.uiloader:seekNodeByName(self.ccui, "nameLabel")
	self.headFrame = cc.uiloader:seekNodeByName(self.ccui, "headFrame")
	self.lvLabel = cc.uiloader:seekNodeByName(self.ccui, "lvLabel")
	self.killLabel = cc.uiloader:seekNodeByName(self.ccui, "killLabel")
	self.existLabel = cc.uiloader:seekNodeByName(self.ccui, "existLabel")
	self.headIcon = cc.uiloader:seekNodeByName(self.ccui, "headIcon")
	self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
	self.bgSel = cc.uiloader:seekNodeByName(self.ccui, "bgSel")
	self.bgSel:setVisible(false)
	self.killLabel:setVisible(false)
	self.existLabel:setVisible(false)
	self:open()
end


function BossHomeViewItem:open()
	if self.data then
	 	local bossConf = getConfigObject(self.data.boss_id,MonsterConf)
	 	self.nameLabel:setString(bossConf.name)
	 	self.headimg = display.newSprite("res/icons/worldBoss/"..bossConf.resId..".png")
	 	self.headimg:setScale(0.8)
	 	--self.headimg:setPosition(64,50)
    	self.headIcon:addChild(self.headimg)
	 	self.lvLabel:setString(bossConf.lv)
	 	--self.killLabel:setVisible(true)
	 	--self.existLabel:setVisible(true)
	end
end

function BossHomeViewItem:updateTime(time)
	if time > 0 then
		self.killLabel:setVisible(true)
	 	self.existLabel:setVisible(false)
	else
		self.killLabel:setVisible(false)
	 	self.existLabel:setVisible(true)
	end
	--GlobalController.boss:requestGZBoss(self.currentSelectData.scene_id,self.currentSelectData.boss_id,1)
end

function BossHomeViewItem:setSelect(b)
	if b then
		self.bgSel:setVisible(true)
	else
		self.bgSel:setVisible(false)
	end

end

function BossHomeViewItem:getData()
	return self.data
end

function BossHomeViewItem:close()

end


function BossHomeViewItem:destory()
	self:close()
	BossHomeViewItem.super.destory(self)
end


return BossHomeViewItem
