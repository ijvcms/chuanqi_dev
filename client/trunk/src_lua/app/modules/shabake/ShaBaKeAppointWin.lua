--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-12-17 16:16:11
--
local ShaBaKeAppointWin = class("ShaBaKeAppointWin", BaseView)

-- 官员任命页面
-- choice01Bg      副城主选择框
-- choice02Bg      长老1选择框
-- choice03Bg      长老2选择框
-- choice04Bg      长老3选择框

-- Label_usenamer01  副城主玩家名字
-- Label_usenamer02  长老1玩家名字
-- Label_usenamer03  长老2玩家名字
-- Label_usenamer04  长老3玩家名字

-- Btn_recall01      罢免副城主按钮
-- Btn_recall02      罢免长老1按钮
-- Btn_recall03      罢免长老2按钮
-- Btn_recall04      罢免长老3按钮

-- Label_pagenumber  翻页页码数字  例：1/5    表示总共5页当前为第1页
-- Btn_leftpage      向前翻页
-- Btn_rightpage     向后翻页
-- Btn_confirm       确定任命按钮
function ShaBaKeAppointWin:ctor(winTag,data,winconfig)
	 self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setContentSize(display.width, display.height)
    --self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    self.ccui = cc.uiloader:load("resui/shabakepositionWin.ExportJson")
    self:addChild(self.ccui)

	  --ShaBaKeAppointWin.super.ctor(self,winTag,data,winconfig)
	  --self:creatPillar()
  	local root = cc.uiloader:seekNodeByName(self.ccui,"root")
  	root:setTouchEnabled(true)
  	local size = root:getContentSize()
  	root:setPosition((display.width - size.width)/2,(display.height - size.height)/2)
    self.Btn_colose = cc.uiloader:seekNodeByName(self.ccui,"Btn_close")
    self.Btn_colose:setTouchEnabled(true)
    self.Btn_colose:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                self.Btn_colose:setScale(1.1)
            elseif event.name == "ended" then
                self.Btn_colose:setScale(1)
                --GlobalWinManger:closeWin(self.winTag)
                self:removeSelfSafety()
            end
            return true
    end)

    self.choice01Bg = cc.uiloader:seekNodeByName(self.ccui,"choice01Bg")
    self.choice02Bg = cc.uiloader:seekNodeByName(self.ccui,"choice02Bg")
    self.choice03Bg = cc.uiloader:seekNodeByName(self.ccui,"choice03Bg")
    self.choice04Bg = cc.uiloader:seekNodeByName(self.ccui,"choice04Bg")
 
    self.guildname1 = cc.uiloader:seekNodeByName(self.ccui,"guildname1")
    self.guildname2 = cc.uiloader:seekNodeByName(self.ccui,"guildname2")
    self.guildname3 = cc.uiloader:seekNodeByName(self.ccui,"guildname3")
    self.guildname4 = cc.uiloader:seekNodeByName(self.ccui,"guildname4")

    self.Label_usenamer01 = cc.uiloader:seekNodeByName(self.ccui,"Label_usenamer01")
    self.Label_usenamer02 = cc.uiloader:seekNodeByName(self.ccui,"Label_usenamer02")
    self.Label_usenamer03 = cc.uiloader:seekNodeByName(self.ccui,"Label_usenamer03")
    self.Label_usenamer04 = cc.uiloader:seekNodeByName(self.ccui,"Label_usenamer04")
 
    self.Btn_recall01 = cc.uiloader:seekNodeByName(self.ccui,"Btn_recall01")
    self.Btn_recall02 = cc.uiloader:seekNodeByName(self.ccui,"Btn_recall02")
    self.Btn_recall03 = cc.uiloader:seekNodeByName(self.ccui,"Btn_recall03")
    self.Btn_recall04 = cc.uiloader:seekNodeByName(self.ccui,"Btn_recall04")
 
    self.Label_pagenumber = cc.uiloader:seekNodeByName(self.ccui,"Label_pagenumber")
    self.Btn_leftpage = cc.uiloader:seekNodeByName(self.ccui,"Btn_leftpage")
    self.Btn_rightpage = cc.uiloader:seekNodeByName(self.ccui,"Btn_rightpage")
    self.Btn_confirm = cc.uiloader:seekNodeByName(self.ccui,"Btn_confirm")

    self.selectSpr = display.newScale9Sprite("#com_listSelFrame.png", 10, 10, cc.size(286, 78))
    root:addChild(self.selectSpr)
    self.selectSpr:setVisible(false)

    self.Btn_recall01:setVisible(false)
    self.Btn_recall02:setVisible(false)
    self.Btn_recall03:setVisible(false)
    self.Btn_recall04:setVisible(false)

    self.rightLayer = display:newNode()
    self.itemList = {}
    self.playerIdList = {}
 
    local clickfun = function()    
          for i=1,#self.itemList do
             self.itemList[i]:setSelect(false)
          end
    end
    for i=1,6 do
        local  item = require("app.modules.shabake.MemberItem").new()
        item:setPosition(0, 40*(0 - i))
        item:setContentSize(cc.size(442, 38))
        item:setTouchEnabled(true)
        item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
           if event.name == "began" then
          elseif event.name == "ended" then
            clickfun()
            item:setSelect(true)
            self.currentClickItemData = item:getData()
          end
          return true
      end)

        self.rightLayer:addChild(item)
        self.itemList[i] = item
        
    end

    root:addChild(self.rightLayer)
    self.rightLayer:setPosition(388, 344)

    self:addEventTouch()
    self:setleftinfo()

    self.currentMin = 1
    self.currentMax = 6
    self.currentPage = 0
    self.member_num = 0
 
    GameNet:sendMsgToSocket(25000,{min_value = self.currentMin, max_value = self.currentMax})
    self:setNodeEventEnabled(true)

