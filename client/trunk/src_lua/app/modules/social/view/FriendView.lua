--
-- Author: Your Name
-- Date: 2015-12-15 15:42:57
--

require("app.modules.social.view.FriendItem")

local FriendView = FriendView or class("FriendView", BaseView)

function FriendView:ctor(winTag,data,winconfig)

	FriendView.super.ctor(self, winTag,data,winconfig)

  self.currentTab = 1
  self.currentClickItemId = 0
  self.itemList = {}
  self.currentClickItemVo = nil
  self.addFriendView = nil
	self.scrollLayer = cc.uiloader:seekNodeByName(self.root,"scrollLayer")
	self.friendNumLbl = cc.uiloader:seekNodeByName(self.root,"friendNumLbl")
	self.stateLbal = cc.uiloader:seekNodeByName(self.root,"stateLbal")
  self.btnLbl = cc.uiloader:seekNodeByName(self.root,"btnLbl")
	 
	self.addFriendBtn = cc.uiloader:seekNodeByName(self.root,"addFriendBtn")
	self.cancelBtn = cc.uiloader:seekNodeByName(self.root,"cancelBtn")
	self.moreOpBtn = cc.uiloader:seekNodeByName(self.root,"moreOpBtn")

	self.spr1 = cc.uiloader:seekNodeByName(self.root,"spr1")
	self.spr3 = cc.uiloader:seekNodeByName(self.root,"spr3")
	self.spr4 = cc.uiloader:seekNodeByName(self.root,"spr4")
	 
	self.opWin = cc.uiloader:seekNodeByName(self.root,"opWin")
	self.btn1 = cc.uiloader:seekNodeByName(self.root,"btn1")
	self.btn2 = cc.uiloader:seekNodeByName(self.root,"btn2")
	self.btn3 = cc.uiloader:seekNodeByName(self.root,"btn3")
	self.btn4 = cc.uiloader:seekNodeByName(self.root,"btn4")
	self.btn5 = cc.uiloader:seekNodeByName(self.root,"btn5")
 
  self.ListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0,0,self.scrollLayer:getBoundingBox().width, self.scrollLayer:getBoundingBox().height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(handler(self, self.touchListener))
        :addTo(self.scrollLayer)
 
 self.friendNumLbl:setString("0/50")
	self.addFriendBtn:setTouchEnabled(true)
	self.cancelBtn:setTouchEnabled(true)
	self.moreOpBtn:setTouchEnabled(true)
 
	self.cancelBtn:setVisible(false)

	self.opWin:setTouchEnabled(true)
	self.btn1:setTouchEnabled(true)
	self.btn2:setTouchEnabled(true)
	self.btn3:setTouchEnabled(true)
	self.btn4:setTouchEnabled(true)
	self.btn5:setTouchEnabled(true)

	self.spr1:setTouchEnabled(true)
	self.spr3:setTouchEnabled(true)
	self.spr4:setTouchEnabled(true)

	self.opWin:setVisible(false)

  self.type = 1
  self.title = "添加好友"

	self.spr1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        SoundManager:playClickSound()
    elseif event.name == "ended" then
    	self:handlerSelButton(1)
    	self.addFriendBtn:setVisible(true)
      self.title = "添加好友"
      self.addFriendBtn:setButtonLabelString(self.title)
      self.type = 1
		  self.cancelBtn:setVisible(false)
		  self.moreOpBtn:setVisible(true)
 
    end
      return true
  end)

	self.spr3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        SoundManager:playClickSound()
    elseif event.name == "ended" then
    	self:handlerSelButton(3)
    	self.addFriendBtn:setVisible(false)
		  self.cancelBtn:setVisible(true)
		  self.moreOpBtn:setVisible(false)
 
    end
      return true
  end)

	self.spr4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        SoundManager:playClickSound()
    elseif event.name == "ended" then
    	self:handlerSelButton(4)
    	self.addFriendBtn:setVisible(true)
      self.title = "添加仇人"
      self.addFriendBtn:setButtonLabelString(self.title)
      self.type = 2
		  self.cancelBtn:setVisible(false)
		  self.moreOpBtn:setVisible(true)
 
    end
      return true
  end)
 --打开添加好友窗口
	self.addFriendBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.addFriendBtn:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.addFriendBtn:setScale(1)
        
        local  node = require("app.modules.social.view.FriendAddView").new(self.title,self.type)
       if node ~= nil then
         GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node) 
       end
        
    end
      return true
  end)
--取消拉黑 
	self.cancelBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.cancelBtn:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.cancelBtn:setScale(1)
        if self.currentClickItemVo ~= nil then
          GameNet:sendMsgToSocket(24001,{tplayer_id = self.currentClickItemVo.playerId, type = self.currentTab})
        end
    end
      return true
  end)

	self.moreOpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.moreOpBtn:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.moreOpBtn:setScale(1)
        self.opWin:setVisible(true)
    end
      return true
  end)

	self.opWin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
      self.opWin:setVisible(false)
    elseif event.name == "ended" then
        self.opWin:setVisible(false)
    end
      return true
  	end)
--私聊
	self.btn1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.btn1:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.btn1:setScale(1)
        
        if self.currentClickItemVo ~= nil then
          local  data = {}
          data.id = self.currentClickItemVo.playerId
          data.name = self.currentClickItemVo.name
          GlobalWinManger:closeWin(GlobalWinManger.curWinTag)
          if GlobalWinManger:getWin(WinName.CHAT) then
              GlobalEventSystem:dispatchEvent(ChatEvent.SET_PRIVATE_CHAT,data)
          else
              GlobalWinManger:openWin(WinName.CHAT,{tabIndex = ChatChannelType.PRIVATE,data = data})
          end
        end
    end
      return true
  end)
