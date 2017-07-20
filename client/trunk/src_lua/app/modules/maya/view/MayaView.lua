--
-- Author: Your Name
-- Date: 2015-12-10 17:21:07
--
local MayaView = MayaView or class("MayaView", BaseView)

MayaView.getInfohandle = nil

function MayaView:ctor(winTag,data,winconfig)
	MayaView.super.ctor(self,winTag,data,winconfig)
    self.itemList = {}
	local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    root:setPosition((display.width-960)/2,(display.height-640)/2)
    self:creatPillar()
    
	self.desLbl = cc.uiloader:seekNodeByName(root,"desLbl")

	self.scrollLayer = cc.uiloader:seekNodeByName(root,"scrollContainer")

    self.scrollContainer = cc.Node:create()
    --self:addChild(self.scrollContainer)
    self.scroll = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,self.scrollLayer:getBoundingBox().width, self.scrollLayer:getBoundingBox().height)}) -- 创建ScrollView,指定裁剪范围  
        :addScrollNode(self.scrollContainer)   
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)  
        :addTo(root)
        :pos(self.scrollLayer:getBoundingBox().x, self.scrollLayer:getBoundingBox().y)

	self.enterBtn = cc.uiloader:seekNodeByName(root,"enterBtn")
    self.enterBtn:setTouchEnabled(true)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.enterBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.enterBtn:setScale(1.0)
            self:enter()
        end     
        return true
    end)

    self.closeBtn = cc.uiloader:seekNodeByName(root,"closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closeBtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)

  GameNet:sendMsgToSocket(11010)
  self.getInfohandle = GlobalEventSystem:addEventListener(MayaEvent.MAYA_GET_INFO, handler(self, self.setViewInfo))
  
end

function MayaView:setViewInfo(data)

    local data = data.data
    if data ~= nil  and self.scrollContainer ~= nil then

        local str = configHelper:getMayaDes(1).content
        if RichTextHelper.checkIsXmlString(str) then            --使用富文本
            local strRT = SuperRichText.new(str,260)
            dump(strRT:getBoundingBox())
            strRT:setPosition(self.desLbl:getPositionX(),self.desLbl:getPositionY() + 180)
            self:getRoot():addChild(strRT)
        else                                                    --使用普通文本
            self.desLbl:setString(configHelper:getMayaDes(1).content)
        end
        local h = 0
        local num = 0
        self.itemList = {}

        local MayaItem = require("app.modules.maya.view.MayaItem")
        for i=1,#data.list do

            if num < #data.list[i]then
                num = #data.list[i]
            end
            
            for j=1,#data.list[i] do
                local item = MayaItem.new(data.list[i][j])
                :addTo(self.scrollContainer)
                :pos((i-1)*200, (0 - j)*44)
                
                table.insert(self.itemList, item)
            end
        end

        self.scrollContainer:setPosition(0, self.scrollLayer:getBoundingBox().height)

    end

end

local function _removeEvent(self)
    if self.getInfohandle then
        GlobalEventSystem:removeEventListenerByHandle(self.getInfohandle)
        self.getInfohandle = nil
    end
    
end

--进入玛雅神殿
function MayaView:enter()
    GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = 20001})
    GlobalWinManger:closeWin(self.winTag)
end

function MayaView:destory()
    _removeEvent(self)
    if #self.itemList >0 then
        for i=1,#self.itemList do
            self.itemList[i]:destory()
        end
    end
    self.itemList = nil

    MayaView.super.destory(self)

end

return MayaView