end	

function ShaBaKeAppointWin:addEventTouch()

    self.choice01Bg:setTouchEnabled(true)
    self.choice02Bg:setTouchEnabled(true)
    self.choice03Bg:setTouchEnabled(true)
    self.choice04Bg:setTouchEnabled(true)

    self.Btn_recall01:setTouchEnabled(true)
    self.Btn_recall02:setTouchEnabled(true)
    self.Btn_recall03:setTouchEnabled(true)
    self.Btn_recall04:setTouchEnabled(true)
 
    self.Btn_leftpage:setTouchEnabled(true)
    self.Btn_rightpage:setTouchEnabled(true)
    self.Btn_confirm:setTouchEnabled(true)

    self.choice01Bg:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
           if event.name == "began" then
          elseif event.name == "ended" then
            self:LeftTouch(1)
          end
          return true
      end)

    self.choice02Bg:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
          elseif event.name == "ended" then
            self:LeftTouch(2)
          end
          return true
      end)

    self.choice03Bg:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then

          elseif event.name == "ended" then
            self:LeftTouch(3)
          end
          return true
      end)

    self.choice04Bg:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
             
          elseif event.name == "ended" then
          self:LeftTouch(4)
          end
          return true
      end)
------任命

    self.Btn_recall01:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
            self.Btn_recall01:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_recall01:setScale(1)
            self:recallTouch(1)
          end
          return true
      end)

    self.Btn_recall02:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
            self.Btn_recall02:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_recall02:setScale(1)
            self:recallTouch(2)
          end
          return true
      end)

    self.Btn_recall03:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
            self.Btn_recall03:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_recall03:setScale(1)
            self:recallTouch(3)
          end
          return true
          
      end)

    self.Btn_recall04:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
              self.Btn_recall04:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_recall04:setScale(1)
            self:recallTouch(4)
          end
          return true
          
      end)
------
 
    self.Btn_leftpage:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
              self.Btn_leftpage:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_leftpage:setScale(1)
            if self.currentPage > 1 then
              GameNet:sendMsgToSocket(25000,{min_value = self.currentMin - 6, max_value = self.currentMax - 6 })
            end
          end
          return true

      end)

    self.Btn_rightpage:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
       if event.name == "began" then
              self.Btn_rightpage:setScale(1.1)
          elseif event.name == "ended" then
            self.Btn_rightpage:setScale(1)
            if self.currentPage < self.member_num then
              GameNet:sendMsgToSocket(25000,{min_value = self.currentMin + 6, max_value = self.currentMax + 6 })
            end
          end
          return true

      end)

    self.Btn_confirm:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
             self.Btn_confirm:setScale(1.1)
        elseif event.name == "ended" then
            self.Btn_confirm:setScale(1)

            if self.currentClickOfficer ~= nil and  self.currentClickItemData~= nil then
              GameNet:sendMsgToSocket(25001,{officer_id = self.currentClickOfficer.officer_id, tplayerId = self.currentClickItemData.player_id })
            end
            
        end
          return true
        end)


    GlobalEventSystem:addEventListener(ShaBaKeEvent.SBK_OFFICIAL_INFO, handler(self, self.setViewInfo))
    GlobalEventSystem:addEventListener(ShaBaKeEvent.SBK_OFFICIAL_UDATAELEFT, handler(self, self.updateLeft))
