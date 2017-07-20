--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 
local ChangLineWin = class("ChangLineWin", BaseView)
function ChangLineWin:ctor(winTag,data,winconfig)
    self.black = display.newColorLayer(cc.c4b(0, 0, 0, 80))
    -- black:setAnchorPoint(0.5,0.5)
    self.black:setPosition(0,0)
    self:addChild(self.black)
    ChangLineWin.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition(0-230,204)
    self.root:setPosition(0,204)
    self.mainLayer = self:seekNodeByName("mainLayer")
    self.black:setTouchEnabled(true)
    self.black:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)

    local function lineListTouchListener(event)

    end

    self.lineListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 218, 198),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(lineListTouchListener)
        :addTo(self.mainLayer)
    self.lineListView:setPosition(0,0)

    --transition.moveTo(self.root, {x =0, time = 0.1})
end


function ChangLineWin:open()
    ChangLineWin.super.open(self)

    if self.lineUpdateEventId == nil then
        self.lineUpdateEventId = GlobalEventSystem:addEventListener(ChangLineEvent.LINE_UPDATE,handler(self,self.lineUpdate))
    end
    
    -- GameNet:sendMsgToSocket(35000,{last_id = 0})
    self:lineUpdate()
end

function ChangLineWin:lineUpdate(data)
    self.curLine = GlobalModel.curLine
    self.lineList = GlobalModel.lineList

    if self.itemViewList == nil then
        self.itemViewList = {}
    else
        for k,v in pairs(self.itemViewList) do
            v:setVisible(false)
        end
    end

    local tjVo = nil

    self.lineListView:removeAllItems()
    for i=1,math.ceil(#self.lineList/5) do
        local item = self.lineListView:newItem()
        local content
        content = display.newNode()
        for count = 1, 2 do
            local idx = (i-1)*2 + count
            if self.lineList[idx] then
                local btnItem = import("app.modules.changLine.ChangLineItem").new()

                btnItem.LineBtn:setTouchEnabled(true)
                btnItem.LineBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                    if event.name == "began" then

                    elseif event.name == "ended" then
                        if self.curLine == self.lineList[idx].line_num then
                            GlobalMessage:show("你已在当前线路")
                        else
                            GameNet:sendMsgToSocket(11039,{line = self.lineList[idx].line_num})
                            GlobalWinManger:closeWin(self.winTag)
                        end
                    end
                    return true
                end)

                btnItem:setData(self.lineList[idx])
                if tjVo == nil then
                    tjVo = self.lineList[idx]
                else
                    if self.lineList[idx].line_num <= tjVo.line_num then
                        tjVo = self.lineList[idx]
                    end
                end
                btnItem:setPosition((count-1)*109,0)
                content:addChild(btnItem)
            end
        end
        
        content:setContentSize(218, 40)
        item:addContent(content)
        item:setItemSize(218, 50)

        self.lineListView:addItem(item)
    end
    self.lineListView:reload()

    if self.tjItem == nil then
        self.tjItem = import("app.modules.changLine.ChangLineItem").new()
        self.root:addChild(self.tjItem)
        self.tjItem:setPosition(100,222)
    end
    self.tjItem:setData(tjVo)
end

function ChangLineWin:close()
    if self.lineUpdateEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.lineUpdateEventId)
        self.lineUpdateEventId = nil
    end
   

    -- if self.timerId then
    --      GlobalTimer.unscheduleGlobal(self.timerId)
    --      self.timerId = nil
    -- end
   
    -- GameNet:sendMsgToSocket(35003)
    ChangLineWin.super.close(self)
end


--清理界面
function ChangLineWin:destory()
    self:close()
	ChangLineWin.super.destory(self)
end

return ChangLineWin