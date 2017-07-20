--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-13 16:20:25
-- GVG复活
local GvgFuhuoWin = class("GvgFuhuoWin", BaseView)
function GvgFuhuoWin:ctor(winTag,data,winconfig)
	self.data = data
    self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    self.bg:setContentSize(display.width, display.height)
    self:addChild(self.bg)
    GvgFuhuoWin.super.ctor(self,winTag,data,winconfig)
    self.root:setPosition((display.width-960)/2,(display.height-640)/2)

    self.name = self:seekNodeByName("name")
    self.times = self:seekNodeByName("times")
    self.cutTimeLab = cc.LabelAtlas:_create()
    self.cutTimeLab:initWithString(
              "",
              "fonts/reviveFont_0.png",
              50,
              64,
              string.byte(0))
    self.cutTimeLab:setTouchEnabled(false)
    self.root:addChild(self.cutTimeLab)
    --self.lvLab:setColor(cc.c3b(73, 73, 73))
    self.cutTimeLab:setPosition(480,320)
    self.cutTimeLab:setAnchorPoint(0.5,0.5)

    self.reviveBtn = self:seekNodeByName("reviveBtn")
    self.reviveBtn:setTouchEnabled(true)
    self.reviveBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.reviveBtn:setScale(1.1)
        elseif event.name == "ended" then
            self.reviveBtn:setScale(1)
            self:onResurgeClick(2)
        end
        return true
    end)

    self.curtime = 15
    self.cutTimeLab:setString(self.curtime)
    self.name:setString(self.data.caster_name)
    self.times:setString(self.data.fh_vip_num)
end

function GvgFuhuoWin:onResurgeClick(ctype,isClick)
    local function enterFun()
        FightModel.isRelive = true
        GameNet:sendMsgToSocket(10005, {type = ctype})
        GlobalWinManger:closeWin(self.winTag)
    end

    if ctype == 2 then
        local bagManager = BagManager:getInstance()
        local goodsNum = bagManager:findItemCountByItemId(110054)
        local numScale = 1
        if self.data.fh_vip_num > 0 then
            enterFun()
            return
        elseif goodsNum > 1*numScale or RoleManager:getInstance().wealth.jade > 50*numScale then
            enterFun()
            return
        else
            GlobalMessage:show("你不能原地复活，缺少复活丹或元宝不够")
            return
        end
    elseif ctype == 1 then
        -- if GameSceneModel.isInterService and isClick == true then
        --     GlobalMessage:alert({
        --       enterTxt = "确定",
        --       backTxt= "取消",
        --       tipTxt = "选择安全区复活会回到本服土城，需要重新消耗门票才能进入2，3层地图，是否如此？",
        --       enterFun = enterFun,
        --       tipShowMid = true
        --     })
        -- else
        --   enterFun()
        -- end
        enterFun()
    else
        enterFun()
    end
  	-- FightModel.isRelive = true
  	-- GameNet:sendMsgToSocket(10005, {type = ctype})
  	-- --<Param name="type" type="int8" describe="复活类型: 1 复活点复活, 2 原地复活"/>
    --  GlobalWinManger:closeWin(self.winTag)
end

function GvgFuhuoWin:open()
    GvgFuhuoWin.super.open(self)
    local listenerFun =  function()
    		self.curtime = self.curtime -1
    		if self.curtime <= 0 then
    			if self.scheduleTimeId then
					GlobalTimer.unscheduleGlobal(self.scheduleTimeId)
					self.scheduleTimeId = nil
				end
    			self:onResurgeClick(1,false)
    		else
    			self.cutTimeLab:setString(self.curtime)
            	--fhLbl:setPosition(timeLbl:getPositionX() + timeLbl:getContentSize().width/2 + fhLbl:getContentSize().width/2 + 2,timeLbl:getPositionY())
    		end
  	end
    if self.scheduleTimeId == nil then
  		  self.scheduleTimeId =  GlobalTimer.scheduleGlobal(listenerFun,1)
  	end
    -- GameNet:sendMsgToSocket(35004,{last_id = 0})
end


function GvgFuhuoWin:close()
    
    GvgFuhuoWin.super.close(self)
    if self.scheduleTimeId then
		GlobalTimer.unscheduleGlobal(self.scheduleTimeId)
		self.scheduleTimeId = nil
	end
end


--清理界面
function GvgFuhuoWin:destory()
    self:close()
	GvgFuhuoWin.super.destory(self)
end

return GvgFuhuoWin
