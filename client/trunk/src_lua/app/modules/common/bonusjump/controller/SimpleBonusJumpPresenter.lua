local SimpleBonusJumpPresenter = class("SimpleBonusJumpPresenter")

local kTag = 10

SimpleBonusJumpPresenter.delegate = nil
SimpleBonusJumpPresenter.model = nil

function SimpleBonusJumpPresenter:setDelegate(delegate)
	self.delegate = delegate
end

function SimpleBonusJumpPresenter:setModel(model)
	self.model = model
end

function SimpleBonusJumpPresenter:updateView()
	if not self.model then return end

	local dropList = self.model.dropList
	if not dropList then return end
	local items = self.delegate:getItems()
	for index,good in ipairs(dropList or {}) do
		local item = items[index]
		if item then
			if item:getChildByTag(kTag) ~= nil then
            	item:getChildByTag(kTag):removeSelf()
        	end
        	local d = {}
            d.goods_id = good[1] or 0
            d.is_bind = good[2] or 0
            d.num = good[3] or 1

            local commonItem = CommonItemCell.new()
            commonItem:setData(d)
            item:addChild(commonItem, kTag, kTag)
            commonItem:setTouchEnabled(true)
            commonItem:setPosition(item:getContentSize().width/2.0, item:getContentSize().height/2.0)
            item:setVisible(true)
		else
			break
		end
		
	end
    
end

function SimpleBonusJumpPresenter:onEnterClick()
	local scene_id = 32112
	GlobalEventSystem:dispatchEvent(FightEvent.CHANG_SCENE, {sceneId = tonumber(scene_id)})
	-- GameNet:sendMsgToSocket(11031, {scene_id = scene_id})
end


return SimpleBonusJumpPresenter