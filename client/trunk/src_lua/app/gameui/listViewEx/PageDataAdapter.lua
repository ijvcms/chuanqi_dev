--分页数据适配器
--@author shine

local DataAdapter = import(".DataAdapter")

local PageDataAdapter =  class("PageDataAdapter", DataAdapter)


function PageDataAdapter:ctor(pageSize)
	PageDataAdapter.super.ctor(self)
	self.pageSize = pageSize or 20
	self.rowLoaded = 0
end

function PageDataAdapter:clearData()
	PageDataAdapter.super.clearData(self)
	self.rowLoaded = 0
end


--必须继承
function PageDataAdapter:getView(position, convertView, parent)
	self:checkData(position)
end

--是否需要获取先数据
function PageDataAdapter:checkData(position)
	if self.rowLoaded < position then
		self.rowLoaded = position
		if self.rowLoaded == self.curDataLength - math.floor(self.pageSize / 2) and self.requestDataFunc then --剩下Size的一半就加载数据
			self.requestDataFunc(math.ceil(self.rowLoaded / self.pageSize) + 1)
		end
	end
end

--设置请求数据函数
function PageDataAdapter:setRequestDataFunc(handler)
	self.requestDataFunc = handler
end

return PageDataAdapter