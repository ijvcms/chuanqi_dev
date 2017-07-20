--
-- Author: casen
-- Date: 2015-09-01 
-- 装备tips窗口
import("app.utils.EquipUtil")

-- local equipTipsWin = equipTipsWin or class("equipTipsWin",function()
--     return cc.uiloader:load("resui/equipTipsWin.ExportJson")
-- end)

local equipTipsWin = equipTipsWin or class("equipTipsWin", function()
    return display.newNode()
end)

--构造
function equipTipsWin:ctor()
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)

    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    local ccui = cc.uiloader:load("resui/equipTipsWin.ExportJson")
    self:addChild(ccui)

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

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win
    self.desLabel = cc.uiloader:seekNodeByName(win, "desLabel")
    local winbg = cc.uiloader:seekNodeByName(win, "bg")
    winbg:setTouchEnabled(true)
    winbg:setTouchSwallowEnabled(true)

    --关闭按钮
    local btnClose = cc.uiloader:seekNodeByName(win, "btnClose")
    btnClose:setTouchEnabled(true)
    btnClose:onButtonPressed(function ()
        btnClose:setScale(1.0)
        SoundManager:playClickSound()
    end)
    btnClose:onButtonRelease(function()
        btnClose:setScale(0.8)
    end)
    btnClose:onButtonClicked(function ()
        btnClose:setScale(0.8)
        self:onCloseClick()
    end)  

    --卖出按钮
    local btnSell = cc.uiloader:seekNodeByName(win, "btnSell")
    self.btnSell = btnSell
    btnSell:setTouchEnabled(true)
    btnSell:onButtonPressed(function ()
        btnSell:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnSell:onButtonRelease(function()
        btnSell:setScale(1.0)
    end)
    btnSell:onButtonClicked(function ()
        btnSell:setScale(1.0)
        self:onSellClick()
    end)

    --穿上按钮
    local btnPutOn = cc.uiloader:seekNodeByName(win, "btnPutOn")
    self.btnPutOn = btnPutOn
    btnPutOn:setTouchEnabled(true)
    btnPutOn:onButtonPressed(function ()
        btnPutOn:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnPutOn:onButtonRelease(function()
        btnPutOn:setScale(1.0)
    end)
    btnPutOn:onButtonClicked(function ()
        btnPutOn:setScale(1.0)
        self:onPutOnClick()
    end)

    --脱下按钮
    local btnTakeOff = cc.uiloader:seekNodeByName(win, "btnTakeOff")
    self.btnTakeOff = btnTakeOff
    btnTakeOff:setTouchEnabled(true)
    btnTakeOff:onButtonPressed(function ()
        btnTakeOff:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnTakeOff:onButtonRelease(function()
        btnTakeOff:setScale(1.0)
    end)
    btnTakeOff:onButtonClicked(function ()
        btnTakeOff:setScale(1.0)
        self:onTakeOffClick()
    end) 

     --特殊
    local specialBtn = cc.uiloader:seekNodeByName(win, "specialBtn")
    self.specialBtn = specialBtn
    specialBtn:setTouchEnabled(true)
    specialBtn:onButtonPressed(function ()
        specialBtn:setScale(1.1)
        SoundManager:playClickSound()
    end)
    specialBtn:onButtonRelease(function()
        specialBtn:setScale(0.9)
    end)
    specialBtn:onButtonClicked(function ()
        specialBtn:setScale(0.9)
        self:onSpecialClick()
    end)

    --坐骑升阶
    local btnMountUp = cc.uiloader:seekNodeByName(win, "btnMountUp")
    self.btnMountUp = btnMountUp
    btnMountUp:setTouchEnabled(true)
    btnMountUp:onButtonPressed(function ()
        btnMountUp:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnMountUp:onButtonRelease(function()
        btnMountUp:setScale(0.9)
    end)
    btnMountUp:onButtonClicked(function ()
        btnMountUp:setScale(0.9)
        self:onbtnMountUpClick()
    end)

    -- 勋章升级按钮
    local btnMedal = cc.uiloader:seekNodeByName(win, "btnMedalUp")
    self.btnMedal = btnMedal
    btnMedal:setTouchEnabled(true)
    btnMedal:onButtonPressed(function ()
        btnMedal:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnMedal:onButtonRelease(function()
        btnMedal:setScale(1.0)
    end)
    btnMedal:onButtonClicked(function ()
        btnMedal:setScale(1.0)
        GlobalWinManger:openWin(self.openWinName)
        self:onCloseClick()
    end) 

    --------------------投保-------------------
    self.timesLabel = cc.uiloader:seekNodeByName(win, "timesLabel")
    self.insuranceIcon = cc.uiloader:seekNodeByName(win, "insuranceIcon")

    local btnInsurance = cc.uiloader:seekNodeByName(win, "btnInsurance")
    self.btnInsurance = btnInsurance
    btnInsurance:setTouchEnabled(true)
    btnInsurance:onButtonPressed(function ()
        btnInsurance:setScale(1.2)
        SoundManager:playClickSound()
    end)
    btnInsurance:onButtonRelease(function()
        btnInsurance:setScale(1.0)
    end)
    btnInsurance:onButtonClicked(function ()
        btnInsurance:setScale(1.0)
        --GlobalWinManger:openWin(WinName.SECUREWIN,self.data)
        local itWin = require("app.modules.secure.SecureView").new(self.data)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
        self:onCloseClick()
    end)
    
    self.timesLabel:setVisible(false)
    self.insuranceIcon:setVisible(false)
    self.btnInsurance:setVisible(false)

end
--param:是否是查看别人装备
-- <Param name="id" type="int8" describe="对应条数id"/>
--             <Param name="state" type="int8" describe="锁定状态0未锁定 1锁定"/>
--             <Param name="key" type="int16" describe="属性key"/>
--             <Param name="value" type="int32" describe="对应key的值"/>
function equipTipsWin:setData(data, param, career)

    local spWashAtt = configHelper:getWashSpGoodsAttById(data.goods_id)
    if spWashAtt then
        for i=1,#spWashAtt.value do
            local v = spWashAtt.value[i]
            local item = {id = tonumber(v[1]),state = tonumber(v[2]),key = tonumber(v[3]),value = tonumber(v[4])}
            table.insert(data.baptize_attr_list,item)
        end
    end
    --data.baptize_attr_list = {}
    self.timesLabel:setVisible(false)
    self.insuranceIcon:setVisible(false)
    self.btnInsurance:setVisible(false)  

    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    career = career or roleInfo.career
    self.data = data
    if param then
       career = configHelper:getGoodCareerByGoodId(data.goods_id)
    end
    --标题部分
    --装备名
    local labName = cc.uiloader:seekNodeByName(self.win, "labName")
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    if data.stren_lv and data.stren_lv >0 then
        labName:setString(equipName.."+"..data.stren_lv)
    else
        labName:setString(equipName)
    end
    local quality = configHelper:getGoodQualityByGoodId(data.goods_id)
    if quality then
        local color
        if quality == 1 then            --白
            color = TextColor.TEXT_W
        elseif quality == 2 then        --绿
            color = TextColor.TEXT_G
        elseif quality == 3 then        --蓝
            color = TextColor.ITEM_B
        elseif quality == 4 then        --紫
            color = TextColor.ITEM_P
        elseif quality == 5 then        --橙
            color = TextColor.TEXT_O
        elseif quality == 6 then        --红
                    color = TextColor.TEXT_R
        end 
        if color then
            labName:setColor(color)
        end
    end
    
    

    --装备等级
    local labLevel
    local equipLevel = configHelper:getGoodLVByGoodId(data.goods_id)
    if equipLevel>roleInfo.lv then
        labLevel = cc.uiloader:seekNodeByName(self.win, "labLevel1")
        labLevel:setString("LV."..(equipLevel or 0))
    else
        labLevel = cc.uiloader:seekNodeByName(self.win, "labLevel")
        labLevel:setString("LV."..(equipLevel or 0))
    end

    --是否绑定
    local labBind = cc.uiloader:seekNodeByName(self.win, "labBind")
    labBind:setVisible((data.is_bind == 1) or false)

    --调整位置
    local x1 = labName:getContentSize().width + labName:getPositionX()
    labLevel:setVisible(true)
    labLevel:setPositionX(x1+10)
    local x2 = x1 + 10 + labLevel:getContentSize().width
    labBind:setPositionX(x2+10) 

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    local itemBg = cc.uiloader:seekNodeByName(self.win, "itemBg")
    if itemBg:getChildByTag(10) then
        itemBg:removeChildByTag(10)
    end
    itemBg:addChild(commonItem)
    commonItem:setTag(10)
    commonItem:setItemClickFunc(handler(self,self.onItemClick))
    commonItem:setPosition(itemBg:getContentSize().width/2,itemBg:getContentSize().height/2)

    --类型
    local labTypeValue = cc.uiloader:seekNodeByName(self.win, "labTypeValue")
    local eType = configHelper:getEquipTypeByEquipId(data.goods_id)
    labTypeValue:setString(eType or "")

    --职业
    local labCareerValue = cc.uiloader:seekNodeByName(self.win, "labCareerValue")
    local eType,eId = configHelper:getEquipCareerByEquipId(data.goods_id)
    if eId ~= roleInfo.career then
        labCareerValue:setColor(TextColor.TEXT_R)
    else
        --labCareerValue:setColor(cc.c3b(23,7,8))
    end
    labCareerValue:setString(eType or "")


    --评分
    local labScoreValue = cc.uiloader:seekNodeByName(self.win, "labScoreValue")
    labScoreValue:setString(data.fighting)
    labScoreValue:setVisible(true)
    cc.uiloader:seekNodeByName(self.win, "labScore"):setVisible(true)
    --基础属性部分
        local subTypeName,subType = configHelper:getEquipTypeByEquipId(data.goods_id)
        local equipSubType = configHelper:getGoodSubTypeByGoodId(data.goods_id)

--      设置属性

        for i=1,4 do
            cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setColor(SoulColorArr[tostring(data.soul)])
            --self["labAttrAdd"..i]:setVisible(false)
        end
        
        if subType == 15 then
            --坐骑
            local equipAttr = configHelper:getEquipValidAllAttrByEquipId(data.goods_id)
            local hp = 0--equipAttr.hp
            local mp = 0--equipAttr.mp
            local min_ac = 0--equipAttr.min_ac
            local max_ac = 0--equipAttr.max_ac
            local min_mac = 0--equipAttr.min_mac
            local max_mac = 0--equipAttr.max_mac
            local min_sc = 0--equipAttr.min_sc
            local max_sc = 0--equipAttr.max_sc
            local min_def = 0--equipAttr.min_def
            local max_def = 0--equipAttr.max_def
            local min_res = 0--equipAttr.min_res
            local max_res = 0--equipAttr.max_res
            local speed = 0--equipAttr.speed
         
            for i=1,4 do
                
                local config-- = configHelper:getMarkByTypeCareerLv(i+5, career, roleInfo.mark[i+5])
                if data.mark and param then
                    config = configHelper:getMarkByTypeCareerLv(i+5, career, data.mark["mounts_mark_"..i])
                else
                    config = configHelper:getMarkByTypeCareerLv(i+5, career, roleInfo.mark[i+5])
                end

                if config then

                    hp = config.hp + hp
                    mp = config.mp + mp
                    min_ac = config.min_ac + min_ac
                    max_ac = config.max_ac + max_ac
                    min_mac = config.min_mac + min_mac
                    max_mac = config.max_mac + max_mac
                    min_sc = config.min_sc + min_sc
                    max_sc = config.max_sc + max_sc
                    min_def = config.min_def + min_def
                    max_def = config.max_def + max_def
                    min_res = config.min_res + min_res
                    max_res = config.max_res + max_res
       
                end

            end

            hp = math.floor( (equipAttr.mounts_p/10000 + 1)*hp + equipAttr.hp )
            mp = math.floor( (equipAttr.mounts_p/10000 + 1)*mp + equipAttr.mp )
            min_ac = math.floor( (equipAttr.mounts_p/10000 + 1)*min_ac + equipAttr.min_ac )
            max_ac = math.floor( (equipAttr.mounts_p/10000 + 1)*max_ac + equipAttr.max_ac )
            min_mac = math.floor( (equipAttr.mounts_p/10000 + 1)*min_mac + equipAttr.min_mac )
            max_mac = math.floor( (equipAttr.mounts_p/10000 + 1)*max_mac + equipAttr.max_mac )
            min_sc = math.floor( (equipAttr.mounts_p/10000 + 1)*min_sc + equipAttr.min_sc )
            max_sc = math.floor( (equipAttr.mounts_p/10000 + 1)*max_sc + equipAttr.max_sc )
            min_def = math.floor( (equipAttr.mounts_p/10000 + 1)*min_def + equipAttr.min_def )
            max_def = math.floor( (equipAttr.mounts_p/10000 + 1)*max_def + equipAttr.max_def )
            min_res = math.floor( (equipAttr.mounts_p/10000 + 1)*min_res + equipAttr.min_res )
            max_res = math.floor( (equipAttr.mounts_p/10000 + 1)*max_res + equipAttr.max_res )
            speed = math.floor( (equipAttr.mounts_p/10000 + 1)*speed + equipAttr.speed )
 

            cc.uiloader:seekNodeByName(self.win,"labAttr"..1):setVisible(true)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setVisible(true)

            cc.uiloader:seekNodeByName(self.win,"labAttr"..2):setVisible(true)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..2):setVisible(true)

            cc.uiloader:seekNodeByName(self.win,"labAttr"..3):setVisible(true)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..3):setVisible(true)

            cc.uiloader:seekNodeByName(self.win,"labAttr"..4):setVisible(true)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..4):setVisible(true)

            cc.uiloader:seekNodeByName(self.win,"labAttr"..1):setString("生命-魔法:")
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(hp.."-"..mp)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setPositionX(cc.uiloader:seekNodeByName(self.win,"labAttr"..1):getPositionX() + 100)

            if career == 1000 then
                cc.uiloader:seekNodeByName(self.win,"labAttr"..2):setString("物理攻击:")
                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..2):setString(min_ac.."-"..max_ac)
            elseif career == 2000 then
                cc.uiloader:seekNodeByName(self.win,"labAttr"..2):setString("魔法攻击:")
                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..2):setString(min_mac.."-"..max_mac)
            elseif career == 3000 then
                cc.uiloader:seekNodeByName(self.win,"labAttr"..2):setString("道术攻击:")
                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..2):setString(min_sc.."-"..max_sc)
            end
     
            cc.uiloader:seekNodeByName(self.win,"labAttr"..3):setString("物理防御:")
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..3):setString(min_def.."-"..max_def)

            cc.uiloader:seekNodeByName(self.win,"labAttr"..4):setString("魔法防御:")
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..4):setString(min_res.."-"..max_res)
 
        else
            --非坐骑
             
            if career == 0 or career == nil then
                --无职业区分的装备
 
                local equipAttr = configHelper:getEquipValidAllAttrByEquipId(data.goods_id)
                local showAttr = self:handlerData(equipAttr)
                local len = #showAttr
                --因为只有三个文本
                if len > 3 then
                    len = 3
                end
                for i=1,len do
                    cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setVisible(true)
                    cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setVisible(true)
                    cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setString(showAttr[i].name)
                    cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setString(showAttr[i].value)
                end
 
 
            else
                --具有职业区分的装备
                local validAttr = configHelper:getStengPlusStrengLv(data.stren_lv, equipSubType)
                local equipItem = configHelper:getEquipValidAttrByEquipId2(data.goods_id, career)
                local soulConfig = configHelper:getSoulAddConfig(data.soul)
                local num = #equipItem/2
                if #equipItem%2 > 0 then
                    --生命
                    cc.uiloader:seekNodeByName(self.win,"labAttr"..1):setVisible(true)
                    cc.uiloader:seekNodeByName(self.win,"labAttr"..1):setString(self:getName(equipItem[1][1]))
                    cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setVisible(true)
                    if data.soul > 0 then
                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setVisible(true)
                    end
                    
                    if validAttr ~= nil then
                
                        if validAttr[equipItem[1][1]] and validAttr[equipItem[1][1]] > 0  then
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(equipItem[1][2].." + ("..validAttr[equipItem[1][1]]..")")
                        else
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setPositionX(495)
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(equipItem[1][2])
                        end

                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setString("+("..math.floor(equipItem[1][2]*soulConfig.modulus)..")")
                    else
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(equipItem[1][2])
                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setPositionX(495)
                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setString("+("..math.floor(equipItem[1][2]*soulConfig.modulus)..")")
                    end
                    if validAttr ~= nil then
                        --validAttr[equipItem[1][1]] = nil
                    end
                    
                    table.remove(equipItem,1)
                     
                    if validAttr ~= nil then
                         for i=1,num do
                        cc.uiloader:seekNodeByName(self.win,"labAttr"..(i+1)):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttr"..(i+1)):setString(self:getName(equipItem[i*2 - 1][1]))
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..(i+1)):setVisible(true)
                        if data.soul > 0 then
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setVisible(true)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setString("+("..math.floor(equipItem[i*2 - 1][2]*soulConfig.modulus).."-"..math.floor(equipItem[i*2][2]*soulConfig.modulus)..")")
                        end
                        
                            if validAttr[equipItem[i*2][1]] > 0  then
                                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..(i+1)):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2].." + ("..validAttr[equipItem[i*2 - 1][1]].."-"..validAttr[equipItem[i*2][1]]..")")
                            else
                                cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setPositionX(495)
                                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..(i+1)):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                            end
                        end
                    else
                        for i=1,num do

                        cc.uiloader:seekNodeByName(self.win,"labAttr"..(i+1)):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttr"..(i+1)):setString(self:getName(equipItem[i*2 - 1][1]))
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..(i+1)):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..(i+1)):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                        if data.soul > 0 then
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setVisible(true)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setPositionX(495)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setString("+("..math.floor(equipItem[i*2 - 1][2]*soulConfig.modulus).."-"..math.floor(equipItem[i*2][2]*soulConfig.modulus)..")")
                        end
                        end
                    end

                else

                    if validAttr ~= nil then
                        for i=1,num do

                        cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setString(self:getName(equipItem[i*2 - 1][1]))
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setVisible(true)
                        if data.soul > 0 then
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setVisible(true)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setString("+("..math.floor(equipItem[i*2 - 1][2]*soulConfig.modulus).."-"..math.floor(equipItem[i*2][2]*soulConfig.modulus)..")")
                        end
                            if validAttr[equipItem[i*2][1]] > 0  then
                                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2].." + ("..validAttr[equipItem[i*2 - 1][1]].."-"..validAttr[equipItem[i*2][1]]..")")
                            else
                                cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setPositionX(495)
                                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                            end
                        end
                    else
                        for i=1,num do

                        cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setString(self:getName(equipItem[i*2 - 1][1]))
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setVisible(true)
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2])
                       
                        if data.soul > 0 then
                        
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setVisible(true)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setPositionX(495)
                            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setString("+("..math.floor(equipItem[i*2 - 1][2]*soulConfig.modulus).."-"..math.floor(equipItem[i*2][2]*soulConfig.modulus)..")")
                        end
                        end
                    end

                end
            end
        end
    
    local attrScroll = cc.uiloader:seekNodeByName(self.win,"attrScroll")
    --attrScroll:getScrollNode():removeAllChildren()
    local proPerList = require("app.modules.tips.view.EquipProperList").new()
    if equipSubType == 15 then
        proPerList:setRideInfo(data)
        labScoreValue:setVisible(false)
        cc.uiloader:seekNodeByName(self.win, "labScore"):setVisible(false)
    else
        proPerList:setViewInfo(data)
    end
    attrScroll:getScrollNode():addChild(proPerList)
    proPerList:setPositionY( - proPerList:getContentSize().height)
    attrScroll:scrollAuto()
 
    --按钮部分
    --显示相应的按钮
    if data.location and data.location == 1 then       --穿在身上
        self.btnPutOn:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnTakeOff:setVisible(true)

    else
        self.btnPutOn:setVisible(true)
        self.btnSell:setVisible(true)
        self.btnTakeOff:setVisible(false)
        
    end
 
    local puton = cc.uiloader:seekNodeByName(self.win,"putOn")
    if data.location and data.location == 1 then 
        puton:setVisible(true)
    else
        puton:setVisible(false)
    end
    self.btnMountUp:setVisible(false)
    --子类型 5:勋章
    if subType == 5 then
        self.openWinName = WinName.MEDALUPWIN
        self.btnMedal:setVisible(true)
        self.btnPutOn:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnTakeOff:setVisible(false)
    elseif subType == 13 then--子类型 翅膀
        self.openWinName = WinName.WINGWIN
        self.btnMedal:setButtonLabelString("翅膀升级")
        self.btnMedal:setVisible(true)
        self.btnPutOn:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnTakeOff:setVisible(false)
    elseif subType == 15 then--子类型 坐骑
        self.btnTakeOff:setVisible(false)
        self.btnPutOn:setVisible(false)
        self.btnMedal:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnMountUp:setVisible(true)
    else
        self.btnMedal:setVisible(false)
    end
    --param 为true：看别人装备，隐藏所有按钮
    if param then
       self.btnPutOn:setVisible(false)
        self.btnSell:setVisible(false)
        self.btnTakeOff:setVisible(false)
        self.btnMedal:setVisible(false)
        self.btnMountUp:setVisible(false)
    end
    local equipSubType = configHelper:getGoodSubTypeByGoodId(data.goods_id)

    if equipSubType == 15 or configHelper:getCanDecomposeById(data.goods_id) then
        self.btnSell:setVisible(false)
    end

    --箭头
    local arrow1 = cc.uiloader:seekNodeByName(self.win,"arrow1")
    arrow1:setVisible(false)
    local arrow2 = cc.uiloader:seekNodeByName(self.win,"arrow2")
    arrow2:setVisible(false)
