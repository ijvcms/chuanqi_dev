

local ActivityOpenCommView = class("ActivityOpenCommView", BaseView)

--創建對象之後自動調用
--function alertExerciseView:ctor()
	
	--print("有進來這裡的。看下是否有對象的話：")
	---讀取alertView
    --GlobalWinManger:closeWin(WinName.ALERTEXERCISEVIEW)
	--self.alertExerciseView = cc.uiloader.load("res.resui.alertExerciseView.ExportJson")

	--添加
	--self:addChild(self.alertExerciseView)

	--設置位置
	--local alertSize = self.alertExerciseView:getcontentSize()
	--self:setPosition((display.width - alertSize.width) * 0.5, (display.height - alertSize.height) * 0.5)
	--self:init()
--end

function ActivityOpenCommView:ctor(winTag,data,winconfig)
    ActivityOpenCommView.super.ctor(self,winTag,data,winconfig)

    --标题
    self.titlelbl = self:seekNodeByName("titlelbl")
    self.titlelbl:setString("改变吧！騷年，會自動居中的")

    --活动图片
    self.headImage = self:seekNodeByName("headImage")
    self.headImage:setSpriteFrame("scene/scene_tabBtnSel.png")
    --self.headImage:ignoreContentAdaptWithSize(false)
    self.headImage:setContentSize(100, 2)
    self.headImage:setScaleX(5)
    self.headImage:setScaleY(2)

    --self.headImage:setAnchorPoint(0,0.5)
    print("容器宽度："..self:getContentSize().width)
    print("图片宽度："..self.headImage:getContentSize().width)

    --活动内容
    self.activeContentlbl = self:seekNodeByName("activeContentlbl")
    self.activeContentlbl:setString("在不在呀？你也是一个人玩的这个游戏么，我们一起玩不^i(38)^\n你是一个人玩的嘛？^i(11)^\n三行\n四行\n五行\n六行")

    --活动时间
    self.activeTimer = self:seekNodeByName("activeTimer")
    self.activeTimer:setString("0:00-24:00");

    --活动奖励按鈕
    self.itemList = {}
    for i=1,7 do
    	
    	nodeByName = "item"..i
    	item = self:seekNodeByName(nodeByName)
    	self.itemList[nodeByName] = item
    end
  
    --self.activityReward1 = activityRewardList["activityReward2"]
    
    --self.activityReward1:setButtonImage("normal", "#roleWin_SPBtn.png")

	--进入活动按钮
	self.enterActiveBtn = self:seekNodeByName("enterActiveBtn")
	self.enterActiveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		
		if event.name == "began" then
			
		elseif event.name == "ended" then
			print("进入活动去浪…")
		end
		return true
	end)

    --关闭按钮
    self.closeBtn = self:seekNodeByName("closeBtn")
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)

		if event.name == "began" then
            self.closeBtn:setScale(1.1)
		elseif event.name == "ended" then
            self.closeBtn:setScale(1)
            GameNet:sendMsgToSocket(11051)
			GlobalWinManger:closeWin(self.winTag)
		end
		return true
	end)
 end

 function ActivityOpenCommView:open(datas)
   
   self:setVisible(true)

   --数据模拟
   self.dataList = {
    {110294, 5, 2}, {110163, 6, 1}, {305021., 7, 1}, {110222, 0 , 1}, {110260, 0 , 2}, {110102, 0 , 4}}
   for i=1,#self.dataList do
      
      itemKey = "item"..i
      item = self.itemList[itemKey]

      local data = self.dataList[i]
      local itemChild = CommonItemCell.new()
      item:addChild(itemChild)

      itemChild:setData({goods_id = data[1],is_bind = data[2], num = data[3]})
      itemChild:setCount(67)
      itemChild:setPosition(0,0)
    end
 end

function ActivityOpenCommView:close()
    ActivityOpenCommView.super.close(self)
end

return ActivityOpenCommView