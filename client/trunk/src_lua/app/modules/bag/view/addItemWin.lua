local addItemWin = class("addItemWin", BaseView)

--构造
function addItemWin:ctor(winTag,data,winconfig)
    addItemWin.super.ctor(self,winTag,data,winconfig)
    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")
    local options = {placeHolder = "请输入物品id",
	    image = "common/input_opacity1Bg.png",
	    UIInputType = 1,
	    width = 290,
	    height = 44,
	    text = "",
	    maxLength = 10,
	    x = 0,y =50,
	    maxLengthEnable = true,
	    passwordEnable = false
	}

	local options1 = {placeHolder = "请输入物品名",
	    image = "common/input_opacity1Bg.png",
	    UIInputType = 1,
	    width = 290,
	    height = 44,
	    text = "",
	    maxLength = 10,
	    x = 0,y =50,
	    maxLengthEnable = true,
	    passwordEnable = false
	}
	local options2 = {placeHolder = "请输入数量",
	    image = "common/input_opacity1Bg.png",
	    UIInputType = 1,
	    width = 290,
	    height = 44,
	    text = "",
	    maxLength = 10,
	    x = 0,y =50,
	    maxLengthEnable = true,
	    passwordEnable = false
	}

  self.bg1 = cc.uiloader:seekNodeByName(win,"bg1")
    self.bg2 = cc.uiloader:seekNodeByName(win,"bg2")
    self.bg3 = cc.uiloader:seekNodeByName(win,"bg3")

    self.idLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(options.width, options.height),
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(290, 44)
        })
    self.idLab:setPlaceHolder(options.placeHolder)
    self.idLab:setFontSize(options.fontSize or 16)
    self.idLab:setText(options.text)
    self.idLab:setAnchorPoint(0,0)
    self.idLab:setPosition(5, 3)
    self.bg1:addChild(self.idLab)
    self.idLab:setColor(cc.c3b(61,61,61))

    self.nameLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(options1.width, options1.height),
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(290, 44)
        })
    self.nameLab:setPlaceHolder(options1.placeHolder)
    self.nameLab:setFontSize(options1.fontSize or 16)
    self.nameLab:setText(options1.text)
    self.nameLab:setAnchorPoint(0,0)
    self.nameLab:setPosition(5, 3)
    self.bg2:addChild(self.nameLab)
    self.nameLab:setColor(cc.c3b(61,61,61))

    self.numLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(options2.width, options2.height),
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          dimensions = cc.size(290, 44)
        })
    self.numLab:setPlaceHolder(options2.placeHolder)
    self.numLab:setFontSize(options2.fontSize or 16)
    self.numLab:setText(options2.text)
    self.numLab:setAnchorPoint(0,0)
    self.numLab:setPosition(5, 3)
    self.bg3:addChild(self.numLab)
    self.numLab:setColor(cc.c3b(61,61,61))

    --确认按钮
    self.btnSure = cc.uiloader:seekNodeByName(win,"btnSure")
    self.btnSure:setTouchEnabled(true)
    self.btnSure:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.btnSure:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.btnSure:setScale(1.0)
            self:onSureClick()
        end     
        return true
    end)

    --确认按钮
    self.closebtn = cc.uiloader:seekNodeByName(win,"closebtn")
    self.closebtn:setTouchEnabled(true)
    self.closebtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.closebtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.closebtn:setScale(1.0)
            GlobalWinManger:closeWin(self.winTag)
        end     
        return true
    end)
    
end

function addItemWin:onSureClick()
	if self.idLab:getText() == "" and self.nameLab:getText() == "" then
		return
	end
	if self.numLab:getText() == "" then
		return
	end

	local id = tonumber(self.idLab:getText())
	local name = self.nameLab:getText()
	local num = tonumber(self.numLab:getText())

	-- local configHelper = import("app.utils.ConfigHelper").getInstance()

	local find = false
	if configHelper.goodsConfig.datas[id] then
		find = true
	end

	if find==false then
		for k,v in pairs(configHelper.goodsConfig.datas) do
			if v[configHelper.goodsConfig.fields[2]] == name then
				id = v[configHelper.goodsConfig.fields[1]]
				find = true
				break
			end
		end
	end
	
	if find == false then
		return
	end

	GameNet:sendMsgToSocket(14003, {goods_id = id,is_bind = 0,num = num})
end

return addItemWin