--如果是可穿戴的本职业的装备,并且评分高于身上的装备,则装备显示提升的小箭头
    local careerName,career = configHelper:getEquipCareerByEquipId(data.goods_id)
    if career == roleInfo.career and data.location==0 then
        -- if configHelper:getGoodLVByGoodId(data.goods_id) <= roleInfo.lv then
            local showIncArrow = false
            local showRedArrow = false
            local etName,etid = configHelper:getEquipTypeByEquipId(data.goods_id)
            local fighting = data.fighting
            if etid == 7 then                           --判断戒指佩戴情况
                local left = false
                local right = false
                local leftItem
                local rightItem 
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == 7 then
                        left = true
                        leftItem = roleInfo.equip[i]
                    elseif roleInfo.equip[i].grid == 12 then
                        right = true
                        rightItem = roleInfo.equip[i]
                    end
                end
                if left and not right then              --右边没有佩戴戒指
                    showIncArrow = true
                elseif not left and right then          --左边没有佩戴戒指
                    showIncArrow = true
                elseif left and right then              --两边都佩戴了戒指
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showIncArrow = true
                    elseif fighting < math.min(leftItem.fighting,rightItem.fighting) then
                        showRedArrow = true
                    end
                else                                    --两边都没佩戴戒指
                    showIncArrow = true
                end
            elseif etid == 6 then                       --判断手镯佩戴情况
                local left = false
                local right = false
                local leftItem
                local rightItem 
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == 6 then
                        left = true
                        leftItem = roleInfo.equip[i]
                    elseif roleInfo.equip[i].grid == 11 then
                        right = true
                        rightItem = roleInfo.equip[i]
                    end
                end
                if left and not right then              --右边没有佩戴手镯
                    showIncArrow = true
                elseif not left and right then          --左边没有佩戴手镯
                    showIncArrow = true
                elseif left and right then              --两边都佩戴了手镯
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showIncArrow = true
                    elseif fighting < math.min(leftItem.fighting,rightItem.fighting) then
                        showRedArrow = true
                    end
                else                                    --两边都没佩戴手镯
                    showIncArrow = true
                end
            else                                        --其余部位的装备
                local findItem = false
                local eqItem
                for i=1,#roleInfo.equip do
                    if roleInfo.equip[i].grid == etid then
                        findItem = true
                        eqItem = roleInfo.equip[i] 
                        break
                    end
                end
                if findItem then                        --身上有穿戴这个部位的装备,则需要根据身上装备的评分来判断
                    if fighting>eqItem.fighting then
                        showIncArrow = true
                    elseif fighting<eqItem.fighting then
                        showRedArrow = true
                    end
                else                                    --身上没有穿戴这个部位的装备
                    showIncArrow = true
                end
            end

            if showIncArrow then
                arrow1:setVisible(true)
            end

            if showRedArrow then
                arrow2:setVisible(true)
            end
        -- end
    end

    -----------------------------
    local securePrice = configHelper:getGoodsSecurePriceByGoodsId(data.goods_id)

    if data.secure and data.secure > 0 or (data.is_bind == 0 and securePrice > 0) then
        
        self.timesLabel:setVisible(true)
        self.insuranceIcon:setVisible(true)
        self.btnInsurance:setVisible(true)
        self.timesLabel:setString(data.secure)

    end

    if param then
        self.btnInsurance:setVisible(false)
    end

    --是否显示特殊装备按钮
    if configHelper:getGoodsSpecialByGoodsId(data.goods_id) == 1 then
        self.specialBtn:setVisible(true)
    else
        self.specialBtn:setVisible(false)
    end
    if EquipUtil.getEquipCanUse(self.data.is_use) then
        self.btnSell:setButtonLabelString("分解")
         self.btnPutOn:setButtonEnabled(true)
         self.desLabel:setString("")
         self.desLabel:setVisible(false)
    else
        self.btnSell:setButtonLabelString("出售")
         self.btnPutOn:setButtonEnabled(false)
         self.desLabel:setVisible(true)
         self.desLabel:setString("跨服战利品，与"..GlobalModel:getServerName(self.data.server_id).."合服后才能使用")
    end
    --"跨服战利品，与"..GlobalModel:getServerName(self.data.server_id).."合服后才能使用"
