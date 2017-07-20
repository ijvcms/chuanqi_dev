--
-- Author: shine
-- Date: 2016-07-28 
-- 趣味答题控制器

AnsweringController = AnsweringController or class("AnsweringController", BaseController)

function AnsweringController:ctor()
	if AnsweringController.instance == nil then
		self:registerProtocal(32030, handler(self,self.onHandle32030))
		self:registerProtocal(32032, handler(self,self.onHandle32032))
		self:registerProtocal(32031, handler(self,self.onHandle32031))
		self:registerProtocal(32033, handler(self,self.onHandle32033))
	end
	AnsweringController.instance = self
end

--参加活动
function AnsweringController:start()
	self:sendMsgToSocket(32030, nil)
end

--获取积分排名
function AnsweringController:requestRankList(func)
	self.rankListFunc = func;
    self:sendMsgToSocket(32032, nil)
end

function AnsweringController:answerTest(idx, choice)
	self:sendMsgToSocket(32031, {ex_index = idx, choice = choice})
end

function AnsweringController:setAnswerResultListener(func)
	self.answerFunc = func
end

function AnsweringController:useTools(idx, tool, func)
	self.toolsFun = func
	self:sendMsgToSocket(32033, {ex_index = idx, type = tool})
end

function AnsweringController:onHandle32030(data)
	if data.result == 0 then
		GlobalWinManger:openWin(WinName.ANSWERINGMAINWIN, data)
	else
	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
	
end

function AnsweringController:onHandle32031(data)
	if data.result == 0 then
		if self.answerFunc then
		    self.answerFunc(data)
	    end	
	else
	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
end

function AnsweringController:onHandle32032(data)
	if self.rankListFunc then
		self.rankListFunc(data)
	end
	self.rankListFunc = nil
	
end

function AnsweringController:onHandle32033(data)
	if data.result == 0 then
		if self.toolsFun then
		    self.toolsFun(data)
	    end	
	else
	    GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_SYSTIPS,ErrorCodeNormalInfo[data.result])
	end
	self.toolsFun = nil
end





