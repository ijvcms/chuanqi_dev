-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- GVG
--
local GvgLeftView = class("GvgLeftView", BaseView)
--234 249
function GvgLeftView:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/gvgList.ExportJson") --588，36
	self:addChild(self.root)
    self.ListView = self:seekNodeByName("ListView")
    
    self.btnState = true

    self.retractBtn = self:seekNodeByName("retractBtn")
    self.retractBtn:setScale(-1)
    self.retractBtn:setTouchEnabled(true)
    self.retractBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            if self.btnState then
            	self.btnState = false
                --self.retractBtn:setScale(1)
                self:onClickHide() 
            else
            	self.btnState = true
                --self.retractBtn:setScale(-1)
                self:onClickShow()
            end
            -- local action1 = cc.DelayTime:create(0.4*(i - 1))
            -- local action2 = cc.CallFunc:create(function () item:setVisible(true) end) 
            -- local action3 = cc.MoveTo:create(0.15, cc.p(display.width/2 + (i - beginX)*90 - 40 ,display.height/2+120))
            -- local action6 = transition.sequence({
            --                  action1,
            --                  action2,
            --                  action3,
            --              }) 
            -- item:runAction(action6)
            -- GameNet:sendMsgToSocket(35006,{id = self.vo.id})
        end
        return true
    end)

    self.rank = self:seekNodeByName("rank") --gvg_rank1 gvg_rank2  gvg_rank3
    self.name = self:seekNodeByName("name") --第四名后显示
    self.point = self:seekNodeByName("point")

    self.mainLayer = self:seekNodeByName("mainLayer")

    self.itemList = {}
    self.name:setString(RoleManager:getInstance().roleInfo.name);
    --self:setData()
    self.rank = self:seekNodeByName("rank")
    self.showPoint = 0
    self.hidePoint = -190
end


function GvgLeftView:onClickShow()
    if self and self:getParent() then
        
        local action = cc.MoveTo:create(0.3, cc.p(self.showPoint, self:getPositionY()))                 
        local action3 = cc.CallFunc:create(function()
            self.retractBtn:setScaleX(-1)
            self.mainLayer:setVisible(true)
        end)     
        self:stopAllActions()  
        self:runAction(transition.sequence({action,action3}))
    end
end

function GvgLeftView:onClickHide()

    if self and self:getParent() then
        local action = cc.MoveTo:create(0.3, cc.p(self.hidePoint, self:getPositionY())) 
        local action2 = cc.CallFunc:create(function() 
            self.retractBtn:setScaleX(1)
            self.mainLayer:setVisible(false) 
        end)       
         self:stopAllActions()
        self:runAction(transition.sequence({action,action2}))
    end
end

function GvgLeftView:open(datas)
    GlobalEventSystem:removeEventListener(GvgEvent.GVG_LEFT_RANK)
    if self.gvgLeftRankEventId == nil then
         self.gvgLeftRankEventId = GlobalEventSystem:addEventListener(GvgEvent.GVG_LEFT_RANK,handler(self,self.setData))
    end
     -- GameNet:sendMsgToSocket(35004,{last_id = 0})
end

function GvgLeftView:setData(data)
    self.data = data.data         
	self.rank:setString(self.data.player_rank)
    self.point:setString(self.data.player_score)

    local gvgItem = require("app.modules.gvg.GvgLeftItem")
    for i=1,#self.data.rank_list do
        local content = self.itemList[i]
        if content == nil then
            local item = self.ListView:newItem()
            content = gvgItem.new()
            self.itemList[i] = content
            item:addContent(content)
            item:setItemSize(235, 36)
            self.ListView:addItem(item)
        end
        content:setData(self.data.rank_list[i])
    end
    self.ListView:reload()
end


function GvgLeftView:close()
    GvgLeftView.super.close(self)
    if self.gvgLeftRankEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.gvgLeftRankEventId)
        self.gvgLeftRankEventId = nil
    end
end

--清理界面
function GvgLeftView:destory()

end

return GvgLeftView