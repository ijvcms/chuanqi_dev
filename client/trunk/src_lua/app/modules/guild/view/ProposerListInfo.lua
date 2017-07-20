--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:18:38
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--

--申请人列表info
local ProposerListInfo = class("ProposerListInfo", function()
	return display.newNode()
end)

function ProposerListInfo:ctor(data,idx)
	self.data = data
	self:setContentSize(960-290-40,36)
	--底图
	if idx%2==0 then
		-- local bg = GradientTips.new({width = 650-290,height = 36},cc.c3b(80,80,80))
		-- bg:setPosition((self:getContentSize().width-bg:getContentSize().width)/2,0)
		-- self:addChild(bg)
	end

	local texts = {
		[1] = data.player_name,
		[2] = data.lv,
		[3] = RoleCareerName[data.career],
		[4] = data.fighting,
		[5] = data.online==1 and "在线" or "离线",
	}
	local pos = {
		[1] = {x=370-290,y=18},
		[2] = {x=500-290,y=18},
		[3] = {x=615-290,y=18},
		[4] = {x=735-290,y=18},
		[5] = {x=865-290,y=18},
	}

	for i=1,5 do
		local lab = display.newTTFLabel({
	    	text = texts[i],
	    	size = 20,
	    	color = TextColor.TEXT_W
		})
		display.setLabelFilter(lab)
		lab:setPosition(pos[i].x,pos[i].y)
		self:addChild(lab)
	end

end

return ProposerListInfo