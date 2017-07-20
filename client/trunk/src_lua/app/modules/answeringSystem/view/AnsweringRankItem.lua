-- 排行榜条目

local AnsweringRankItem = class("AnsweringRankItem", require("app.gameui.listViewEx.UIAsynListViewItem"))

function AnsweringRankItem:ctor(loader, layoutFile)
	self.root = loader:BuildNodesByCache(layoutFile)
	self:addChild(self.root)
	self:setContentSize(self.root:getContentSize())
	self:initComponents()
end

function AnsweringRankItem:initComponents()
    self.rankLabel = cc.uiloader:seekNodeByName(self.root, "rank")
    self.nameLabel = cc.uiloader:seekNodeByName(self.root, "name")
    self.pointLabel = cc.uiloader:seekNodeByName(self.root, "point")
end

function AnsweringRankItem:invalidateData()
	self.rankLabel:setString(tostring(self.data.rank))
	self.nameLabel:setString(self.data.name)
	self.pointLabel:setString(tostring(self.data.score))
end


function AnsweringRankItem:setData(data)
	self.data = data
	self:invalidateData()
end


return AnsweringRankItem
