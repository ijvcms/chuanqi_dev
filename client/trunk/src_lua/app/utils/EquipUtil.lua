EquipUtil = EquipUtil or class("EquipUtil")

local EquipModel = require("app.game.equipment.model.EquipModel")

function EquipUtil.showBaseAttrFormat(validAttr)
    local showAttr = {}
    for i=1,#validAttr do
        if validAttr[i][1] == "hp" then
            table.insert(showAttr,{"气血",min=validAttr[i][2]})

        elseif validAttr[i][1] == "mp" then
            table.insert(showAttr,{"魔法",min=validAttr[i][2]})

        elseif validAttr[i][1] == "min_ac" or validAttr[i][1] == "max_ac" then
            local find
            local pos
            for j=1,#showAttr do
                if showAttr[j][1] == "物攻" then
                    find = true
                    pos = j
                    break
                end
            end
            if validAttr[i][1] == "min_ac" then
                if find then
                    showAttr[pos].min = validAttr[i][2]
                else
                    table.insert(showAttr,{"物攻",min=validAttr[i][2],max=0})
                end
            elseif validAttr[i][1] == "max_ac" then
                if find then
                    showAttr[pos].max = validAttr[i][2]
                else
                    table.insert(showAttr,{"物攻",min=0,max=validAttr[i][2]})
                end
            end

        elseif validAttr[i][1] == "min_mac" or validAttr[i][1] == "max_mac" then
            local find
            local pos
            for j=1,#showAttr do
                if showAttr[j][1] == "法攻" then
                    find = true
                    pos = j
                    break
                end
            end
            if validAttr[i][1] == "min_mac" then
                if find then
                    showAttr[pos].min = validAttr[i][2]
                else
                    table.insert(showAttr,{"法攻",min=validAttr[i][2],max=0})
                end
            elseif validAttr[i][1] == "max_mac" then
                if find then
                    showAttr[pos].max = validAttr[i][2]
                else
                    table.insert(showAttr,{"法攻",min=0,max=validAttr[i][2]})
                end
            end

        elseif validAttr[i][1] == "min_sc" or validAttr[i][1] == "max_sc" then
            local find
            local pos
            for j=1,#showAttr do
                if showAttr[j][1] == "道攻" then
                    find = true
                    pos = j
                    break
                end
            end
            if validAttr[i][1] == "min_sc" then
                if find then
                    showAttr[pos].min = validAttr[i][2]
                else
                    table.insert(showAttr,{"道攻",min=validAttr[i][2],max=0})
                end
            elseif validAttr[i][1] == "max_sc" then
                if find then
                    showAttr[pos].max = validAttr[i][2]
                else
                    table.insert(showAttr,{"道攻",min=0,max=validAttr[i][2]})
                end
            end

        elseif validAttr[i][1] == "min_def" or validAttr[i][1] == "max_def" then
            local find
            local pos
            for j=1,#showAttr do
                if showAttr[j][1] == "物防" then
                    find = true
                    pos = j
                    break
                end
            end
            if validAttr[i][1] == "min_def" then
                if find then
                    showAttr[pos].min = validAttr[i][2]
                else
                    table.insert(showAttr,{"物防",min=validAttr[i][2],max=0})
                end
            elseif validAttr[i][1] == "max_def" then
                if find then
                    showAttr[pos].max = validAttr[i][2]
                else
                    table.insert(showAttr,{"物防",min=0,max=validAttr[i][2]})
                end
            end 

        elseif validAttr[i][1] == "min_res" or validAttr[i][1] == "max_res" then
            local find
            local pos
            for j=1,#showAttr do
                if showAttr[j][1] == "法防" then
                    find = true
                    pos = j 
                    break
                end
            end
            if validAttr[i][1] == "min_res" then
                if find then
                    showAttr[pos].min = validAttr[i][2]
                else
                    table.insert(showAttr,{"法防",min=validAttr[i][2],max=0})
                end
            elseif validAttr[i][1] == "max_res" then
                if find then
                    showAttr[pos].max = validAttr[i][2]
                else
                    table.insert(showAttr,{"法防",min=0,max=validAttr[i][2]})
                end
            end 

        elseif validAttr[i][1] == "m_hit" then
            table.insert(showAttr,{"魔法命中",min=validAttr[i][2]})

        elseif validAttr[i][1] == "m_dodge" then
            table.insert(showAttr,{"魔法闪避",min=validAttr[i][2]})

        end
    end
    return showAttr
end

