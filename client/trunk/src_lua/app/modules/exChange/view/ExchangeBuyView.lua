--
-- Author: Yi hanneng
-- Date: 2016-02-25 11:46:00
--

--[[
	交易所－－－购买
--]]
 
local ExchangeBuyTipView = import(".ExchangeBuyTipView")
require("app.modules.exChange.model.ExChangeManager")

local ExchangeBuyView = ExchangeBuyView or class("ExchangeBuyView", BaseView)

function ExchangeBuyView:ctor(winTag,data,winconfig)
	self.ccui = cc.uiloader:load("resui/exchangeBuyWin.ExportJson")
  	self:addChild(self.ccui)
   	
   	self:init()
   	self:setNodeEventEnabled(true)
end

function ExchangeBuyView:init()
  
	self.totalNum = 0
	self.currentSortType = SORT_TYPE.SORT_DOWN
	 
	self.inputField = cc.uiloader:seekNodeByName(self.ccui, "inputField")
	self.searchBtn = cc.uiloader:seekNodeByName(self.ccui, "searchBtn")
	self.helpBtn = cc.uiloader:seekNodeByName(self.ccui, "helpBtn")
	self.bg = cc.uiloader:seekNodeByName(self.ccui, "bg")
	self.amountLabel = cc.uiloader:seekNodeByName(self.ccui, "amountLabel")
	self.buyBtn = cc.uiloader:seekNodeByName(self.ccui, "buyBtn")
	self.arrow = cc.uiloader:seekNodeByName(self.ccui, "arrow")

	self.inputLab = cc.ui.UIInput.new({
          UIInputType = 1,
          size = cc.size(150, 30),
          --listener = onEdit,
          image = "common/input_opacity1Bg.png",
          align = cc.TEXT_ALIGNMENT_CENTER,
          --dimensions = cc.size(self:getContentSize().width, self:getContentSize().height)
        })
	self.inputLab:setPlaceHolder("输入文字搜索")
	self.ccui:addChild(self.inputLab)
	self.inputLab:setPosition(self.inputField:getPositionX() + 60, self.inputField:getPositionY())
	self.inputLab:setMaxLength(7)

	self.menuListView = CQMenuList.new(cc.rect(0,0,230, 380),cc.ui.UIScrollView.DIRECTION_VERTICAL,230,60)
	self.ccui:addChild(self.menuListView)
	self.menuListView:setPosition(42 - 54, 470-80 - self.menuListView:getContentSize().height)
	self.menuListView:setItemClickFunc(handler(self, self.itemClick))
	self.menuListView:setMenuItemClickFunc(handler(self, self.itemClick))
 
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, self.bg:getContentSize().width - 4, self.bg:getContentSize().height - 10)}
    self.saleListView = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.saleListViewAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/exchangeBuyItem.ExportJson", "app.modules.exChange.view.ExchangeBuyItem", 20)
    self.saleListView:setAdapter(self.saleListViewAdapter)
	self.bg:addChild(self.saleListView)
	self.saleListView:setPosition(1, 5)
	self.saleListView:onTouch(handler(self, self.saleItemClick))
	self.saleListViewAdapter:setRequestDataFunc(handler(self,self.load))

	self.searchBtn:setTouchEnabled(true)
	self.helpBtn:setTouchEnabled(true)
	self.buyBtn:setTouchEnabled(true)
	self.arrow:setTouchEnabled(true)

	self.arrow:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then

	        	if self.currentSortType == SORT_TYPE.SORT_UP then
	     			self.arrow:setScale(-1.1)
	            elseif self.currentSortType == SORT_TYPE.SORT_DOWN then
	 				self.arrow:setScale(1.1)
	            end
	           
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.arrow:setScale(1.0)
	            if self.currentSortType == SORT_TYPE.SORT_NONE or self.currentSortType == SORT_TYPE.SORT_UP then
	            	self.arrow:setScaleY(1)
	            	self.currentSortType = SORT_TYPE.SORT_DOWN
	            elseif self.currentSortType == SORT_TYPE.SORT_DOWN then
	            	self.arrow:setScaleY(-1)
	            	self.currentSortType = SORT_TYPE.SORT_UP
	            end
	            self.currentClickItem = nil
	            self.currentClickData = nil
				self.saleListViewAdapter:clearData()
				self:sendData(1)
	        end     
	        return true
    end)

	self.searchBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.searchBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.searchBtn:setScale(1.0)
	            
	            self:search()
	        end     
	        return true
    end)


	self.helpBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "began" then
		            self.helpBtn:setScale(1.1)
		            SoundManager:playClickSound()
		        elseif event.name == "ended" then
		            self.helpBtn:setScale(1.0)

		            local function enterFun()
 
					end
 	           
					GlobalMessage:alert({
						enterTxt = "确定",
						backTxt= "取消",
						tipTxt = configHelper:getRuleByKey(4),
						enterFun = handler(self, enterFun),
						tipShowMid = true,
						hideBackBtn = true,
					})
		            
		        end     
		        return true
    end)


	self.buyBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		        if event.name == "began" then
		            self.buyBtn:setScale(1.1)
		            SoundManager:playClickSound()
		        elseif event.name == "ended" then
		            self.buyBtn:setScale(1.0)
		          
		            if self.currentClickItem == nil then
		            	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"请选择需要购买的物品！")
		            	return
		            end
		            local dialog = ExchangeBuyTipView.new()
			 		dialog:setData(self.currentClickData,handler(self, self.buy))
					GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX, dialog)
		        end     
		        return true
    end)

 
	self:createMenu()
	
