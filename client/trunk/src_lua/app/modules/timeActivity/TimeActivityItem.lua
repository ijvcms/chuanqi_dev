--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-11-23 18:36:00
--
local TimeActivityItem = class("TimeActivityItem", BaseView)
function TimeActivityItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/activityLimitItem.ExportJson")
	self:addChild(self.root)
    self.time = self:seekNodeByName("time")
    self.name = self:seekNodeByName("name")
    self.reward = self:seekNodeByName("reward")
    self.state = self:seekNodeByName("state")
    self.selected = self:seekNodeByName("selected")
    self.root:setPosition(0-585/2,-23)
end

function TimeActivityItem:setSelect(bool)
    if bool then
    	self.selected:setVisible(true)
    else
    	self.selected:setVisible(false)
    end
end

function TimeActivityItem:updateStates(date)
	if self.vo.state == 0 then
		self.state:setString("敬请期待") --红
        self.state:setColor(TextColor.TEXT_R)
	else
        local temp = date
        if self:isdays(temp.wday,self.vo.open_week) then
            if StringUtil:isBeforecurTime(self.vo.tips_time,temp) == false and  StringUtil:isBeforecurTime(self.vo.open_time,temp) then
                self.state:setString("即将开始") --白
                self.state:setColor(cc.c3b(80, 179, 211))
            elseif StringUtil:isBeforecurTime(self.vo.open_time,temp)== false and  StringUtil:isBeforecurTime(self.vo.close_time,temp) then
                self.state:setString("进行中") --绿
                 self.state:setColor(cc.c3b(0, 255, 13))
            elseif StringUtil:isBeforecurTime(self.vo.close_time,temp) == false then
                self.state:setString("活动结束") --灰
                 self.state:setColor(TextColor.TEXT_GRAY)
            else
                self.state:setString("未开始") --白
                self.state:setColor(cc.c3b(255, 255, 255))
            end
        else
            self.state:setString("尚未开启") --白
            self.state:setColor(cc.c3b(255, 255, 255))
        end
	end
end

--是否当天开放
--local temp = os.date("*t", os.time())
--temp.wday
function TimeActivityItem:isdays(osWeekid,days)
    osWeekid = osWeekid -1
    if osWeekid == 0 then
        osWeekid = 7
    end
    for i=1,#days do
        if days[i] == osWeekid then
            return true
        end
    end
    return false
end


function TimeActivityItem:open(datas)
    
end
--"id", "activity_id", "open_time1", "state", "des", "drop_list"
function TimeActivityItem:getData()
	return self.vo
end

function TimeActivityItem:setData(vo,date)
	self.vo = vo
	self.time:setString(self.vo.open_time1)
	self.name:setString(self.vo.name)
	self.state:setString(self.vo.state) --进行中 未开始
    self.reward:setString(self.vo.reward_txt)
	self:updateStates(date)
    -- self.vo = vo
    -- self.lvLab:setString("LV"..self.vo.lv)
    -- self.numLabel:setString(self.vo.point)
    -- local goods = self.vo.goods[1]
    -- local itemName = configHelper:getGoodNameByGoodId(goods[1])
    -- self.name:setString(itemName)
    -- local quality = configHelper:getGoodQualityByGoodId(goods[1])
    -- local color
    -- if quality then
        
    --     if quality == 1 then            --白
    --         color = TextColor.TEXT_W
    --     elseif quality == 2 then        --绿
    --         color = TextColor.TEXT_G
    --     elseif quality == 3 then        --蓝
    --         color = TextColor.ITEM_B
    --     elseif quality == 4 then        --紫
    --         color = TextColor.ITEM_P
    --     elseif quality == 5 then        --橙
    --         color = TextColor.TEXT_O
    --     elseif quality == 6 then        --红
    --         color = TextColor.TEXT_R
    --     end 
    --     if color then
    --         self.name:setTextColor(color)
    --     end
    -- end

    -- self.item = CommonItemCell.new()
    -- self.itemBg:addChild(self.item)
    -- self.item:setData({goods_id = goods[1], is_bind = goods[2], num = goods[3]})
    -- self.item:setCount(goods[3])
    -- self.item:setPosition(40,40)
end


function TimeActivityItem:close()
    
    TimeActivityItem.super.close(self)
end


--清理界面
function TimeActivityItem:destory()
  
end

return TimeActivityItem