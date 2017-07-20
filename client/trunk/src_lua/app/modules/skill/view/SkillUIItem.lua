--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-10-13 21:14:13
-- 
local SkillUIItem = SkillUIItem or class("SkillUIItem", function()
    return display.newNode()
end)

--构造
function SkillUIItem:ctor(vo)
    self.vo = vo
	self.bg = display.newSprite("#skill_listBg.png")
  	self:addChild(self.bg)
  	self.bg:setPosition(0,0)

  	self.selbg = display.newSprite("#skill_listSel.png")
  	self:addChild(self.selbg)
  	self.selbg:setPosition(0,0)
    self.selbg:setVisible(false)

  	self.itemBg = display.newSprite("#com_propBg1.png")
  	self:addChild(self.itemBg)
  	self.itemBg:setPosition(-110,-2)

    self.skillIcon = display.newSprite(ResUtil.getSkillIcon2(self.vo.id))
    self:addChild(self.skillIcon)
    self.skillIcon:setPosition(-110,-2)

  	self.skillName = display.newTTFLabel({text = self.vo.conf.name,
        size = 20,color = TextColor.TEXT_W})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    self.skillName:setPosition(-50,20)
    display.setLabelFilter(self.skillName)

    self.skillLv = display.newTTFLabel({text = "",
        size = 20,color = TextColor.TEXT_G})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    self.skillLv:setPosition(45,20)
    display.setLabelFilter(self.skillLv)

    self.jns = display.newTTFLabel({text = "技能书:",
        size = 20,color = TextColor.TEXT_O})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    self.jns:setPosition(-50,-20)
    display.setLabelFilter(self.jns)

    self.jnsNum = display.newTTFLabel({text = "5/10",
        size = 20,color = TextColor.TEXT_R})
            :align(display.LEFT_CENTER,0,0)
            :addTo(self)
    self.jnsNum:setPosition(50,-20)
    display.setLabelFilter(self.jnsNum)
    self:update()
end

function SkillUIItem:setSelect(b)
    if b then
        self.bg:setVisible(false)
        self.selbg:setVisible(true)
    else
        self.bg:setVisible(true)
        self.selbg:setVisible(false)
    end
end


function SkillUIItem:getSkillVO()
    return self.vo
end

function SkillUIItem:update()
    local playLv = RoleManager:getInstance().roleInfo.lv
    local lvStr = "LV"..self.vo.lv
    if self.vo.lv == 0 then
        lvStr = "未学习"
    end
    if self.vo.IsTopLv then --满级
        self.skillLv:setString(lvStr)
        self.jns:setString("已满级")
        self.jnsNum:setString("")
    else
        local nextSkillConf = FightModel:getSkillUiConfig(self.vo.id,self.vo.lv+1)
        if playLv < nextSkillConf.pLv then --级别不够
            if self.vo.lv > 0 then
                if self.vo.conf.nextExp <= self.vo.exp then
                    self.skillLv:setString(lvStr)
                    self.jns:setString(nextSkillConf.pLv.."级可升级")
                    self.jnsNum:setString("")
                    self.jnsNum:setColor(TextColor.TEXT_G)
                else
                    self.jns:setString("   EXP:")
                    self.jnsNum:setString(self.vo.exp.."/"..self.vo.conf.nextExp)
                    self.jnsNum:setColor(TextColor.TEXT_R)
                end
            else
                self.skillLv:setString(lvStr)
                self.jns:setString(nextSkillConf.pLv.."级可学习")
                self.jnsNum:setString("")
            end
        else
            local bagManager = BagManager:getInstance()
            local boosNum = bagManager:findItemCountByItemId(nextSkillConf.bookId)
            self.skillLv:setString(lvStr)
            if self.vo.lv > 0 then
                if self.vo.conf.nextExp > 0 then
                    self.jns:setString("   EXP:")
                    self.jnsNum:setString(self.vo.exp.."/"..self.vo.conf.nextExp)
                    if self.vo.conf.nextExp <= self.vo.exp then
                        self.jnsNum:setColor(TextColor.TEXT_G)
                    else
                        self.jnsNum:setColor(TextColor.TEXT_R)
                    end
                elseif nextSkillConf.bookId then
                    self.jns:setString(configHelper:getGoodNameByGoodId(nextSkillConf.bookId)..":")
                    self.jnsNum:setString(boosNum.."/"..nextSkillConf.bookNum)
                    if nextSkillConf.bookNum <= boosNum then
                        self.jnsNum:setColor(TextColor.TEXT_G)
                    else
                        self.jnsNum:setColor(TextColor.TEXT_R)
                    end
                end
            else
                self.jns:setString("技能书:")
                self.jnsNum:setString(boosNum.."/"..nextSkillConf.bookNum)
                if nextSkillConf.bookNum <= boosNum then
                    self.jnsNum:setColor(TextColor.TEXT_G)
                else
                    self.jnsNum:setColor(TextColor.TEXT_R)
                end
            end
        end
    end

end

return SkillUIItem