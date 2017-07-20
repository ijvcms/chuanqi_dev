--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-08-17 14:33:21
-- 副本奖励面板
local CopyPrizeView = class("CopyPrizeView", BaseView)
function CopyPrizeView:ctor(winTag,data,winconfig)
	self.data = data
	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
	self:addChild(self.bg)
	
	CopyPrizeView.super.ctor(self,winTag,data,winconfig)
	-- self.root = cc.uiloader:load("resui/storyInstanceWin.ExportJson")
	-- self:addChild(self.root)

    self.root:setPosition((display.width-590)/2,(display.height-480)/2+50)

    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
           	GlobalWinManger:closeWin(WinName.COPYPRIZETIPS)
        end
        return true
    end)

    self.goBtn = self:seekNodeByName("goBtn")
    self.goBtn:setTouchEnabled(true)
    self.goBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.goBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.goBtn:setScale(1)
            if self.data.sendtype == 1 then
                GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(self.data.sceneId)})
            elseif self.data.sendtype == 2 then
                if GameSceneModel.sceneId == tonumber(self.data.sceneId) then
                    GlobalAlert:show("已在场景中！")
                else
                     GameNet:sendMsgToSocket(11024,{id = tonumber(self.data.id)})
                end
            end
            GlobalWinManger:closeWin(WinName.COPYPRIZETIPS)
        end
        return true
    end)

    self.item1 = self:seekNodeByName("item1")
    self.item2 = self:seekNodeByName("item2")
    self.item3 = self:seekNodeByName("item3")
    self.item4 = self:seekNodeByName("item4")
    self.win = self:seekNodeByName("win")
    self.prizeListItem = {}
end


function CopyPrizeView:open()
	local sceneConfig = getConfigObject(self.data.sceneId,ActivitySceneConf)
	local tips = sceneConfig.story_dec or ""
	local prizeList = sceneConfig.story_reward or {}
	local lab = SuperRichText.new("<font color='0x00EE00' size='20' opacity='255'>"..tips.."</font>")
    lab:setPosition(50,312)
    self.win:addChild(lab)
    for i=1,4 do
	    --for i=1,10 do
	    if prizeList[i] then
	        local item = CommonItemCell.new()
	        self.win:addChild(item)
	        item:setData({goods_id = prizeList[i][1], is_bind = prizeList[i][2], num = prizeList[i][3]})
	        item:setCount(prizeList[i][3])
	        local ix,iy = self["item"..i]:getPosition()
	        item:setPosition(ix,iy)
	        self.prizeListItem[i] = item
	    else
	    	self["item"..i]:setVisible(false)
	   	end
    end
end



function CopyPrizeView:close()
    for k,v in pairs(self.prizeListItem) do
    	v:destory()
    	self.win:removeChild(v)
    end
    self.prizeListItem = {}
    CopyPrizeView.super.close(self)
end


--清理界面
function CopyPrizeView:destory()
	
end

return CopyPrizeView