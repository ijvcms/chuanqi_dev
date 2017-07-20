--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-03-11 00:27:27
-- 变异地宫
--local AberrancePalaceTips = class("AberrancePalaceTips", BaseView)
local AberrancePalaceTips = class("AberrancePalaceTips", function()
	return display.newNode()
end)
function AberrancePalaceTips:ctor(winTag,data,winconfig)
	-- self.data = data
	-- self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
 --    self.bg:setContentSize(display.width, display.height)
	-- self:addChild(self.bg)
	--AberrancePalaceTips.super.ctor(self,winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/aberrancePalaceWin.ExportJson")
    self:addChild(self.root)

    self.root:setPosition((display.width-362 - 180),(display.height-94))

    self.mainLayer = cc.uiloader:seekNodeByName(self.root,"mainLayer")
    self.numLabel = cc.uiloader:seekNodeByName(self.root,"numLabel")
    self.timeLabel = cc.uiloader:seekNodeByName(self.root,"timeLabel")

    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 0, 356, 50),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png" }
        --:onTouch(handler(self, self.touchListener))
        :addTo(self.mainLayer)
    self.itemList = {}
    self:update()

    self.conf = {
        {sceneId = 32122,tips="第二层传送条件"},
        {sceneId = 32123,tips="第三层传送条件"},
        {sceneId = 32124,tips="第四层传送条件"},
        {sceneId = 32125,tips=""},
    }

    local apItem = require("app.modules.mainUI.AberrancePalaceTipsItem")
    local arr = {}
    for i=1,#self.conf -1 do
        local dd = self.conf[i]
        local item = self.itemListView:newItem()
        local content = apItem.new()
        --content:setData(self.conf[i],nil)
        self.itemList[i] = content
        item:addContent(content)
        item:setItemSize(105, 21)
        self.itemListView:addItem(item)

    end
    self.itemListView:reload()

    self.sceneTime = {}
    self.killBossNum = {}
    self:setNodeEventEnabled(true)
    --SceneManager.aberrancePalaceData
end

function AberrancePalaceTips:onCleanup()
    self:destory()
end

function AberrancePalaceTips:touchListener()
    -- body
end

function AberrancePalaceTips:update()
    if self.time and self.time >=1 then
        self.time = self.time - 1
        self.timeLabel:setString(StringUtil.convertTime(self.time))
    else
        self.timeLabel:setString("00:00:00")
        if self.timerId then
            GlobalTimer.unscheduleGlobal(self.timerId)
            self.timerId = nil
        end
    end
end

function AberrancePalaceTips:open()
    GameNet:sendMsgToSocket(11061)
	if self.timerId == nil then
        self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.update),1)
    end

    if self.apDataEventId == nil then
        local function onGetDatas(data)
            self:onUpdateDatas(data.data)
        end
        self.apDataEventId = GlobalEventSystem:addEventListener(SceneEvent.UPDATE_ABERRANCE_DATA,onGetDatas)
    end
end

function AberrancePalaceTips:onUpdateDatas()
    if SceneManager.aberrancePalaceData then
        local leftTimeArr = SceneManager.aberrancePalaceData.left_time
        local killBossArr = SceneManager.aberrancePalaceData.kill_boss
        local obj
        for i=1,#leftTimeArr do
            obj = leftTimeArr[i]
            self.sceneTime[obj.scene_id] = obj.time
        end

        for i=1,#killBossArr do
            obj = killBossArr[i]
            self.killBossNum[obj.scene_id] = obj
        end
        self.numLabel:setString(0)
        self.time = 0

        for i=1,#self.conf do
            local conf = self.conf[i]
            if self.killBossNum[conf.sceneId] then
                conf.bossId = self.killBossNum[conf.sceneId].boss_id
                conf.num = self.killBossNum[conf.sceneId].num
            else
                conf.bossId = 0
                conf.num = 0
            end
            if self.sceneTime[conf.sceneId] then
                conf.time = self.sceneTime[conf.sceneId]
            else
                conf.time = 0
            end
            if self.itemList[i] then
                self.itemList[i]:setData(conf)
            end
            if GameSceneModel.sceneId == conf.sceneId then
                self.numLabel:setString(conf.num)
                self.time = conf.time
                if self.timerId == nil then
                    self.timerId = GlobalTimer.scheduleGlobal(handler(self,self.update),1)
                end
            end
        end


    end
end

function AberrancePalaceTips:close()
    --AberrancePalaceTips.super.close(self)

    if self.timerId then
        GlobalTimer.unscheduleGlobal(self.timerId)
        self.timerId = nil
    end
    if self.apDataEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.apDataEventId)
        self.apDataEventId = nil
    end
end


--清理界面
function AberrancePalaceTips:destory()
    self:close()
   
end

return AberrancePalaceTips