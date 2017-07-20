--
-- Author: Your Name
-- Date: 2015-12-14 10:39:27
--
local UIAsynListViewItemEx = import("app.gameui.listViewEx.UIAsynListViewItemEx")
require("app.modules.role.RoleManager")

local CopyItem = CopyItem or class("CopyItem",UIAsynListViewItemEx)

function CopyItem:ctor(loader, layoutFile)
	self.ccui = loader:BuildNodesByCache(layoutFile)
    self:addChild(self.ccui)
    self:setContentSize(cc.size(self.ccui:getContentSize().width, self.ccui:getContentSize().height + 10))
    self:init()
end

function CopyItem:init()

    local root = cc.uiloader:seekNodeByName(self.ccui, "root")
    self.nameLbl = cc.uiloader:seekNodeByName(self.ccui, "name")
    self.goodsLbl = cc.uiloader:seekNodeByName(self.ccui, "type")
    self.LV = cc.uiloader:seekNodeByName(self.ccui, "LV")
    self.Image_3 = cc.uiloader:seekNodeByName(self.ccui, "Image_3")
    self.Image_4 = cc.uiloader:seekNodeByName(self.ccui, "Image_4")
    --self.ico = cc.uiloader:seekNodeByName(ccui, "ico")

    self.Image_4:setVisible(false)
 
    self.ico = display.newSprite()
    root:addChild(self.ico)
end
 
function CopyItem:setData(data)

    self.data = data

    self.nameLbl:setString(data.copyInfo.name)
    self.LV:setString(data.copyInfo.lv)

    if data.copyInfo.lv > RoleManager:getInstance().roleInfo.lv  then
        self.goodsLbl:setString("【"..data.copyInfo.lv.."级开启】")
        self.goodsLbl:setColor(cc.c3b(255, 0, 0))
    else
        self.goodsLbl:setString(data.copyInfo.reward)
        self.goodsLbl:setColor(cc.c3b(0, 255, 0))
    end
    
    local path = "m_"..data.copyInfo.res..".png"
 
    if self.ico then
        self.ico:setSpriteFrame(path)
        self.ico:setPosition( self.ico:getContentSize().width/2 + 5, self.Image_3:getContentSize().height/2)
    end
 
end

function CopyItem:getData()
    return self.data
end
 
function CopyItem:setSelect(b)
    if b == true then
        --self.bg:setSpriteFrame("copy_sel.png")
        self.Image_3:setVisible(false)
        self.Image_4:setVisible(true)
    else
        --self.bg:setSpriteFrame("copy_unSel.png")
        self.Image_3:setVisible(true)
        self.Image_4:setVisible(false)
    end
end

function CopyItem:destory()
 
end

return CopyItem