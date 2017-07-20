--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2015-12-15 20:27:36
--

--[[
	通常，我们使用uiloader来加载使用编辑器编辑的列表项。
	但是这样有一个很明显的性能消耗，那就是每加载一个列表项就会进行I/O读写以及JSON解析。
	在一个复杂的的列表项中，这样做是非常耗费性能的。

	我们完全可以只进行一次I/O读写，然后缓存它以便列表的循环使用。
	唯一的麻烦在于不需要的时候要手动清理，这样做是值得的。
]]

local GameUILoaderUtils = class("GameUILoaderUtils")

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GameUILoaderUtils:ctor()
	self.uiLoaderUtilitys = require(cc.PACKAGE_NAME .. ".cc.uiloader.UILoaderUtilitys")
	self.cache = {}
end

--
-- 将一个UI编辑器导出的JSON文件转为Lua对象，并调用BuildNodesByCache方法来重复生成
-- 有效的减少加载时间，在销毁时调用Clear即可。
--
function GameUILoaderUtils:AddUIEditorCache(jsonFile)
	local fileUtil = cc.FileUtils:getInstance()
	local fullPath = fileUtil:fullPathForFilename(jsonFile)

	local pathinfo = io.pathinfo(fullPath)
	local dirname  = pathinfo.dirname
	self.uiLoaderUtilitys.addSearchPathIf(dirname)

	local jsonStr = fileUtil:getStringFromFile(fullPath)
	local jsonVal = json.decode(jsonStr)

	self:addCache(jsonFile, dirname, jsonVal)
end

--
-- 将一个已经缓存的布局文件生成一个显示对象。
--
function GameUILoaderUtils:BuildNodesByCache(jsonFile)
	local cache = self:getCache(jsonFile)
	self.uiLoaderUtilitys.addSearchPathIf(cache.dir)

	return cc.uiloader:load(deepcopy(cache.obj), {bJsonStruct = true})
end

--
-- 清除已缓存的布局对象。
--
function GameUILoaderUtils:Clear()
	if self.uiLoaderUtilitys then
		self.uiLoaderUtilitys.clearPath()
	end
	self.uiLoaderUtilitys = nil
	self.cache = nil
end


function GameUILoaderUtils:addCache(jsonFile, dir, convertedTable)
	if self.cache[jsonFile] ~= nil then
		return
	end
	--assert(self.cache[jsonFile] == nil, "[GameUILoaderUtils] 重复添加了缓存，有覆盖的风险！！！")
	self.cache[jsonFile] = {dir = dir, obj = convertedTable}
end

function GameUILoaderUtils:getCache(jsonFile)
	return self.cache[jsonFile]
end

return GameUILoaderUtils