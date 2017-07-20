--
-- Author: zhangshunqiu
-- Date: 2015-02-04 19:21:05
-- 角色头像
local RoleHead = class("RoleHead", function()
	return display.newNode()
end)

function RoleHead:ctor(headUrl,scale)
	scale = scale or 1
	local bg1 = display.newSprite("res/public/icon_user_big@2x.png")
	bg1:setScale(scale)
	-- local bg2 = display.newSprite("res/publicUI/btn_close2.png")
	-- local cl = cc.ClippingNode:create()
	self:addChild(bg1)
	-- cl:addChild(bg2)

	-- cl:setStencil(bg1)
 	-- cl:setInverted(false)
end	


function RoleHead:setImage(url)

end

--清理
function RoleHead:destory()
end	

return RoleHead    