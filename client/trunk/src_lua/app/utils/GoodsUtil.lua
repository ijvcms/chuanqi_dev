local GoodsUtil = class("GoodsUtil")

--哪些物品是否能够用来传送
function GoodsUtil.canDeliverByGoodsId(goodId)
	return goodId == 305083 or goodId == 305084 or goodId == 305085
end

--获取所有能传送的物品
function GoodsUtil.getAllCanDeliverGoodIds()
	return {305083,305084,305085}
end

--是否是登陆特戒
function GoodsUtil.isLoginSpecialRingByGoodId(goodId)
	return goodId == 305086 or goodId == 305087 or goodId == 305088
end


--获取所有登陆特戒
function GoodsUtil.getAllLoginSpecialRingGoodIds()
	return {305086,305087,305088}
end


function GoodsUtil.getIconPathByGoodId(goodId)
	local iconId = configHelper:getIconByGoodId(goodId)
	if not iconId then return "" end
	return ResUtil.getGoodsIcon(iconId)
end

return GoodsUtil

