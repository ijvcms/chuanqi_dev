--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-13 22:11:25
-- 技能列表
local SkillListView = SkillListView or class("SkillListView", function()
    return display.newNode()
end)

--构造
function SkillListView:ctor()
    local bar1 = display.newScale9Sprite("#com_panelBg4.png", 0, 0, cc.size(394, 478),cc.rect(26, 26,1, 1))
  	self:addChild(bar1)
  	bar1:setAnchorPoint(0,0)
    bar1:setPosition(362,5)

  	local bar2 = display.newScale9Sprite("#com_frameBg2.png", 0, 0, cc.size(376, 142),cc.rect(26, 26,1, 1))
  	bar1:addChild(bar2)
  	--bar2:setAnchorPoint(0,0)
  	bar2:setPosition(198,392)

    local bar3 = display.newSprite("#com_nameBg.png")
    bar2:addChild(bar3)
    --bar2:setAnchorPoint(0,0)
    bar3:setPosition(188,118)

  	--上半部分
  	self.itemBg = display.newSprite("#com_propBg1.png")
  	bar2:addChild(self.itemBg)
  	self.itemBg:setPosition(50,98)

  	self.skillNameLab = display.newTTFLabel({text = "剑术",
        size = 20,color = TextColor.TEXT_O})
            :align(display.LEFT_CENTER,0,0)
            :addTo(bar2)
    self.skillNameLab:setPosition(130,118)
    display.setLabelFilter(self.skillNameLab)

    self.skillLvLab = display.newTTFLabel({text = "LV2",
        size = 20,color = TextColor.TEXT_G})
            :align(display.CENTER,0,0)
            :addTo(bar2)
    self.skillLvLab:setPosition(330,118)
    display.setLabelFilter(self.skillLvLab)


    self.skillDescLab = display.newTTFLabel({text = "描述信息描述信息描述信息描述信息\n描述信息描述信息",
        size = 16,color = TextColor.TEXT_W})
            :align(display.LEFT_TOP,0,0)
            :addTo(bar2)
    self.skillDescLab:setPosition(90,90)
    display.setLabelFilter(self.skillDescLab)




    local downBg = display.newScale9Sprite("#com_viewBg1.png", 0, 0, cc.size(376, 306),cc.rect(6, 6,1, 1))
    bar1:addChild(downBg)
    --bar2:setAnchorPoint(0,0)
    downBg:setPosition(198,163)

    local downTitle = display.newSprite("#skill_nameBg.png")
    downBg:addChild(downTitle)
    --bar2:setAnchorPoint(0,0)
    downTitle:setPosition(188,306 - 16)


    --下半部分
    self.skillTipLab = display.newTTFLabel({text = "技能升级",
        size = 20,color = TextColor.TEXT_W})
            :align(display.CENTER,0,0)
            :addTo(downTitle)
    self.skillTipLab:setPosition(188,14)
    --display.setLabelFilter(self.skillTipLab)


    self.topLvLab = display.newTTFLabel({text = "已满级",
            size = 20,color = TextColor.TEXT_O})
                :align(display.CENTER,0,0)
                :addTo(downBg)
    self.topLvLab:setPosition(188,153)
    display.setLabelFilter(self.topLvLab)

    self.helpBtn = display.newSprite("#com_helpBtn.png")
    downBg:addChild(self.helpBtn)
    self.helpBtn:setPosition(347,30)
    self.helpBtn:setTouchEnabled(true)
    self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.helpBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.helpBtn:setScale(1.0)
            GlobalMessage:alert({
                  enterTxt = "确定",
                  backTxt= "取消",
                  tipTxt = configHelper:getRuleByKey(16),
                  tipShowMid = true,
                  hideBackBtn = true,
              })
        end     
        return true
    end)

    --左边技能列表
    self.itemListView = cc.ui.UIListView.new {
        viewRect = cc.rect(8, 10, 352, 468),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        --scrollbarImgV = "bar.png"}
        :onTouch(handler(self, self.touchListener))
        :addTo(self)

    self.itemList = {}
    local skillUiItem = require("app.modules.skill.view.SkillUIItem")

    local skillList = RoleManager:getInstance():getSkillArrWithOutAllJobs()
    for i=1,#skillList do
		local content = self.itemList[i]
		if content == nil then
            local item = self.itemListView:newItem()
			content = skillUiItem.new(skillList[i])
        
			self.itemList[i] = content
            item:addContent(content)
            item:setItemSize(351, 116)
            self.itemListView:addItem(item)
		end
        -- content:updateStar(self.starlist[i] or 0)
        --content:setPosition(-251,-45)
        --content:setAnchorPoint(cc.p(0.5, 0.5)
        if i == 1 then
            self:onListClick(content)
        end
	end
    self.itemListView:reload()
end

function SkillListView:onListClick(item)
    if self.selItem then
        self.selItem:setSelect(false)
    end
    self.selItem = item
    self.selItem:setSelect(true)
    self:updateRightView()
end

function SkillListView:update()
    for k,v in pairs(self.itemList) do
        v:update()
    end
    self:updateRightView()
end

function SkillListView:open()
    if self.updateSkillListEventId == nil then
        self.updateSkillListEventId = GlobalEventSystem:addEventListener(SkillEvent.UPDATE_SKILL_LIST,handler(self,self.update))
    end
    self:update()
end

function SkillListView:close()

    if self.updateSkillListEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.updateSkillListEventId)
        self.updateSkillListEventId = nil
    end

    if self.useExpView then
        self.useExpView:destory()
        self:removeChild(self.useExpView)
        self.useExpView = nil
    end
