
local putOnTips = class("putOnTips", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

local TYPE_EQUIP_DATA  = 1
local TYPE_SKILL_BOOK  = 2
local TYPE_REWARD_GIFT = 3

function putOnTips:ctor()	
	local ccui = cc.uiloader:load("resui/putOnTips.ExportJson")
    self:addChild(ccui)
    ccui:setPosition(display.width-188*2,display.cy-200-40)
    local root = cc.uiloader:seekNodeByName(ccui, "root")
    self.win = cc.uiloader:seekNodeByName(root, "win")
    local btnClose = cc.uiloader:seekNodeByName(self.win, "btnClose")
    btnClose:setTouchEnabled(true)
    btnClose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            btnClose:setScale(1.2)
        elseif event.name == "ended" then
            btnClose:setScale(1)
            self:onCloseClick()
        end     
        return true
    end) 

    local btnPutOn = cc.uiloader:seekNodeByName(self.win, "btnPutOn")
    btnPutOn:setTouchEnabled(true)
    btnPutOn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
            btnPutOn:setScale(1.2)
        elseif event.name == "ended" then
            btnPutOn:setScale(1)
            self:onPutOnClick()
        end     
        return true
    end) 
end

function putOnTips:setData(data)
    self.data = data
    self._type = self:getType()
    -- 装备
    if self._type == TYPE_EQUIP_DATA then
        self:initWithEquipData()

    -- 技能书
    elseif self._type == TYPE_SKILL_BOOK then
        self:initWithSkillBook()
        
    -- 礼包
    elseif self._type == TYPE_REWARD_GIFT then
        self:initWithRewardGift()
    end
    if DEBUG == 1 and AUTO == 1 then
        require("framework.scheduler").performWithDelayGlobal(function() 
            self:onPutOnClick()
        end, 0.4)
        
    end
end

function putOnTips:getType()
    local goods_config = configHelper:getGoodsByGoodId(self.data.goods_id)
    local goods_type = goods_config.type
    -- 技能书
    if configHelper:isSkillBookByGoodsId(self.data.goods_id) then return TYPE_SKILL_BOOK
    -- 礼包
    elseif goods_type == 6 or goods_type == 7  then return TYPE_REWARD_GIFT
    -- 装备
    else return TYPE_EQUIP_DATA end
end

function putOnTips:onPutOnClick()
    -- 技能书
    if self._type == TYPE_EQUIP_DATA then
        self:sendUseEquip()
    -- 礼包
    elseif self._type == TYPE_SKILL_BOOK then
        self:sendUserSkillBook()
    -- 装备
    elseif self._type == TYPE_REWARD_GIFT then
        self:sendReceiveGift()
    end
    
    self:onCloseClick()
end


-- //////////////////////////////////////////////////////////////////////////////////////////
function putOnTips:initWithSkillBook()
    self:addGoodsItem()

    -- 立即学习
    self:setButtonLabelString("学习")

    -- 获得提示
    local labPower = cc.uiloader:seekNodeByName(self.win, "labPower")
    local bookName = configHelper:getGoodNameByGoodId(self.data.goods_id)
    labPower:setString("获得" .. bookName)
end


function putOnTips:sendUserSkillBook()
    local goods_config = configHelper:getGoodsByGoodId(self.data.goods_id)
    local goods_type = goods_config.type
    if goods_type == 7 then
        --使用
        if self.data.map_scene ~= 0 then
            SceneManager:playerMoveToBaoCang(self.data.map_scene,cc.p(self.data.map_x,self.data.map_y),self.data.id)
        end
    else
        -- 道具使用
        local data = {
            goods_id = self.data.goods_id
        }
        --GameNet:sendMsgToSocket(14007, data)
        BagController:getInstance():requestUseGoods(data)
    end
end


-- //////////////////////////////////////////////////////////////////////////////////////////
function putOnTips:initWithRewardGift()
    self:addGoodsItem()

    -- 立即领取
    self:setButtonLabelString("使用")

    -- 恭喜获得XXX礼包
    local labPower = cc.uiloader:seekNodeByName(self.win, "labPower")
    labPower:setString(configHelper:getGoodNameByGoodId(self.data.goods_id))
end

function putOnTips:sendReceiveGift()
    -- 道具使用
    --GlobalController.welfare:RequestReceiveReward(self.data.key)
    self:sendUserSkillBook()
end


-- //////////////////////////////////////////////////////////////////////////////////////////
function putOnTips:initWithEquipData()
    self:addGoodsItem()

    -- 立即穿戴
    self:setButtonLabelString("穿戴")
    
    -- 战斗力
    local labPower = cc.uiloader:seekNodeByName(self.win, "labPower")
    if  configHelper:getGoodSubTypeByGoodId(self.data.goods_id) == 15 then
        cc.uiloader:seekNodeByName(self.win, "labPower"):setVisible(false)
    end
    labPower:setString("战力:"..self.data.fighting)
end

function putOnTips:sendUseEquip()
    --发送穿上协议 
    import("app.utils.EquipUtil") 
    local data = 
    {
        id          =  self.data.id,
        goods_id    =  self.data.goods_id,
        grid        =  EquipUtil.getEquipPutOnPos(self.data)
    }
    GameNet:sendMsgToSocket(14022, data)
end


-- ------------------------------------------------------------------------------------------------------------------------
-- Normal private menbers
-- ------------------------------------------------------------------------------------------------------------------------
function putOnTips:addGoodsItem()
    -- 移除旧的物品
    local itemLayer = cc.uiloader:seekNodeByName(self.win, "itemLayer")
    if itemLayer:getChildByTag(10) then
        itemLayer:removeChildByTag(10)
    end

    -- 添加新的物品
    local commonItem = CommonItemCell.new()
    commonItem:setData(self.data)
    commonItem:setTag(10)
    commonItem:setPosition(itemLayer:getContentSize().width/2,itemLayer:getContentSize().height/2)
    itemLayer:addChild(commonItem)
end


function putOnTips:setButtonLabelString(labelString)
    cc.uiloader:seekNodeByName(self.win, "Label_31"):setString(labelString)
end

--关闭按钮回调
function putOnTips:onCloseClick()
    self:removeSelfSafety()
end

return putOnTips