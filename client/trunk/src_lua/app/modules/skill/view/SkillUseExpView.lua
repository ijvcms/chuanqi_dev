--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-01-08 15:45:56
--
local SkillUseExpView = SkillUseExpView or class("SkillUseExpView", function()
    return display.newNode()
end)

function SkillUseExpView:updateGoodsNum()
    local bagManager = BagManager:getInstance()
    for i=1,#self.goodsList do
        local boosNum = bagManager:findItemCountByItemId(self.goodsList[i][1])
        self.goodsItemArr[i]:setCount(boosNum)
        self.goodsList[i][3] = boosNum
    end
end

function SkillUseExpView:updateSelectBg()
    for i=1,#self.goodsList do
        if self.selectIndex == i then
            self["selectBg"..i]:setVisible(true)
        else
            self["selectBg"..i]:setVisible(false)
        end
    end
end

--构造
function SkillUseExpView:ctor(jsonurl,winName)
    jsonurl = "resui/skillupWin_1.ExportJson"
    --"skillupWin_1"
    self.winName = winName
    self.selectIndex = 1
    if jsonurl then
        self.root = cc.uiloader:load(jsonurl)
        self:addChild(self.root)
        self.goodsList = {
            [1] = {110068,100,0},
            [2] = {110069,1000,0},
            [3] = {110070,3000,0},
        }

        self.closeBtn = self:seekNodeByName("close")
        self.closeBtn:setTouchEnabled(true)
        self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                self.closeBtn:setScale(1.1)
            elseif event.name == "ended" then
                self.closeBtn:setScale(1)
                self:close()
            end
            return true
        end)

        self.btnuse1 = self:seekNodeByName("btnuse1") --使用一次按钮
        self.btnuse1:setTouchEnabled(true)
        self.btnuse1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                    self.btnuse1:setScale(1.1)
                elseif event.name == "ended" then
                    self.btnuse1:setScale(1)
                    self:useBtnClick(1)
                end
                return true
            end)
        self.btnuse2 = self:seekNodeByName("btnuse2") --使用全部
        self.btnuse2:setTouchEnabled(true)
        self.btnuse2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                    self.btnuse2:setScale(1.1)
                elseif event.name == "ended" then
                    self.btnuse2:setScale(1)
                    self:useBtnClick(0)
                end
                return true
            end)

        self.btn_list1 = self:seekNodeByName("btn_list1_0") --物品1
        self.btn_list2 = self:seekNodeByName("btn_list1_1") --物品2
        self.btn_list3 = self:seekNodeByName("btn_list1_2") --物品3
        
        self.selectBg1 = cc.uiloader:seekNodeByName(self.btn_list1, "selected")
        self.selectBg2 = cc.uiloader:seekNodeByName(self.btn_list2, "selected")
        self.selectBg3 = cc.uiloader:seekNodeByName(self.btn_list3, "selected")

        for i=1,#self.goodsList do
            local item = self["btn_list"..i]
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                elseif event.name == "ended" then
                    self.selectIndex = i
                    self:updateSelectBg()
                end
                return true
            end)
        end

        self.goodsItemArr = {}
        for i=1,#self.goodsList do
            local item = CommonItemCell.new()
            self["btn_list"..i]:addChild(item)
            item:setPosition(50,50)
            item:setData({goods_id=self.goodsList[i][1]})
            table.insert(self.goodsItemArr,item)
            --item:setCount(33)
        end
    end
end

function SkillUseExpView:useBtnClick(num)
    if num == 0 then
        num = self.goodsList[self.selectIndex][3]
    end
    if num== 0 or self.goodsList[self.selectIndex][3] < num then
        GlobalMessage:show("缺少道具")
    else
        GameNet:sendMsgToSocket(12009, {skill_id = self.skillVo.id,goods_id=self.goodsList[self.selectIndex][1],num = num})
    end
end

function SkillUseExpView:open(vo)
    self.skillVo = vo
    self:setVisible(true)
    if self.propChangEventId == nil then
        self.propChangEventId = GlobalEventSystem:addEventListener(BagEvent.PROP_CHANGE, handler(self, self.updateGoodsNum))
    end
    self:updateGoodsNum()
    self:updateSelectBg()
end

function SkillUseExpView:close()
    self:setVisible(false)
    if self.propChangEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.propChangEventId)
        self.propChangEventId = nil
    end
end

function SkillUseExpView:destory()
    for k,v in pairs(self.goodsItemArr) do
        v:destory()
    end
end

function SkillUseExpView:getSkillVO()
    return self.vo
end

function SkillUseExpView:seekNodeByName(name)
  return cc.uiloader:seekNodeByName(self.root, name)
end 

return SkillUseExpView