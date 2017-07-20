import("app.utils.EquipUtil")

TipsEquip = TipsEquip or class("TipsEquip",function()
	return cc.uiloader:load("resui/tt_equip.ExportJson")
end)

--构造
function TipsEquip:ctor()	
	local root = cc.uiloader:seekNodeByName(self, "root")
    root:setTouchEnabled(false)
    root:setTouchSwallowEnabled(false)

    local win = cc.uiloader:seekNodeByName(root, "win")
    self.win = win

    --卖出按钮
    local btnSell = cc.uiloader:seekNodeByName(win, "btnSell")
    self.btnSell = btnSell
    btnSell:setTouchEnabled(true)
    btnSell:onButtonPressed(function ()
        btnSell:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnSell:onButtonRelease(function()
        btnSell:setScale(0.9)
    end)
    btnSell:onButtonClicked(function ()
        btnSell:setScale(0.9)
        --装备出售改成分解
        if EquipUtil.getEquipCanUse(self.data.is_use) then
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
            self:onSellClick()
        end
        
    end)

    --穿上按钮
    local btnPutOn = cc.uiloader:seekNodeByName(win, "btnPutOn")
    self.btnPutOn = btnPutOn
    btnPutOn:setTouchEnabled(true)
    btnPutOn:onButtonPressed(function ()
        btnPutOn:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnPutOn:onButtonRelease(function()
        btnPutOn:setScale(0.9)
    end)
    btnPutOn:onButtonClicked(function ()
        btnPutOn:setScale(0.9)
        self:onPutOnClick()
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
    
    self.desLabel = cc.uiloader:seekNodeByName(win, "desLabel")
    --脱下按钮
    local btnTakeOff = cc.uiloader:seekNodeByName(win, "btnTakeOff")
    self.btnTakeOff = btnTakeOff
    btnTakeOff:setTouchEnabled(true)
    btnTakeOff:onButtonPressed(function ()
        btnTakeOff:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnTakeOff:onButtonRelease(function()
        btnTakeOff:setScale(0.9)
    end)
    btnTakeOff:onButtonClicked(function ()
        btnTakeOff:setScale(0.9)
        self:onTakeOffClick()
    end)  

    local btnSend = cc.uiloader:seekNodeByName(win, "btnSend")
    self.btnSend = btnSend
    btnSend:setTouchEnabled(true)
    btnSend:onButtonPressed(function ()
        btnSend:setScale(1.1)
        SoundManager:playClickSound()
    end)
    btnSend:onButtonRelease(function()
        btnSend:setScale(0.9)
    end)
    btnSend:onButtonClicked(function ()
        btnSend:setScale(0.9)
        self:onSendClick()
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
        local itWin = require("app.modules.secure.SecureView").new(self.data)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
        self:setVisible(false)
        --GlobalWinManger:openWin(WinName.SECUREWIN,self.data)
        --self:onCloseClick()
    end)
    
    self.timesLabel:setVisible(false)
    self.insuranceIcon:setVisible(false)
    self.btnInsurance:setVisible(false)  

end

function TipsEquip:setData(data, isChat)

    self.timesLabel:setVisible(false)
    self.insuranceIcon:setVisible(false)
    self.btnInsurance:setVisible(false)  
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

    local equipSubType = configHelper:getGoodSubTypeByGoodId(data.goods_id)

    if equipSubType == 15 or configHelper:getCanDecomposeById(data.goods_id) then
        self.btnSell:setVisible(false)
    end
    
    if isChat == true then
        self.btnSend:setVisible(true)
        self.btnTakeOff:setVisible(false)
        self.btnPutOn:setVisible(false)
        self.btnSell:setVisible(false)
    else
        self.btnSend:setVisible(false)
    end

    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    self.data = data

    --标题部分
    --装备名
    local labName = cc.uiloader:seekNodeByName(self.win, "labName")
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local equipName = configHelper:getGoodNameByGoodId(data.goods_id)
    if data.stren_lv >0 then
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
        labLevel:setVisible(true)
        cc.uiloader:seekNodeByName(self.win, "labLevel"):setVisible(false)
    else
        labLevel = cc.uiloader:seekNodeByName(self.win, "labLevel")
        labLevel:setString("LV."..(equipLevel or 0))
        labLevel:setVisible(true)
        cc.uiloader:seekNodeByName(self.win, "labLevel1"):setVisible(false)
    end

    --是否绑定
    local labBind = cc.uiloader:seekNodeByName(self.win, "labBind")
    labBind:setVisible((data.is_bind==1) or false)

    --调整位置
    local x1 = labName:getContentSize().width + labName:getPositionX()
    
    labLevel:setPositionX(x1+10)
    local x2 = x1 + 10 + labLevel:getContentSize().width
    labBind:setPositionX(x2+10) 

    --图标
    local commonItem = CommonItemCell.new()
    commonItem:setData(data)
    commonItem:setItemClickFunc(handler(self,self.onItemClick))
    local itemBg = cc.uiloader:seekNodeByName(self.win, "itemBg")
    commonItem:setTag(10)
    if itemBg:getChildByTag(10) then
        itemBg:removeChildByTag(10, true)
    end
    itemBg:addChild(commonItem)
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
        labCareerValue:setColor(cc.c3b(255,255,255))
    end
    labCareerValue:setString(eType or "")

    --评分
    local labScoreValue = cc.uiloader:seekNodeByName(self.win, "labScoreValue")
    labScoreValue:setString(data.fighting)
    labScoreValue:setVisible(true)
    cc.uiloader:seekNodeByName(self.win, "labScore"):setVisible(true)
    --基础属性部分
        local subTypeName,subType = configHelper:getEquipTypeByEquipId(data.goods_id)
        

--      设置属性

        for i=1,4 do
            cc.uiloader:seekNodeByName(self.win,"labAttr"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setVisible(false)
            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setPositionX(276)
            cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setColor(SoulColorArr[tostring(data.soul)])
            --self["labAttrAdd"..i]:setVisible(false)
        end
 
        local validAttr = configHelper:getStengPlusStrengLv(data.stren_lv, equipSubType)
        local equipItem = configHelper:getEquipValidAttrByEquipId2(data.goods_id, eId)
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
                cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setPositionX(195)
                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(equipItem[1][2])
                end
                cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setString("+("..math.floor(equipItem[1][2]*soulConfig.modulus)..")")
            else
                cc.uiloader:seekNodeByName(self.win,"labAttrValue"..1):setString(equipItem[1][2])
                cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..1):setPositionX(195)
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
                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setPositionX(195)
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
                    cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..(i+1)):setPositionX(195)
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
                    if validAttr[equipItem[i*2][1]] and validAttr[equipItem[i*2][1]] > 0  then
                        cc.uiloader:seekNodeByName(self.win,"labAttrValue"..i):setString(equipItem[i*2 - 1][2].."-"..equipItem[i*2][2].." + ("..validAttr[equipItem[i*2 - 1][1]].."-"..validAttr[equipItem[i*2][1]]..")")
                    else
                        cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setPositionX(195)
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
                    cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setPositionX(195)
                    cc.uiloader:seekNodeByName(self.win,"soulAttrValue"..i):setString("+("..math.floor(equipItem[i*2 - 1][2]*soulConfig.modulus).."-"..math.floor(equipItem[i*2][2]*soulConfig.modulus)..")")
                end
                end
            end

        end
 
    local attrScroll = cc.uiloader:seekNodeByName(self.win,"attrScroll")
    attrScroll:getScrollNode():removeAllChildren()
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
    if data.secure > 0 or (data.is_bind == 0 and securePrice > 0) then
        
        self.timesLabel:setVisible(true)
        self.insuranceIcon:setVisible(true)
        self.btnInsurance:setVisible(true)

        self.timesLabel:setString(data.secure)

    end

    if isChat == true then
        self.btnInsurance:setVisible(false)
    end
    --是否显示特殊装备按钮
    if configHelper:getGoodsSpecialByGoodsId(data.goods_id) == 1 then
        self.specialBtn:setVisible(true)
    else
        self.specialBtn:setVisible(false)
    end
    --self.specialBtn:setVisible(true)

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

function TipsEquip:onItemClick()
end

function TipsEquip:getName(str)

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

function TipsEquip:onSellClick( )
    local quality = configHelper:getGoodQualityByGoodId(self.data.goods_id)
    local onEnterFun = function()
        local id_list = {
            [1] = self.data.id
        }
        GameNet:sendMsgToSocket(14005, {goods_list = id_list})
        self:setVisible(false)
        if self.btnClickCallBack then
            self.btnClickCallBack()
        end
    end
    if quality < 4 then
        local param = {enterTxt = "返 回",tipTxt = "确定出售"..self.data.name.."吗？",enterFun = handler(self, onEnterFun)}
        GlobalMessage:alert(param)
    else
        onEnterFun()
    end

    --发送出售协议
    -- local id_list = {
    --     [1] = self.data.id
    -- }
    -- GameNet:sendMsgToSocket(14005, {goods_list = id_list})
    -- self:setVisible(false)
    -- if self.btnClickCallBack then
    --     self.btnClickCallBack()
    -- end
end

function TipsEquip:onPutOnClick( )
    --发送穿上协议 
    import("app.utils.EquipUtil")
    local data = 
    {
        id          =  self.data.id,
        goods_id    =  self.data.goods_id,
        grid        =  EquipUtil.getEquipPutOnPos(self.data)
    }
    GameNet:sendMsgToSocket(14022, data)
    self:setVisible(false)
    if self.btnClickCallBack then
        self.btnClickCallBack()
    end
end

function TipsEquip:onTakeOffClick( )
    --发送脱下协议
    local data = {
        grid = self.data.grid
    }
    GameNet:sendMsgToSocket(14023, data)
    if self.btnClickCallBack then
        self.btnClickCallBack()
    end
end

function TipsEquip:onSpecialClick( )
    local upWin = require("app.modules.tips.view.SpecialTips").new()
    upWin:setData({title = "特殊说明",content = configHelper:getGoodDescByGoodId(self.data.goods_id)})
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,upWin)
end

function TipsEquip:onSendClick( )
    --发送聊天
    GlobalEventSystem:dispatchEvent(ChatEvent.CHAT_SEND_GOODS, self.data)
end

function TipsEquip:setBtnClickCallBack(func)
    self.btnClickCallBack = func
end
