
--属性变化动画view
local AttrChangeView = class("AttrChangeView", function()
	return display.newNode() --cc.Sprite:create() -- 
end)

-- local filterTable = {
-- 	1,--等级
-- 	2,--经验
-- 	3,--当前血量
-- 	4,--当前魔量
-- }


function AttrChangeView:ctor(update_list)
	local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo	

    self.layer = display.newLayer()
    self.layer:setTouchEnabled(false)
    self.layer:setPosition(display.width/2-50, 190)
    self:addChild(self.layer)
    local showAttr = {}
    self.showAttrLayers = {}
    for k,v in pairs(update_list) do
		local match = false
		local field
		--RoleInfoVo上查找对应的属性
		for k1,v1 in pairs(AttrMatch) do
			if v.key == v1.key then
				match = true
				field = v1.field
				break
			end 
		end
		-- --有些属性尽管在RoleInfoVo上有，但是还是要过滤掉
		-- if match then
		-- 	for k2,v2 in pairs(filterTable) do
		-- 		if v2 == v.key then
		-- 			match = false
		-- 			break
		-- 		end
		-- 	end
		-- end
		if match then 
			local curValue = roleInfo[field] 
			if v.key == 74 then 			 	--幸运(诅咒)单独处理
				if not showAttr[v.key] then
	    			showAttr[v.key] = {}
	    		end
	    		local oldValue = curValue
	    		local newValue = v.value
	    		local zz
	    		local xy
	    		if newValue < 0 then 	--为负值，则表示存在诅咒
	    			if oldValue >0 then
	    				xy=-oldValue
	    				zz=0-newValue
	    			else
	    				zz=oldValue-newValue
	    			end
	    		else 					--为正值,则表示存在幸运
	    			if oldValue >0 then
	    				xy=newValue-oldValue
	    			elseif oldValue <0 then
	    				zz=oldValue
	    				xy=newValue
	    			end
	    		end
	    		if zz and zz~=0 then
	    			if not showAttr.zz then
		    			showAttr.zz = {}
		    		end
		    		showAttr.zz.min = zz
	    		end

	    		if xy and xy~=0 then
	    			if not showAttr.xy then
		    			showAttr.xy = {}	
		    		end
		    		showAttr.xy.min = xy
	    		end
			else
				if v.value>curValue then 		--属性增长才显示
					if v.key == 8 or v.key == 10 or v.key == 12 or v.key == 14 or v.key == 16 then 					--8最大物攻 --10最大法攻 --12最大道攻 --14最大物防 --16最大法防
			    		if not showAttr[v.key-1] then
			    			showAttr[v.key-1] = {}
			    		end
			    		showAttr[v.key-1].max = v.value-curValue
			    		if not showAttr[v.key-1].min then
		    				showAttr[v.key-1].min = 0
		    			end 
			    	else
			    		if not showAttr[v.key] then
			    			showAttr[v.key] = {}
			    		end
			    		showAttr[v.key].min = v.value-curValue
			    		if v.key == 7 or v.key == 9 or v.key == 11 or v.key == 13 or v.key == 15 then 					--8最大物攻 --10最大法攻 --12最大道攻 --14最大物防 --16最大法防
			    			if not showAttr[v.key].max then
			    				showAttr[v.key].max = 0
			    			end 
			    		end
			    	end
	    		end
			end
		end
    end

    local fileUtil = cc.FileUtils:getInstance()
    local function getNumArray(inputNumber)
    	local temp = inputNumber
    	local numCount = 1
    	while true do
			if temp/10 >= 1 then
				numCount = numCount+1
				temp = temp/10
			else
				break
			end
		end

		--[1]对应个位,[2]对应10位......
		local nums = {}
		local temp = inputNumber
		for i=1,numCount do
			nums[numCount-i+1] = math.floor(temp/(10^(numCount-i)))
			temp = temp - nums[numCount-i+1]*(10^(numCount-i))
		end
		return nums
    end
    local function addShowAttrLayer(attrIndex,min,max)
    	if type(attrIndex) == "number" and (attrIndex < 5 or attrIndex == 8 or attrIndex == 10 or attrIndex == 12 or attrIndex == 14 or attrIndex == 16 or attrIndex > 29) then
            return
    	end
    	local path = "#scene/attrName_attr"..attrIndex..".png"
    	local layer = display.newLayer()
    	layer:setTouchEnabled(false)
    	layer:setTouchSwallowEnabled(false)
    	local sps = {}

		--幸运(诅咒)减少的时候也要显示
		if tostring(attrIndex) == "xy" or tostring(attrIndex) == "zz" then
			if min>0 then
				--"+"
				local spAdd = display.newSprite("#scene/attrName_A_+.png")
				table.insert(sps,spAdd)
			elseif min<0 then
				--"-"
				local spAdd = display.newSprite("#scene/attrName_A_-.png")
				table.insert(sps,spAdd)
				min = math.abs(min)
			end
		else
			--"+"
			local spAdd = display.newSprite("#scene/attrName_A_+.png")
			table.insert(sps,spAdd)
		end
		
    	--"属性名"
		local spAttrName = display.newSprite(path)
		table.insert(sps,spAttrName)
		--"最小值"
		local minNumArray = getNumArray(min)
		for i=1,#minNumArray do
			local sp = display.newSprite("#scene/attrName_A_"..minNumArray[#minNumArray-i+1]..".png")
			table.insert(sps,sp)
		end
		--最大值
		if max then
			--"-"
			local sp = display.newSprite("#scene/attrName_A_-.png")
			table.insert(sps,sp)
			local maxNumArray = getNumArray(max)
			for i=1,#maxNumArray do
				local sp = display.newSprite("#scene/attrName_A_"..maxNumArray[#maxNumArray-i+1]..".png")
				table.insert(sps,sp)
			end
		end

		local width = 0
		local height = 0
		for i=1,#sps do
			layer:addChild(sps[i])
			sps[i]:setAnchorPoint(0,0)
			if i>1 then
				sps[i]:setPositionX(sps[i-1]:getPositionX()+sps[i-1]:getContentSize().width)
			end
			width = width+sps[i]:getContentSize().width
			if sps[i]:getContentSize().height > height then
				height = sps[i]:getContentSize().height
			end
		end
		layer:setContentSize(width,height)

		self.layer:addChild(layer)
		table.insert(self.showAttrLayers,layer)
    end

    for k,v in pairs(showAttr) do
		addShowAttrLayer(k,v.min,v.max)
    end

    self.diffY = {[1]= 0,}
    for i=1,#self.showAttrLayers do
    	-- showAttrLayers[i]:setPositionY(diffY[1])
    	self.showAttrLayers[i]:setVisible(false)
    	self.diffY[i+1] = self.diffY[i]+self.showAttrLayers[i]:getContentSize().height
    end

    self:popAttrLayer(1)
end

local acSpeed = 550
function AttrChangeView:popAttrLayer(index)
	if not self.showAttrLayers[index] then  			--最后一个
		self:runAction(transition.sequence({
		    cc.DelayTime:create(1.0),
		    cc.CallFunc:create(function()
		    	self:fadeOutAttrLayer(1)
		    end)
		}))
		return
	end
	self.showAttrLayers[index]:setVisible(true)
	local acTime = self.diffY[(#self.showAttrLayers - index + 1)] / acSpeed
	self.showAttrLayers[index]:runAction(transition.sequence({
		    cc.MoveTo:create(acTime, cc.p(0,self.diffY[(#self.showAttrLayers - index + 1)])),
		    cc.CallFunc:create(function()
		    	self:popAttrLayer(index+1)
		    end)
		}))
end

function AttrChangeView:fadeOutAttrLayer(index)
	if not self.showAttrLayers[index] then  		--最后一个
		self:removeSelf()
		return
	end
	local acTime = 100 / acSpeed
	self.showAttrLayers[index]:runAction(transition.sequence({
		cc.MoveTo:create(acTime, cc.p(150,self.showAttrLayers[index]:getPositionY())),
		cc.CallFunc:create(function()
	    	self:fadeOutAttrLayer(index+1)
	    end)
		}))
	local childs = self.showAttrLayers[index]:getChildren()	
	for i=1,#childs do
		childs[i]:runAction(cc.FadeOut:create(acTime))
	end
end

return AttrChangeView