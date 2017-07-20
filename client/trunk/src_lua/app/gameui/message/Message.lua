--
-- Author: 21102585@qq.com
-- Date: 2014-11-07 14:56:54
--
-- local Message = class("Message", function()
-- 	return display.newNode()
-- end)

local Message = class("Message")

function Message:ctor( )
	self.showNum = 0
end


--文字消息提示
--@param string str 提示文字
--@return 
--用法：GlobalMessage:show("你好，我是消息提示信息")
function Message:show(str,position)	
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,str)
    if true then return end
	local fontsize = 24
	local fwidth = 400
	local sizeOffset = 2
    local pp = position
    if pp == nil then
        pp = cc.p(display.cx,display.cy-200)
    end    
    pp = cc.p(display.cx,display.cy)
	local node = display.newNode()
    local midLayer = cc.LayerColor:create(cc.c4b(0,0,0,120))
    midLayer:setContentSize(500,42)
    --self.midLayer:setPosition(-contentSize.width/2,-contentSize.height/2)
    midLayer:setPosition(-300,-21)
    node:addChild(midLayer)


	-- local label4 = cc.ui.UILabel.new({text = str, size = fontsize, color = display.COLOR_BLACK})
 --        :align(display.CENTER_TOP,0,0)
 --    	:pos(pp.x-sizeOffset, pp.y)
 --    	--label4:setWidth(fwidth)
 --    local label3 = cc.ui.UILabel.new({text = str, size = fontsize, color = display.COLOR_BLACK})
 --        :align(display.CENTER_TOP,0,0)
 --    	:pos(pp.x+sizeOffset, pp.y)
 --    	--label3:setWidth(fwidth)
 --    local label2 = cc.ui.UILabel.new({text = str, size = fontsize, color = display.COLOR_BLACK})
 --        :align(display.CENTER_TOP,0,0)
 --    	:pos(pp.x, pp.y+sizeOffset)
 --    	--label2:setWidth(fwidth)

	-- local label1 = cc.ui.UILabel.new({text = str, size = fontsize, color = display.COLOR_BLACK})
 --        :align(display.CENTER_TOP,0,0)
 --    	:pos(pp.x, pp.y-sizeOffset)
 --    	--label1:setWidth(fwidth)
 --    	--label:enableShadow(cc.size(2,-2),0.5,1,true)
 --    	-- label:enableOutline(cc.c4b(1,1,0,1),3)
 --    	-- label:enableGlow(cc.c4b(1,1,0,1))

    local label = cc.ui.UILabel.new({text = str, size = fontsize, color = display.COLOR_RED})
        :align(display.CENTER,0,0)
    	--:pos(pp.x, pp.y)
    	--label:setContentSize(cc.size(50,200))
    	--label:setWidth(fwidth)
    	--label:enableShadow(cc.size(2,-2),0.5,1,true)
    	-- label:enableOutline(cc.c4b(1,1,0,1),3)
    	-- label:enableGlow(cc.c4b(1,1,0,1))	

    	-- node:addChild(label1)
    	-- node:addChild(label2)
    	-- node:addChild(label3)
    	-- node:addChild(label4)
    node:addChild(label)	
    node:setPosition(pp.x, pp.y)
    
   -- node:pos(math.random()*320,math.random()*200)	

    --transition.execute(node, cc.MoveTo:create(0.5, cc.p(display.cx, display.cy+50)), {
    local ac1 = function()
        local sequence = transition.sequence({
            cc.MoveTo:create(0.5, cc.p(pp.x, pp.y+150-(self.showNum-1)*45)),
            cc.DelayTime:create(0.5),
            cc.FadeOut:create(0.3),
            cc.CallFunc:create(function()
                self.showNum = math.max(0,self.showNum-1)
                local pare = node:getParent()
                if pare ~= nil then
                    pare:removeChild(node)
                end
            end),
        })
        return sequence
    end

    node:runAction(ac1())

 --    transition.execute(node, cc.MoveTo:create(0.4, cc.p(0, 0+120)), {
 --    delay = 0.0,
 --    easing = "backout",
 --    onComplete = function()
 --       local pare = node:getParent()
 --       if pare ~= nil then
 --       		showNum = showNum-1
 --       		pare:removeChild(node)
 --       end
 --    end,
	-- })

    -- local sequence = transition.sequence({
    -- cc.MoveTo:create(0.5, cc.p(display.cx, display.cy)),
    -- cc.FadeOut:create(1.2),
    -- cc.DelayTime:create(1.5),
    -- cc.FadeIn:create(1.3),
    -- })
    -- node:runAction(sequence)


	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_MESSAGE,node)
    if node:getParent() then
        self.showNum = math.min(self.showNum + 1,3)
    end
end

-- 使用方法: GlobalMessage:alert({enterTxt = "继续训练",backTxt="退出",tipTxt = "",enterFun = handler(self, enterFun),backFun = handler(self, backFun)})

function Message:alert(param,position)
    local pp = position
    if pp == nil then
        pp = cc.p(0,0)
    end    
   
    local alertTips = require("app.gameui.message.AlertTips").new(param)    
    alertTips:setPosition(pp)
    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,alertTips)
    return alertTips
end	

-- function Message:alert2(param,position)
--     local pp = position
--     if pp == nil then
--         pp = cc.p(0,0)
--     end    
   
--     local alertTips = require("app.gameui.message.AlertTipsII").new(param)
--     alertTips:setPosition(pp)
--     GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,alertTips)
--     return alertTips
-- end

-- function Message:alertTips(data,position)
--     local view = require("app.gameui.message.AlertTipView1").new(data)
--     GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,view)
-- end    

return Message