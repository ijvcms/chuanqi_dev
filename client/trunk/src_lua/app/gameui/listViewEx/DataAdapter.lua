--数据适配器
--@author shine
--注意setData（）和clearData（）的使用
--采用self.curDataLength 记录数据的长度来清理数据，而不是使用self.data ={}，提高性能
--所以获取数据必须用getCount()
--如果外部修改了self.data，需要调用同步syncData

local DataAdapter =  class("DataAdapter")


function DataAdapter:ctor()
	self.data = {}
	self.curDataLength = 0 --数据指针
end

function DataAdapter:setData(data,needSetPosition)

	self.data = data
	self.curDataLength = #self.data
	self.listView.rowLoaded = 0
    self.listView.isToBottom = false

    if needSetPosition and needSetPosition == true and self.listView:getFirstItem() then
    	local postion = self.listView:getScrollPosition()
		self.listView:reload()
		self.listView:scrollTo(postion)
	else
		self.listView:reload()
    end
    
end

function DataAdapter:insertData(data, position, needRefresh)
	self.curDataLength = self.curDataLength + 1
	if position then
		table.insert(self.data, position, data)
	else
		table.insert(self.data, self.curDataLength, data)
	end
	if needRefresh then
		self.listView:reload()
	end
	
end

--增加数据
function DataAdapter:addData(data, needRefresh)
	for i = 1, #data do
		self.curDataLength = self.curDataLength + 1
		table.insert(self.data, self.curDataLength, data[i])
	end
	if needRefresh then
		self.listView:reload()
	end
end

function DataAdapter:removeData(position)

	if self.data and #self.data >= position then
		table.remove(self.data,position)
	end
end

function DataAdapter:clearData()
	self.curDataLength = 0
	self.data = {}
	self.listView.rowLoaded = 0
    self.listView.isToBottom = false
	self.listView:reload()
end

function DataAdapter:getData()
	return self.data
end


--获取数量
function DataAdapter:getCount()
	return self.curDataLength
end


function DataAdapter:getItem(position)
	return self.data[position]
end

--自己实现
--@param  position item位置
--@param  convertView 如果不为nil，就是重复利用
--@param  parent listview
--@return 返回UIListViewItem
function DataAdapter:getView(position, convertView, parent)

end

function DataAdapter:setListView_(listView)
	self.listView = listView
end

--同步数据
--由于外部对整个数据源修改了，才调用
function DataAdapter:syncData(needRefresh)
	self.curDataLength = #self.data
	if needRefresh then
		self.listView:reload()
	end
end

function DataAdapter:destory()
end

return DataAdapter