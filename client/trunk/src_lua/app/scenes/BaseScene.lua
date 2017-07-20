--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-02-11 16:59:40
-- 场景基类
require("config")
require("cocos.init")
require("framework.init")
local BaseScene = class("BaseScene", function()
	return display.newScene("BaseScene")
end)

function BaseScene:ctor()
	
end


--运行场景
function BaseScene:run(sceneName,gameId,width,height)
	sceneName = sceneName or self.sceneName
	gameId = gameId or self.gameId
	width = width or display.width
	height = height or display.height
	cc.FileUtils:getInstance():addSearchPath("res/")

	local addSrc = cc.FileUtils:getInstance():getWritablePath().."src/"
    local addRes = cc.FileUtils:getInstance():getWritablePath().."res/"
    --cc.FileUtils:getInstance():addSearchPath(addSrc,true)
    if DEVELOP then
    	cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."src_lua/",true)
	else
		cc.FileUtils:getInstance():addSearchPath(addSrc,true)
	end
    cc.FileUtils:getInstance():addSearchPath(addRes,true)
    dump(cc.FileUtils:getInstance():getSearchPaths())    
    self:enterScene(sceneName,{sceneName,gameId,width,height})
end	

function BaseScene:enterScene(sceneName, args, transitionType, time, more)
	self.packageRoot = packageRoot or "app"
    local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))   
    display.replaceScene(scene, transitionType, time, more)
end

--进入场景
function BaseScene:onEnter()

end	

--退出场景
function BaseScene:onExit()

end	

return BaseScene