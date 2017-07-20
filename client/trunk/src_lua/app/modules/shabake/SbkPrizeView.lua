--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-15 18:46:02
-- 沙巴克奖励页面
local SbkPrizeView = class("SbkPrizeView", function()
	return display.newNode()
end)

-- 沙巴克奖励界面	
-- havereceived01Pic	屠龙已发放图标文字
-- havereceived02Pic	称号已发放图标文字
-- item01Bg	屠龙道具背景图
-- item02Bg	称号道具背景图
-- item03Bg	城主每日奖励图标1
-- item04Bg	城主每日奖励图标2
-- item06Bg	城主每日奖励图标3
-- item07Bg	副城主每日奖励图标1
-- item08Bg	副城主每日奖励图标2
-- item09Bg	副城主每日奖励图标3
-- item010Bg	长老每日奖励图标1
-- item11Bg	长老每日奖励图标1
-- item12Bg	长老每日奖励图标1
-- item13Bg	成员每日奖励图标1
-- item14Bg	成员每日奖励图标1
-- item15Bg	成员每日奖励图标1
-- Btn_receive01	屠龙领取按钮
-- Btn_receive02	称号领取按钮
-- Btn_receive03	称号领取按钮
-- Btn_receive03	城主每日奖励领取按钮
-- Btn_receive04	副城主每日奖励领取按钮
-- Btn_receive05	长老每日奖励领取按钮
-- Btn_receive06	成员每日奖励领取按钮

function SbkPrizeView:ctor(jsonurl, winName)
	self.jsonurl = jsonurl
	self.winName = winName
	self:initialization()
end

function SbkPrizeView:initialization()

	--display.addSpriteFrames("resui/shabakeawardWin0.plist", "resui/shabakeawardWin0.png")
	self:initComponents()
	self:initListeners()
	--self:invalidateRewards()

	-- Get info from server
	GameNet:sendMsgToSocket(25003)
end

function SbkPrizeView:initComponents()
	if self.jsonurl then
		self:loadUIFromJson()
		
		self:initButtons()
		self.tulong_owner_name = self:seekNodeByName("Label_uesrname01")
		self.frist_owner_name  = self:seekNodeByName("Label_uesrname02")
		self.title_owner_name  = self:seekNodeByName("Label_uesrname03")

		self.closeBtn = self:seekNodeByName("closeBtn")
		self.closeBtn:setTouchEnabled(true)
      self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
          if event.name == "began" then
              self.closeBtn:setScale(1.1)
          elseif event.name == "ended" then
              self.closeBtn:setScale(1)
              self:setVisible(false)
          end
          return true
      end)
	end
end

function SbkPrizeView:initListeners()
	self:registerGlobalEventHandler(ShaBaKeEvent.SBK_REWARDS_INFO, handler(self, self.onGetRewardsInfo))
end

--
-- 注册全局事件监听。
--
function SbkPrizeView:registerGlobalEventHandler(eventId, handler)
	local handles = self._eventHandles or {}
	handles[#handles + 1] = GlobalEventSystem:addEventListener(eventId, handler)
	self._eventHandles = handles
end

--
-- 移除对全局事件的监听。
--
function SbkPrizeView:removeAllEvents()
	if self._eventHandles then
		for _, v in pairs(self._eventHandles) do
			GlobalEventSystem:removeEventListenerByHandle(v)
		end
	end
end

function SbkPrizeView:open()
	self:setVisible(true)
end

function SbkPrizeView:close()
end

function SbkPrizeView:destory()
	self:removeAllEvents()
	self:removeSelf()
end


-- ------------------------------------------------------------------------------
-- 领取状态相关

function SbkPrizeView:onGetRewardsInfo(event)
	self._data = event.data.data
	self:invalidateRewardsInfo()
	self:invalidateButtons()
end

function SbkPrizeView:invalidateRewardsInfo()
	local data = self._data or {}

	local firstName  = data.frist_player_name
	local masterName = data.title_player_name
	local everyName = data.every_player_name
	--local mergeName = data.merge_player_name
	if firstName ~= "" then
		--self.cheked_tulong:setVisible(true)
		self.tulong_owner_name:setString(firstName)
	else
		--self.cheked_tulong:setVisible(false)
		self.tulong_owner_name:setString("【暂无】")
	end

	if everyName ~= "" then
		--self.cheked_title:setVisible(true)
		self.frist_owner_name:setString(everyName)
	else
		--self.cheked_title:setVisible(false)
		self.frist_owner_name:setString("【暂无】")
	end

	if masterName ~= "" then
		--self.cheked_title:setVisible(true)
		self.title_owner_name:setString(masterName)
	else
		--self.cheked_title:setVisible(false)
		self.title_owner_name:setString("【暂无】")
	end

end

-- ------------------------------------------------------------------------------
-- 按钮相关

function SbkPrizeView:invalidateButtons()

	self:disableAllButton()

	local data = self._data
	if not data then return end
	-- ---------------------------------------------
	-- 左侧屠龙领取按钮
	local isMaster = tonumber(data.isfrist) == 0
	self:enabledImageButton(self.btn_tulong, isMaster)
	if isMaster then
		self.btn_tulong:setVisible(true)
		self.btn_tulong:setButtonEnabled(true)
		self.btn_tulong:setButtonLabelString("领取")
	else
		self.btn_tulong:setVisible(false)
		self.btn_tulong:setButtonEnabled(false)
		--self.btn_tulong:setButtonLabelString("已领取")
	end


	local isexery = tonumber(data.isexery) == 0
	self:enabledImageButton(self.btn_title, isexery)

	if isexery then
		self.btn_title:setVisible(true)
		self.btn_title:setButtonEnabled(true)
		self.btn_title:setButtonLabelString("领取")
	else
		self.btn_title:setVisible(false)
		self.btn_title:setButtonEnabled(false)
		--self.btn_title:setButtonLabelString("已领取")
	end
end

function SbkPrizeView:initButtons()
	self.btn_tulong = self:seekNodeByName("Btn_receive01")
	self.btn_title  = self:seekNodeByName("Btn_receive02")

	self.btn_tulong:setTouchEnabled(true)
    self.btn_tulong:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_tulong:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_tulong:setScale(1.0)
            -- TODO 发送请求领取首次奖励
            GameNet:sendMsgToSocket(25004)
            self:disableAllButton()
        end
        return true
    end)

    self.btn_title:setTouchEnabled(true)
    self.btn_title:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btn_title:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btn_title:setScale(1.0)
            -- TODO 发送请求领取首次奖励
            GameNet:sendMsgToSocket(25008)
            self:disableAllButton()
        end
        return true
    end)

	self:disableAllButton()
end

function SbkPrizeView:disableAllButton()
	self:enabledImageButton(self.btn_tulong)
	self:enabledImageButton(self.btn_title)
end

function SbkPrizeView:enabledImageButton(target, enabled)
	target:setTouchEnabled(enabled)
end

function SbkPrizeView:loadUIFromJson()
	self.root = cc.uiloader:load(self.jsonurl)
	self:addChild(self.root)
end

function SbkPrizeView:seekNodeByName(name)
	return cc.uiloader:seekNodeByName(self.root, name)
end

return SbkPrizeView