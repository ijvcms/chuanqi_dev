--
-- Author: Your Name
-- Date: 2015-12-09 17:43:15
--
local CopyRewardInfo = CopyRewardInfo or class("CopyRewardInfo")

function CopyRewardInfo:ctor()
	self.goodsList = {}
end

function CopyRewardInfo:setData(data)

	for i=1,#data do

		local info = {}
		info.goodsId = data[i][1]
		info.goodsBang= data[i][2]
		info.goodsNum = data[i][3]

		table.insert(self.goodsList, info)
		
	end

end

return CopyRewardInfo