end

function ShaBaKeAppointWin:setleftinfo()
  local config = configHelper:getShabakeOfficer()
  for i=1,#config do
    self["guildname"..i]:setString(config[i].name)
  end

end


function ShaBaKeAppointWin:setViewInfo(data)

  self.data = data.data[1]
--设置官员名字
  local info
  local config = configHelper:getShabakeOfficer()

  for j=1,#config do

    self["Label_usenamer0"..j]:setString("")
    self["Btn_recall0"..j]:setVisible(false)
    self.playerIdList[j] = 0

    for i=1,#data.data[1].city_officer_list do
      info = data.data[1].city_officer_list[i]

      if info and config[j].officer_id == info.officer_id then

        self["Label_usenamer0"..j]:setString(info.tname)
        self["Btn_recall0"..j]:setVisible(true)
        self.playerIdList[j] = info.tplayer_id
        table.remove(data.data[1].city_officer_list, i)
        info = nil
        break

      end
    end

  end
 
--设置页码
  self.currentMin = data.data[1].min_value
  self.currentMax = self.currentMin + 6

  self.currentPage = math.ceil(data.data[1].min_value/6)
  self.member_num = math.ceil(data.data[1].member_num/6)
  self.Label_pagenumber:setString(self.currentPage.."/"..self.member_num )

  --成员列表
    if data.data[1].guild_member_list and  #data.data[1].guild_member_list then
 
      for i=1,6 do
          self.itemList[i]:setData(data.data[1].guild_member_list[i])
      end

    end
end

function ShaBaKeAppointWin:updateLeft(data)
 
  self.data.city_officer_list = data.data[1].city_officer_list
  local info
  local config = configHelper:getShabakeOfficer()

  for j=1,#config do

    self["Label_usenamer0"..j]:setString("")
    self["Btn_recall0"..j]:setVisible(false)
    self.playerIdList[j] = 0

    for i=1,#data.data[1].city_officer_list do
      info = data.data[1].city_officer_list[i]

      if info and config[j].officer_id == info.officer_id then
        self["Label_usenamer0"..j]:setString(info.tname)
        self["Btn_recall0"..j]:setVisible(true)
        self.playerIdList[j] = info.tplayer_id
        table.remove(data.data[1].city_officer_list, i)
        info = nil
        break
      end
    end

  end
end

--左侧职位选择点击
function ShaBaKeAppointWin:LeftTouch(index)

  self.selectSpr:setPosition(self["choice0"..index.."Bg"]:getPositionX() + 142, self["choice0"..index.."Bg"]:getPositionY() + 40)
  self.selectSpr:setVisible(true)
  local config = configHelper:getShabakeOfficer()
  self.currentClickOfficer = config[index]
 
end
--左侧职位任命按钮点击
function ShaBaKeAppointWin:recallTouch(index)

  local id =  self.playerIdList[index]
  dump(id)
  if info ~= 0 then
    GameNet:sendMsgToSocket(25002,{tplayerId = id })
  end

end
 
function ShaBaKeAppointWin:open()
    
end
	
function ShaBaKeAppointWin:close()
    GlobalEventSystem:removeEventListener(ShaBaKeEvent.SBK_OFFICIAL_INFO)
    GlobalEventSystem:removeEventListener(ShaBaKeEvent.SBK_OFFICIAL_UDATAELEFT)
end

function ShaBaKeAppointWin:destory()
    self:close()
    self.super.destory(self)
end

function ShaBaKeAppointWin:createItem()

  local node = display.newNode()
  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(node, 1, 1):pos(92, 0)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(node, 2, 2):pos(192, 0)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(node, 3, 3):pos(262, 0)

  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(node, 4, 4):pos(336, 0)


  display.newTTFLabel({
      text = "",
      size = 20,
      color = TextColor.TEXT_W,
      align = cc.TEXT_ALIGNMENT_CENTER
    }):addTo(node, 5, 5):pos(418, 0)

  return node

end


return ShaBaKeAppointWin