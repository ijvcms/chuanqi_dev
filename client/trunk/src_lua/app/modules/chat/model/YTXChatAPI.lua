local YTXChatAPI = class("YTXChatAPI")

local Java_ClassName = "com/rongyao/chuanqi/chat/YTXChatJavaAPI"
local OC_ClassName = "YTXChatLuaAPI"


function YTXChatAPI:ctor()
	local platform = device.platform
	if platform == "ios"  then
		self.callHelper = require("framework.luaoc")
	elseif platform == "android" then
		self.callHelper = require("framework.luaj")
	end
end

 --登陆
 --/*
 -- *uid:用户名
 -- *timestamp:时间戳
 -- *token:票据
 -- *callback:回调函数
 -- *         @result 200 正常登陆
 -- */
function YTXChatAPI:login(uid, timestamp, token, callback)
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "login", {uid = uid,timestamp = timestamp,token = token,callback = callback})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            callback(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "login", {uid,timestamp, token, fun}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V")
	end
end

--播放语音信息
-- /*
--  *mesId:信息ID
--  *isPlayEar:是否耳放
--  *callback:播放完成回调
--  *         @result 错误码 200 成功
--  *
--  */
function YTXChatAPI:playVoiceMessage(mesId, isPlayEar, callback)
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "playVoiceMessage", {mesId = mesId,isPlayEar = isPlayEar, callback = callback})
	elseif platform == "android" then
		self.callHelper.callStaticMethod(Java_ClassName, "playVoiceMessage", {mesId,isPlayEar,callback},"(Ljava/lang/String;Z;I)V")
	end
end

-- 设置接收信息回调的函数
-- /*
--  *handler:收到信息回调函数
--  *         @type 信息类型  1.文本信息  2.语音信息
--  *         @content 文本信息内容或语音信息ID
--  *         @sender  发送者
--  *
--  */
function YTXChatAPI:setOnReceiveEvent(handler)
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "setOnReceiveMessage", {callback = handler})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            handler(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "setOnReceiveMessage", {fun}, "(I)V")
	end
end

-- 开始录音
-- /*
--  *callback:发送信息回调函数
--  *          @result 错误码 200成功
--  *          @mesId  语言信息ID
--  *
--  */
function YTXChatAPI:beginRecordVocie(callback)
	print("call YTXChatAPI:beginRecordVocie")
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "beginRecordVocie", {callback = callback})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            callback(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "beginRecordVocie", {fun}, "(I)V")
	end
end

--停止录音
function YTXChatAPI:cancelRecordVocie()
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "cancelRecordVocie")
	elseif platform == "android" then
		self.callHelper.callStaticMethod(Java_ClassName, "cancelRecordVocie", "()V")
	end
end

-- 结束录音
-- /*
--  *callback:发送信息回调函数
--  *          @result 错误码 200成功
--  *          @mesId  语言信息ID
--  *
--  */
function YTXChatAPI:endRecordVocie(callback)
   print("call YTXChatAPI:endRecordVocie")
   local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "endRecordVoice", {callback = callback})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            callback(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "endRecordVoice", {fun}, "(I)V")
	end
    
end

--录音音震参数回调
-- /*
--  *handler:震动变化回调函数
--  *         @amplitude :震动值
--  *
--  */
function YTXChatAPI:setOnRecordingAmplitude(handler)
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "setOnRecordingAmplitude", {callback = handler})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            handler(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "setOnRecordingAmplitude", {fun}, "(I)V")
	end
end

--发送文本信息
-- /*
--  *conent:文本内容
--  *callback:发送信息回调函数
--  *          @result 错误码 200 成功
--  *          @mesId  语言信息ID
--  *
--  */
function YTXChatAPI:sendTextMessage(content, callback)
    local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "sendTextMessage", {content = content, callback = callback})
	elseif platform == "android" then
		local fun = function (data)
            local ret = self:stringToTable(data)
            callback(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "sendTextMessage", {content, fun} ,"(Ljava/lang/String;I)V")
	end
end

--设置发送信息的接收者
-- /*
--  *arg 参数
--  *receiver:接收者
--  *
--  */
function YTXChatAPI:setReceiver(receiver)
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "setReceiver", {receiver = receiver})
	elseif platform == "android" then
		self.callHelper.callStaticMethod(Java_ClassName, "setReceiver", {receiver}, "(Ljava/lang/String;)V")
	end
end

function YTXChatAPI:stringToTable(str)  
   local ret = loadstring("return "..str)()  
   return ret  
end


function  YTXChatAPI:test()
	print("YTXChatAPI:test()")
	local platform = device.platform
	if platform == "ios"  then
	    self.callHelper.callStaticMethod(OC_ClassName, "test", {callback = handler(self,self.test_callback)})
	elseif platform == "android" then
		local fun = function (data)

            local ret = self:stringToTable(data)
            self:test_callback(ret)
		end
		self.callHelper.callStaticMethod(Java_ClassName, "test", {fun})
	end
end

function YTXChatAPI:test_callback(data)
	print("YTXChatAPI:test_callback========>"..data.result)
end



return YTXChatAPI





