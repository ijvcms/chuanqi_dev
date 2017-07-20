--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-06-30 09:35:39
-- 提示窗口
local AlertTips = AlertTips or class("AlertTips", function()
	return display.newNode()
end)


function AlertTips:ctor(param)
	self.width = param.width or 550
	self.height = param.height or 320
	self.enterTxt = param.enterTxt or "确定"
	self.backTxt = param.backTxt or "返回"
	self.tipTxt = param.tipTxt or ""
	self.enterFun = param.enterFun
	self.backFun = param.backFun
    self.titleTxt = param.title or "提示"
    self.tipShowMid = param.tipShowMid or false
    self.hideBackBtn = param.hideBackBtn or false
    self.hideCloseBtn = param.hideCloseBtn or false

	self.bg =  cc.LayerColor:create(cc.c4b(0,0,0,100))
    --self.bg:setOpacity(255*0.8)
    self.bg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bg)

    --文本
    self.tipsLab = display.newTTFLabel({text = self.tipTxt,
        size = 18,color = UiColorType.ALERT_TIPS--[[,dimensions = cc.size(self.txtBg:getContentSize().width-10, 0)--]]})
            :align(display.LEFT_TOP,0,0)
            --:addTo(self)
    self.tipsLab:setDimensions(self.width-32,0)
    -- if self.tipsLab:getContentSize().width > self.width-32 then
    --     self.tipsLab:setDimensions(self.width-32,0)
    -- end
    local checkboxH = 60
    local top1H = 52
    local top2H = 10
    local but1H = 100
    local but2H = 10
    local leftW = 14
    local leftW2 = 10
    local tipsSize = self.tipsLab:getContentSize()
    local miniH = math.max(tipsSize.height+top1H + top2H + but2H + but1H,self.height)
    self.hideBackBtn = false
    if param.checkbox then
        miniH = miniH + checkboxH
    end
    self.height = miniH
    -- top 52 10
    --button 100 10
    --背景
    self.tipsLab:setPosition(leftW +leftW2,self.height - top1H - top2H - tipsSize.height)
	self.tipsBg = display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(self.width, self.height),cc.rect(62, 60,1, 1))
    --display.newScale9Sprite("#com_panelBg2.png", 0, 0, cc.size(self.width, self.height))
    --self.tipsBg:setAnchorPoint(cc.p(0, 0))
    self.tipsBg:setPosition((display.width)/2,(display.height)/2)
    self:addChild(self.tipsBg)
    --标题背景
    local titalBg = display.newScale9Sprite("#com_alertTitleBg.png", 0, 0, cc.size(199, 30),cc.rect(30, 15,1, 1))
    --self.txtBg:setAnchorPoint(cc.p(0, 0))
    titalBg:setPosition(self.width/2,self.height-26)
    self.tipsBg:addChild(titalBg)
    --提示背景
    self.txtBg = display.newScale9Sprite("#com_viewBg2.png", 0, 0, cc.size(self.width-(leftW*2), self.height -top1H - but1H))
    --self.txtBg:setAnchorPoint(cc.p(0, 0))
    self.txtBg:setPosition(self.width/2,(self.height -top1H + but1H)/2)
    self.tipsBg:addChild(self.txtBg)
    --关闭按钮
    if self.hideCloseBtn == false then
        self.closeBtn = display.newSprite("#com_closeBtn1.png")
        self.closeBtn:setTouchEnabled(true)  
        self.closeBtn:setPosition(self.width - 28,self.height-28)
        self.tipsBg:addChild(self.closeBtn)
        self.closeBtn:setScale(1)
        self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)          
                if event.name == "began" then               
                    self.closeBtn:setScale(1.1)
                elseif event.name == "ended" then               
                    self.closeBtn:setScale(1)
                    self:close()
                end
                return true
            end)
    end
    --确定按钮
    self.enterBtn = display.newSprite("#com_labBtn2.png")
    -- self.enterBtn:setColor(cc.c3b(217, 108, 87))
    self.enterBtn:setTouchEnabled(true) 
    self.tipsBg:addChild(self.enterBtn)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)     
            if event.name == "began" then               
                self.enterBtn:setScale(1.1)
            elseif event.name == "ended" then               
                self.enterBtn:setScale(1)
                if self.enterFun then
                    self.enterFun()
                end
                self:close()
            end
            return true
        end)
    local enterLab = display.newTTFLabel({
            text = self.enterTxt,       
            size = 24,
            color = UiColorType.BTN_LAB1,
    })
    --display.setLabelFilter(enterLab)
    enterLab:setTouchEnabled(false) 
    enterLab:setPosition(69,27)
    self.enterBtn:addChild(enterLab)
    self.enterBtn:setPosition(self.width - 100,52)
    --返回按钮
    if self.hideBackBtn == false then
        self.backBtn = display.newSprite("#com_labBtn2.png") 
        -- self.backBtn:setColor(cc.c3b(124, 207, 125))     
        self.backBtn:setTouchEnabled(true)  
        self.tipsBg:addChild(self.backBtn)
        self.backBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)          
                if event.name == "began" then               
                    self.backBtn:setScale(1.1)
                elseif event.name == "ended" then               
                    self.backBtn:setScale(1)
                    if self.backFun then
                        self.backFun()
                    end
                    self:close()
                end
                return true
            end)
        local backLab = display.newTTFLabel({
                text = self.backTxt,        
                size = 24,
                color = UiColorType.BTN_LAB1,
        })
        --display.setLabelFilter(backLab)
        backLab:setTouchEnabled(false)  
        backLab:setPosition(69,27)
        self.backBtn:addChild(backLab)
        self.backBtn:setPosition(self.width - 100,52)
    end
    if self.hideBackBtn then
    else
        self.backBtn:setPosition(100,52)
    end

    --标题文本
    self.titleLab = display.newTTFLabel({text = self.titleTxt,
        size = 24,color = UiColorType.ALERT_TITLE})
            :align(display.CENTER,0,0)
            :addTo(self.tipsBg)
    self.titleLab:setPosition(self.width/2,self.height-26)
    --display.setLabelFilter(self.titleLab)

    self.tipsBg:addChild(self.tipsLab)
    self.tipsLab:setPosition(leftW +leftW2,self.height - top1H - top2H)

    if param.checkbox then
        local ckParams = param.checkbox
        local ww = self.width - leftW- leftW - leftW2 -leftW2
        self:creatCheckBox(ckParams.text, cc.p(leftW +leftW2+ww/2,but1H+checkboxH), ww,ckParams.callback)
    end
