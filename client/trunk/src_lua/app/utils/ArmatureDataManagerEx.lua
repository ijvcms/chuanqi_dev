--异步加载资源图片
--by shine
--2016-08-09
--正常的异步加载思路
--所有的资源是按序加载的，不可同时加载多个文件。执行异步加载的处理肯定是写在void update(float f)中，做到按帧加载。
--以下方法是补之前的错误

local ArmatureDataManager = ccs.ArmatureDataManager
local scheduler = require("framework.scheduler")
local fun = function() end

function ArmatureDataManager:addArmaturefoAsync(imagePath, plistPath, configFilePath, armatureId, callback)
	local handler
	display.addSpriteFrames(plistPath, imagePath, function()
		local texture =  cc.Director:getInstance():getTextureCache():getTextureForKey(imagePath)
		if not texture then
			display.addSpriteFrames(plistPath, imagePath)
			texture = cc.Director:getInstance():getTextureCache():getTextureForKey(imagePath)
		end

        self:addArmatureFileInfo(imagePath, plistPath, configFilePath)--同步加载
        local data = self:getArmatureData(armatureId)
        if nil ~= callback and 0 ~= callback then
			callback(armatureId, data)--这种方式非常不安全,动画可能被清理，直接加上动画？
		end

		-- texture:retain()--异步加载
		-- self:addArmatureFileInfoAsync(imagePath, plistPath, configFilePath, fun)--图片资源没有完全的异步加载
		-- handler = scheduler.scheduleUpdateGlobal(function()--所以使用addSpriteFrames，每帧调用
		-- 	local data = self:getArmatureData(armatureId)
		-- 	if data then
		-- 	    scheduler.unscheduleGlobal(handler)
		-- 	    if nil ~= callback and 0 ~= callback then
		-- 	   	    data:retain()
		-- 	   	    callback(armatureId, data)--这种方式非常不安全,动画可能被清理，直接加上动画？
		-- 	   	    data:release()
		-- 	    end
		-- 	    texture:release()
		-- 	end
		-- end)
	end)
end



function ArmatureDataManager:autoAddArmaturefoAsync(configFilePath, armatureId, callback)
    local info = io.pathinfo(configFilePath)
	local imagePath, plistPath
	if info.dirname then
		imagePath = info.dirname .. info.basename .. "0.png"
		plistPath = info.dirname .. info.basename .. "0.plist"
		if not io.exists(cc.FileUtils:getInstance():fullPathForFilename(plistPath)) then
			imagePath = info.dirname .. info.basename .. ".png"
		    plistPath = info.dirname .. info.basename .. ".plist"
        end
	else
		imagePath = info.basename .. "0.png"
		plistPath = info.basename .. "0.plist"
		if not io.exists(cc.FileUtils:getInstance():fullPathForFilename(plistPath)) then
			imagePath = info.basename .. ".png"
		    plistPath = info.basename .. ".plist"
        end
	end
	self:addArmaturefoAsync(imagePath, plistPath, configFilePath, armatureId, callback)
end

--================= 新方法 ========================
--有没资源在各Sprite自己检查
function ArmatureDataManager:addArmatureFileInfoAsyncEx(imagePath, plistPath, configFilePath)
	display.addSpriteFrames(plistPath, imagePath, function()
		self:addArmatureFileInfoAsync(imagePath, plistPath, configFilePath, fun)
	end)
end

function ArmatureDataManager:autoAddArmatureFileInfoAsyncEx(imagePath, plistPath, configFilePath)
	local info = io.pathinfo(configFilePath)
	local imagePath, plistPath
	if info.dirname then
		imagePath = info.dirname .. info.basename .. "0.png"
		plistPath = info.dirname .. info.basename .. "0.plist"
		if not io.exists(cc.FileUtils:getInstance():fullPathForFilename(plistPath)) then
			imagePath = info.dirname .. info.basename .. ".png"
		    plistPath = info.dirname .. info.basename .. ".plist"
        end
	else
		imagePath = info.basename .. "0.png"
		plistPath = info.basename .. "0.plist"
		if not io.exists(cc.FileUtils:getInstance():fullPathForFilename(plistPath)) then
			imagePath = info.basename .. ".png"
		    plistPath = info.basename .. ".plist"
        end
	end
	self:addArmatureFileInfoAsyncEx(imagePath, plistPath, configFilePath)
end