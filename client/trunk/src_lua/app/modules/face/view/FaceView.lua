
local FaceAdapter = import(".FaceAdapter")
--动态表情
local FaceView = class("FaceView", function()
	return display.newLayer()
end)

function FaceView:ctor()
   
    self.viewbg = display.newScale9Sprite("#com_panelBg4.png", 0, 0, cc.size(466, 244),cc.rect( 26, 26, 4, 4)) 
    self.viewbg:setAnchorPoint(0, 0)
    self.viewbg:setPosition(145, 106)
    self.viewbg:setTouchEnabled(true)
    self.viewbg:setVisible(false)
    self:addChild(self.viewbg)
    self:setNodeEventEnabled(true)
	self.FaceBtn = display.newSprite("#scene/scene_chatBtnSel.png")
    self.FaceBtn:setVisible(false)--先屏蔽功能
	self.FaceBtn:setTouchEnabled(true)
	self.FaceBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            if self.viewbg:isVisible() then
                self:hide()
            else
                self:show()
            end
        	
        end     
        return true
    end)
    self.FaceBtn:setPosition(145,50)
    self:addChild(self.FaceBtn)
    self:setTouchEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            self:hide()
        end     
        return true
    end)
    
end

function FaceView:show()
    if nil == self.pager then
        self:initFaceAdapter()
    else
        self.pager:getCurrentPage_():setVisible(true)--开始动画
    end
    self.viewbg:setVisible(true)
    self:setTouchEnabled(true)
end

function FaceView:hide()
    self.viewbg:setVisible(false)
    self:setTouchEnabled(false)
    self.pager:getCurrentPage_():setVisible(false)--停止动画
end

function FaceView:onCleanup()
    if self.adapter then
        self.adapter:Destroy()
    end
end

function FaceView:initFaceAdapter()
    
    local faceList = configHelper:getFaceConfig()

    local adapter = FaceAdapter.new()
    local pager   = ViewPager.new({x = 16, y = 34, height = 176, width = 414})
    local pagerMarker = PageMarker.create(math.ceil(#faceList / 10))

    pager:addEventListener(ViewPager.PAGE_CHANGED, handler(self, self.onPageChanged))
    pager:SetAdapter(adapter)
    pagerMarker:setPosition(self.viewbg:getContentSize().width / 2 + 20, 30)

    
    self.viewbg:addChild(pager)
    self.viewbg:addChild(pagerMarker)

    self.adapter = adapter
    self.pager   = pager
    self.pagerMarker = pagerMarker
 
    adapter:setData(faceList)

    self.adapter:addEventListener(FaceAdapter.ON_SELECTED_ITEM, handler(self, self.onClickFace))
end
 
function FaceView:onPageChanged(event)
    local index = event.currentIndex
    if self.pagerMarker then
        self.pagerMarker:SetMarkIndex(index)
    end
end

function FaceView:onClickFace(event)
    GameNet:sendMsgToSocket(18009, {content = event.data})  
    self:hide()
end







return FaceView






