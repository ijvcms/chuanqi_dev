local FightBg = class("FightBg", function()
	return display.newNode()
end)

function FightBg:ctor(bgId)
    -- self.picWidth = 300                     --300像素一张图片     
    self.picWidth = 256                     --300像素一张图片     
    self.curPosX = 0
    -- self.bgId = bgId
    self.bgId = 1101
    if bgId ~= nil then
        self.bgId = bgId
    end
    self.topBgIndex = {}
    self.bottomBgIndex = {}
    self.topBgNode = {}
    self.bottomBgNode = {}
    self.topDelIndexArr = {}
    self.buttomDelIndexArr = {}

    self.topWidth = 2732               --前景宽宽度
    self.bottomWidth = 1800            --后景宽宽度
    self.precent = (self.bottomWidth-display.width)/(self.topWidth-display.width)
    self.topPos = 0
    self.bottomPos = 0
    self:setTouchCaptureEnabled(false) 
    self:setTouchEnabled(false)

    self.farbg = display.newNode()
    self:addChild(self.farbg)
    self.farbg:setTouchEnabled(false)
    self.farbg:setTouchCaptureEnabled(false) 


    self.fightScene = display.newNode()
    self:addChild(self.fightScene)
    self.fightScene:setTouchEnabled(false)
    self.fightScene:setTouchCaptureEnabled(false) 

    -- local handle = scheduler.scheduleGlobal(handler(self, self.update), 1 / 60)
	
end

function FightBg:drawMap()
    
    local delIndexArr,newIndexArr = self:initCurPos(self.bottomPos, self.bottomBgIndex, self.buttomDelIndexArr)
    -- self:drawBg("back", self.bottomPos, newIndexArr, delIndexArr, display.height - 258)
    self:drawBg("b", self.bottomPos, newIndexArr, delIndexArr, display.height - 256)
    self.bottomBgIndex = newIndexArr
    self.buttomDelIndexArr = delIndexArr


    local delIndexArr,newIndexArr = self:initCurPos(self.topPos, self.topBgIndex, self.topDelIndexArr)
    -- self:drawBg("front", self.topPos, newIndexArr, delIndexArr, 0)
    self:drawBg("f", self.topPos, newIndexArr, delIndexArr, 0)
    self.topBgIndex = newIndexArr
    self.topDelIndexArr = delIndexArr
end

function FightBg:drawBg( type_, curPos, newIndexArr, delIndexArr, y )
    local offX = -(curPos % self.picWidth)    
    local bgNode = self.topBgNode
    local parents = self
    local pic = ".png"
    if type_ == "b" then 
        bgNode = self.bottomBgNode 
        pic = ".jpg"
        parents = self.farbg
    else  
        parents = self.fightScene  
    end

    for i=newIndexArr[1], newIndexArr[2] do
        if bgNode[i] == nil and table.maxn(delIndexArr) ~= 0 then
            local index = table.remove(delIndexArr, 1)
            bgNode[i] = bgNode[index]
            self:clearCache(bgNode[i]:getTexture())
            -- bgNode[i]:setTexture("res/Battle/"..type_.."-"..i..".jpg")
            bgNode[i]:setTexture("res/Battle/"..self.bgId.."/"..type_..i..pic)
            bgNode[index] = nil
        elseif bgNode[i] == nil then
            -- bgNode[i] = display.newSprite("res/Battle/"..type_.."-"..i..".jpg")
            bgNode[i] = display.newSprite("res/Battle/"..self.bgId.."/"..type_..i..pic)
            bgNode[i]:setAnchorPoint(cc.p(0, 0))            
            parents:addChild(bgNode[i])
        end    
        --bgNode[i]:setContentSize(cc.size(256, 588))       
        bgNode[i]:setPosition(offX + (i - newIndexArr[1]) * self.picWidth, y)
    end
    for k,v in pairs(delIndexArr) do
        local index = table.remove(delIndexArr, 1)
        self:clearCache(bgNode[index]:getTexture())
        bgNode[index]:removeSelf()
        bgNode[index] = nil
        delIndexArr = {}
    end
end

function FightBg:initCurPos( curPos, curIndexArr, delIndexArr )          
    local begin = math.floor(curPos / self.picWidth) + 1                 --当前起始位置
    local last = math.ceil((curPos + display.width) / self.picWidth)     --当前结束位置 
    local newIndexArr = {begin, last}

    if table.maxn(curIndexArr) == 0 then return delIndexArr,newIndexArr end

    if curIndexArr[1] < newIndexArr[1] then
        for i=curIndexArr[1],newIndexArr[1] - 1 do
            table.insert(delIndexArr, i)
        end
    end
    if curIndexArr[2] > newIndexArr[2] then
        for i=curIndexArr[2],newIndexArr[2] + 1, -1 do
            table.insert(delIndexArr, i)
        end
    end
    return delIndexArr,newIndexArr
end    

-- function FightBg:update( dt )
--     self:setPos(self.curPosX + 1)
-- end

function FightBg:setPos(x)
    if x > self.topWidth - display.width then x = self.topWidth - display.width end
    if x < 0 then x = 0 end
	self.curPosX = x

    self.topPos = x
    self.bottomPos = self.precent * self.topPos
    self:drawMap()
end

function FightBg:getPos()
    return self.curPosX
end 

function FightBg:clearCache(texture)
    cc.Director:getInstance():getTextureCache():removeTexture(texture)
end

function FightBg:destory()
    for k,v in pairs(self.topBgNode) do
        cc.Director:getInstance():getTextureCache():removeTexture(v:getTexture())
    end
    for k,v in pairs(self.bottomBgNode) do
        cc.Director:getInstance():getTextureCache():removeTexture(v:getTexture())
    end
end

function FightBg:shockScene(xx,yy)
    self.fightScene:setPosition(cc.p(xx,yy))
end
return FightBg