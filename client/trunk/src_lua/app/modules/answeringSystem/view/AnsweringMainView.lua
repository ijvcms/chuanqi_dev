local AnsweringMainView = class("AnsweringMainView", BaseView)

function AnsweringMainView:ctor(winTag,data,winconfig)
    AnsweringMainView.super.ctor(self,winTag,data,winconfig)
    self.curQuestion = 0 --当前题目
	self.questionIdx = {1, 2, 3, 4}
   	self:init()
   	self:setData(data)
end


function AnsweringMainView:init()
	self.answerLayer = self:seekNodeByName("answerLayer")
	self.answerLayer:setCascadeOpacityEnabled(true)
	self.closeBtn = self:seekNodeByName("closeBtn")
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            self.closeBtn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            self.closeBtn:setScale(1.0)
	            GlobalWinManger:closeWin(self.winTag)	        
			end     
	        return true
    end)
    self.activityTime = self:seekNodeByName("activityTime")
    self.timeLabel = self:seekNodeByName("timeLabel")
    self.topicNum = self:seekNodeByName("topicNum")
    local contentLayer = self:seekNodeByName("topicLayer")
    self.contentLayerH = contentLayer:getContentSize().height
    self.content = SuperRichText.new("", contentLayer:getContentSize().width)
    contentLayer:addChild(self.content)
    self.aBtn = self:seekNodeByName("btn1")
    self:initAnswerBtn(self.aBtn)
    self.aLabel = cc.uiloader:seekNodeByName(self.aBtn, "answer1")
    self.bBtn = self:seekNodeByName("btn2")
    self:initAnswerBtn(self.bBtn)
    self.bLabel = cc.uiloader:seekNodeByName(self.bBtn, "answer2")
    self.cBtn = self:seekNodeByName("btn3")
    self:initAnswerBtn(self.cBtn)
    self.cLabel = cc.uiloader:seekNodeByName(self.cBtn, "answer3")
    self.dBtn = self:seekNodeByName("btn4")
    self:initAnswerBtn(self.dBtn)
    self.dLabel = cc.uiloader:seekNodeByName(self.dBtn, "answer4")
    self.toolsBtn1 = self:seekNodeByName("toolsBtn1")
    self:initToolBtn(self.toolsBtn1, 1)
    self.toolsBtn2 = self:seekNodeByName("toolsBtn2")
    self:initToolBtn(self.toolsBtn2, 2)
    self.toolsBtn3 = self:seekNodeByName("toolsBtn3")
    self:initToolBtn(self.toolsBtn3, 3)
    local rankLayer = self:seekNodeByName("rankLayer")
    local size = rankLayer:getContentSize()
    local params = {direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, viewRect = cc.rect(0, 0, size.width, size.height)}
    self.rankList = require("app.gameui.listViewEx.UIAsyncListView").new(params)
    self.rankList:setContentSize(size)
    self.rankList:setPosition(0, 0)
    self.rankListAdapter = require("app.gameui.listViewEx.GeneralPageDataAdapterEx").new("resui/examinationMainItem.ExportJson", "app.modules.answeringSystem.view.AnsweringRankItem", 20)
    self.rankList:setAdapter(self.rankListAdapter)
    rankLayer:addChild(self.rankList)
    self.rankLabel = self:seekNodeByName("rankLabel")
    self.pointLabel = self:seekNodeByName("pointLabel")
    self.accuracyLabel = self:seekNodeByName("accuracyLabel")
    self.expLabel = self:seekNodeByName("expLabel")
    self.coinLabel = self:seekNodeByName("coinLabel")

end

function AnsweringMainView:initAnswerBtn(btn)
	btn:setCascadeOpacityEnabled(true)
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            if self.answerTimeHandler then
	                GlobalTimer.unscheduleGlobal(self.answerTimeHandler)
	            end
	            self.aBtn:setTouchEnabled(false)
	            self.bBtn:setTouchEnabled(false)
	            self.cBtn:setTouchEnabled(false)
	            self.dBtn:setTouchEnabled(false)
	            GlobalController.answeringController:answerTest(self.curQuestion, btn:getTag())       
			    self.selectBtn = btn

			end     
	        return true
    end)
end

function AnsweringMainView:initToolBtn(btn, tool_type)
	btn:setTouchEnabled(true)
    btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
	        if event.name == "began" then
	        	btn:setScale(1.1)
	            SoundManager:playClickSound()
	        elseif event.name == "ended" then
	            btn:setScale(1.0)
	            if self.curQuestion <= #self.ex_ids then
	            	GlobalController.answeringController:useTools(self.curQuestion, tool_type, handler(self, self.handleUseToolsResult))       
			    end
			end     
	        return true
    end)
end

