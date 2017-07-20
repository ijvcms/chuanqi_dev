-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- 结盟
--
local GuildUnionPageItem = class("GuildUnionPageItem", BaseView)
function GuildUnionPageItem:ctor(winTag,data,winconfig)
	self.root = cc.uiloader:load("resui/guildUnionRightItem.ExportJson")
	self:addChild(self.root)
    self.unionName = self:seekNodeByName("unionName")
    self.ownerName = self:seekNodeByName("ownerName")
    self.unionLevel = self:seekNodeByName("unionLevel")
    self.peopleNum = self:seekNodeByName("peopleNum")
    self.cancelBtn = self:seekNodeByName("cancelBtn")
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.cancelBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.cancelBtn:setScale(1)
            if self.vo.guild_id ~= RoleManager:getInstance().guildInfo.guild_id then
                --退出结盟
                local param = {server_id_b=self.vo.server_id,guild_id_b = self.vo.guild_id}
                local function enterFun() --同意
                        GameNet:sendMsgToSocket(17090,param)
                    end
                    local tipsStr = "解除结盟将会使对方行会失去与我方所有同盟行会的结盟关系，是否与"
                    tipsStr = tipsStr ..self.vo.guild_name.."]行会解除结盟状态？"
                    GlobalMessage:alert({
                        enterTxt = "确定",
                        backTxt= "取消",
                        tipTxt = tipsStr,
                        enterFun = handler(self, enterFun),
                        tipShowMid = true,
                    })
            else
                --取消结盟
            end
        end
        return true
    end)
    self.root:setPosition(-285,-38)
end

function GuildUnionPageItem:open(datas)
end

function GuildUnionPageItem:setData(vo)
    self.sceneType = 1--本服 
    --self.sceneType = 2--跨服

    local canOper = true

    self.vo = vo
    self.unionName:setString(self.vo.guild_name)
    self.ownerName:setString(self.vo.chairman_name)
    self.unionLevel:setString(self.vo.guild_lv)
    self.peopleNum:setString(self.vo.number)
    if (RoleManager:getInstance().guildInfo.position == 1 or RoleManager:getInstance().guildInfo.position == 2) and canOper then
        if self.vo.guild_id ~= RoleManager:getInstance().guildInfo.guild_id then
            self.cancelBtn:setButtonLabelString("退出结盟")
            self.cancelBtn:setVisible(true)
        else
            self.cancelBtn:setVisible(true)
            self.cancelBtn:setButtonLabelString("取消结盟")
        end
    else
        self.cancelBtn:setVisible(false)
    end
end


function GuildUnionPageItem:close()
    GuildUnionPageItem.super.close(self)
end


--清理界面
function GuildUnionPageItem:destory()

end

return GuildUnionPageItem