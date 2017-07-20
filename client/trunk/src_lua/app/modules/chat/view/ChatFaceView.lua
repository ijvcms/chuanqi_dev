--
-- Author: Yi hanneng
-- Date: 2016-01-13 10:53:54
--

local FaceAdapter = import(".FaceAdapter")
local ChatFaceView = class("ChatFaceView", function() return display.newNode() end)

function ChatFaceView:ctor(posX,posY)

    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:addChild(self.bg)
	display.addSpriteFrames("resui/face0.plist", "resui/face0.png")

    self.viewbg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(432,267),cc.rect(63, 49,1, 1))
 	self.viewbg:setPosition(posX - 100, posY + 30 + 131)
 	self:addChild(self.viewbg)

    self:setTouchEnabled(true)
  
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
    
        elseif event.name == "ended" then
      
            if not cc.rectContainsPoint(self.viewbg:getBoundingBox(), event) then
                self:setVisible(false)
               
            end
            
        end     
        return true
    end)

 	self:initFaceAdapter()
    self:setNodeEventEnabled(true)
end

function ChatFaceView:initFaceAdapter()
	
	local faces = cc.FileUtils:getInstance():getValueMapFromFile("resui/face0.plist").frames
	local faceList = {}
	for k, v in pairs(faces) do
		v.frameName = k
		faceList[#faceList + 1] = v
	end

    local adapter = FaceAdapter.new()
    local pager   = ViewPager.new({x = 16, y = 34, height = 200, width = 400})
    local pagerMarker = PageMarker.create(math.ceil(#faceList / 12))

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
 
function ChatFaceView:onPageChanged(event)
    local index = event.currentIndex
    if self.pagerMarker then
        self.pagerMarker:SetMarkIndex(index)
    end
end

function ChatFaceView:onClickFace(event)
	GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_SEND_FACE, event.data)
end

function ChatFaceView:onCleanup()
    self.adapter:Destroy()
end

return ChatFaceView