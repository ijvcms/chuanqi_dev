-- 自动生成，请勿修改 
-- 时间：2016/02/27
-- 21102585@qq.com

local npctransportConfig = class("npctransportConfig")
function npctransportConfig:ctor()
	self.fields = {"id", "transportId", "type", "name", "npcId"}
	self.datas = {
		[1] = {1, 101, 1, "新手村", 7507},
		[2] = {2, 102, 1, "比奇城", 7507},
		[3] = {3, 103, 1, "沙巴克", 7507},
		[4] = {4, 104, 2, "矿洞", 7507},
		[5] = {5, 105, 2, "沃玛", 7507},

	}
end
return npctransportConfig
