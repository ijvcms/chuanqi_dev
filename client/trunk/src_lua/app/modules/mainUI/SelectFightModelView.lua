-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-09-13 15:37:48
-- 获取章节奖励
local SelFightModelItem = SelFightModelItem or class("SelFightModelItem", function()
	return display.newNode()
end)

function SelFightModelItem:ctor(ctype)
    self.ctype = ctype
    self.selBg1 = display.newScale9Sprite("#com_listBg1.png", 0, 0, cc.size(218, 50))
	self.selBg = display.newScale9Sprite("#com_listBg1Sel.png", 0, 0, cc.size(218, 50))
    self:addChild(self.selBg1)
    self:addChild(self.selBg)
	
    self.selBg1:setAnchorPoint(cc.p(0, 0))
	self.selBg:setAnchorPoint(cc.p(0, 0))
    self.selBg:setPosition(0, 0)
    self.selBg:setVisible(false)

    self:init(ctype)

	self.itemPic = display.newSprite(self.pic)
	self:addChild(self.itemPic)
	self.itemPic:setPosition(30,25)

	self.tipsLab = display.newTTFLabel({text = self.tips,
        size = 15})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    self.tipsLab:setPosition(60,25)
    display.setLabelFilter(self.tipsLab)
end

function SelFightModelItem:init(ctype)
    self.pic, self.tips = ResUtil.getFightModelPic(ctype)
end


local SelectFightModelView = SelectFightModelView or class("SelectFightModelView", function()
	return display.newNode()
end)


function SelectFightModelView:ctor(param)
	self.width = param.width or 230
	self.height = param.height or 370

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,80))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    if RoleManager:getInstance().roleInfo.lv > 35 then
        self.tipsBg = display.newScale9Sprite("#com_panelBg3.png", 0, 0, cc.size(self.width , self.height  +  30 ))
        self.tipsBg:setAnchorPoint(cc.p(0, 0))
        self.tipsBg:setPosition(0-self.width,83)
    else
        self.tipsBg = display.newScale9Sprite("#com_panelBg3.png", 0, 0, cc.size(self.width , self.height  +  64 ))
        self.tipsBg:setAnchorPoint(cc.p(0, 0))
        self.tipsBg:setPosition(0-self.width,83)
    end
    self:addChild(self.tipsBg)

    transition.moveTo(self.tipsBg, {x =0, time = 0.1})

    self.titleLab = display.newTTFLabel({text = "恶意杀死玩家将增加PK值",
        size = 16,color = TextColor.TEXT_O})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self.tipsBg)
    self.titleLab:setPosition(12,22)
    display.setLabelFilter(self.titleLab)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        elseif event.name == "ended" then
            self:close()
        end
        return true
    end)

    self.curSelType = RoleManager:getInstance().roleInfo.pkMode

    self.itemList = {}
    self:setData()
end

function SelectFightModelView:setData()
    local fightModelList = {FightModelType.ALL,FightModelType.ENEMY,FightModelType.GUILD,FightModelType.TEAM,FightModelType.UNION,FightModelType.GOODEVIL,FightModelType.PEACE}
    local len = #fightModelList
	for i=1,len do
		local item = self.itemList[i]
		if item == nil then
            item = SelFightModelItem.new(fightModelList[i])
            self.tipsBg:addChild(item)
            self.itemList[i] = item
            item:setPosition(6,(i-1)*50 +38)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
                    if event.name == "began" then                   
                    elseif event.name == "ended" then 
                        self:setItemSelect(item.ctype)
                        self:close()
                    end
                    return true
            end)
		end
	end
    self:setItemSelect(self.curSelType)
end

function SelectFightModelView:setItemSelect(ctype)
    for i=1,#self.itemList do
        local item = self.itemList[i]
        if item.ctype == ctype then
            item.selBg:setVisible(true)
            --RoleManager:getInstance().roleInfo.pkMode = ctype
            if self.curSelType ~= ctype then
                self.curSelType = ctype
                GameNet:sendMsgToSocket(10008,{pk_mode = self.curSelType})
            end
            --GlobalEventSystem:dispatchEvent(SceneEvent.UPDATE_FIGHT_MODEL_TYPE,self.curSelType)
        else
            item.selBg:setVisible(false)
        end
    end
end

function SelectFightModelView:close()
    local parent = self:getParent()
    if parent ~= nil then
        parent:removeChild(self)
    end 
end

return SelectFightModelView