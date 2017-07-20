--
-- Author: Your Name
-- Date: 2015-11-30 11:45:20
--
local DailyTaskView = class("DailyTaskView", BaseView)

function DailyTaskView:ctor(winTag,data,winconfig)
	DailyTaskView.super.ctor(self,winTag,data,winconfig)

  self.data = data
  self:setTouchEnabled(true)

  self.cur = 0
  self.total = 0
  self.getList = {}
   
  self:init()

end

function DailyTaskView:init()

  self.leftitemList = {}
  self.rightItemList = {}

  local root = self:getRoot()
  self.progress = cc.uiloader:seekNodeByName(root, "progress")
  self.goalPoint = cc.uiloader:seekNodeByName(root, "goalPoint")

  local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0,0,400,480)}
  self.leftListView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
  self.leftListViewAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/goalWin_2.ExportJson", "app.modules.dailyTask.view.DailyTaskLeftItem", 20)
  self.leftListView:setAdapter(self.leftListViewAdapter)
  root:addChild(self.leftListView)
  self.leftListView:setPosition(10, 10)

  self.rightListView = SCUIList.new {
        viewRect = cc.rect(0,0,470, 395),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --:onTouch(handler(self, self.touchListener))
        :addTo(self:getRoot()):pos(403, 8)
end
 
function DailyTaskView:refreshList(data)

  if data == nil then
    return 
  end

  if self.leftitemList and #self.leftitemList > 0 then
      self.leftitemList = {}
      self.leftListView:removeAllItems()
  end

  data = data.data
  self.cur = data.cur
  self.total = data.total
  self.progress:setPercent(data.cur/data.total*100)
  self.goalPoint:setString(data.cur.."/"..data.total)
  self.getList = data.getList
  --[[
    for i=1,#data.list do
      local item = self.leftListView:newItem()
      local content = require("app.modules.dailyTask.view.DailyTaskLeftItem").new()
      content:setData(data.list[i])
      --content:setItemClickFunc(handler(self, self.invite))
      item:addContent(content)
      item:setItemSize(content:getContentSize().width, content:getContentSize().height)
      table.insert(self.leftitemList, content)
      self.leftListView:addItem(item) 
      self.leftListView:reload()
    end
  --]]
  self:initLeft(data)
  self:initRightReward()
 
end

function DailyTaskView:initLeft(data)
  if data == nil then
    return
  end
  self.dataList = data.list
  self:setPageInfo()
end

function DailyTaskView:setPageInfo()
    self.leftListViewAdapter:setData(self.dataList)
end

function DailyTaskView:initRightReward()

  if self.rightItemList and #self.rightItemList > 0 then
      self.rightItemList = {}
      self.rightListView:removeAllItems()
  end

  local config = configHelper:getDailyTaskReward()

  for i=1,#config do
      local item = self.rightListView:newItem()
      local content = require("app.modules.dailyTask.view.DailyTaskRightItem").new()
      if config[i].need_active > self.cur then
        config[i].finish = 0
      else

        config[i].finish = 1

        for j=1,#self.getList do
          if tonumber(config[i].need_active) == tonumber(self.getList[j]) then
            config[i].finish = 2
            break
          end
        end
        
      end

      content:setData(config[i])
      --content:setItemClickFunc(handler(self, self.invite))
      item:addContent(content)
      item:setItemSize(content:getContentSize().width, content:getContentSize().height)
      table.insert(self.rightItemList, content)
      self.rightListView:addItem(item) 
      self.rightListView:reload()
  end

end

function DailyTaskView:jump(winTag)
  GlobalWinManger:openWin(winTag)
end
 
function DailyTaskView:open()
 
    GlobalEventSystem:addEventListener(DailyTaskEvent.GET_TASK_INFO, handler(self, self.refreshList))
    --GlobalEventSystem:addEventListener(DailyTaskEvent.UPDATE_TASK_INFO, function() GameNet:sendMsgToSocket(19000, {player_id = RoleManager.Instance.roleInfo.player_id}) end)
    GameNet:sendMsgToSocket(19000, {player_id = RoleManager.Instance.roleInfo.player_id})
end

function DailyTaskView:close()
	DailyTaskView.super.close(self)
  GlobalEventSystem:removeEventListener(DailyTaskEvent.GET_TASK_INFO)
  --GlobalEventSystem:removeEventListener(DailyTaskEvent.UPDATE_TASK_INFO)
end

--清理界面
function DailyTaskView:destory()
  self:close()
  self.leftListView:onCleanup()
	DailyTaskView.super.destory(self)
end
 
return DailyTaskView