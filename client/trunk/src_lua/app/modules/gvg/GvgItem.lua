-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- GVG
--
local GvgItem = class("GvgItem", BaseView)
function GvgItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/gvgItem.ExportJson") --588，36
	self:addChild(self.root)
    self.root:setPosition(-290,0)
    self.rankImg = self:seekNodeByName("rankImg") --gvg_rank1 gvg_rank2  gvg_rank3
    self.rankLabel = self:seekNodeByName("rankLabel") --第四名后显示
    self.nameLabel = self:seekNodeByName("nameLabel")
    self.levelLabel = self:seekNodeByName("levelLabel")

    self.occupation = self:seekNodeByName("occupation") --职业图 --gvg_mage 法师 _soldier  _taoist
    self.pointLabel = self:seekNodeByName("pointLabel")
end


function GvgItem:open(datas)
    
end

function GvgItem:setData(vo)
    self.vo = vo

    if self.vo.career == 1000 then
        self.occupation:setSpriteFrame("com_carrerIcon1.png");
    elseif self.vo.career == 2000 then
        self.occupation:setSpriteFrame("com_carrerIcon2.png");
    elseif self.vo.career == 3000 then
        self.occupation:setSpriteFrame("com_carrerIcon3.png");
    end
    self.pointLabel:setString(self.vo.score)
    self.levelLabel:setString(self.vo.lv)
    self.nameLabel:setString(self.vo.name)

    local rank = self.vo.rank
    if rank <= 3 then
        self.rankLabel:setVisible(false)
        self.rankImg:setVisible(true)
        self.rankImg:setSpriteFrame("com_rank"..rank.."Pic.png");
    else
        self.rankLabel:setVisible(true)
        self.rankImg:setVisible(false)
        self.rankLabel:setString(rank)
    end
end

function GvgItem:close()
    GvgItem.super.close(self)
end


--清理界面
function GvgItem:destory()
	
end

return GvgItem