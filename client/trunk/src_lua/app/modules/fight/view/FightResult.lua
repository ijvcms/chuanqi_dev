local FightResult = class("FightResult", function()
	return display.newNode()
end)

function FightResult:ctor(data)
    self.data = data
	local black = display.newColorLayer(cc.c4b(0, 0, 0, 225))
	self:addChild(black)

    local str = {"Result_lost.json", "Result.json"}

	local node, width, height = cc.uiloader:load(str[data.data.success + 1])
    -- width = width or display.width
    -- height = height or display.height
    -- node:setAnchorPoint(0.5,0.5)
    if node then
        -- node:setPosition((display.width - width)/2, (display.height - height)/2)
        -- node:setPosition(cc.p(display.cx,display.cy))
        self:addChild(node)
    end

    local button = cc.uiloader:seekNodeByName(self, "back_button")
    button:onButtonClicked(function(event)
        self:back()
    end)

    -- audio.setMusicVolume(0.3)
    -- print("加载音乐。。。。。。。。。。。。。。。。")

end

function FightResult:open()
    audio.stopMusic(true)
    audio.stopAllSounds()

    if self.data.data.success == 1 then
        local items = self.data.data.lootList
        local i = 1
        for k,v in pairs(items) do
            local Ditem = cc.uiloader:seekNodeByName(self, "Ditem_"..i)
            local icon = GlobalController.item:getItemByKey(v.goodsId):getField("icon")
            local item = display.newSprite("res/icon/items_icon/"..icon..".png", Ditem:getContentSize().width * 0.5, Ditem:getContentSize().height * 0.5)
            Ditem:addChild(item)
            i = i + 1
        end

        items = self.data.data.starLootList
        i = 1
        for k,v in pairs(items) do
            local Ritem = cc.uiloader:seekNodeByName(self, "Ritem_"..i)
            local icon = GlobalController.item:getItemByKey(v.goodsId):getField("icon")
            local item = display.newSprite("res/icon/items_icon/"..icon..".png", Ritem:getContentSize().width * 0.5, Ritem:getContentSize().height * 0.5)
            Ritem:addChild(item)
            i = i + 1
        end
        cc.uiloader:seekNodeByName(self, "gold_number"):setString(self.data.data.gold)
        cc.uiloader:seekNodeByName(self, "exp_number"):setString(self.data.data.exp)

        print("播放胜利")
        audio.playMusic("sound/craftwin.mp3", false)
    else
        print("播放失败")
        audio.playMusic("sound/craftlose.mp3", false)
    end
end

function FightResult:close()
    audio.stopMusic(true)
    -- audio.stopAllSounds()

    -- audio.unloadSound("sound/craftwin.mp3")
    -- audio.unloadSound("sound/craftlose.mp3")
end

function FightResult:back()
    GlobalController.fight:clear()
    FightModel:clear()
 

    GlobalWinManger:openWin(WinName.CHAPTERVIEW)

    GameNet:sendMsgToSocket(15000,{iType = 1})
end

function FightResult:destory()
    self:removeSelf()
end

return FightResult