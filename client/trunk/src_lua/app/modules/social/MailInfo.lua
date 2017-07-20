--
-- Author: yangjiacheng    383229800@qq.com
-- Date: 2015-10-11 
-- 邮件信息

MailInfo = MailInfo or class("MailInfo")

--构造
function MailInfo:ctor()	
	self.mails = {}
end

function MailInfo:initMails(mailList)
	self.mails = mailList
	if #self.mails > 1 then
		table.sort(self.mails,function(a,b)
		return a.send_time>b.send_time
	end)
	end
	
end

function MailInfo:pushMail(mailData,isInsertTop)
	if isInsertTop then
		table.insert(self.mails,1,mailData)
	else
		table.insert(self.mails,mailData)
	end
	
end

function MailInfo:deleteMail(mailData)
	for i=1,#self.mails do
		if self.mails[i].id == mailData.id then
			table.remove(self.mails,i)
			return 
		end
	end
end

function MailInfo:changeMail(mailData)
	for i=1,#self.mails do
		if self.mails[i].id == mailData.id then
			self.mails[i] = mailData
			return
		end
	end
	--没找到对应id的邮件信息,则代表是新邮件
	self:pushMail(mailData,true)
	if not MailManager:getInstance().showingMailWin then
		if GlobalController.fight:getScene() then
			if GlobalController.fight:getScene().loading then 			--如果loading界面正在显示,那么等loading完再显示
				self.eventForNewMail = nil 
				local function onShow()
					SystemNotice:newMailNotice()
					GlobalEventSystem:removeEventListenerByHandle(self.eventForNewMail)
					self.eventForNewMail = nil 
				end
				self.eventForNewMail = GlobalEventSystem:addEventListener(GlobalEvent.HIDE_SCENE_LOADING,onShow)
			else
				SystemNotice:newMailNotice()
			end
		end
	end

end

