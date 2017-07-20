local FightMap = class("FightMap", function()
	return display.newNode()
end)

FightMap.curPosX = 0
FightMap.bgId = nil
FightMap.sprites1 = nil
FightMap.sprites2 = nil
FightMap.picWidth = 300                     --300像素一张图片
FightMap.BGWidth = 2732                     --总的背景宽度
FightMap.lastPos = 0                        --上一次的 第几张图片
FightMap.lastPos1 = 0

function FightMap:ctor(bgId)
    self.sprites1 = nil
    self.sprites2 = nil
    self.curPosX = 0
    self.bgId = bgId
    self:drawMap()
	return true
end

function FightMap:drawMap()

	local width = display.width
    local height = display.height

    local num = math.floor(width / self.picWidth) + 2                                                   --需要多少张背景图

    local pos = math.floor(self.curPosX / self.picWidth) + 1 			                                --第几张图片	
    local pos1 = math.floor(self.curPosX * 0.5 / self.picWidth) + 1                                     --第几张图片  
    
    self.lastPos = pos
    self.lastPos1 = pos1

    local offX = -(self.curPosX % self.picWidth)	    												--偏移坐标
    local offX1 = -((self.curPosX * 0.5) % self.picWidth)                                               --偏移坐标

    self.sprites1 = {}
    self.sprites2 = {}

    for i = 1, num do
    	local node = display.newSprite("res/Battle/back-"..(pos1 + i - 1)..".jpg", offX1 + i * self.picWidth - self.picWidth, height)
        node:setAnchorPoint(cc.p(0, 1))
        self:addChild(node)
        self.sprites2[i] = node
    end

    for i = 1, num do
    	local node = display.newSprite("res/Battle/front-"..(pos + i - 1)..".jpg", offX + i * self.picWidth - self.picWidth, 0)
        node:setAnchorPoint(cc.p(0, 0))
        self:addChild(node)
        self.sprites1[i] = node
    end

    -- local handle = scheduler.scheduleGlobal(handler(self, self.update), 1 / 60)

end



function FightMap:resetMap()
    local width = display.width
    local height = display.height

    local num = math.floor(width / self.picWidth) + 2                                                             --需要多少张背景图

    local pos = math.floor(self.curPosX / self.picWidth) + 1                                                      --第几张图片 
    local pos1 = math.floor(self.curPosX * 0.5 / self.picWidth) + 1                                               --第几张图片  

    local offX = -(self.curPosX % self.picWidth)                                                                  --偏移坐标
    local offX1 = -((self.curPosX * 0.5) % self.picWidth)                                                         --偏移坐标

    for i = 1, num do
        self.sprites2[i]:setTexture("res/Battle/back-"..(pos1 + i - 1)..".jpg")
        self.sprites2[i]:setPosition(offX1 + i * self.picWidth - self.picWidth, height)
    end

    for i = 1, num do
        self.sprites1[i]:setTexture("res/Battle/front-"..(pos + i - 1)..".jpg")
        self.sprites1[i]:setPosition(offX + i * self.picWidth - self.picWidth, 0)
    end

    self:destory(pos, pos1, num)

    self.lastPos = pos
    self.lastPos1 = pos1

end

function FightMap:update( dt )
    self:setPos(self.curPosX + 1)
end

function FightMap:setPos(x)

    if x > self.BGWidth - display.width then
        x = self.BGWidth - display.width
    end

    if x < 0 then x = 0 end

	self.curPosX = x
	self:resetMap()
end

function FightMap:getPos()
    return self.curPosX
end    

function FightMap:destory(pos, pos1, num)
    for i = 1, num do
        if (self.lastPos + i - 1) < pos or (self.lastPos + i - 1) > (pos + num - 1) then
            cc.Director:getInstance():getTextureCache():removeTextureForKey("res/Battle/front-"..(self.lastPos + i)..".jpg")
        end 
        if (self.lastPos + i - 1) < pos1 or (self.lastPos + i - 1) > (pos1 + num - 1) then
            cc.Director:getInstance():getTextureCache():removeTextureForKey("res/Battle/back-"..(self.lastPos1 + i)..".jpg")
        end
    end
end

return FightMap