function AnsweringMainView:setData(data)
	self.allTimeLeft = data.time_left
	self.tool1Count = data.tools1
	self.tool2Count = data.tools2
	self.tool3Count = data.tools3
	self.ex_ids = data.ex_ids
	self.topicNum:setString("1/"..#self.ex_ids)
    self.rankLabel:setString(tostring(data.rank))
	self:setAllTimeLeft()
	local fun = function()
	    self.allTimeLeft = self.allTimeLeft - 1
	    self:setAllTimeLeft()
	    if  self.allTimeLeft == 0 then
	    	if self.allTimeHandler then
	    		GlobalTimer.unscheduleGlobal(self.allTimeHandler)
	    	end
	        self:timeUp()
	    end
    end
	self.allTimeHandler = GlobalTimer.scheduleGlobal(fun, 1)
	self:initTools(self.toolsBtn1, self.tool1Count, "exam_tool1_1.png", "exam_tool1_2.png")
	self:initTools(self.toolsBtn2, self.tool2Count, "exam_tool2_1.png", "exam_tool2_2.png")
	self:initTools(self.toolsBtn3, self.tool3Count, "exam_tool3_1.png", "exam_tool3_2.png")
	GlobalController.answeringController:requestRankList(handler(self, self.initRankList))
	GlobalController.answeringController:setAnswerResultListener(handler(self, self.handleAnswerResult))
end

function AnsweringMainView:initRankList(data)
	self.ranks = data.ranks
	self.rankListAdapter:setData(data.ranks)
end

function AnsweringMainView:timeUp()
	self:seekNodeByName("timeUpLayer"):setVisible(true)
	self.answerLayer :setVisible(false)
end

function AnsweringMainView:finish()
	self:stopTimer()
	self.timeLabel:setString("0")
	self:seekNodeByName("gameoverLayer"):setVisible(true)
	self.answerLayer:setVisible(false)
end

function AnsweringMainView:setAllTimeLeft()
	local hour = math.floor(self.allTimeLeft / 3600)
	local left = self.allTimeLeft - hour * 3600
	local min = math.floor(left / 60)
	local sec = left - min * 60
	local strText
	if hour > 9 then
		strText = hour..":"
	else
		strText = "0"..hour..":"
	end
	if min > 9 then
		strText = strText..min..":"
	else
		strText = strText.."0"..min..":"
	end
	if sec > 9 then
		strText = strText..sec
	else
		strText = strText.."0"..sec
	end
	self.activityTime:setString(strText) 
end

function AnsweringMainView:initTools(root, count, enableImg, disableImg)
	local index = 1
	while  index <= count do
		local  toolsSp = cc.uiloader:seekNodeByName(root, "tools"..index)
		toolsSp:setSpriteFrame(enableImg)
		index = index + 1
	end
	while  index <= 3 do
		local  toolsSp = cc.uiloader:seekNodeByName(root, "tools"..index)
		toolsSp:setSpriteFrame(disableImg)
		index = index + 1
	end
end

function AnsweringMainView:handleAnswerResult(data)
	if self.selectBtn ~= nil then
	    self.answerSp = cc.uiloader:seekNodeByName(self.selectBtn, "signal")
	    self.answerSp:setVisible(true)
	    if data.is_right == 1 then
		    self.answerSp:setSpriteFrame("exam_true.png")
	    else
		    self.answerSp:setSpriteFrame("exam_false.png")
	    end
	    self.selectBtn = nil
    end
	self.rankLabel:setString(tostring(data.rank))
    self.pointLabel:setString(tostring(data.total_score))
    self.accuracyLabel:setString(data.right_num.."/"..(data.right_num + data.error_num))
    self.expLabel:setString(tostring(data.exp))
    self.coinLabel:setString(tostring(data.coin))
    self:refreshRankData(data.rank, data.total_score)
	self:toNextQuestion()
end

function AnsweringMainView:handleUseToolsResult(data)
	if data.type == 1 then
		self.tool1Count = data.tools_num
		self:initTools(self.toolsBtn1, data.tools_num, "exam_tool1_1.png", "exam_tool1_2.png")
	elseif data.type == 2 then
		for i = 1, #data.params do
			local ex_id =  tonumber(data.params[i], 10)
			if self.aBtn:getTag() == ex_id then
				self:hideAnswerBtn(self.aBtn)
			elseif self.bBtn:getTag() == ex_id then
				self:hideAnswerBtn(self.bBtn)
			elseif self.cBtn:getTag() == ex_id then
				self:hideAnswerBtn(self.cBtn)
			else
				self:hideAnswerBtn(self.dBtn)
			end
		end
		self.tool2Count = data.tools_num
		self:initTools(self.toolsBtn2, data.tools_num, "exam_tool2_1.png", "exam_tool2_2.png")
    elseif data.type == 3 then
    	self.tool3Count = data.tools_num
    	self:initTools(self.toolsBtn3, data.tools_num, "exam_tool3_1.png", "exam_tool3_2.png")
	end
end 

function  AnsweringMainView:hideAnswerBtn(btn)
	btn:setTouchEnabled(false)
	transition.execute(btn, cc.FadeOut:create(0.3), {easing = "out"})
end

function AnsweringMainView:toNextQuestion()
	local sequence = transition.sequence({
		    cc.FadeOut:create(0.4),
		    cc.CallFunc:create(handler(self, self.nextQuestion)),
		    cc.FadeIn:create(0.4),
		    cc.CallFunc:create(handler(self, self.setAnswerBtnEnable)),})
	self.answerLayer:runAction(sequence)

end

function AnsweringMainView:setAnswerBtnEnable()
	self.aBtn:setTouchEnabled(true)
	self.bBtn:setTouchEnabled(true)
	self.cBtn:setTouchEnabled(true)
	self.dBtn:setTouchEnabled(true)
end

function AnsweringMainView:nextQuestion()
	if self.answerSp then
		self.answerSp:setVisible(false)
	end
	self.curQuestion = self.curQuestion + 1
	if self.curQuestion > #self.ex_ids then
		self:finish()
		return
	end
	self.topicNum:setString(self.curQuestion.."/"..#self.ex_ids)
	local questionData = configHelper:getQuestionConfig()[self.ex_ids[self.curQuestion]]
    self.content:renderXml("<font color='0x000000' size='20'>"..self.curQuestion..". "..questionData.title.."</font>")
    local y =  self.contentLayerH - self.content:getContentSize().height
    self.content:setPositionY(y)
    self:sort()
    local idx = self.questionIdx[1]
	self.aLabel:setString(questionData["selection"..idx])
	self.aBtn:setTag(idx)
	self.aBtn:stopAllActions()	
	self.aBtn:setOpacity(255)
	idx = self.questionIdx[2]
	self.bLabel:setString(questionData["selection"..idx])
	self.bBtn:setTag(idx)
	self.bBtn:stopAllActions()
	self.bBtn:setOpacity(255)
	idx = self.questionIdx[3]
	self.cLabel:setString(questionData["selection"..idx])
	self.cBtn:setTag(idx)
	self.cBtn:stopAllActions()
	self.cBtn:setOpacity(255)
	idx = self.questionIdx[4]
	self.dLabel:setString(questionData["selection"..idx])
	self.dBtn:setTag(idx)
	self.dBtn:stopAllActions()
	self.dBtn:setOpacity(255)
	if self.answerTimeHandler then
	    GlobalTimer.unscheduleGlobal(self.answerTimeHandler)
	end
	self.answerTimeLeft = 10
	self:setAnswerTimeLeft()
	local fun = function()
	    self.answerTimeLeft = self.answerTimeLeft - 1
	    self:setAnswerTimeLeft()
	    if  self.answerTimeLeft == 0 then
	    	self:setAnswerTimeLeft()
	    	if self.answerTimeHandler then
	            GlobalTimer.unscheduleGlobal(self.answerTimeHandler)
	        end
	        self:toNextQuestion()
	    end
    end
    self.answerTimeHandler = GlobalTimer.scheduleGlobal(fun, 1)
end

function AnsweringMainView:sort()
	math.newrandomseed()
	for i = 1 , #self.questionIdx do
		for j = i + 1, #self.questionIdx do
			if math.random() > 0.5 then
				local tmp = self.questionIdx[i]
				self.questionIdx[i] = self.questionIdx[j]
				self.questionIdx[j] = tmp
			end
		end
	end
end

function AnsweringMainView:setAnswerTimeLeft()
	self.timeLabel:setString(tostring(self.answerTimeLeft))
end

function AnsweringMainView:refreshRankData(rank, points)
	if rank < #self.ranks then
		return
	end
	if rank == #self.ranks and self.ranks[rank].name == RoleManager:getInstance().roleInfo.name then
		self.ranks[rank].score = points
		self.rankListAdapter:setData(self.ranks)
		return
	end
	table.insert(self.ranks, rank, {name = RoleManager:getInstance().roleInfo.name, score = points, rank = rank})
	table.remove(self.ranks)
	self.rankListAdapter:setData(self.ranks)
end

--打开界面
function AnsweringMainView:open()
	self:nextQuestion()
end

function AnsweringMainView:stopTimer()
	if  self.answerTimeHandler then
		GlobalTimer.unscheduleGlobal(self.answerTimeHandler)
	end
	self.answerTimeHandler = nil
	if self.allTimeHandler then
		GlobalTimer.unscheduleGlobal(self.allTimeHandler)
	end
    self.allTimeHandler = nil
end

--关闭界面
function AnsweringMainView:close()
	self:stopTimer()
end

function AnsweringMainView:destory()
	if self.isDestory then return end
	self:close()
	GlobalController.answeringController:setAnswerResultListener(nil)
    AnsweringMainView.super.destory(self)
    self.rankList:onCleanup()--记得清理资源
    self.rankListAdapter:destory()
end


return AnsweringMainView






