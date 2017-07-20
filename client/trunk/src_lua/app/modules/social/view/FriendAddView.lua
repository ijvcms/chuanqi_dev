--
-- Author: Your Name
-- Date: 2015-12-18 14:59:30
--
local FriendAddView = FriendAddView or class("FriendAddView", function()
	return display.newNode()
end)

function FriendAddView:ctor(title,type)

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
  self.bg:setContentSize(display.width, display.height)
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(true)
  self:addChild(self.bg)
  	
  self.data = data

	local ccui = cc.uiloader:load("resui/frendaddWin.ExportJson")
  ccui:setPosition(display.cx - ccui:getBoundingBox().width/2, display.cy - ccui:getBoundingBox().height/2)

	local root = cc.uiloader:seekNodeByName(ccui, "root")
  root:setTouchEnabled(true)
  root:setTouchSwallowEnabled(true)
  root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self:onCloseClick()
        end     
        return true
      end)
  self:addChild(ccui)

  self.type = type
  self.title = cc.uiloader:seekNodeByName(ccui, "title")   
  	self.name = cc.uiloader:seekNodeByName(ccui, "name")
  	self.lv = cc.uiloader:seekNodeByName(ccui, "lv")
	self.career = cc.uiloader:seekNodeByName(ccui, "career")
  	self.Buttonadd = cc.uiloader:seekNodeByName(ccui, "Buttonadd")
 	self.Buttoncancel = cc.uiloader:seekNodeByName(ccui, "Buttoncancel")
 	self.Btnsearch = cc.uiloader:seekNodeByName(ccui, "Btn_search")
 	self.inputText = cc.uiloader:seekNodeByName(ccui, "inputtext")
 	self.win2 = cc.uiloader:seekNodeByName(ccui, "win2")
 	self.win3 = cc.uiloader:seekNodeByName(ccui, "win3")
	self.inputText:setVisible(false)


  self.title:setString(title)
 	self.inputName = cc.ui.UIInput.new({
          UIInputType = 1,
          size =  cc.size(250, 40),
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(250, 40)
        })
    self.inputName:setPlaceHolder("点击输入玩家名字")
    self.inputName:setFontSize(10)
    self.inputName:setPosition(self.inputText:getPosition())
    self.inputName:setMaxLength(10)
    self.win3:addChild(self.inputName)
    self.inputName:setColor(cc.c3b(61,61,61))

    self.win2:setVisible(false)

    self.Buttonadd:setTouchEnabled(true)
    self.Buttonadd:setTouchSwallowEnabled(true)
    self.Buttonadd:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.Buttonadd:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.Buttonadd:setScale(1)
    
        	if self.playerId ~= nil and self.playerId ~= 0 then
        		
            if self.type == 1 then
                --1 好友 2:仇人
                GameNet:sendMsgToSocket(24003, {tplayerId = self.playerId})
              elseif self.type == 2 then
                GameNet:sendMsgToSocket(24009, {tplayer_id = self.playerId})
              end
        		self:onCloseClick()
        	end
     
        end     
        return true
    end)

    self.Buttoncancel:setTouchEnabled(true)
    self.Buttoncancel:setTouchSwallowEnabled(true)
    self.Buttoncancel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.Buttoncancel:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.Buttoncancel:setScale(1)
          self:onCloseClick()
        end     
        return true
    end)

    self.Btnsearch:setTouchEnabled(true)
    self.Btnsearch:setTouchSwallowEnabled(true)
    self.Btnsearch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	self.Btnsearch:setScale(1.1)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
        	self.Btnsearch:setScale(1)
        	local pname = StringUtil.trim(self.inputName:getText())
            if  pname == "" and pname ~=  RoleManager:getInstance().roleInfo.name then
            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请输入玩家名字!")
           	elseif pname ==  RoleManager:getInstance().roleInfo.name then
              GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"不能添加自己!")
            else
              GameNet:sendMsgToSocket(24005, {name = pname})
            end
        end     
        return true
    end)

    GlobalEventSystem:addEventListener(FriendEvent.FRIEND_RESEARCH, handler(self, self.onSwitchWin))
    --GlobalEventSystem:addEventListener(FriendEvent.FRIEND_APPLYFRIEND, handler(self, self.onCloseClick))
end

function FriendAddView:onSwitchWin(data)

  self.win2:setVisible(true)

  self.win3:setVisible(false)
  self.inputName:setVisible(false)
 
 	self.name:setString(data.data.name) 
  	self.lv:setString(data.data.lv)
  if data.data.career == 1000 then
    self.career:setString("战士")
  elseif data.data.career == 2000 then
    self.career:setString("法师")
  elseif data.data.career == 3000 then
    self.career:setString("道士")
  end
	self.playerId = data.data.tplayer_id
end

function FriendAddView:onCloseClick()
   if self:getParent() then
    --self:setVisible(false)
    self:removeSelfSafety()
    GlobalEventSystem:removeEventListener(FriendEvent.FRIEND_RESEARCH)
  end
end


return FriendAddView