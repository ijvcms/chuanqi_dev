--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-14 14:08:58
-- 技能快捷设置界面

local SkillQuickView = SkillQuickView or class("SkillQuickView", function()
    return display.newNode()
end)

--构造
function SkillQuickView:ctor()
	  self.isClearSetting = false
	  local bg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(312, 475),cc.rect(6, 6,1, 1))
  	self:addChild(bg)
    bg:setPosition(6+156,6+238)

  	local bg2 = display.newScale9Sprite("#skill_frame1.png", 0, 0, cc.size(432, 476),cc.rect(82, 82,1, 1))
  	bg2:setPosition(760-216-6,6+238)
  	self:addChild(bg2)

    local bg3 = display.newSprite("#skill_bigPic.png")
    bg3:setPosition(216,238)
    bg2:addChild(bg3)


  	local tipLab1 = display.newTTFLabel({text = "以上为可主动使用技能",
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    tipLab1:setPosition(170,25)
    display.setLabelFilter(tipLab1)

    local tipLab1 = display.newTTFLabel({text = "点击左边技能拖至技能快捷键",
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(self)
    tipLab1:setPosition(470,30)
    display.setLabelFilter(tipLab1)

    self.clearBtn = display.newSprite("#com_labBtn1.png")
    -- self.clearBtn:setColor(cc.c3b(217, 108, 87))  	
    self.clearBtn:setTouchEnabled(true)	
    self:addChild(self.clearBtn)
    self.clearBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)			
            if event.name == "began" then            	
                self.clearBtn:setScale(1.1)
            elseif event.name == "ended" then            	
                self.clearBtn:setScale(1)
                self.isClearSetting = (self.isClearSetting == false)
                self:setUseItemDelBtnVisible(self.isClearSetting)
            end
            return true
        end)
    local upgradeLab = display.newTTFLabel({
        	text = "清除设置",    	
        	size = 20,
        	color = TextColor.BTN_W, 
   	})
    display.setLabelFilter(upgradeLab)
    upgradeLab:setTouchEnabled(false)	
    upgradeLab:setPosition(56,21)
    self.clearBtn:addChild(upgradeLab)
    self.clearBtn:setPosition(563+120,34)

  	self.defSkill = RoleManager:getInstance():getCarrerDefSkill()
    self.defSkillIcon = display.newSprite("icons/skill/"..self.defSkill.."A.png")
    bg2:addChild(self.defSkillIcon)
    self.defSkillIcon:setPosition(216,238)
   
    local useItem = require("app.modules.skill.view.SkillQuickUseItem")
    self.useItemArr = {}
    for i=1,9 do
      	local ang = 40*i + 80
      	local xx = math.cos((ang*3.1415)/180)*140 + 216 +328 -5
      	local yy = math.sin((ang*3.1415)/180)*140 + 238 +3
      	local item = useItem.new(i)
  		  self.useItemArr[i] = item
  		  item:setSkillVO(nil)
  		  item:setPosition(xx,yy)
  		  self:addChild(item)
    end

    self.listItemArr = {}

    self:setTouchEnabled(true)  
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)     
            if event.name == "began" then             
            elseif event.name == "ended" then             
                self.isClearSetting = false
                self:setUseItemDelBtnVisible(self.isClearSetting)
            end
            return true
        end)
end

function SkillQuickView:update()

    local skillList = self:getUseSkillListArr()
    local hasSkill = false
    for i=1,9 do
        local item = self.useItemArr[i]
        local vo 
        for j=1,#skillList do
            if skillList[j].posKey == i then
                vo = skillList[j]
            end
        end
        item:setSkillVO(vo)
        if vo then
          hasSkill = true
        end
    end
    if hasSkill == false then
        self.isClearSetting = false
        self:setUseItemDelBtnVisible(self.isClearSetting)
    end
end

function SkillQuickView:open()
    if self.updateSkillListEventId == nil then
        self.updateSkillListEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_SKILL_LIST,handler(self,self.update))
    end

    local listItem = require("app.modules.skill.view.SkillQuickListItem")
    local skillList = self:getUseSkillListArr()
    for i=1,#skillList do
        local vo = skillList[i]
        local item = self.listItemArr[vo.id]
        if item == nil then
            item = listItem.new(skillList[i])
            self.listItemArr[vo.id] = item
            self:addChild(item)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                  if self.isClearSetting then
                      return true
                  end
                  if self.selItem == nil then
                    self.selItem = listItem.new(item:getSkillVO())
                    self:addChild(self.selItem)
                    self.selItem:setPosition(self:convertToNodeSpace(cc.p(event.x, event.y)))
                  end
                    elseif event.name == "moved" then
                      if self.selItem then
                        self.selItem:setPosition(self:convertToNodeSpace(cc.p(event.x, event.y)))
                      end
                    elseif event.name == "ended" then
                      if self.selItem then
                        self:removeChild(self.selItem)
                        self.selItem = nil

                        local pos = self:convertToNodeSpace(cc.p(event.x, event.y))
                        for k,v in pairs(self.useItemArr) do
                          local xx,yy = v:getPosition()
                          if FightUtil:getDistance(xx,yy,pos.x,pos.y) < 30 then
                              local vvo = item:getSkillVO()
                              if vvo.posKey > 0 then
                                  GlobalMessage:show("该技能已添加快捷键")
                              else
                                  v:setSkillVO(item:getSkillVO(),true)
                                  
                                  -- GUIDE CONFIRM
                                  GlobalController.guide:notifyEventWithConfirm(GUIOP.SLIDE_SKILL_SETTING)
                              end
                              return true
                          end
                        end
                      end
                end
                return true
            end)
        end
        item:setPosition(65+98*(math.floor((i-1)%3)),447-67 +40- 102*math.floor((i-1)/3))
    end

    self:update()
end

function SkillQuickView:close()
    if self.updateSkillListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateSkillListEventId)
        self.updateSkillListEventId = nil
    end
end


function SkillQuickView:getUseSkillListArr()

    local list = {}
    local sourcelist = RoleManager:getInstance():getSkillArrWithOutAllJobs()
    for i=1,#sourcelist do
        vo = sourcelist[i]
        if vo.conf.type == 1 and vo.lv >0  then
            table.insert(list,vo)
        end
    end
    return list
end


--
function SkillQuickView:setUseItemDelBtnVisible(bool)
    for k,v in pairs(self.useItemArr) do
        v:setClearBtnVisible(bool)
    end
end


return SkillQuickView