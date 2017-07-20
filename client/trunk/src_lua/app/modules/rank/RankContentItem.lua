-- 排行榜条目

local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")

local RankContentItem = class("RankContentItem", UIAsynListViewItemEx)

function RankContentItem:ctor(loader, layoutFile)
	self.root = loader:BuildNodesByCache(layoutFile)
	self:addChild(self.root)
	self:initComponents()
end

function RankContentItem:initComponents()
    self.LvContent = cc.uiloader:seekNodeByName(self.root, "level_rank")
    self.FightContent = cc.uiloader:seekNodeByName(self.root, "power_rank")
    self.GuildContent = cc.uiloader:seekNodeByName(self.root, "union_rank")
    self.selected = cc.uiloader:seekNodeByName(self.root, "selected")
    self:setContentSize(self.LvContent:getContentSize())
end

function RankContentItem:invalidateData()
	self.selected:setVisible(false)
	if self.data.lv then
		self:invalidateLvData()
	elseif self.data.fight then
		self:invalidateFightData()
    else
    	self:invalidateGuildData()
	end
end


--等级排行信息
function RankContentItem:invalidateLvData()
	self.LvContent:setVisible(true)
	self.FightContent:setVisible(false)
	self.GuildContent:setVisible(false)
	local rankContainer = cc.uiloader:seekNodeByNameFast(self.LvContent, "rank")
	if self.data.rank > 3 then
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(false)
		rankLabel:setVisible(true)
		rankLabel:setString(tostring(self.data.rank))
	else
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(true)
		rankLabel:setVisible(false)
		rankImg:setSpriteFrame("rank"..self.data.rank..".png")
    end
    local nameLabel = cc.uiloader:seekNodeByNameFast(self.LvContent, "nameLabel")
    nameLabel:setString(self.data.name)
	local careerImg = cc.uiloader:seekNodeByNameFast(self.LvContent, "occupation")
	if self.data.career == 1000 then--战士
		careerImg:setSpriteFrame("com_carrerIcon1.png")
	elseif self.data.career == 2000  then--法师
		careerImg:setSpriteFrame("com_carrerIcon2.png")
	elseif self.data.career == 3000 then--道士
		careerImg:setSpriteFrame("com_carrerIcon3.png")
	end
	local levelLabel = cc.uiloader:seekNodeByNameFast(self.LvContent, "levelLabel")
	levelLabel:setString(tostring(self.data.lv))
	local unionLabel = cc.uiloader:seekNodeByNameFast(self.LvContent, "unionLabel")
	unionLabel:setString(self.data.guild_name)
end


--战斗力排行信息
function RankContentItem:invalidateFightData()
	self.LvContent:setVisible(false)
	self.FightContent:setVisible(true)
	self.GuildContent:setVisible(false)
	local rankContainer = cc.uiloader:seekNodeByNameFast(self.FightContent, "rank")
	if self.data.rank > 3 then
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(false)
		rankLabel:setVisible(true)
		rankLabel:setString(tostring(self.data.rank))
	else
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(true)
		rankLabel:setVisible(false)
		rankImg:setSpriteFrame("rank"..self.data.rank..".png")
    end
    local nameLabel = cc.uiloader:seekNodeByNameFast(self.FightContent, "nameLabel")
    nameLabel:setString(self.data.name)
	local careerImg = cc.uiloader:seekNodeByNameFast(self.FightContent, "occupation")
	if self.data.career == 1000 then--战士
		careerImg:setSpriteFrame("com_carrerIcon1.png")
	elseif self.data.career == 2000  then--法师
		careerImg:setSpriteFrame("com_carrerIcon2.png")
	elseif self.data.career == 3000 then--道士
		careerImg:setSpriteFrame("com_carrerIcon3.png")
	end
	local powerLabel = cc.uiloader:seekNodeByNameFast(self.FightContent, "powerLabel")
	powerLabel:setString(tostring(self.data.fight))
	local unionLabel = cc.uiloader:seekNodeByNameFast(self.FightContent, "unionLabel")
	unionLabel:setString(self.data.guild_name)
end

--行会排行信息
function RankContentItem:invalidateGuildData()
	self.LvContent:setVisible(false)
	self.FightContent:setVisible(false)
	self.GuildContent:setVisible(true)
	local rankContainer = cc.uiloader:seekNodeByNameFast(self.GuildContent, "rank")
	if self.data.rank > 3 then
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(false)
		rankLabel:setVisible(true)
		rankLabel:setString(tostring(self.data.rank))
	else
		local rankLabel = cc.uiloader:seekNodeByNameFast(rankContainer, "rankLabel")
		local rankImg = cc.uiloader:seekNodeByPath(rankContainer, "rankImg")
		rankImg:setVisible(true)
		rankLabel:setVisible(false)
		rankImg:setSpriteFrame("rank"..self.data.rank..".png")
    end
    local nameLabel = cc.uiloader:seekNodeByNameFast(self.GuildContent, "nameLabel")
    nameLabel:setString(self.data.guild_name)
	local levelLabel = cc.uiloader:seekNodeByNameFast(self.GuildContent, "levelLabel")
	levelLabel:setString(tostring(self.data.guild_lv))
	local ownerNameLabel = cc.uiloader:seekNodeByNameFast(self.GuildContent, "ownerNameLabel")
	ownerNameLabel:setString(self.data.chief_name)
	local peopleNumLabel = cc.uiloader:seekNodeByNameFast(self.GuildContent, "peopleNumLabel")
	peopleNumLabel:setString(tostring(self.data.member_num))
end

function RankContentItem:setData(data)
	self.data = data
	self:invalidateData()
end

function RankContentItem:getData()
	return self.data
end

function RankContentItem:setSelect(b)
	self.selected:setVisible(b)
end

return RankContentItem
