--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2017-10-12 09:30:19
-- 技能界面
local SkillView = class("SkillView", BaseView)
function SkillView:ctor(winTag,data,winconfig)
	  SkillView.super.ctor(self,winTag,data,winconfig)

    self.rootLay = display.newNode()
    self.rootLay:setTouchEnabled(false)
    self.rootLay:setContentSize(880,500)

    local lbg = display.newScale9Sprite("#com_tabBg1.png", 0, 0, cc.size(110, 488))
    self.rootLay:addChild(lbg)
    lbg:setPosition(55, 250)

    self.rbg = display.newScale9Sprite("#com_tabBg1.png", 0, 0, cc.size(760, 488))
    self.rootLay:addChild(self.rbg)
    self.rbg:setPosition(120+380, 250)

    self:addChildToViewBg(self.rootLay)
    --self.rootLay:setPosition((display.width-960)/2,(display.height-640)/2)
  	self.data = data
    display.addSpriteFrames("resui/skill0.plist", "resui/skill0.png")

  	self.tabList = {
  		  {"技能列表","jnlb"},
  		  {"快捷设置","kjsz"},
  		  {"自动战斗","zdzd"},
  	}
  	self.tabBtnView = {}
  	self.curSelectTab = nil
  	local tabBtnItem = require("app.gameui.TabBtn")
  	for i=1,#self.tabList do
    		local item = tabBtnItem.create({label = self.tabList[i][1],data = self.tabList[i]})
    		if i == 1 then
            self.curSelectTab = item
            item:setSelect(true)
        end
        self.tabBtnView[i] = item
    		self.rootLay:addChild(item)
    		item:setPosition(56,443-70*(i-1))
    		item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
      			if event.name == "began" then
                if item:getSelect() == true then
                    return true
                end
        				if self.curSelectTab then
        					self.curSelectTab:setSelect(false)
        				end
        				self.curSelectTab = item
        				self.curSelectTab:setSelect(true)
                self:switchView(self.tabList[i])
      			end
            return true
    		end)
  	end
    self:switchView(self.curSelectTab.data)
end

function SkillView:switchView(data)
  if "jnlb" == data[2] then --列表
      if self.skillListView == nil then
          self.skillListView = require("app.modules.skill.view.SkillListView").new()
          self.rbg:addChild(self.skillListView)
          --self.skillListView:setPosition(40,110)
      end
      self.skillListView:setVisible(true)
      self.skillListView:open()
      if self.skillAutoView then
          self.skillAutoView:setVisible(false)
          self.skillAutoView:close()
      end
      if self.skillQuickView then
          self.skillQuickView:setVisible(false)
          self.skillQuickView:close()
      end
      
  elseif "kjsz" == data[2] then --设置
      if self.skillQuickView == nil then
          self.skillQuickView = require("app.modules.skill.view.SkillQuickView").new()
          self.rbg:addChild(self.skillQuickView)
          --self.skillQuickView:setPosition(40,110)
      end
      self.skillQuickView:setVisible(true)
      self.skillQuickView:open()
      if self.skillAutoView then
          self.skillAutoView:setVisible(false)
          self.skillAutoView:close()
      end
      if self.skillListView then
          self.skillListView:setVisible(false)
          self.skillListView:close()
      end
      -- GUIDE CONFIRM
      GlobalController.guide:notifyEventWithConfirm(GUIOP.CLICK_SKILL_QUICK_TAG)
  elseif "zdzd" == data[2] then --自动战斗
      if self.skillAutoView == nil then
          self.skillAutoView = require("app.modules.skill.view.SkillAutoView").new()
          self.rbg:addChild(self.skillAutoView)
          --self.skillAutoView:setPosition(40,110)
      end
      self.skillAutoView:setVisible(true)
      self.skillAutoView:open()
      if self.skillQuickView then
          self.skillQuickView:setVisible(false)
          self.skillQuickView:close()
      end
      if self.skillListView then
          self.skillListView:setVisible(false)
          self.skillListView:close()
      end
  end
end


function SkillView:open()
    SkillView.super.open(self)
end

function SkillView:close()
	SkillView.super.close(self)
  if self.skillQuickView then
      self.skillQuickView:close()
  end
  if self.skillAutoView then
      self.skillAutoView:close()
  end
  if self.skillListView then
      self.skillListView:close()
  end
end

--清理界面
function SkillView:destory()
  self:close()
	SkillView.super.destory(self)
  display.removeSpriteFramesWithFile("resui/skill0.plist", "resui/skill0.png")
end

return SkillView