--
-- Author: Yi hanneng
-- Date: 2016-08-23 16:33:41
--
local OpenServeRankWin = OpenServeRankWin or class("OpenServeRankWin", BaseView)

function OpenServeRankWin:ctor()
	self.ccui = cc.uiloader:load("resui/serveRankWin.ExportJson")
	 
  	self:addChild(self.ccui)
   	self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height))
   	self:init()
end

function OpenServeRankWin:init()

 
	self.timeLabel = cc.uiloader:seekNodeByName(self.ccui, "timeLabel")
	self.description1 = cc.uiloader:seekNodeByName(self.ccui, "description1")
	self.description2 = cc.uiloader:seekNodeByName(self.ccui, "description2")
	self.mainLayer = cc.uiloader:seekNodeByName(self.ccui, "leftLayer")

	self.description1:setVisible(false)
   	self.ruleRich1 = SuperRichText.new(nil,self.description1:getContentSize().width)
   	self.ruleRich1:setAnchorPoint(0,1)
   	self.description1:getParent():addChild(self.ruleRich1)
   	self.ruleRich1:setPosition(self.description1:getPositionX(), self.description1:getPositionY() + 10)

   	self.description2:setVisible(false)
   	self.ruleRich2 = SuperRichText.new(nil,self.description2:getContentSize().width)
   	self.ruleRich2:setAnchorPoint(0,1)
   	self.description2:getParent():addChild(self.ruleRich2)
   	self.ruleRich2:setPosition(self.description2:getPositionX(), self.description2:getPositionY() + 10)

	self.rankList = {}
	self.rankList[1] = cc.uiloader:seekNodeByName(self.ccui, "rank1")
	self.rankList[2] = cc.uiloader:seekNodeByName(self.ccui, "rank2")
	self.rankList[3] = cc.uiloader:seekNodeByName(self.ccui, "rank3")

	self.rankLabel = cc.uiloader:seekNodeByName(self.ccui, "rankLabel")
	self.desLabel = cc.uiloader:seekNodeByName(self.ccui, "desLabel")
	self.numLabel = cc.uiloader:seekNodeByName(self.ccui, "numLabel")
 
	local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height)}
    self.listView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.listView:setContentSize(cc.rect(0,0,self.mainLayer:getContentSize().width - 10 , self.mainLayer:getContentSize().height))
  
    self.listView:setPositionX(5)

   	self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterBx").new("resui/serveRankItem.ExportJson", "app.modules.activity.view.OpenServeRankItem", 6, handler(self, self.itemClick))
    self.listView:setAdapter(self.rankListAdapter)
    self.mainLayer:addChild(self.listView)
 
end

function OpenServeRankWin:setViewInfo(data,config)
	if data == nil or self.data == data then
		return
	end

	self.data = data
 
	self.timeLabel:setString(os.date("%Y年%m月%d日%H:%M",data.begin_time).."-"..os.date("%Y年%m月%d日%H:%M",data.end_time))
	
	if data.my_rank == 0 then
		self.rankLabel:setString("未上榜")
	else
		self.rankLabel:setString(data.my_rank)
	end
 
	self.numLabel:setString(data.my_lv)
	
	if not data.rank_list then return end
	
	if #data.rank_list >1 then
		table.sort(data.rank_list,function(a,b) return a.rank < b.rank end )
	end
	

	for i=1,#self.rankList do
		if data.rank_list and data.rank_list[i] then
			self.rankList[i]:setString(data.rank_list[i].rank.."、"..data.rank_list[i].name)
		else
			self.rankList[i]:setString("")
		end
	end

	local list = {}

	for k,v in pairs(config) do
		table.insert(list, v)
	end

	if #list > 1 then
		table.sort(list,function(a,b) return a.id < b.id end )
	end

	self.desLabel:setString(list[1].rank_des)

	self.numLabel:setPositionX(self.desLabel:getPositionX() + self.desLabel:getContentSize().width - 4 )
	self.rankListAdapter:setData(list)
 
end

function OpenServeRankWin:setTitle(config)

	self.ruleRich1:renderXml("<font color='ffffff' size='16' opacity='255'>"..config.des1.."</font>")
	self.ruleRich2:renderXml("<font color='ffffff' size='16' opacity='255'>"..config.des2.."</font>")

end
 
function OpenServeRankWin:open()
 
end

function OpenServeRankWin:close()
 
end

return OpenServeRankWin