
local itemTipsWin = require("app.modules.tips.view.itemTipsWin")
local equipTipsWin = require("app.modules.tips.view.equipTipsWin")
local SuperRichText = class("SuperRichText", function()
	return display.newNode()
end)

--字体结构信息
local function newFontInfo(fontName,fontSize,color,opacity)
	local result = {
		--fontName = fontName or "simhei", 			--字体名
		fontSize = fontSize or 20,	 				--字体大小
		color = color or cc.c3b(20,20,20),			--字体颜色
		opacity = opacity or 255, 					--透明度
	}
	return result 
end

--图片结构信息
local function newImgInfo(path,color,opacity,width,height)
	local result = {
		path = path or "", 							--图片资源路径
		color = color or cc.c3b(255,255,255),		--混合颜色
		opacity = opacity or 255,--透明度
		width = width or 33,				--图片宽
		height = height or 33,				--图片宽
	}
	return result 
end

function SuperRichText:reset()
    while #self.labelUICache > 0  do --回收字体控件
    	local ui = table.remove(self.labelUICache)
    	table.insert(self.freeLabelUICache, ui)
    	ui:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    	ui:setTouchEnabled(false)
    	ui:retain()
    	ui:removeFromParent(false)
    end

    while #self.imgUICache > 0 do -- 回收图片控件
    	local ui = table.remove(self.imgUICache)
    	table.insert(self.freeImgUICache, ui)
    	ui:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    	ui:setTouchEnabled(false)
    	ui:retain()
    	ui:removeFromParent(false)
    end

    while #self.lineList >0 do
    	local ui = table.remove(self.lineList)
    	table.insert(self.freeLineList, ui)
    	ui:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)
    	ui:setTouchEnabled(false)
    	ui:retain()
    	ui:removeFromParent(false)
    end

	self.curFontList  = 1   --字体指针,1是默认字体
	self.curEventList = 0
	self.curlineGap = 0
	self.curLine = nil 		--当前行
	--第一行
	self:addNewLine()
end

function SuperRichText:ctor(xmlText, adaptWidth, isEllipsize)
	self:buildCacheData()
	--默认字体
	table.insert(self.fontList,newFontInfo())
	if adaptWidth then
		self.adaptWidth = adaptWidth
	end
	if isEllipsize then
		self.isEllipsize = isEllipsize
	end
	self:setAnchorPoint(0,0)
	if xmlText then
		self:renderXml(xmlText)
	else
		self:reset()
	end
	self:setNodeEventEnabled(true)
end

function SuperRichText:onCleanup()
	for _, ui in ipairs(self.freeLabelUICache) do
		ui:cleanup()
		ui:release()
	end

	for _, ui in ipairs(self.freeImgUICache) do
		ui:cleanup()
		ui:release()
	end

	for _, ui in ipairs(self.freeLineList) do
		ui:cleanup()
		ui:release()
	end
	self.fontList  = nil
	self.eventList = nil
	self.lineGap = nil
	self.curLine = nil 
	self.freeLabelUICache = nil
	self.freeImgUICache = nil
	self.freeLineList = nil
	self.labelUICache = nil
    self.imgUICache = nil 
    self.lineList  = nil
end

function SuperRichText:buildCacheData()
	self.fontList = {} 		--字体列表
	self.curFontList  = 0   --字体指针
	self.eventList = {} 	--事件列表
	self.curEventList = 0
	self.lineList = {} 		--保存所有富文本
	self.lineGap = {} 		--行距
	self.curlineGap = 0
	self.curLine = nil 		--当前行
	self.labelUICache = {}  --文字UI集
    self.imgUICache = {}    --图片UI集
    self.freeLabelUICache = {}  --文字UI缓存
    self.freeImgUICache = {}    --图片UI缓存
    self.freeLineList = {}
end

--重用
function SuperRichText:reuse(xmlText,adaptWidth)
	if adaptWidth then
		self.adaptWidth = adaptWidth
	end
	if xmlText then
		self:renderXml(xmlText)
	else
		self:reset()
	end
end

function SuperRichText:renderXml(xmlString)
	self:reset()
	--解析xml字符串
	local xml = require("app.utils.xmlSimple").newParser() 
	--dump(xmlString)
    local xmlParse = xml:ParseXmlText(xmlString)
    --print("***********")
    local rootNode = xmlParse:children()[1]
    --渲染节点
    self:renderNode(rootNode)
    --渲染完成后,进行位置排列
    self:updateLine()
    
