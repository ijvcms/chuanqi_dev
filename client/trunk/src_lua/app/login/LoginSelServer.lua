--
-- Author: Allen    21102585@qq.com
-- Date: 2017-04-26 19:28:23
-- 选服界面
local LoginSelServer = class("LoginSelServer", function()
	return display.newNode()
end)

local SelServerItem = class("SelServerItem", function()
    return display.newNode()
end)

function SelServerItem:ctor(param)
    self.data = param
    self.states = param.state or 0
    self.tips = param.name or ""
    self.bgPic = display.newSprite("#login/login_serverBtn2.png")
    self.bgPic:setAnchorPoint(0,0.5)
    self:addChild(self.bgPic)
    --self.bgPic:setVisible(false)
    self.statesIcon = display.newSprite()
    self:addChild(self.statesIcon)
    self.statesIcon:setPosition(20,-2)

    self.label = display.newTTFLabel({
        text = "",
        size = 28,
        color = cc.c3b(238, 228, 208),
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
        --dimensions = cc.size(400, 200)
    })
    self.label:setAnchorPoint(0,0.5)
    self.label:setPosition(38,0)
    self:addChild(self.label)
    self.label:setString(self.tips)
    self:setStates()
    --self.bgPic:setOpacity(180)
end
function SelServerItem:setData(param)
    self.data = param
    self.states = param.state or 0
    self.tips = param.name or ""
    self.label:setString(self.tips)
    self:setStates()
end
function SelServerItem:setStates()
    if self.states == 0 then
        self.statesIcon:setSpriteFrame("login/login_statusGrag.png")
        self.label:setColor(cc.c3b(136, 136, 136))
    elseif self.states == 1 then
        self.statesIcon:setSpriteFrame("login/login_statusRed.png")
        self.label:setColor(cc.c3b(238, 228, 208))
    elseif self.states == 2 then  
        self.statesIcon:setSpriteFrame("login/login_statusGreen.png")
        self.label:setColor(cc.c3b(238, 228, 208))
    end
end

function SelServerItem:setSelect(b)
    self.select = b
    if b then
    	self.bgPic:setSpriteFrame("login/login_serverBtnSel2.png")
    else
    	self.bgPic:setSpriteFrame("login/login_serverBtn2.png")
    end
    --self.bgPic:setVisible(b)
end

--选区组Item
local ServerGroupItem = class("ServerGroupItem", function()
    return display.newNode()
end)

function ServerGroupItem:ctor(param)
    self.data = param
    self.bgSelect = display.newSprite("#login/login_serverBtnsel.png")
    self:addChild(self.bgSelect)
    self.bg = display.newSprite("#login/login_serverBtn.png")
    self:addChild(self.bg)

    self.label = display.newTTFLabel({
            text = "服务器",
            --font = "Arial",
            size = 24,
            color = cc.c3b(238, 228, 208), -- 使用纯红色
            align = cc.TEXT_ALIGNMENT_LEFT,
            valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
            --dimensions = cc.size(400, 200)
    })
    self.label:setPosition(0,0)
    self:addChild(self.label)
   
    self:setTouchEnabled(true)
end

function ServerGroupItem:setData(page,lab)
    self.page = page
    self.label:setString(lab)
end

function ServerGroupItem:setSelect(b)
    self.select = b
    if self.select then
        self.bgSelect:setVisible(true)
        self.bg:setVisible(false)
    else
        self.bgSelect:setVisible(false)
        self.bg:setVisible(true)
    end
end



