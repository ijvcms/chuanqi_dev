local itemTipsWin = require("app.modules.tips.view.itemTipsWin")
--商城view
local GuildStoreView = class("GuildStoreView", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

function GuildStoreView:ctor()
	--背景
	self:setAnchorPoint(0,0)
    local bg = display.newLayer()
    bg:setContentSize(670,384)
    bg:setTouchEnabled(false)
    bg:setTouchSwallowEnabled(false)
	self.bg = bg
	bg:setAnchorPoint(0,0)
	self:addChild(bg)
	self:setContentSize(bg:getContentSize())

	--触摸层
    --[[
	self.touchLayer = display.newLayer()
	self.touchLayer:setContentSize(bg:getContentSize())
	self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.onTLTouch))
	bg:addChild(self.touchLayer,10)
	self.touchLayer:setTouchSwallowEnabled(false)
    --]]
	--内容层
	self.contentLayer = cc.Node:create()
    self.contentLayer:setAnchorPoint(0,0)
    self.contentLayer:setContentSize(cc.size(bg:getContentSize().width,bg:getContentSize().height))
    self.scrollView = cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,bg:getContentSize().width,bg:getContentSize().height)})
        :addScrollNode(self.contentLayer)   
        :addTo(bg)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)  
        --:onScroll(handler(self, self.onTouchHandler))
        self.scrollView:setPosition(6,0)

        self.scrollView:setTouchSwallowEnabled(false)
 
end

function GuildStoreView:pushItemData(data,modifyFunc)
	if not data then return end
 
    if self.contentLayer~= nil and data ~= nil then

        local itemWidth = 164
        local itemHeight = 174
 
        for i=1,#data do
            local item = self:createStoreItem(data[i])
            self.contentLayer:addChild(item)
 
            item:setPosition(((i-1)%4)*itemWidth +78,itemHeight*math.ceil(#data/4) - math.floor((i-1)/4)*itemHeight - itemHeight/2-140)
            if modifyFunc then
                modifyFunc(item,{data[i]})
            end
        end
        --self.contentLayer:setPosition(itemWidth, self.bg:getContentSize().height - self.contentLayer:getContentSize().height - 86)
    end
    --self.scrollView:scrollAuto()
end
 
function GuildStoreView:createStoreItem(itemData)
    local sp = display.newScale9Sprite("#com_listBg1.png", 0, 0, cc.size(150, 166),cc.rect(30, 30,1, 1))--newSprite("#com_listBg1.png")
    --sp:setAnchorPoint(0,0)
    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(itemData)
    commonItem:setPosition(sp:getContentSize().width/2,sp:getContentSize().height-70)
    commonItem:setTouchEnabled(false)
    commonItem:setTouchSwallowEnabled(false)
    commonItem:setItemClickFunc(function ()
        local itWin = itemTipsWin.new()
        itWin:setData(itemData)
        itWin.btnUse:setVisible(false)
        itWin.btnSell:setVisible(false)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
    end)
    sp:addChild(commonItem)
    --名字
    local nameLabel = display.newTTFLabel({font = "Marker Felt",size=16}):addTo(sp,15)
    nameLabel:setColor(TextColor.TITLE)
    nameLabel:setString(configHelper:getGoodNameByGoodId(itemData.goods_id))
    nameLabel:setAnchorPoint(0.5,0.5)
    nameLabel:setPosition(sp:getContentSize().width/2,sp:getContentSize().height-18)
    --根据品质改变名字颜色
    local quality = configHelper:getGoodQualityByGoodId(itemData.goods_id)
    if quality then
        local color
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
            color = TextColor.TEXT_R
        end 
        if color then
            nameLabel:setTextColor(color)
        end
    end
    display.setLabelFilter(nameLabel)
    --"贡献:"
    local sjLabel = display.newTTFLabel({font = "Marker Felt",size=16}):addTo(sp,15)
    sjLabel:setColor(TextColor.TEXT_W)
    sjLabel:setString("贡献:")
    sjLabel:setAnchorPoint(0,0.5)
    display.setLabelFilter(sjLabel)
    --价格
    local jgLabel = display.newTTFLabel({font = "Marker Felt",size=16}):addTo(sp,15)
    jgLabel:setColor(TextColor.TEXT_Y)
    jgLabel:setString(itemData.need_contribution)
    jgLabel:setAnchorPoint(0,0.5)
    display.setLabelFilter(jgLabel)

    local posX = (sp:getContentSize().width-sjLabel:getContentSize().width-jgLabel:getContentSize().width)/2
    sjLabel:setPosition(posX,sp:getContentSize().height/2-35)
    jgLabel:setPosition(sjLabel:getPositionX()+sjLabel:getContentSize().width,sp:getContentSize().height/2-35)
    --购买按钮
    local btn = display.newSprite("#com_labBtn1.png")
    sp:addChild(btn)
    btn:setScale(0.8)
    btn:setPosition(sp:getContentSize().width/2,20)
    local label = display.newTTFLabel({
        text = "购 买",
        size = 22,
        color = TextColor.TEXT_W
    })
    label:setPosition(btn:getContentSize().width/2,btn:getContentSize().height/2)
    btn:addChild(label)
    display.setLabelFilter(label)
    btn:setVisible(false)
    sp.buyBtn = btn

    --tips
    sp.tips = {}
    for i=1,2 do
        local label = display.newTTFLabel({
            text = i==1 and itemData.limit_guild_lv.."级行会可购买" or itemData.limit_lv.."级可购买",
            size = 20,
            color = TextColor.TEXT_R
        })
        label:setPosition(sp:getContentSize().width/2,20)
        sp:addChild(label)
        display.setLabelFilter(label)
        label:setVisible(false)
        table.insert(sp.tips,label)
    end

    return sp
end

return GuildStoreView