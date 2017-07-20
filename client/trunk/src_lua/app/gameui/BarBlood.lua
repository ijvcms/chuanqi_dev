--
-- Author: Evans
-- Date: 2014-11-08 11:47:50
--血条

local BarBlood = class("BarBlood", function()
	return display.newNode()
end)


--override--

--type_ 	类型：（1已方 2敌方 3主城）
function BarBlood:ctor(type_)
	self.type_ = type_ or 1
	self:createBar()
end

--custom--

function BarBlood:createBar()
	--url
	local urlBg
	local urlBar
	local color
	if self.type_ == 1 or
		self.type_ == 2 then
		urlBg = urlRes("images/share/pgb_blood_bg.png")
		urlBar = urlRes("images/share/pgb_blood.png")
	else
		urlBg = urlRes("images/share/pgb_blood2_bg.png")
		urlBar = urlRes("images/share/pgb_blood2.png")
	end

	if self.type_ == 1 then
		color = STYLE.COLOR_ORANGE
	elseif self.type_ == 2 then
		color = display.COLOR_RED
	else
		color = display.COLOR_BLUE
	end

	local bg = display.newSprite(urlBg):addTo(self)
	local bar = cc.ui.UILoadingBar.new({
		image = urlBar,
		percent = 100,
		-- viewRect = cc.rect(0, 0, options.width, options.height)
		})
		:addTo(self)
	local rect = bar:getViewRect()
	bar:pos(-rect.width / 2, -rect.height / 2)
	bar:setColor(color)

	self.bg_ = bg
	self.bar_ = bar
end

--设置百分比
function BarBlood:setPercent(percent)
	self.bar_:setPercent(percent)
end

--设置值
function BarBlood:setValue(curr, total)
	self:setPercent(curr / total * 100)
end


return BarBlood