function LoginSelServer:ctor(serverCount,serverList,parent)
    self.parent = parent
	self.serverCount = serverCount
	self.serverList = serverList
	self.selServerBtn = nil
	self.selGroupBtn = nil


	self.bbg =  cc.LayerColor:create(cc.c4b(61,40,30,150))
    self.bbg:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addChild(self.bbg)

    self.pageNum = 10
    self.curGType = 0

	local ww = 666
    local hh = 460+54

    self.bg = display.newScale9Sprite("#login/login_bg1.png", 0, 0,cc.size(ww,hh))
    self:addChild(self.bg)
    self.bg:setAnchorPoint(0,0)
    self.bg:setPosition((display.width-ww)/2 ,(display.height-hh)/2)

    self.bg:setOpacity(200)

    self.btnListBg = display.newScale9Sprite("#login/login_selServerBg.png", 0, 0,cc.size(460,380))
    self.bg:addChild(self.btnListBg)
    self.btnListBg:setAnchorPoint(0,0)
    self.btnListBg:setPosition(196 ,20+54)

    self.groupListBg = display.newScale9Sprite("#login/login_selServerBg.png", 0, 0,cc.size(180,380))
    self.bg:addChild(self.groupListBg)
    self.groupListBg:setAnchorPoint(0,0)
    self.groupListBg:setPosition(10 ,20+54)

    self.titleLab = display.newTTFLabel({text = "选择服务器",
        size = 24,color = cc.c3b(238, 196,142)})
            :align(display.CENTER,0,0)
            :addTo(self.bg)
    self.titleLab:setPosition(ww/2,hh-28)

 	--右边服务器按钮列表
    self.serverBtnCache = {}
    for i=1,10 do
        local item = SelServerItem.new({})
        self.btnListBg:addChild(item)
        item:setPosition(math.floor((i-1)%2)*222+13,334 - math.floor((i-1)/2)*72)
        self.serverBtnCache[i] = item
        item:setTouchEnabled(true)
      	item:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            SoundManager:playClickSound()
	            
	        elseif event.name == "ended" then
	        	if self.selServerBtn then
			        self.selServerBtn:setSelect(false)
			    end
			    self.selServerBtn = item
			    self.selServerBtn:setSelect(true)

	            GlobalModel.selServerInfo = item.data
	            GlobalModel.curServerId = item.data.service_id
	        end  
	        return true
	    end)
    end

    --左边服务组按钮

    --登录过的
    self.loginBtn = ServerGroupItem.new()
    self.loginBtn:setData(-2,"已登区服")
    self.groupListBg:addChild(self.loginBtn)
    self.loginBtn:setPosition(90,341)
   	self.loginBtn:setTouchEnabled(true)
    self.loginBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
        if event.name == "began" then
        	SoundManager:playClickSound()
        elseif event.name == "ended" then
        	if self.loginBtn.select then return end
        	self:onGroupListClick(1)
        end
        return true
    end)
    --推荐区
    self.tujianBtn = ServerGroupItem.new()
    self.tujianBtn:setData(-1,"推荐区服")
    self.groupListBg:addChild(self.tujianBtn)
    self.tujianBtn:setPosition(90,341-74+4)
    self.tujianBtn:setTouchEnabled(true)
    self.tujianBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                SoundManager:playClickSound()
            elseif event.name == "ended" then
            	if self.tujianBtn.select then return end
            	self:onGroupListClick(2)
            end  
            return true
        end)


    local function leftServerListTouchListener(event)
        local listView = event.listView
        if "began" == event.name then
            
        end
        if "clicked" == event.name then
        	SoundManager:playClickSound()
        	if self.groupBtnCache[event.itemPos].select then return end
        	self:onGroupListClick(3,event.itemPos)
        end
    end 
    --区列表
    self.serverGroupListView = cc.ui.UIListView.new {
        viewRect = cc.rect(0, 4, 180,231),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        }
        :onTouch(leftServerListTouchListener)
        :addTo(self.groupListBg)
    self.serverGroupListView:setPosition(0,0)
    self.groupBtnCache = {}
    --初始化区列表
    for i=math.ceil(self.serverCount/self.pageNum),1,-1 do
        local item = self.serverGroupListView:newItem()
        local groupBtn = ServerGroupItem.new()
        groupBtn:setSelect(false)
        groupBtn:setTouchEnabled(false)
        groupBtn:setData(i,((i-1)*self.pageNum+1).."-"..math.min((i*self.pageNum),self.serverCount).."服")
        table.insert(self.groupBtnCache,groupBtn)
        item:addContent(groupBtn)
        item:setItemSize(174, 68+0)
        self.serverGroupListView:addItem(item)
    end
    self.serverGroupListView:reload()

    --已登陆服务器数组
    self.loginInServerList = {}
    for i=1,#GlobalModel.loginServerList do
        for k,v in pairs(GlobalModel.serverList) do
            if v.service_id == GlobalModel.loginServerList[i] then
                table.insert(self.loginInServerList,v)
            end
        end
    end

    --当前列表页数
    self.cupServerListPage = math.ceil(self.serverCount/self.pageNum)

    --默认选中已登陆，如果没有已登陆，则选择推荐
    if #self.loginInServerList >0 then
	    self:onGroupListClick(1)
	else
		self:onGroupListClick(2)
	end

	self.enterBtn = display.newSprite("common/com_PicBtnY1.png")
    self.enterBtn:setTouchEnabled(true)	
    self.bg:addChild(self.enterBtn)
    self.enterBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then            	
                self.enterBtn:setScale(1.1)
            elseif event.name == "ended" then            	
                self.enterBtn:setScale(1)
                self:close()
                GlobalEventSystem:dispatchEvent(LoginEvent.LOGIN_SHOW_ENTER)
            end
            return true
        end)
    local enterLab = display.newTTFLabel({
        	text = "确定",    	
        	size = 22,
        	color = cc.c3b(238, 196,142), 
   	})
    --display.setLabelFilter(enterLab)
    enterLab:setTouchEnabled(false)	
    enterLab:setPosition(69,30)
    self.enterBtn:addChild(enterLab)
    self.enterBtn:setPosition(ww+23 - 100,38)
