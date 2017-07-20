--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-10-12 
-- 错误码管理器
ErrorCodeManager = ErrorCodeManager or class("ErrorCodeManager",BaseManager)

--构造
function ErrorCodeManager:ctor()	
	ErrorCodeManager.Instance=self
end

function ErrorCodeManager:getInstance()
	if ErrorCodeManager.Instance==nil then
		ErrorCodeManager.new()
		ErrorCodeManager.Instance:registerEvent()
	end
	return ErrorCodeManager.Instance
end

function ErrorCodeManager:showNormalErrorInfo(errorCode)
	if ErrorCodeNormalInfo[errorCode] then
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[errorCode])
	else
		GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,"未知错误码:"..errorCode)
	end
end

function ErrorCodeManager:registerEvent()
	local lang =  require("app.conf.languageConfig").new()
	if ErrorCodeNormalInfo == nil then
		ErrorCodeNormalInfo = {}
	end
	for k,v in pairs(lang.datas) do
		ErrorCodeNormalInfo[k] = v[2]
	end
	
	self:unregisterEvent()
	local function onGetErrorCode(data)
		if not data.data.info and data.data.info~="" then 							--如果info为空，那么显示通用错误码提示
        	self:showNormalErrorInfo(data.data.errorCode)
        else 																	--如果info不为空,那么显示info的内容
        	GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,data.data.info)
        end
    end
	self.registerEventId = {}
	self.registerEventId[1] = GlobalEventSystem:addEventListener(GlobalEvent.GET_ERROR_CODE,onGetErrorCode)
end

function ErrorCodeManager:unregisterEvent()
	if self.registerEventId then
		for i=1,#self.registerEventId do
			GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
		end
	end
end