--信息查看
	self.btn2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.btn2:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.btn2:setScale(1)
        if self.currentClickItemVo ~= nil then
          GameNet:sendMsgToSocket(10011, {player_id = self.currentClickItemVo.playerId})
        end
        self.opWin:setVisible(false)
    end
      return true
  end)
--邀请行会
	self.btn3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.btn3:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.btn3:setScale(1)

        if  RoleManager:getInstance().guildInfo.position == 1 or  RoleManager:getInstance().guildInfo.position == 2 then
          if self.currentClickItemVo ~= nil then
          GameNet:sendMsgToSocket(17054, {tplayer_id = self.currentClickItemVo.playerId})
          end

        elseif RoleManager:getInstance().guildInfo.position ~= 0 then
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您的职位不够!")
        else
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"您还没有行会!")
        end

        
        self.opWin:setVisible(false)
    end
      return true
  end)
--添加删除好友
	self.btn4:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.btn4:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.btn4:setScale(1)
        if self.currentClickItemVo ~= nil then
          if self.currentTab == 4 then
            --添加好友
            GameNet:sendMsgToSocket(24003,{tplayerId = self.currentClickItemVo.playerId})
            
          else
            --删除好友
            GameNet:sendMsgToSocket(24001,{tplayer_id = self.currentClickItemVo.playerId, type = self.currentTab})
          end
          
        end
        self.opWin:setVisible(false)
    end
      return true
  end)
--拉黑
	self.btn5:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    if event.name == "began" then
        self.btn5:setScale(1.1)
        SoundManager:playClickSound()
    elseif event.name == "ended" then
        self.btn5:setScale(1)
        if self.currentClickItemVo ~= nil then
          if index ~= 4 then
            GameNet:sendMsgToSocket(24001,{tplayer_id = self.currentClickItemVo.playerId, type = self.currentTab})
          end
          GameNet:sendMsgToSocket(24002,{tplayer_id = self.currentClickItemVo.playerId})
        end
        self.opWin:setVisible(false)
    end
      return true
  end)

  GlobalEventSystem:addEventListener(FriendEvent.FRIEND_UPDATE_GOODFRIENDLIST, handler(self, self.updateList))
  GlobalEventSystem:addEventListener(FriendEvent.FRIEND_UPDATE_BLACKLIST, handler(self, self.setViewInfo))
  GlobalEventSystem:addEventListener(FriendEvent.FRIEND_UPDATE_ENEMYLIST, handler(self, self.setViewInfo))
  GlobalEventSystem:addEventListener(FriendEvent.FRIEND_UPDATE_APPLYLIST, handler(self, self.setViewInfo))
 
  GlobalEventSystem:addEventListener(FriendEvent.FRIEND_GETLIST, handler(self, self.setViewInfo))
--默认选1:我的好友
  self:handlerSelButton(1)

end


--

function FriendView:handlerSelButton(index)

	for i=1,4 do
    if i ~= 2 then
 
      if i == index then
        self["spr"..i]:setSpriteFrame("com_labBtn4Sel.png")
      else
  		  self["spr"..i]:setSpriteFrame("com_labBtn4.png")
      end
    end
	end

  self.currentTab = index

  GameNet:sendMsgToSocket(24000,{type = index})

  if index == 4 then
    self.btnLbl:setString("添加好友")
  else
    self.btnLbl:setString("删除好友")
  end
 
end
 
function FriendView:setViewInfo(data)
 
  data = data.data
  self.itemList = {}

  if self.ListView then
    self.ListView:removeAllItems()
  end

  if self.friendNumLbl then
    self.friendNumLbl:setString(data.friendNum.."/50")
  end
  

  if data ~= nil and data.list and #data.list > 0 and self.ListView then

    for i=1,#data.list do

        local item = self.ListView:newItem()
        local content = FriendItem.new(data.list[i], self.currentTab )
 
              self.itemList[i] = content
              item:addContent(content)
              item:setItemSize(596, 44)
              self.ListView:addItem(item)
 
    end
    self.ListView:reload()

  end
end
--添加好友
function FriendView:addFriendItem(data)
  local item = self.ListView:newItem()
  local content = FriendItem.new(data.data[i], self.currentTab )
   
  self.itemList[#self.itemList + 1] = content
  item:addContent(content)
  item:setItemSize(596, 44)
  self.ListView:addItem(item)
  self.ListView:reload()
end

function FriendView:removeItem(data)
end

function FriendView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        self.currentClickItemVo = self.itemList[event.itemPos]:getData()
        for i=1,#self.itemList do
          self.itemList[i]:setSelect(false)
        end
        self.itemList[event.itemPos]:setSelect(true)
    elseif "moved" == event.name then
         
    elseif "ended" == event.name then
         
    end
end
function FriendView:open()

end
function FriendView:close()

end
function FriendView:destory()
  print("FriendView:destory")
  GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_UPDATE_GOODFRIENDLIST)
  GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_UPDATE_BLACKLIST)
  GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_UPDATE_ENEMYLIST)
  GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_UPDATE_APPLYLIST)
 
  GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_GETLIST)
  self.super.destory(self)
end
 
return FriendView