end

--服务器组点击事件
function LoginSelServer:onGroupListClick(gtype,itemPos)
	local newGroupBtn = nil
	local serverList = {}
	if gtype == 1 then
	
	    newGroupBtn = self.loginBtn
	    for k=1,#self.serverBtnCache do
	        self.serverBtnCache[k]:setVisible(false)
	        self.serverBtnCache[k]:setSelect(false)
	    end
	    if self.selServerBtn then
	        self.selServerBtn:setSelect(false)
	    end
	    for j=1,math.min(#self.loginInServerList,10),1 do
	        local datas = self.loginInServerList[j]
	        local itemView = self.serverBtnCache[j]
	        itemView:setData(datas)
	        itemView:setVisible(true)
	        if GlobalModel.curServerId == datas.service_id then
	            itemView:setSelect(true)
	            self.selServerBtn = itemView
	        end
	    end
	elseif gtype == 2 then
    	newGroupBtn = self.tujianBtn
        local data = GlobalModel.serverList[#GlobalModel.serverList]
     	for j=1,10,1 do
	        local itemView = self.serverBtnCache[j]
	        if j == 1 then
		        itemView:setData(data)
		        itemView:setVisible(true)
		    else
		    	itemView:setVisible(false)
		    	itemView:setSelect(false)
		    end
	        if GlobalModel.curServerId == data.service_id then
	            itemView:setSelect(true)
	            self.selServerBtn = itemView
	        end
	    end
            -- GlobalModel.selServerInfo = data
            -- GlobalModel.curServerId = data.service_id
            -- if self.selServerBtn then
            --     self.selServerBtn:setSelect(false)
            --end
	elseif gtype == 3 then
		newGroupBtn = self.groupBtnCache[itemPos]
        local pageIndex = math.ceil(self.serverCount/self.pageNum)- itemPos+1
        local i = pageIndex
       -- if self.cupServerListPage ~= i then
       --     self.cupServerListPage = i
        local beginIndex = (i-1)*self.pageNum+1
        local endIndex = math.min((i*self.pageNum),self.serverCount)
        for k=1,#self.serverBtnCache do
            self.serverBtnCache[k]:setVisible(false)
            self.serverBtnCache[k]:setSelect(false)
        end
         if self.selServerBtn then
            self.selServerBtn:setSelect(false)
        end
        local count = 1
        for j=endIndex,beginIndex,-1 do
            local datas = GlobalModel.serverList[j]
            local itemView = self.serverBtnCache[count]
            count = count +1
            itemView:setData(datas)
            itemView:setVisible(true)
            if GlobalModel.curServerId == datas.service_id then
                itemView:setSelect(true)
                self.selServerBtn = itemView
            end
        end
       -- end
	end

	if newGroupBtn then
		if self.selGroupBtn then
	        self.selGroupBtn:setSelect(false)
	    end
	    self.selGroupBtn = newGroupBtn
		self.selGroupBtn:setSelect(true)
	end
end

function LoginSelServer:open()
	 self:setVisible(true)
end

function LoginSelServer:close()
	 self:setVisible(false)
end

function LoginSelServer:destory()
	
end

return LoginSelServer
