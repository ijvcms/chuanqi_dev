--
-- Author: Allen    21102585@qq.com
-- Date: 2017-05-22 17:52:08
-- 目标头像
local TargetHead = class("TargetHead", function()
	return display.newNode()
end)

function TargetHead:ctor(jsonurl, winName)
	self.isDestory = false
	self.jsonurl = "resui/targetHead.ExportJson"
	self.winName = winName
	self.root = cc.uiloader:load(self.jsonurl)
	self:addChild(self.root)

	self.headBg = self:seekNodeByName("headBg") --头像容器
	self.headLay = self:seekNodeByName("headLay") --头像容器
	self.nameLab = self:seekNodeByName("nameLab") --boss名字

	-- self.hpPrecentLab = self:seekNodeByName("hpPrecentLab") --bosshp百分比 w=102 37，40
 --    self.lvLab = self:seekNodeByName("lvLab") --boss级别

    self.hpPrecentLab = display.newBMFontLabel({
            text = "",
            font = "fonts/bitmapText_22.fnt",
            })
    self.hpPrecentLab:setTouchEnabled(false)
    self.root:addChild(self.hpPrecentLab)
    self.hpPrecentLab:setPosition(120,33)
    self.hpPrecentLab:setAnchorPoint(0.5,0.5)
    --self.hpPrecentLab:setColor(cc.c3b(255, 222, 176))
    self.hpPrecentLab:setScale(0.9)

    self.lvLab = display.newBMFontLabel({
            text = "",
            font = "fonts/bitmapText_22.fnt",
            })
    self.lvLab:setTouchEnabled(false)
    self.root:addChild(self.lvLab)
    self.lvLab:setPosition(13,19)
    self.lvLab:setAnchorPoint(0.5,0.5)
    --self.lvLab:setColor(cc.c3b(255, 222, 176))
    self.lvLab:setScale(0.9)



	
	self.hpBarPic = self:seekNodeByName("hpBarPic")
	self.heteBg = self:seekNodeByName("heteBg")
	self.heteLab = self:seekNodeByName("heteLab")

    local xx,yy = self.hpBarPic:getPosition()
    self.hpBarxx = xx
    self.hpBaryy = yy
    self.hpWidth = self.hpBarPic:getContentSize().width

    self.hpClippingRegion = cc.ClippingRegionNode:create()
    self.hpClippingRegion:setAnchorPoint(0,0)
    self.hpClippingRegion:setPosition(self.hpBarxx,self.hpBaryy)
    self.headBg:addChild(self.hpClippingRegion)

    local collectionBar = display.newSprite("#scene/scene_atkTagHpBar.png")
    collectionBar:setAnchorPoint(0,0)
    self.hpClippingRegion:addChild(collectionBar)

    local pare = self.hpBarPic:getParent()
 	if pare ~= nil then              
 		pare:removeChild(self.hpBarPic)
 		self.hpClippingRegion:addChild(self.hpBarPic)
 	end
    self.hpbloodRect = cc.rect(0, 0, 30, self.hpBarPic:getContentSize().height)
    self.hpClippingRegion:setClippingRegion(self.hpbloodRect)

    self.headLay:setTouchEnabled(true)
    self.headLay:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
		    SoundManager:playClickSound()
	        --点击弹出tips 
	        if self.curVo and self.curVo.type == SceneRoleType.PLAYER and GameSceneModel.curSceneHideName == true then
	            GlobalMessage:show("本活动地图禁止使用此功能")
	        else
	            self:showBtnTips(self.curVo.type,nil,self.curVo,nil)
	        end
	    end
	    return true
    end)
end

function TargetHead:showBtnTips(popTipsType,itemOpenTable,voData,modifyFunc)
    -- if popTipsType == SceneRoleType.PLAYER then    --玩家
        local node = require("app.gameui.PopTipsList").new(popTipsType,itemOpenTable,voData,nil)
        node:setPosition(display.width/2,display.height/2 - node:getContentSize().height/2 + 50)
        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
    -- end
end

function TargetHead:open()

end

function TargetHead:close()

end

function TargetHead:destory()
	self:removeSelf()
end


function TargetHead:setData(vo,isshenmi)
	--self.hpPrecentLab:setString(vo.hp.."/"..vo.hp_limit)
	--if self.curVo and self.curVo.id == vo.id then return end
	self.curVo = vo
	if isshenmi then 
		self.nameLab:setString("神秘人")
		self.lvLab:setString("?")
	else
		self.nameLab:setString(vo.name)
		self.lvLab:setString(vo.lv)
	end
	--todo
    --self.bloodBarClippingRegion:setClippingRegion(self.bloodRect)
    self.hpPrecentLab:setString(vo.hp.."/"..vo.hp_limit)
    
    self.hpbloodRect.width = math.min((vo.hp/vo.hp_limit)*self.hpWidth,self.hpWidth)
    self.hpClippingRegion:setClippingRegion(self.hpbloodRect)

    if self.headId ~= vo.modelID then
        self.headId = vo.modelID
        local url = "icons/tarHead/tarh_"
        if vo.mConf and vo.mConf.type == 3 then
        	url = "icons/tarHead/bh_"..vo.modelID..".png"
        else
        	if vo.type == SceneRoleType.PLAYER then
                url = url..vo.sex..vo.career..".png"
            else
                url = url.."00000"..".png"
            end
        end
        if self.headImage then
            self.headImage:setTexture(url)
        else
        	self.headImage = display.newSprite(url)
        	self.headLay:addChild(self.headImage)
        	self.headImage:setScale(0.8)
        end
    end

    if vo.enmity and vo.enmity.name and vo.enmity.name ~= "" then
        self.heteBg:setVisible(false)
        self.heteLab:setVisible(true)
        self.heteLab:setString("目标:"..vo.enmity.name)
    else
        self.heteBg:setVisible(false)
        self.heteLab:setVisible(false)
    end
end



function TargetHead:seekNodeByName(name)
	return cc.uiloader:seekNodeByName(self.root, name)
end

return TargetHead