function EquipUtil.showBaptizeAttrFormat(validAttr)
    local showAttr = {}
    if validAttr == nil then
        return showAttr
    end
    for i=1,#validAttr do
        -- if AttrName[validAttr[i].key] == "最小物理攻击" or AttrName[validAttr[i].key] == "最大物理攻击" then            --物理攻击
        --     local find
        --     local pos
        --     for j=1,#showAttr do
        --         if showAttr[j][1] == "物攻" then
        --             find = true
        --             pos = j
        --             break
        --         end
        --     end
        --     if AttrName[validAttr[i].key] == "最小物理攻击" then
        --         if find then
        --             showAttr[pos].min = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"物攻",min=validAttr[i].value,max=0})
        --         end
        --     elseif AttrName[validAttr[i].key] == "最大物理攻击" then
        --         if find then
        --             showAttr[pos].max = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"物攻",min=0,max=validAttr[i].value})
        --         end
        --     end

        -- elseif AttrName[validAttr[i].key] == "最小魔法攻击" or AttrName[validAttr[i].key] == "最大魔法攻击" then        --魔法攻击
        --     local find
        --     local pos
        --     for j=1,#showAttr do
        --         if showAttr[j][1] == "魔攻" then
        --             find = true
        --             pos = j
        --             break
        --         end
        --     end
        --     if AttrName[validAttr[i].key] == "最小魔法攻击" then
        --         if find then
        --             showAttr[pos].min = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"魔攻",min=validAttr[i].value,max=0})
        --         end
        --     elseif AttrName[validAttr[i].key] == "最大魔法攻击" then
        --         if find then
        --             showAttr[pos].max = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"魔攻",min=0,max=validAttr[i].value})
        --         end
        --     end

        -- elseif AttrName[validAttr[i].key] == "最小道术攻击" or AttrName[validAttr[i].key] == "最大道术攻击" then        --道术攻击
        --     local find
        --     local pos
        --     for j=1,#showAttr do
        --         if showAttr[j][1] == "道攻" then
        --             find = true
        --             pos = j
        --             break
        --         end
        --     end
        --     if AttrName[validAttr[i].key] == "最小道术攻击" then
        --         if find then
        --             showAttr[pos].min = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"道攻",min=validAttr[i].value,max=0})
        --         end
        --     elseif AttrName[validAttr[i].key] == "最大道术攻击" then
        --         if find then
        --             showAttr[pos].max = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"道攻",min=0,max=validAttr[i].value})
        --         end
        --     end

        -- elseif AttrName[validAttr[i].key] == "最小物防" or AttrName[validAttr[i].key] == "最大物防" then                --物理防御
        --     local find
        --     local pos
        --     for j=1,#showAttr do
        --         if showAttr[j][1] == "物防" then
        --             find = true
        --             pos = j
        --             break
        --         end
        --     end
        --     if AttrName[validAttr[i].key] == "最小物防" then
        --         if find then
        --             showAttr[pos].min = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"物防",min=validAttr[i].value,max=0})
        --         end
        --     elseif AttrName[validAttr[i].key] == "最大物防" then
        --         if find then
        --             showAttr[pos].max = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"物防",min=0,max=validAttr[i].value})
        --         end
        --     end

        -- elseif AttrName[validAttr[i].key] == "最小魔防" or AttrName[validAttr[i].key] == "最大魔防" then                --魔法防御
        --     local find
        --     local pos
        --     for j=1,#showAttr do
        --         if showAttr[j][1] == "魔防" then
        --             find = true
        --             pos = j
        --             break
        --         end
        --     end
        --     if AttrName[validAttr[i].key] == "最小魔防" then
        --         if find then
        --             showAttr[pos].min = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"魔防",min=validAttr[i].value,max=0})
        --         end
        --     elseif AttrName[validAttr[i].key] == "最大魔防" then
        --         if find then
        --             showAttr[pos].max = validAttr[i].value
        --         else
        --             table.insert(showAttr,{"魔防",min=0,max=validAttr[i].value})
        --         end
        --     end

        -- else                                                                                                            --其他属性
            table.insert(showAttr,{AttrName[validAttr[i].key],key = validAttr[i].key,name = AttrName[validAttr[i].key],min=validAttr[i].value,id = validAttr[i].id,state = validAttr[i].state})
        -- end

    end

    return showAttr
end

function EquipUtil.showArtifactAttrFormat(validAttr)
    local showAttr = {}
    for i=1,#validAttr do
        table.insert(showAttr,{validAttr[i][1],min=validAttr[i][2]})
    end
    return showAttr
end

function EquipUtil.formatEquipItem(data)
    local euqipModel = EquipModel.mapServerModel(data)
    return euqipModel
end

function EquipUtil.getEquipCanUse(is_use)
    if is_use == nil then
        --print(is_use,"true")
        return true
    elseif is_use == 0 then
        --print(is_use,"false")
        return false
    end
    --print(is_use,"true")
    return true
end

