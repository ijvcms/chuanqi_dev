--排行榜控制器
local RankWinController = class("RankWinController", BaseController)


--获取到数据
function RankWinController:setOnDataGetFunc(fun)
	self:registerProtocal(32009,fun)
	self:registerProtocal(32010,fun)
	self:registerProtocal(32011,fun)
end



--请求数据
--key  协议号
--param 筛选参数
--page 页数
function RankWinController:requestData(key, param, page)
	self.key = key
	self.type = param
	self.page = page
	self:sendMsgToSocket(key, {type = param, page = page})
end

--继续请求分页数据
function RankWinController:requestPageData(page)
	if page == self.page then
		return
	end
	self.page = page
	self:sendMsgToSocket(self.key, {type = self.type, page = page})
end


function RankWinController:clean()
	self:unRegisterProtocal(32009)
	self:unRegisterProtocal(32010)
	self:unRegisterProtocal(32011)
end




return RankWinController