--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-20 16:16:14
-- 
-- Split from app/moduls/social/view/GuildOperatePage.lua
--

--成员列表info
local MemberListInfo = class("MemberListInfo", function()
	return display.newNode()
end)

function MemberListInfo:ctor(data,idx, isCorps)
	self.data = data
	self:setContentSize(960-290-40,36)
	--底图
	if idx%2==0 then
		-- local bg = GradientTips.new({width = 650-290,height = 36},cc.c3b(80,80,80))
		-- bg:setPosition((self:getContentSize().width-bg:getContentSize().width)/2,0)
		-- self:addChild(bg)
	end
    
    local texts
    if isCorps then
    	texts = {
		    [1] = data.player_name,
		    [2] = CorpsPosition[data.position],
		    [3] = data.lv,
		    [4] = RoleCareerName[data.career],
		    [5] = data.fighting,
		    [6] = data.contribution,
	    }
    else
    	texts = {
		    [1] = data.player_name,
		    [2] = GuildPosition[data.position],
		    [3] = data.lv,
		    [4] = RoleCareerName[data.career],
		    [5] = data.fighting,
		    [6] = data.contribution,
	    }

    end
	
	local pos = {
		[1] = {x=370-290,y=18},
		[2] = {x=500-290,y=18},
		[3] = {x=580-290,y=18},
		[4] = {x=665-290,y=18},
		[5] = {x=760-290,y=18},
		[6] = {x=860-290,y=18}
	}

	self.labs = {}
	for i=1,6 do
		local lab = display.newTTFLabel({
	    	text = (texts[i] == nil and "") or texts[i],
	    	size = 20,
	    	color = TextColor.TEXT_W
		})
		display.setLabelFilter(lab)
		lab:setPosition(pos[i].x,pos[i].y)
		self:addChild(lab)
		table.insert(self.labs,lab)
	end

end

return MemberListInfo