end

function equipTipsWin:onSellClick( )
    --发送出售协议
    --[[
    local id_list = {
        [1] = self.data.id
    }
    GameNet:sendMsgToSocket(14005, {goods_list = id_list})
    --]]
    if EquipUtil.getEquipCanUse(self.data.is_use) then
        --装备出售改成分解
        --self:onSellClick()
        local quality = configHelper:getGoodQualityByGoodId(self.data.goods_id)
        --品质低于紫色直接分解
        if quality < 4 then
            GlobalController.equip:requestDecompose(self.data.id)
        else
            local soleView = require("app.modules.equip.view.EquipDecomposeViewII").new()
            soleView:setData(self.data)
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,soleView)
        end
    else
        --跨服不能使用装备改成出售
         local quality = configHelper:getGoodQualityByGoodId(self.data.goods_id)
        --品质低于紫色直接分解
        local onEnterFun = function()
            local id_list = {
                [1] = self.data.id
            }
            GameNet:sendMsgToSocket(14005, {goods_list = id_list})
        end
        if quality < 4 then
            local param = {enterTxt = "返 回",tipTxt = "确定出售"..self.data.name.."吗？",enterFun = handler(self, onEnterFun)}
            GlobalMessage:alert(param)
        else
            onEnterFun()
        end
    end
    self:onCloseClick()