end

--设置是否不换行省略
function SuperRichText:setIsEllipsize(value)
	self.isEllipsize = value
end

-- local function LuaReomve(str,remove)  
--     local lcSubStrTab = {}  
--     while true do  
--         local lcPos = string.find(str,remove)  
--         if not lcPos then  
--             lcSubStrTab[#lcSubStrTab+1] =  str      
--             break  
--         end  
--         local lcSubStr  = string.sub(str,1,lcPos-1)  
--         lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
--         str = string.sub(str,lcPos+1,#str)  
--     end  
--     local lcMergeStr =""  
--     local lci = 1  
--     while true do  
--         if lcSubStrTab[lci] then  
--             lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
--             lci = lci + 1  
--         else   
--             break  
--         end  
--     end  
--     return lcMergeStr  
-- end  


function SuperRichText:renderNode(xmlNode)
	while(xmlNode) do
		local name = string.upper(xmlNode:name())
		if name == "FONT" then 			--字体标签
			-- print("字体标签")
			--遍历所有属性
			local lastFont = self.fontList[self.curFontList]
			local lastEvent = self.eventList[self.curEventList] or {}
			local newFont = newFontInfo(lastFont.fontName,lastFont.fontSize,lastFont.color,lastFont.opacity)
			local eventType = lastEvent[1]
			local eventParam = lastEvent[2] or {}
			for i=1,#xmlNode:properties() do
				local attrName = string.upper(xmlNode:properties()[i].name)
				if attrName == "FACE" then 				--设置字体
					newFont.fontName = xmlNode:properties()[i].value
				elseif attrName == "COLOR" then 		--设置颜色
					newFont.color = DisplayUtil.convertToCCC3(xmlNode:properties()[i].value)
				elseif attrName == "SIZE" then 			--设置大小
					newFont.fontSize = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "OPACITY" then 		--设置不透明度
					newFont.opacity = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "EVENTTYPE" then 	--事件类型
					eventType = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "EVENTPARAM" then 	--事件参数
					eventParam = self:parserEventParam(xmlNode:properties()[i].value)
				end
			end

			if eventType then
				eventParam = self:formatEventParam(eventType, eventParam)
			end

			--移除'\n'和'\r'
			local str = xmlNode:value()
			str = string.gsub(str, "[\n\r]+", "");
			self:handleText(str,newFont,eventType,eventParam)
			--插入字体列表,在子集的渲染中会用到
			self.curFontList = self.curFontList + 1
			self.fontList[self.curFontList] = newFont
			--插入事件列表,在子集中会用到
			if eventType then
				self.curEventList = self.curEventList + 1
				self.eventList[self.curEventList] = {eventType,eventParam}
			end
			--继续渲染子集
			self:renderNode(xmlNode:firstChild())
			--子集渲染完了,从字体列表中移除该字体
			self.curFontList = self.curFontList - 1
			--子集渲染完了,从事件列表中移除事件
			if eventType then
				self.curEventList = self.curEventList - 1
			end
		elseif name == "IMG" then 		--图片标签 
			-- print("图片标签")
			--遍历所有属性
			local imgInfo = newImgInfo()
			local fontInfo = newFontInfo()
			local lastEvent = self.eventList[self.curEventList] or {}
			local eventType = lastEvent[1]
			local eventParam = lastEvent[2] or {}
			local fontString
			for i=1,#xmlNode:properties() do
				local attrName = string.upper(xmlNode:properties()[i].name)
				if attrName == "COLOR" then 				--设置颜色
					imgInfo.color = DisplayUtil.convertToCCC3(xmlNode:properties()[i].value)
				elseif attrName == "OPACITY" then 			--设置不透明度
					imgInfo.opacity = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "PATH" then 				--资源路径
					imgInfo.path = xmlNode:properties()[i].value
				elseif attrName == "WITDH" then 				--资源路径
					imgInfo.width = xmlNode:properties()[i].value
				elseif attrName == "HEIGHT" then 				--资源路径
					imgInfo.height = xmlNode:properties()[i].value
				elseif attrName == "EVENTTYPE" then 		--事件类型
					eventType = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "EVENTPARAM" then 		--事件参数
					eventParam = self:parserEventParam(xmlNode:properties()[i].value)
				elseif attrName == "IMGFONTFACE" then 		--图片上的文字字体
					fontInfo.fontName = xmlNode:properties()[i].value
				elseif attrName == "IMGFONTCOLOR" then 		--图片上的文字的颜色
					fontInfo.color = DisplayUtil.convertToCCC3(xmlNode:properties()[i].value)
				elseif attrName == "IMGFONTSIZE" then 		--图片上的文字的字体大小
					fontInfo.fontSize = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "IMGFONTOPACITY" then 	--图片上的文字的透明度
					fontInfo.opacity = tonumber(xmlNode:properties()[i].value)
				elseif attrName == "IMGFONTSTRING" then 	--图片上的文字内容
					fontString = xmlNode:properties()[i].value
				end
			end
			if eventType then
				eventParam = self:formatEventParam(eventType, eventParam)
			end
			self:handleImg(imgInfo,eventType,eventParam)
		elseif name == "BR" then 		--换行标签
			-- print("换行标签")
			for i=1,#xmlNode:properties() do
				local attrName = string.upper(xmlNode:properties()[i].name)
				if attrName == "GAP" then
					self.curlineGap = self.curlineGap + 1
					--行距
					self.lineGap[self.curlineGap] = xmlNode:properties()[i].value
				end
			end
			self:addNewLine()
		end
		--渲染下一个同级节点
		xmlNode = xmlNode:nextSibling()
	end
end

function SuperRichText:parserEventParam(str)
	local params = {}
	--按分隔符"%%"分割字符串
	function lua_string_split(str, split_char)
	    local sub_str_tab = {};
	    while (true) do
	        local pos = string.find(str, split_char);
	        if (not pos) then
	            sub_str_tab[#sub_str_tab + 1] = str;
	            break;
	        end
	        local sub_str = string.sub(str, 1, pos - 1);
	        sub_str_tab[#sub_str_tab + 1] = sub_str;
	        str = string.sub(str, pos + 1, #str);
	    end

	    return sub_str_tab;
	end
	local kvs = lua_string_split(str,"%%")

	for i=1,#kvs do
		--按"="号取key value对
		if kvs[i]~="" then
			local kv = lua_string_split(kvs[i],"=")
			if kv[1] then
				params[kv[1]] = kv[2]
			end
		end
	end
 
	return params
end

local EventDefaultParam = {
	[1] = { 			--聊天点击玩家名字
		player_id = {eType = "number" ,default = 0},
		player_name = {eType = "string" ,default = ""},
		teamId = {eType = "number" ,default = 0},
		guild_id = {eType = "number" ,default = 0},
	},
	--(Quality,goods_id,is_bind,location,stren_lv,finghting,name)
	[2] = { 		
		goods_id = {eType = "number" ,default = 0},
		is_bind  = {eType = "number" ,default = 0},
		location  = {eType = "number" ,default = 0},
		stren_lv  = {eType = "number" ,default = 0},
		finghting  = {eType = "number" ,default = 0},
		name = {eType = "string" ,default = ""},
	},
	[3] = { 		
		teamId = {eType = "number" ,default = 0},
	}

}

	


function SuperRichText:formatEventParam(eventType,eventParams)
	 
	for k,v in pairs(EventDefaultParam[eventType]) do

		if not eventParams[k] then
			eventParams[k] = v.default
		else
			eventParams[k] = v.eType=="number" and tonumber(eventParams[k]) or eventParams[k]
		end
	end
	return eventParams
end

function SuperRichText:handleImg(imgInfo,eventType,eventParam)
	local obj = nil
	if imgInfo.path ~= "" then
		local img
		if #self.freeImgUICache > 0 then
			img = table.remove(self.freeImgUICache)
			if string.byte(imgInfo.path) == 35 then -- first char is #
				img:setSpriteFrame(string.sub(imgInfo.path, 2))
			else
				img:setTexture(imgInfo.path)
			end
		else
			img = display.newSprite(imgInfo.path)
			img:retain()
		end
		--是否需要自动换行
		if self.adaptWidth then
			
			--要换行
			img:setScale(imgInfo.height/img:getContentSize().height)
			if self.curLine.leftWidth-img:getContentSize().width < 0 then
				self:addNewLine()
				self:handleImg(imgInfo,eventType,eventParam)
				table.insert(self.freeImgUICache, img)
			else
				img:setAnchorPoint(0,0.5)
				img:setPositionX(self.curLine.width)
				img:setColor(imgInfo.color);
		        img:setOpacity(imgInfo.opacity);
				if fontString then
					-- local label = display.newTTFLabel({text=fontString, font=fontInfo.fontName, size=fontInfo.fontSize, color=fontInfo.color})
					-- label:setOpacity(fontInfo.opacity)
					-- img:addChild(label)
				end
				self.curLine:addChild(img)
				table.insert(self.imgUICache, img)
                img:release()
				self.curLine.width = self.curLine.width+img:getContentSize().width
				if img:getContentSize().height > self.curLine.height then
					self.curLine.height = img:getContentSize().height
				end
				self.curLine.leftWidth = self.curLine.leftWidth-img:getContentSize().width
				obj = img
			end
		else
			img:setAnchorPoint(0,0.5)
			img:setPositionX(self.curLine.width)
			img:setColor(imgInfo.color);
	        img:setOpacity(imgInfo.opacity);
			if fontString then
				-- local label = display.newTTFLabel({text=fontString, font=fontInfo.fontName, size=fontInfo.fontSize, color=fontInfo.color})
				-- label:setOpacity(fontInfo.opacity)
				-- img:addChild(label)
			end
			self.curLine:addChild(img)
			table.insert(self.imgUICache, img)
			img:release()
			img:setScale(imgInfo.height/img:getContentSize().height)
			self.curLine.width = self.curLine.width+img:getContentSize().width
			if img:getContentSize().height > self.curLine.height then
				self.curLine.height = img:getContentSize().height
			end
			obj = img
		end
	end

	if obj and eventType then
		self:handleEvent(obj,eventType,eventParam)
	end
end

function SuperRichText:handleText(str,fontInfo,eventType,eventParam)

    if str == "" then
    	return
    end
	local obj = nil
	local reText
	if #self.freeLabelUICache > 0 then
		reText = table.remove(self.freeLabelUICache)
		if cc.FileUtils:getInstance():isFileExist(fontInfo.fontName) then
			local ttfConfig = { fontFilePath = fontInfo.fontName, fontSize = fontInfo.fontSize, glyphs = "DYNAMIC" }
            reText:setTTFConfig(ttfConfig)
		else
            reText:setSystemFontName(fontInfo.fontName);
            reText:setSystemFontSize(fontInfo.fontSize);
		end
		
		reText:setColor(fontInfo.color)
		reText:setString(str)
	else
		reText = display.newTTFLabel({color=fontInfo.color,text=str,font=fontInfo.fontName,size=fontInfo.fontSize})
		reText:retain()
	end
	--创建Label,并添加到当前行
	--是否需要自动分行
	if self.adaptWidth then
		
		local textRendererWidth = reText:getContentSize().width
		--要换行
		if self.curLine.leftWidth-textRendererWidth < 0 then
		    local leftW = self.curLine.leftWidth
		    if self.isEllipsize then
		    	leftW = self.curLine.leftWidth - 1.5 * fontInfo.fontSize
			end
			local temp, nextStr = StringUtil.SubUTF8StringWithWidth(str,fontInfo.fontSize, leftW)
			if self.isEllipsize then
		    	temp = temp .. "..."
			end
			reText:setString(temp)
			reText:setOpacity(fontInfo.opacity)
			reText:setAnchorPoint(0,0.5)
			reText:setPositionX(self.curLine.width)
			self.curLine:addChild(reText)
			table.insert(self.labelUICache, reText)
			reText:release()
			self.curLine.width = self.curLine.width+reText:getContentSize().width
			if reText:getContentSize().height > self.curLine.height then
				self.curLine.height = reText:getContentSize().height
			end
			if not self.isEllipsize then
			    self:addNewLine()
			    self:handleText(nextStr,fontInfo,eventType,eventParam)
			end
			obj = reText
		else
			self.curLine.leftWidth = self.curLine.leftWidth-textRendererWidth
			reText:setOpacity(fontInfo.opacity)
			reText:setAnchorPoint(0,0.5)
			reText:setPositionX(self.curLine.width)
			self.curLine:addChild(reText)
			table.insert(self.labelUICache, reText)
			reText:release()
			self.curLine.width = self.curLine.width+reText:getContentSize().width
			if reText:getContentSize().height > self.curLine.height then
				self.curLine.height = reText:getContentSize().height
			end
			obj = reText
		end
		
	else
		reText:setOpacity(fontInfo.opacity)
		reText:setAnchorPoint(0,0.5)
		reText:setPositionX(self.curLine.width)
		self.curLine:addChild(reText)
		table.insert(self.labelUICache, reText)
		reText:release()
		self.curLine.width = self.curLine.width+reText:getContentSize().width
		if reText:getContentSize().height > self.curLine.height then
			self.curLine.height = reText:getContentSize().height
		end
		obj = reText
	end

	if obj and eventType then
		self:handleEvent(obj,eventType,eventParam)
	end
end

function SuperRichText:handleEvent(obj,eventType,eventParams)
	if not obj or not eventType then return end
	obj:setTouchEnabled(true)
	obj:setTouchSwallowEnabled(false)
	local touchBeganX, touchBeganY
	local touchMoved = false
	obj:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	touchBeganX = event.x
            touchBeganY = event.y
        elseif event.name == "moved" then
        	touchMoved = math.abs(event.x - touchBeganX) > 6 or math.abs(event.y - touchBeganY) > 6
        elseif event.name == "ended" then
            local touchInTarget = self:checkTouchInSprite_(obj, touchBeganX, touchBeganY)
            if touchMoved or not touchInTarget then touchMoved = false return false end
            SoundManager:playClickSound()
            if eventType == 1 then 		--聊天信息点击玩家名字
            	local roleManager = RoleManager:getInstance()
				local roleInfo = roleManager.roleInfo
				if tonumber(roleInfo.player_id) == tonumber(eventParams.player_id) then return end
 				local node = require("app.gameui.PopTipsList").new(SceneRoleType.PLAYER,nil,{id=eventParams.player_id,teamId = eventParams.teamId, guildId = eventParams.guild_id,name=eventParams.player_name},nil)
				node:setPosition(display.width/2,display.height/2 - node:getContentSize().height/2 + 50)
				GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,node)
			elseif eventType == 2 then  --装备道具
				local data = json.decode(eventParams.data)
		 		local goodType = configHelper:getGoodTypeByGoodId(data.goods_id)
		        if not goodType then return end
		        if goodType == 2 then           --装备
		           local eTWin = equipTipsWin.new()
		           local career_name, career_id = configHelper:getEquipCareerByEquipId(data.goods_id)
		           	eTWin:setData(EquipUtil.formatEquipItem(data),true, career_id)
		           	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)
		        elseif goodType == 1 or goodType == 3 or goodType == 6 or goodType == 4 then      --道具
		           	local itWin = itemTipsWin.new()
		            itWin:setData(data)
		            itWin.btnUse:setVisible(false)
		            itWin.btnSell:setVisible(false)
		            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
		        end

		    elseif eventType == 3 then  --组队
		    	if tonumber(RoleManager:getInstance().roleInfo.teamId) > 0 then
		    		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"已有队伍")
		    	else
		    		GlobalController.team:RequestJoinTeam(eventParams.teamId)
		    	end
		    	
            end
        end     
        return true
    end)
end

function SuperRichText:checkTouchInSprite_(obj, x, y)
    return obj:getCascadeBoundingBox():containsPoint(cc.p(x, y))
end

function SuperRichText:addNewLine()
	if #self.freeLineList > 0 then
		self.curLine = table.remove(self.freeLineList)
	else
		self.curLine = display.newNode()
		self.curLine:retain()
    end
	self.curLine.width = 0
	self.curLine.height = 0
	if self.adaptWidth then
		self.curLine.leftWidth = self.adaptWidth 
	end
	self.curLine:setAnchorPoint(0,0)
	self:addChild(self.curLine)
	table.insert(self.lineList,self.curLine)
	self.curLine:release()
end

function SuperRichText:updateLine()
    local maxWidth,maxHeight = 0,0
    for i = #self.lineList, 1, -1  do
    	local rowH = self.lineList[i].height
    	local rowW = self.lineList[i].width
    	local gap = self.lineGap[i-1] or 0
    	self.lineList[i]:setPositionY(maxHeight + rowH / 2)
    	if rowW > maxWidth then
    		maxWidth = rowW
    	end
    	maxHeight = maxHeight + rowH

    end
    self:setContentSize(maxWidth, maxHeight)
end

return SuperRichText