end

--
--@test:checkbox显示的文字
--@pos:checkbox显示的位置
--@callback:checkbox的点击事件
--
function AlertTips:creatCheckBox(text, pos,ww,callback)
    local checkLine = display.newScale9Sprite("#com_uiLine1.png", 0, 0, cc.size(ww, 2))
    self.tipsBg:addChild(checkLine)

    local chkBtn = display.newSprite("#com_chkBtn1.png")
    self.tipsBg:addChild(chkBtn)
    self.checkPic = display.newSprite("#com_chkBtn1Sel.png")
    chkBtn:addChild(self.checkPic)
    self.checkPic:setVisible(false)
    self.checkPic:setAnchorPoint(0, 0)
    chkBtn:setAnchorPoint(0, 0.5)
    chkBtn:setTouchEnabled(true)
    chkBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)      
        if event.name == "ended" then               
            self.checkPic:setVisible(not self.checkPic:isVisible())     
            if callback then
                callback(self.checkPic:isVisible())
            end   
        end
        return true
    end)        
    local checkBoxLab = display.newTTFLabel({text = text,
        size = 20,color = UiColorType.LAB_W})
    checkBoxLab:setAnchorPoint(0, 0.5)
    self.tipsBg:addChild(checkBoxLab)

    checkLine:setPosition(pos.x,pos.y)
    chkBtn:setPosition(pos.x - ww/2+30, pos.y-26)
    checkBoxLab:setPosition(pos.x+40- ww/2+30, pos.y-26)
end


function AlertTips:show(tips)
	self.tipsLab:setString(tips)
end

function AlertTips:close()
    local parent = self:getParent()
    if parent ~= nil then
        parent:removeChild(self)
    end 

    self.enterFun = nil
    self.backFun = nil
end

return AlertTips