end

function equipTipsWin:onPutOnClick( )
    --发送穿上协议 
    local data = 
    {
        id          =  self.data.id,
        goods_id    =  self.data.goods_id,
        grid        =  EquipUtil.getEquipPutOnPos(self.data)
    }
    GameNet:sendMsgToSocket(14022, data)
    self:onCloseClick()
end

function equipTipsWin:onTakeOffClick( )
    --发送脱下协议
    local data = {
        grid = self.data.grid
    }
    GameNet:sendMsgToSocket(14023, data)
    self:onCloseClick()
end

function equipTipsWin:onSpecialClick( )
    local upWin = require("app.modules.tips.view.SpecialTips").new()
    upWin:setData({title = "特殊说明",content = configHelper:getGoodDescByGoodId(self.data.goods_id)})
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin)
end

function equipTipsWin:onItemClick()
end
function equipTipsWin:getName(str)
    if str == "min_ac" then
        return "物理攻击:"
    elseif str == "min_def" then
        return "物理防御:"
    elseif str == "min_res" then
        return "魔法防御:"
    elseif str == "hp" then
        return "生命:"
    elseif str == "min_mac" then
        return "魔法攻击:"
    elseif str == "min_sc" then
        return "道术攻击:"
    end
    return ""
end

function equipTipsWin:handlerData(data)

    local tem = {}
    if data.hp and data.hp > 0 then
        table.insert(tem, {name = "生命:", value = data.hp})
    end

    if data.mp and data.mp > 0 then
        table.insert(tem, {name = "魔法:", value = data.mp})
    end

    if data.max_ac and data.max_ac > 0 then
        table.insert(tem, {name = "物理攻击:", value = data.min_ac.."-"..data.max_ac})
    end

    if data.max_mac and data.max_mac > 0 then
        table.insert(tem, {name = "魔法攻击:", value = data.min_mac.."-"..data.max_mac})
    end

    if data.max_sc and data.max_sc > 0 then
        table.insert(tem, {name = "道术攻击:", value = data.min_sc.."-"..data.max_sc})
    end

    if data.max_def and data.max_def > 0 then
        table.insert(tem, {name = "物理防御:", value = data.min_def.."-"..data.max_def})
    end

    if data.max_res and data.max_res > 0 then
        table.insert(tem, {name = "魔法防御:", value = data.min_res.."-"..data.max_res})
    end

    return tem
 
end
--关闭按钮回调
function equipTipsWin:onCloseClick()
    if self:getParent() then
        self:removeSelfSafety()
    end
end

--坐骑升阶
function equipTipsWin:onbtnMountUpClick()
    if self:getParent() then
        self:removeSelfSafety()
        GlobalEventSystem:dispatchEvent(RoleEvent.OPEN_RIDE_TAG)
    end
end

return equipTipsWin