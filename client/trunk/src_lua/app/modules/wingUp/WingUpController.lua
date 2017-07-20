--
-- Author: Shine
--
local WingUpController = WingUpController or class("WingUpController", BaseController)

function WingUpController:onUpdateWingCompleted(fun)
	self:registerProtocal(14044,fun)
end

function WingUpController:clean()
	self:unRegisterProtocal(14044)
end

--更新翅膀
function WingUpController:updateWing(wing, noAlert)
	local has_count = BagManager:getInstance():findItemCountByItemId(wing.need_goods)--当前拥有数量
	local upgrage_count =  wing.need_num-- 升级需要树数量
	local currentWingKey = wing.key -- 当前翅膀强化key
    local up_one_price = wing.jade_price -- 补足元宝单价
    --需要的物品名称，如羽毛
    local needGoodsName =  configHelper:getGoodNameByGoodId(wing.need_goods)
    if has_count >= upgrage_count then
        --<Packet proto="14044" type="c2s" name="req_wing_upgrade" describe="翅膀升级">
        --<Param name="id" type="int16" describe="勋章升级id"/>
        --<Param name="type" type="int8" describe="是否用元宝补足0不用 1用"/>
        --</Packet>
        self:sendMsgToSocket(14044,{id = currentWingKey, type = 0})
    else
        local goldName
        if 1 == wing.money_type then
            goldName = "金币"
        elseif 2 ==  wing.money_type then
            goldName = "元宝"
        elseif 3 ==  wing.money_type then
            goldName = "礼卷"
        end
        local gold = up_one_price * (upgrage_count - has_count)--需求不足的元宝
        local tipTxt  = "升级需要"..upgrage_count.."个"..needGoodsName..
                        "，当前拥有"..has_count.."个，\n"..
                        "是否花费"..gold..goldName.."补齐材料升级？"
        local upgrapeFun = function ()
            self:sendMsgToSocket(14044,{id = currentWingKey, type = 1})
        end
        if noAlert then
            upgrapeFun()
            return
        end
        GlobalMessage:alert({
            enterTxt = "是",
            backTxt= "否",
            tipTxt = tipTxt,
            enterFun = upgrapeFun,
            tipShowMid = true
        })
     end
	
end

function WingUpController:isTempWing(goods)
    if goods.grid == 13 and configHelper:getGoodTimeLinessByGoodId(goods.goods_id) > 0 then
        return true
    end
    return false
end
function WingUpController:getCurTempWing()
    local equipList = RoleManager:getInstance().roleInfo.equip
    for i=1,#equipList do
        local curGoodsId = equipList[i].goods_id
        if self:isTempWing(equipList[i]) then
            return equipList[i]
        end
    end
    return nil
end
--设置可见与否 0显示 1不现实
function WingUpController:setWingVisible(isVisible)
    self:sendMsgToSocket(10013,{subtype = 13,state = isVisible})
end

return WingUpController