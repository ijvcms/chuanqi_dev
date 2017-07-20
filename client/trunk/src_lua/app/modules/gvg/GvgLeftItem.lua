-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- GVG
--
local GvgLeftItem = class("GvgLeftItem", BaseView)
function GvgLeftItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/gvgListItem.ExportJson") --588，36
	self:addChild(self.root)
    self.root:setPosition(-110,-5)
    self.rank = self:seekNodeByName("rank") --gvg_rank1 gvg_rank2  gvg_rank3
    self.name = self:seekNodeByName("name") --第四名后显示
    self.point = self:seekNodeByName("point")
end


function GvgLeftItem:open(datas)
    
end

function GvgLeftItem:setData(vo)
    self.vo = vo
    self.rank:setString(self.vo.rank)
    self.name:setString(self.vo.name);
    self.point:setString(self.vo.score)
end


function GvgLeftItem:close()
    GvgLeftItem.super.close(self)
end


--清理界面
function GvgLeftItem:destory()

end

return GvgLeftItem