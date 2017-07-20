
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-09-02 20:54:49
-- 跨服火龙神殿

local KfHlsdWin = class("KfHlsdWin", BaseView)
function KfHlsdWin:ctor(winTag,data,winconfig)
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
    KfHlsdWin.super.ctor(self,winTag,data,winconfig)

    self.root:setPosition((display.width-960)/2,(display.height-640)/2)
    self.closeBtn = self:seekNodeByName("closeBtn")
    self.closeBtn:setTouchEnabled(true)
    self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closeBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GlobalWinManger:closeWin(self.winTag)
        end
        return true
    end)
    self.enterBtn = self:seekNodeByName("enterBtn")
    self.enterBtn:setTouchEnabled(true)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.enterBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.enterBtn:setScale(1)
            GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(self.config.activity_id)})
        end
        return true
    end)

    for i=1,6 do
        self["Item"..i] = self:seekNodeByName("Item"..i)
    end

end


function KfHlsdWin:open(datas)
    self:setVisible(true)
    self.config = configHelper:getDarkHouseGoods(11)
    local goodsList = self.config.drop_list
    if self.prizeListItem == nil then  
        self.prizeListItem = {}
        for i=1,6 do
            local vo = goodsList[i]
            local item = CommonItemCell.new()
            self["Item"..i]:addChild(item)
            item:setData({goods_id = vo[1], is_bind = vo[2], num = vo[3]})
            item:setCount(1)
            item:setPosition(40,40)
            self.prizeListItem[i] = item
        end
    end
end


function KfHlsdWin:close()
    KfHlsdWin.super.close(self)
end

--清理界面
function KfHlsdWin:destory()
    if self.prizeListItem then
        for i=1,#self.prizeListItem do
            self.prizeListItem[i]:destory()
            if self.prizeListItem[i]:getParent() then
                self.prizeListItem[i]:getParent():removeChild(self.prizeListItem[i])
            end
        end
        self.prizeListItem = nil
    end
end

return KfHlsdWin
