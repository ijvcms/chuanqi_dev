--
-- Author: 21102585@qq.com
-- Date: 2014-12-25 16:15:11
-- 战斗常用函数

FightUtil = FightUtil or {}

--判断某个数字是否在里面
--现只支持4位数的数字
--使用方法FightUtil:hasSubNum(1234,4) return true
function FightUtil:hasSubNum(pNum,sNum)
  if math.floor(pNum/1000) == sNum then
    return true
  end
  local nn = pNum%1000
  if math.floor(nn/100) == sNum then
    return true
  end 
  nn = nn%100
  if math.floor(nn/10) == sNum then
     return true
  end 
  if nn%10 == sNum then
    return true
  end
  return false
end 

--coco2dx像素坐标转化成格子
function FightUtil:pointToGrid(xx,yy,sceneH)
    yy = GameSceneModel.sceneHeight - yy
    return cc.p(math.ceil(xx/SceneGridRect.width),math.ceil(yy/SceneGridRect.height))
end

function FightUtil:gridToPoint(xx,yy)
    xx = xx*SceneGridRect.width-SceneGridRect.width/2
    yy = GameSceneModel.sceneHeight-yy*SceneGridRect.height+SceneGridRect.height/2 
    return cc.p(xx,yy)
end


--根据两点算出倾斜角度
function FightUtil:getAngle22(p1,p2)
    local xdis = p2.x - p1.x
    local ydis = p2.y - p1.y
    local result = (math.tan(ydis/xdis)*180)/math.pi
    if ydis ~= 0 and xdis ~= 0 then
        return result
    else
        return 0
    end
end

function FightUtil:getAngleByGrid(p1,p2)
    local xdis = p2.x - p1.x
    local ydis = 0-p2.y + p1.y
    return (cc.pToAngleSelf(cc.p(xdis,ydis))*180)/math.pi
end

function FightUtil:getAngle(p1,p2)
    local xdis = p2.x - p1.x
    local ydis = p2.y - p1.y
    return (cc.pToAngleSelf(cc.p(xdis,ydis))*180)/math.pi
end

--计算两点之间距离
function FightUtil:getDistance(apx,apy,bpx,bpy)
  return math.sqrt((bpx -apx)*(bpx -apx) + (bpy -apy)*(bpy -apy) )
end

--计算两个格子差
--用来判断获取两个最近的角色
--@return  xx,yy  xx表示X轴之间有多少格子 yy表示Y轴有多少格子
function FightUtil:getGridSpace(grid1,grid2)	
	return math.abs(grid1[1]-grid2[1]),math.abs(grid1[2] - grid2[2])
end	

--根据角度获取方向ID和转向
--return 方向
function FightUtil:getDirectByAngle(ang)
    if ang<-67.5 and ang >= -112.5 then
        return 1
    elseif ang<-22.5 and ang >= -67.5 then
        return 2
    elseif ang<22.5 and ang >= -22.5 then
        return 3
    elseif ang<67.5 and ang >= 22.5 then
        return 4
    elseif ang<112.5 and ang >= 67.5 then
        return 5
    elseif ang<157.5 and ang >= 112.5 then
        return 6
    elseif ang>=157.5 or ang < -157.5 then
        return 7
    elseif ang>=-157.5 and ang < -112.5 then
        return 8
    end
    return 5
end


--根据角度获取方向相关信息
--return 方向编号 动作编号 X轴缩放
function FightUtil:getDireInfoByAngle(ang)  
    if ang<-67.5 and ang >= -112.5 then
        return 1,1,1
    elseif ang<-22.5 and ang >= -67.5 then
        return 2,2,1
    elseif ang<22.5 and ang >= -22.5 then
        return 3,3,1
    elseif ang<67.5 and ang >= 22.5 then
        return 4,4,1
    elseif ang<112.5 and ang >= 67.5 then
        return 5,5,1
    elseif ang<157.5 and ang >= 112.5 then
        return 6,4,-1
    elseif ang>=157.5 or ang < -157.5 then
        return 7,3,-1
    elseif ang>=-157.5 and ang < -112.5 then
        return 8,2,-1
    end
    return 5,5,1
end

--根据方向获取动作方向相关信息
--return 动作编号 X轴缩放
function FightUtil:getActionByDirect(key)  
    if key == 1 then
        return 1,1
    elseif key == 2 then
        return 2,1
    elseif key == 3 then
        return 3,1
    elseif key == 4 then
        return 4,1
    elseif key == 5 then
        return 5,1
    elseif key == 6 then
        return 4,-1
    elseif key == 7 then
        return 3,-1
    elseif key == 8 then
        return 2,-1
    end
    return 5,1
end



function FightUtil:getPetNameColorByLv(lv)
    if lv == 1 then
        return cc.c3b(255, 255, 255)
    elseif lv == 2 then
        return cc.c3b(150, 232, 244)
    elseif lv == 3 then
        return cc.c3b(145, 213, 234)
    elseif lv == 4 then
        return cc.c3b(31, 98, 168)
    elseif lv == 5 then
        return cc.c3b(55, 121, 195)
    elseif lv == 6 then
        return cc.c3b(7, 49, 123)
    elseif lv == 7 then
        return cc.c3b(3, 37, 108)
    elseif lv == 8 then
        return cc.c3b(253, 107, 252)
    elseif lv == 9 then
        return cc.c3b(245, 252, 46)
    end
    return cc.c3b(255, 255, 255)
end  


function FightUtil:getRoleWeaponID(weapon,sex)
    if weapon == "" or weapon == 0 then
        return 0
    end
    return (sex+2)..weapon
    --return (sex+2).."10"
end
--获取当前格子周围的随机一格
--grid 目标格子
--
-- function FightUtil:getRandomAroundGrid(grid,beginGrid)
--     local min = 100000
--     local temp = 0
--     for k,v in pairs(SceneGridAround) do
--         temp =  
--         if 
--     end
--     for SceneGridAround

-- end
