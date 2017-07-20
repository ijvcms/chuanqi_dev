--
-- Author: Yi hanneng
-- Date: 2016-01-26 10:08:02
--

--[[
下载奖励界面：downloadWin_1
物品1-4：goods1 goods2 goods3 goods4
物品5-8：goods5  goods6 goods7 goods8
领取按钮：btnget1 btnget2
关闭按钮：close
--]]

require("app.modules.downloadReward.DLRewardManager")

local DLRewardView = DLRewardView or class("DLRewardView", BaseView)

function DLRewardView:ctor(winTag,data,winconfig)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
	self.bg:setContentSize(display.width, display.height)
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
	self:addChild(self.bg)
	--self:creatPillar()
	DLRewardView.super.ctor(self,winTag,data,winconfig)

    self.currentClickLv= nil
    self.btnList = {}
	
    local root = self:getRoot()
    root:setPosition((display.width-root:getContentSize().width)/2,(display.height-root:getContentSize().height)/2)

    self:init()

end

function DLRewardView:init()
 
	local list = DLRewardManager:getInstance():getList()

	if list then
		for i=1,#list do
			local commonItem = CommonItemCell.new()
			commonItem:setData({goods_id = list[i][1], is_bind = list[i][2]})
			commonItem:setCount(list[i][3])
			self:seekNodeByName("goods"..i):addChild(commonItem, 10,10)
			--commonItem:setItemClickFunc(handler(self,self.equipClick))
			commonItem:setPosition(commonItem:getContentSize().width/2 + 1, commonItem:getContentSize().height/2 + 2)
			commonItem:setScale(0.8)
		end
	end

	self.closeBtn = self:seekNodeByName("close")
	self.btnget1 = self:seekNodeByName("btnget1")
	self.btnget2 = self:seekNodeByName("btnget2")

    self.btnList[30] = self.btnget1
    self.btnList[50] = self.btnget2

    self.btnList[30].state = 0
    self.btnList[50].state = 0
	
	self:addEvent()
end

function DLRewardView:setViewInfo(data)

	data = data.data
    for k,v in pairs(self.btnList) do
        if k >  GlobalModel.downPackageLv then
            --状态改为前往下载
            v.state = 1
            v:setButtonLabelString("normal","前往下载")
        end
    end

	for i=1,#data.list do
        local item = self.btnList[data.list[i]]
        item:setTouchEnabled(false)
        item.state = 2
        --状态改为已领取
        item:setButtonLabelString("normal","已领取")
    end

end

function DLRewardView:update()
    local item = self.btnList[self.currentClickLv]
    if item then
        item:setTouchEnabled(false)
        item:setButtonLabelString("normal","已领取")
        item.state = 2
        self.currentClickLv = nil
    end
    
end

function DLRewardView:addEvent()

	self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)


    for k,v in pairs(self.btnList) do
        if v.state ~= 2 then
            v:setTouchEnabled(true)
            v:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                v:setScale(1.1)
                SoundManager:playClickSound()
            elseif event.name == "ended" then
                v:setScale(1.0)
                if v.state == 0 then
                    --领取奖励
                    self.currentClickLv = k
                    GameNet:sendMsgToSocket(31002,{lv = k})
                elseif v.state == 1 then
                    --前往下载
                    print("前往下载")
                    LoadingPackageManager:checkToLoadPackage(k)
                end
            end     
            return true
            end)
        end
    end
 
end

function DLRewardView:open()
	GlobalEventSystem:addEventListener(DownLoadEvent.DOWENLOAD_LIST,handler(self,self.setViewInfo))
    GlobalEventSystem:addEventListener(DownLoadEvent.DOWENLOAD_REWARD_SUCCESS,handler(self,self.update))
    GameNet:sendMsgToSocket(31001)
end

function DLRewardView:close()
	GlobalEventSystem:removeEventListener(DownLoadEvent.DOWENLOAD_LIST)
    GlobalEventSystem:removeEventListener(DownLoadEvent.DOWENLOAD_REWARD_SUCCESS)
end

function DLRewardView:destory()
    self:close()
    DLRewardView.super.destory(self)
end

return DLRewardView
 