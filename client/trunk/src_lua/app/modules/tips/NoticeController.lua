--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-10-11 
-- 公告系统控制器
NoticeController = NoticeController or class("NoticeController",BaseController)


function NoticeController:ctor()	
	NoticeController.Instance = self
	self:initProtocal()
end

function NoticeController:startSystemNoticeTask()
	self.stopSystemNoticeTask = false
	function onRequestFinished(event)
	    local ok = (event.name == "completed")
	    local request = event.request

	    if not ok then return end

	    local code = request:getResponseStatusCode()
	    if code ~= 200 then
	        -- 请求结束，但没有返回 200 响应代码
	        print("NoticeController::startSystemNoticeTask()", code)
	        return
	    end
	    -- 请求成功，显示服务端返回的内容
	    local jsonString = request:getResponseString()
	    if jsonString ~= "" then
	    	local data = json.decode(jsonString)
	    	if data then
	    		SystemNotice:showAnnouncement(data.info)
	    	end
	    end
	end
	local channelId = ChannelAPI:getChannelId()
	local request = network.createHTTPRequest(onRequestFinished, GlobalModel.systemNoticeURL.."&chl="..channelId.."&aid="..ChannelAPI:getAppId().."&cps="..ChannelAPI:getSubChannelId(), "GET")
	--local request = network.createHTTPRequest(onRequestFinished, "http://123.206.225.144/chuanqi_mg/index.php?s=/Home/Index/post&istest=0&chl=1000&aid=6012&cps=0", "GET")
	request:start()

	--http://123.206.225.144/chuanqi_mg/index.php?s=/Home/Index/post&istest=0&chl=1000&aid=6012&cps=0
	--"<font color='0xFFFFFF' size='22' opacity='255'>抵制不良游戏，拒绝盗版游戏。<br/><br gap="10"/>    注意自我保护，谨防受骗上当。<br/><br gap="10"/>    适度游戏益脑，沉迷游戏伤身。 <br/><br gap="10"/>    合理安排时间，享受健康生活。<br/><br gap="10"/><br gap="10"/><br gap="10"/></font>"
end



function NoticeController:getInstance()
	if NoticeController.Instance==nil then
		NoticeController.new()
	end
	return NoticeController.Instance
end

function NoticeController:initProtocal( )
	--显示公告
	self:registerProtocal(9999,handler(self,self.onHandle9999))
	--显示提示信息
	self:registerProtocal(9998,handler(self,self.onHandle9998))
end

function NoticeController:onHandle9999(data)
	local content = configHelper:getNoticeContent(data.notice_id,data.arg_list)
	SystemNotice:showWorldNotice({content = content,priority = configHelper:getNoticePriority(data.notice_id)})
	GlobalController.chat:pushSystemMsg(content)
end

function NoticeController:onHandle9998(data)
	if data.result then
		GlobalEventSystem:dispatchEvent(GlobalEvent.GET_ERROR_CODE,ErrorCodeInfoFormat(data.result))
	end
end

function NoticeController:destory()
	if self.handle then
		GlobalEventSystem:removeEventListenerByHandle(self.handle)
	end
end