end

function ExchangeBuyView:createMenu()
	local data = ExChangeManager:getInstance():getMenuData()
	self.menuListView:setData(data[1],data[2],require("app.modules.exChange.view.ExchangeMenuItem"))
end

function ExchangeBuyView:initViewInfo()
	self:open()
 	self.inputLab:setText("")
end
--菜单栏点击
function ExchangeBuyView:itemClick(item)

	self.searchStr = ""
	self.isSearch = false

	local str = item:getData().keyName
	local key = item:getData().key
	self.currentKeyName = str
	self.currentKey = key
	self.currentClickItem = nil
	self.currentClickData = nil
	self.saleListViewAdapter:clearData()
	self:sendData(1)

end
--设置加载信息
function ExchangeBuyView:loadViewInfo(data)
	if data == nil then
		return
	end

  	self.totalNum = data.data.num
 	self.amountLabel:setString(data.data.num)
    if self.saleListViewAdapter:getCount() > 0 then
    	self.saleListViewAdapter:addData(data.data.sale_goods_list)
    else
    	self.saleListViewAdapter:setData(data.data.sale_goods_list)
    end
	
end
--出售列表点击
function ExchangeBuyView:saleItemClick(event)
	if "clicked" == event.name then
		--控件是重用，所以需要self.currentClickData
		if self.currentClickItem  and self.currentClickData.sale_id == self.currentClickItem:getData().sale_id then
			self.currentClickItem:setSelect(false)
		elseif self.currentClickData then
			self.currentClickData.selected = false
		end
    	local item = event.item:getChildByTag(11)--UIListViewItem.CONTENT_TAG
        item:setSelect(true)
        self.currentClickItem = item
        self.currentClickData = item:getData()
    end
end

--加载出售分页列表
function ExchangeBuyView:load(next_page)

    if self.saleListViewAdapter:getCount() >= self.totalNum then
    	return
    end
	self:sendData(next_page)
end
--模糊搜索
function ExchangeBuyView:search()
 	self.isSearch = true
 	self.searchStr = self.inputLab:getText()
 	self.currentClickItem = nil
 	self.currentClickData = nil
    self.saleListViewAdapter:clearData()
	self:sendData(1)
end

function ExchangeBuyView:buy(data)
	if data == nil then
		return
	end

	GameNet:sendMsgToSocket(33005, {sale_id = data.sale_id})
end

function ExchangeBuyView:buySuccess(data)
    self.saleListViewAdapter:clearData()
    self.currentClickItem = nil
    self.currentClickData = nil
	self:sendData(1)

end


-- function ExchangeBuyView:hasItemDataById(data)

-- 	if data == nil then
-- 		return false
-- 	end

-- 	if self.itemDataList then
-- 		for i=1,#self.itemDataList do
--  			if self.itemDataList[i].sale_id == data.sale_id then
--  				return false
--  			end
--  		end
-- 	end

-- 	return true
-- end


function ExchangeBuyView:sendData(page)

	if self.isSearch then
		GameNet:sendMsgToSocket(33001, {page = page, name = self.searchStr,order = self.currentSortType})
	else
		if "sort1" ==  self.currentKeyName then
			GameNet:sendMsgToSocket(33000, {page = page, sort1 = self.currentKey,sort2 = 0,sort3 = 0,order = self.currentSortType})
		elseif "sort2" ==  self.currentKeyName then
			GameNet:sendMsgToSocket(33000, {page = page, sort1 = 0,sort2 = self.currentKey,sort3 = 0,order = self.currentSortType})
		elseif "sort3" == self.currentKeyName then
			GameNet:sendMsgToSocket(33000, {page = page, sort1 = 0,sort2 = 0,sort3 = self.currentKey,order = self.currentSortType})
		end
	end
end

function ExchangeBuyView:open()
	self.searchStr = ""
	self.isSearch = false
	self.currentKeyName = "sort1"
	self.currentKey = 0
	GlobalEventSystem:addEventListener(ExChangeEvent.BUYVIEW_INFO,handler(self,self.loadViewInfo))
	GlobalEventSystem:addEventListener(ExChangeEvent.BUY_SUCCESS,handler(self,self.buySuccess))
	self.currentClickItem = nil
 	self.currentClickData = nil
    self.saleListViewAdapter:clearData()
	GameNet:sendMsgToSocket(33000, {page = 1, sort1 = 0,sort2 = 0,sort3 = 0,order = self.currentSortType})
	
	--GlobalEventSystem:addEventListener(BagEvent.STRENG_SUCCESS,handler(self,self.strenSuccess))
end

local function _removeEvent(self)
	GlobalEventSystem:removeEventListener(ExChangeEvent.BUYVIEW_INFO)
	GlobalEventSystem:removeEventListener(ExChangeEvent.BUY_SUCCESS)
end

function ExchangeBuyView:close()
	_removeEvent(self)
	--self.saleListView:onCleanup()
	if self.inputLab then
		self.inputLab:setText("")
	end
	self.searchStr = ""
end


function ExchangeBuyView:destory()
	_removeEvent(self)
	self.super.destory(self)
end
 
return ExchangeBuyView