end

function SkillListView:updateRightView()
    if self.selItem then
        local vo = self.selItem:getSkillVO()
        self.skillNameLab:setString(vo.conf.name)
        if self.selItem:getSkillVO().lv == 0 then
            self.skillLvLab:setString("未学习")
        else
            self.skillLvLab:setString("LV"..vo.lv)
        end

        if self.skillIcon then
            self.itemBg:removeChild(self.skillIcon)
        end
        self.skillIcon = display.newSprite(ResUtil.getSkillIcon2(vo.id))
        self.itemBg:addChild(self.skillIcon)
        self.skillIcon:setPosition(38,38)





        self.skillDescLab:setString(vo.conf.desc)
        if self.upGradeLay then
            self.upGradeLay:setVisible(false)
        end
        if self.learnLay then
            self.learnLay:setVisible(false)
        end
        self.topLvLab:setVisible(false)
        if vo.IsTopLv then --满级
            self.topLvLab:setVisible(true)
        elseif vo.isLearn == false then
            self:showLearnView()
        else
            self:showUpGradeView()
        end
    end
end

function SkillListView:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
        self:onListClick(self.itemList[event.itemPos])
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end

-- 显示升级页面
function SkillListView:showUpGradeView()
    if self.upGradeLay == nil then
        self.upGradeLay = display.newNode()
        self.upGradeLay:setTouchEnabled(false)
        self:addChild(self.upGradeLay)
        self.upGradeLay:setPosition(358,45)

        local uNextLvTip = display.newTTFLabel({text = "技能下级等级：",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        uNextLvTip:setPosition(30,220)
        display.setLabelFilter(uNextLvTip)

        self.uNextLvLab = display.newTTFLabel({text = "LV3",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        self.uNextLvLab:setPosition(180,220)
        display.setLabelFilter(self.uNextLvLab)

        local uRoleLvTip = display.newTTFLabel({text = "需要角色等级：",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        uRoleLvTip:setPosition(30,190)
        display.setLabelFilter(uRoleLvTip)

        self.uRoleLvLab = display.newTTFLabel({text = "56",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        self.uRoleLvLab:setPosition(180,190)
        display.setLabelFilter(self.uRoleLvLab)

        self.ubooksTip = display.newTTFLabel({text = "技能熟练度:",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        self.ubooksTip:setPosition(30,160)
        display.setLabelFilter(self.ubooksTip)

        self.ubooksLab = display.newTTFLabel({text = "0/0",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.upGradeLay)
        self.ubooksLab:setPosition(160,160)
        display.setLabelFilter(self.ubooksLab)

        self.uNextSkillDescLab = display.newTTFLabel({text = "desc",
            size = 18,color = TextColor.TEXT_W})
                :align(display.LEFT_TOP,0,0)
                :addTo(self.upGradeLay)
        self.uNextSkillDescLab:setPosition(30,140)
        display.setLabelFilter(self.uNextSkillDescLab)


        self.upGradeBtn = display.newSprite("#com_labBtn2.png")
        self.upGradeBtn:setTouchEnabled(true)   
        self.upGradeLay:addChild(self.upGradeBtn)
        self.upGradeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)           
                if event.name == "began" then 
                    self.upGradeBtn:setScale(1.1)
                elseif event.name == "ended" then         
                    self.upGradeBtn:setScale(1)
                    local vo = self.selItem:getSkillVO()
                    self:onSendLearnSkill(vo)
                end
                return true
            end)
        local lab = display.newTTFLabel({
                text = "升  级",      
                size = 22,
                color = TextColor.BTN_W, 
        })
       -- display.setLabelFilter(lab)
        lab:setTouchEnabled(false)   
        lab:setPosition(69,27)
        self.upGradeBtn:addChild(lab)
        self.upGradeBtn:setPosition(204,26)
    end
    self.upGradeLay:setVisible(true)
    local vo = self.selItem:getSkillVO()
    local nextSkillConf = FightModel:getSkillUiConfig(vo.id,vo.lv+1)

    local bagManager = BagManager:getInstance()
    local boosNum = bagManager:findItemCountByItemId(nextSkillConf.bookId)

    self.uNextLvLab:setString("LV"..vo.conf.nextLv)
    self.uRoleLvLab:setString(nextSkillConf.pLv)
    self.upGradeBtn:setVisible(false)
    if vo.conf.nextExp > 0 then 
        self.ubooksTip:setString("技能熟练度:")
        self.ubooksLab:setString(vo.exp.."/"..vo.conf.nextExp)
    else
        local goodName = configHelper:getGoodNameByGoodId(nextSkillConf.bookId)
        self.ubooksTip:setString(goodName..":")
        self.ubooksLab:setString(boosNum.."/"..nextSkillConf.bookNum)
        self.upGradeBtn:setVisible(true)
    end

    self.uNextSkillDescLab:setString(nextSkillConf.desc)

end

-- 显示学习页面
function SkillListView:showLearnView()
    if self.learnLay == nil then
        self.learnLay = display.newNode()
        self.learnLay:setTouchEnabled(false)
        self:addChild(self.learnLay)
        self.learnLay:setPosition(358,45)

        local lRoleLvTip = display.newTTFLabel({text = "需要学习等级：",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        lRoleLvTip:setPosition(30,220)
        display.setLabelFilter(lRoleLvTip)

        self.lRoleLvLab = display.newTTFLabel({text = "56",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        self.lRoleLvLab:setPosition(180,220)
        display.setLabelFilter(self.lRoleLvLab)


        self.lbooksTip = display.newTTFLabel({text = "2级共杀剑术:",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        self.lbooksTip:setPosition(30,190)
        display.setLabelFilter(self.lbooksTip)

        self.lbooksLab = display.newTTFLabel({text = "5/6",
            size = 20,color = TextColor.TEXT_O})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        self.lbooksLab:setPosition(160,190)
        display.setLabelFilter(self.lbooksLab)

        self.skillGetTips1 = display.newTTFLabel({text = "1.前往商城购买",
            size = 16,color = TextColor.TEXT_W})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        self.skillGetTips1:setPosition(28,150)
        display.setLabelFilter(self.skillGetTips1)
        self.skillGetTips2 = display.newTTFLabel({text = "2.击杀世界BOSS有几率获得",
            size = 16,color = TextColor.TEXT_W})
                :align(display.LEFT_CENTER,0,0)
                :addTo(self.learnLay)
        self.skillGetTips2:setPosition(28,110)
        display.setLabelFilter(self.skillGetTips2)


        self.skillGetBtn1 = display.newSprite("#com_labBtn1.png")  
        self.skillGetBtn1:setTouchEnabled(true) 
        self.learnLay:addChild(self.skillGetBtn1)
        self.skillGetBtn1:setScale(0.9)
        self.skillGetBtn1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
                if event.name == "began" then               
                    self.skillGetBtn1:setScale(1.1)
                elseif event.name == "ended" then               
                    self.skillGetBtn1:setScale(1)
                    self:skillGetClick(1)
                end
                return true
            end)
        self.skillGetLab1 = display.newTTFLabel({
                text = "buyBtn1",
                size = 20,
                color = TextColor.BTN_W, 
        })
        display.setLabelFilter(self.skillGetLab1)
        self.skillGetLab1:setTouchEnabled(false) 
        self.skillGetLab1:setPosition(56,21)
        self.skillGetBtn1:addChild(self.skillGetLab1)
        self.skillGetBtn1:setPosition(326,150)


        self.skillGetBtn2 = display.newSprite("#com_labBtn1.png") 
        self.skillGetBtn2:setTouchEnabled(true) 
        self.learnLay:addChild(self.skillGetBtn2)
        self.skillGetBtn2:setScale(0.9)
        self.skillGetBtn2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)         
                if event.name == "began" then               
                    self.skillGetBtn2:setScale(1.1)
                elseif event.name == "ended" then               
                    self.skillGetBtn2:setScale(1)
                    self:skillGetClick(2)
                end
                return true
            end)
        self.skillGetLab2 = display.newTTFLabel({
                text = "buyBtn2",
                size = 20,
                color = TextColor.BTN_W, 
        })
        display.setLabelFilter(self.skillGetLab2)
        self.skillGetLab2:setTouchEnabled(false) 
        self.skillGetLab2:setPosition(56,21)
        self.skillGetBtn2:addChild(self.skillGetLab2)
        self.skillGetBtn2:setPosition(326,110)



        self.learnBtn = display.newSprite("#com_labBtn2.png")  
        self.learnBtn:setTouchEnabled(true)   
        self.learnLay:addChild(self.learnBtn)
        self.learnBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)           
                if event.name == "began" then               
                    self.learnBtn:setScale(1.1)
                elseif event.name == "ended" then               
                    self.learnBtn:setScale(1)
                    local vo = self.selItem:getSkillVO()
                    self:onSendLearnSkill(vo)
                    
                end
                return true
            end)
        local lab = display.newTTFLabel({
                text = "学  习",      
                size = 22,
                color = TextColor.BTN_W, 
        })
        display.setLabelFilter(lab)
        lab:setTouchEnabled(false)   
        lab:setPosition(69,27)
        self.learnBtn:addChild(lab)
        self.learnBtn:setPosition(206,26)
    end
    self.learnLay:setVisible(true)

    local vo = self.selItem:getSkillVO()
    local nextSkillConf = FightModel:getSkillUiConfig(vo.id,vo.lv+1)

    local bagManager = BagManager:getInstance()
    local boosNum = bagManager:findItemCountByItemId(nextSkillConf.bookId)

    self.lRoleLvLab:setString(nextSkillConf.pLv)
    local goodName = configHelper:getGoodNameByGoodId(nextSkillConf.bookId)
    self.lbooksTip:setString(goodName..":")
    self.lbooksLab:setString(boosNum.."/"..nextSkillConf.bookNum)

    self.skillGetWin = {}
    local list = StringUtil.split(vo.conf.jump, ";")
    for i=1,2 do
        self["skillGetTips"..i]:setVisible(false)
        self["skillGetBtn"..i]:setVisible(false)
    end
    for i=1,#list do
        local arr = StringUtil.split(list[i], "_")
        if self["skillGetTips"..i] then
            self["skillGetTips"..i]:setString(arr[1])
            self["skillGetLab"..i]:setString(arr[2])
            self["skillGetTips"..i]:setVisible(true)
            self["skillGetBtn"..i]:setVisible(true)
        end
        table.insert(self.skillGetWin,arr)
    end
    -- self.skillGetTips2
    -- self.skillGetLab2
    -- self.skillGetBtn2
end

function SkillListView:skillGetClick(type)
    if self.skillGetWin[type] then
        local curWin = self.skillGetWin[type][3]
        if FunctionOpenManager:getFunctionOpenByWinName(curWin) then
            if curWin == WinName.NPCBUYWIN then
                GlobalWinManger:openWin(curWin,{id = tonumber(self.skillGetWin[type][4])})
            else
                GlobalWinManger:openWin(curWin)
            end
        else
            FunctionOpenManager:showFunctionOpenTips(curWin)
        end
    end
end

function SkillListView:onSendLearnSkill(vo)
    
    if vo.IsTopLv then --满级
        GlobalMessage:show("技能已满级")
        return
    end

    local nextSkillConf = FightModel:getSkillUiConfig(vo.id,vo.lv+1)
    
    local playLv = RoleManager:getInstance().roleInfo.lv
    if playLv < nextSkillConf.pLv then
        GlobalMessage:show("人物等级不足，升级/学习失败")
        return
    end
    if vo.lv <= 0 or nextSkillConf.bookId > 0 then
        local bagManager = BagManager:getInstance()
        local boosNum = bagManager:findItemCountByItemId(nextSkillConf.bookId)
        if boosNum < nextSkillConf.bookNum then
            GlobalMessage:show("升级技能书不足，升级/学习失败")
            return
        end
        GameNet:sendMsgToSocket(12004,{skill_id = vo.id,lv = vo.lv+1})
    else
        --弹出使用经验丹窗口
        self:showSelExpView(vo)
    end

end



function SkillListView:showSelExpView(vo)
    if self.useExpView == nil then
        local view = require("app.modules.skill.view.SkillUseExpView")
        self.useExpView = view.new()
        self:addChild(self.useExpView)
        self.useExpView:setPosition((960 - 394)/2,0)--(640 - 524)/2)
    end
    self.useExpView:open(vo)
end


return SkillListView