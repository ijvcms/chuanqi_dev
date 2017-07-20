--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-07 17:53:12
--

--[[
	引导通知事件对象
	==========
		此对象用于引导模块的抛出目标，并在通知到对应处理模块的时候自动销毁。
		通常，此对象由外部模块请求产生，用以说明用户当前进行了与引导相关的何种操作。
		因此，此对象封装了有关对当前引导操作的反馈。凡是与引导相关的操作，都应当抛出一个引导事件。
		此事件会被引导模块的主控制器GuideController传递给引导处理器GuideProcessor来进行处理。
]]

local GuideNotifyEvent = class("GuideNotifyEvent")

GuideNotifyEvent.TYPE_CONFIRM     = 1 -- 确认类型，遇到此类型应该走向下一步
GuideNotifyEvent.TYPE_DEMAND_BACK = 2 -- 需求反馈类型，此类型一般为外部模块对处理器的需求响应。

function GuideNotifyEvent:ctor()
end

--[[
	事件类型
	不同的事件类型需要定义，以便处理器来进行区分。
]]
function GuideNotifyEvent:setType(type) self._type = type end
function GuideNotifyEvent:getType() return self._type end

--[[
	设置当前事件标识，每一个外部模块在抛出引导事件之前都需要设置这个属性。
	用以表明当前这个引导事件是通过哪个功能发出的，处理器根据自身当前的引导命令来过滤这些引导事件，并选择自己感兴趣的事件来进行处理。
]]
function GuideNotifyEvent:setIdentify(identify) self._identify = identify end
function GuideNotifyEvent:getIdentify() return self._identify end

--[[
	事件所携带的数据。
	一般来说，每个引导操作都应当携带不同的数据用于当前引导处理来进行处理。
	例如，需求反馈类型就需要携带处理器请求的数据信息，因为需求广播之后，处理器就会等待事件反馈事件。
]]
function GuideNotifyEvent:setData(data) self._data = data end
function GuideNotifyEvent:getData() return self._data end

function GuideNotifyEvent:clear()
	self._type    = nil
	self._data    = nil
end

function GuideNotifyEvent:recycle()
	self:clear()
end

function GuideNotifyEvent:destory()
	self:clear()
end

return GuideNotifyEvent