--取得装备的评分
function EquipUtil.getEquipFight(equip)
    --装备的评分只与基础,强化和洗炼属性有关,与神器属性无关
    local fightValue = 0
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()

    --基础属性
    local validAttr = configHelper:getEquipValidAttrByEquipId(equip.goods_id)
    local sourValue = tonumber(configHelper:getSoulAddConfig(equip.soul).modulus) + 1

    if validAttr == nil then
        return 0
    end
    for i=1,#validAttr,1 do
        for k,v in pairs(AttrMatch) do
            if validAttr[i][1] == v.field then
                --强化提升
                fightValue = fightValue + validAttr[i][2]*configHelper:getAttrFight(v.key)*sourValue
            end
        end
    end

    if equip.stren_lv and equip.stren_lv>0 then
        local equipSubType = configHelper:getGoodSubTypeByGoodId(equip.goods_id)
        local plus = configHelper:getStengPlusStrengLv(equip.stren_lv,equipSubType)
        
        for k,v in pairs(AttrMatch) do
             if plus[v.field] and plus[v.field] > 0 then

                 fightValue = fightValue + plus[v.field]*configHelper:getAttrFight(v.key) 
             end
        end
           
     end

    --洗炼属性
    local validAttr = equip.baptize_attr_list
    for i=1,#validAttr do
        fightValue = fightValue + validAttr[i].value*configHelper:getAttrFight(validAttr[i].key)
    end

    --最后的值要除以10
    return math.floor(fightValue/10)
end

--检查装备是否比身上装备战力更强,不满足装备条件的(等级,职业)会返回false
function EquipUtil.checkPutonEquipPromote(itemData)
    local itemData = EquipUtil.formatEquipItem(itemData)
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    --如果是可穿戴的本职业的装备,并且评分高于身上的装备,则装备显示提升的小箭头
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local careerName,career = configHelper:getEquipCareerByEquipId(itemData.goods_id)

    local showArrow = false
    if career == roleInfo.career then
        if configHelper:getGoodLVByGoodId(itemData.goods_id) <= roleInfo.lv then
            local etName,etid = configHelper:getEquipTypeByEquipId(itemData.goods_id)
            local fighting = itemData.fighting
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
                    showArrow = true
                elseif not left and right then          --左边没有佩戴戒指
                    showArrow = true
                elseif left and right then              --两边都佩戴了戒指
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showArrow = true
                    end
                else                                    --两边都没佩戴戒指
                    showArrow = true
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
                    showArrow = true
                elseif not left and right then          --左边没有佩戴手镯
                    showArrow = true
                elseif left and right then              --两边都佩戴了手镯
                    if fighting > leftItem.fighting or fighting > rightItem.fighting then
                        showArrow = true
                    end
                else                                    --两边都没佩戴手镯
                    showArrow = true
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
                        showArrow = true
                    end
                else                                    --身上没有穿戴这个部位的装备
                    showArrow = true
                end
            end
        end
    end
    return showArrow
end

--计算穿上装备时装备的位置，比如戒指可能穿左手，也可能穿右手
function EquipUtil.getEquipPutOnPos(data)
    -- local configHelper = import("app.utils.ConfigHelper").getInstance()
    local etName,etid = configHelper:getEquipTypeByEquipId(data.goods_id)
    local pos
    if etid == 7 then                           --判断戒指显示在左手还是右手
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
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
        if left and not right then              --左边已经佩戴戒指
            pos = 12
        elseif not left and right then          --右边已经佩戴戒指
            pos = 7
        elseif left and right then              --两边都佩戴了戒指
            if leftItem.fighting <= rightItem.fighting then
                pos = 7
            else
                pos = 12
            end
        else                                    --两边都没佩戴戒指
            pos = 7
        end
    elseif etid == 6 then                       --判断手镯显示在左手还是右手
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
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
        if left and not right then              --左边已经佩戴手镯
            pos = 11
        elseif not left and right then          --右边已经佩戴手镯
            pos = 6
        elseif left and right then              --两边都佩戴了手镯
            if leftItem.fighting <= rightItem.fighting then
                pos = 6
            else
                pos = 11
            end
        else                                    --两边都没佩戴手镯
            pos = 6
        end
    elseif etid == 29 then                       --判断特戒显示在左手还是右手
        local roleManager = RoleManager:getInstance()
        local roleInfo = roleManager.roleInfo
        local left = false
        local right = false
        local leftItem 
        local rightItem 
        for i=1,#roleInfo.equip do
            if roleInfo.equip[i].grid == 29 then
                left = true
                leftItem = roleInfo.equip[i]
            elseif roleInfo.equip[i].grid == 30 then
                right = true
                rightItem = roleInfo.equip[i]
            end
        end
        if left and not right then              --左边已经佩戴手镯
            pos = 30
        elseif not left and right then          --右边已经佩戴手镯
            pos = 29
        elseif left and right then              --两边都佩戴了手镯
            if leftItem.fighting <= rightItem.fighting then
                pos = 29
            else
                pos = 30
            end
        else                                    --两边都没佩戴手镯
            pos = 29
        end
    else
        pos = etid
    end
    return pos
end

