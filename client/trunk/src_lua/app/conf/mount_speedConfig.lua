-- 自动生成，请勿修改 
-- 时间：2016/09/13
-- 21102585@qq.com

local mount_speedConfig = class("mount_speedConfig")
function mount_speedConfig:ctor()
	self.fields = {"res", "speed"}
	self.datas = {
		[9203] = {9203, 110},
		[9202] = {9202, 120},
		[9201] = {9201, 130},
		[9204] = {9204, 140},
		[9205] = {9205, 150},

	}
end
return mount_speedConfig
