--
-- Author: casen
-- Date: 2015-10-01 
-- 社交窗口
local SocialWin = class("SocialWin", BaseView)

local itemTipsWin = require("app.modules.tips.view.itemTipsWin")

local equipTipsWin = require("app.modules.tips.view.equipTipsWin")

-- local configHelper = import("app.utils.ConfigHelper").getInstance()

local mailManager = MailManager:getInstance()

import("app.utils.EquipUtil")

function SocialWin:ctor(winTag,data,winconfig)
    SocialWin.super.ctor(self,winTag,data,winconfig)
    self:creatPillar()
    local root = self:getRoot()
    root:setTouchEnabled(true)
    root:setTouchSwallowEnabled(true)
    local win  = cc.uiloader:seekNodeByName(root,"win")
    self.win = win

    --
    self.leftLayer = cc.uiloader:seekNodeByName(win,"leftLayer")
    self.rightLayer = cc.uiloader:seekNodeByName(win,"rightLayer")

    --
    --self:refreshCoin()

    --注册监听事件
    self:registerEvent()

    --打开时选中行会标签
    self:onTagBtnClick(2)

end

--刷新金币
function SocialWin:refreshCoin()
   --[[
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo

    local wealthInfo = roleManager.wealth

    --金币值
    self:setCoinValue(1, wealthInfo.coin or 0)

    --金锭(元宝值)
    self:setCoinValue(2, wealthInfo.jade or 0)

    --礼券
    self:setCoinValue(3, wealthInfo.gift or 0)
    --]]
end

--金币点击回调
--coinType:金币类型,1:金币 2:金锭 3:银票
function SocialWin:onCoinClick(coinType)
    -- body
end

--设置金币数
--coinType:金币类型,1:金币 2:金锭 3:银票
--value:金币数
function SocialWin:setCoinValue(coinType,value)
    --[[
    local coinLabel
    if coinType == 1 then               --金币
        coinLabel = self.coin1Label
    elseif coinType == 2 then           --金锭
        coinLabel = self.coin2Label
    elseif coinType == 3 then           --银票
        coinLabel = self.coin3Label
    end

    if coinLabel then
        coinLabel:setString(value)
    end
    --]]
end

--标签按钮点击回调
--tagBtnIndex:标签按钮类型,2:好友 3:行会
function SocialWin:onTagBtnClick(tagBtnIndex)
    --[[
    local function showCoin(b)
        self.coin1:setVisible(b)
        self.coin2:setVisible(b)
        self.coin3:setVisible(b)
        self.coin1Label:setVisible(b)
        self.coin2Label:setVisible(b)
        self.coin3Label:setVisible(b)
    end
    
    if not self.tagBtns[tagBtnIndex] then return end

    if self.curTagBtnIndex and self.curTagBtnIndex == tagBtnIndex then
        return
    else
        if self.curTagBtnIndex then
            local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
            sp:setVisible(false)
        end
        self.curTagBtnIndex = tagBtnIndex
        local sp = cc.uiloader:seekNodeByName(self.tagBtns[self.curTagBtnIndex],"selected")
        sp:setVisible(true)
    end
    --]]
    if tagBtnIndex == 2 then
        cc.uiloader:seekNodeByName(self.rightLayer,"guildWin_bg"):setVisible(false)
       if not self.friendLayer then
            self.friendLayer = require("app.modules.social.view.FriendView").new()
            self.leftLayer:addChild(self.friendLayer)
            self.friendLayer:setPosition(31, 130)
        else
            self.friendLayer:setVisible(true)
        end
        --[[
        if self.l_mailLayer then
            self.l_mailLayer:setVisible(false)
        end
        if self.r_mailLayer then
            self.r_mailLayer:setVisible(false)
        end

        if self.guildWin then
            self.guildWin:setVisible(false)
        end
        
        if self.guildOperatePage and self.guildOperatePage.pages and self.guildOperatePage.pages[1] and self.guildOperatePage.pages[1].inputLab then
            self.guildOperatePage.pages[1].inputLab:setVisible(false)
        end
        --]]
        --showCoin(false)
    elseif tagBtnIndex == 3 then
        cc.uiloader:seekNodeByName(self.rightLayer,"guildWin_bg"):setVisible(false)
        if not self.l_mailLayer then
            self.l_mailLayer = cc.uiloader:load("resui/socialWin_l_mailLayer.ExportJson")
            self.leftLayer:addChild(self.l_mailLayer)
        else
            self.l_mailLayer:setVisible(true)
        end
        if not self.r_mailLayer then
            self.r_mailLayer = cc.uiloader:load("resui/socialWin_r_mailLayer.ExportJson")
            self.rightLayer:addChild(self.r_mailLayer)
        else
            self.r_mailLayer:setVisible(true)
        end
        self:initMail()
        GlobalEventSystem:dispatchEvent(MailEvent.MAIL_WIN_STATE_CHANGE,true)
        if self.guildWin then
            self.guildWin:setVisible(false)
        end

        if self.guildOperatePage and self.guildOperatePage.pages and self.guildOperatePage.pages[1] and self.guildOperatePage.pages[1].inputLab then
            self.guildOperatePage.pages[1].inputLab:setVisible(false)
        end

        if self.friendLayer then
            self.friendLayer:setVisible(false)
        end

        --showCoin(true)
    end

end

--刷新邮件列表
function SocialWin:initMail()
    local mailList = mailManager.mailInfo.mails

    self.mailList = {}
    self.mailItems = {}
    self.mailContentItems = {}
    
    local mailCount = #mailList

    if not self.mailLv then
        local MAILUIListView = require("app.modules.social.view.MAILUIListView")
        self.mailLv = MAILUIListView.new({
                direction=1,
                viewRect={x=0,y=0,width = 330, height = 420}
            })
        self.mailLv:setPosition(31,115)
        self.l_mailLayer:addChild(self.mailLv)
    else
        self.mailLv:removeAllItems()
        self.curMail = nil
        self.curMailItemSp = nil
    end 

    for i=1,mailCount do
        self:pushMailItem(mailList[i],true,false)
    end
    self.mailLv:reload()
end

function SocialWin:pushMailItem(mailData,isInit,isInsertTop)
    local item = self.mailLv:newItem()
    local content = display.newNode()

    local sp = display.newScale9Sprite("#com_listBg1.png", 0, 0, cc.size(333,101))
    sp:setTouchEnabled(true)
    sp:setTouchSwallowEnabled(false)

    local selected = display.newScale9Sprite("#com_listBg1Sel.png", 0, 0, cc.size(333,101))
    sp:addChild(selected)
    selected:setTag(10)
    selected:setVisible(false)
    selected:setPosition(sp:getContentSize().width/2, sp:getContentSize().height/2)

    local itembg = display.newSprite("#com_propBg1.png")
    sp:addChild(itembg)
    itembg:setPosition(sp:getContentSize().width/2-100, sp:getContentSize().height/2)

    local itemSp 
    if mailData.state ~= 1 then
        itemSp = display.newSprite("common/mail_read.png")
    else
        itemSp = display.newSprite("common/mail_readed.png")
    end
    itembg:addChild(itemSp)
    itemSp:setPosition(itembg:getContentSize().width/2, itembg:getContentSize().height/2)


    local title = display.newTTFLabel({
        font = "Marker Felt",
        text = mailData.title,
        size = 20,
        color = TextColor.TEXT_O})
    title:setAnchorPoint(0,0.5)
    sp:addChild(title)
    title:setPosition(sp:getContentSize().width/2-50, sp:getContentSize().height/2+10)

    local date= display.newTTFLabel({
        font = "Marker Felt",
        text = os.date("%Y-%m-%d   %H:%M",mailData.send_time),
        size = 20,
        color = TextColor.TEXT_O})
    sp:addChild(date)
    date:setPosition(sp:getContentSize().width/2+40, sp:getContentSize().height/2-25)

    
    content:addChild(sp)
    sp:setTag(10)
    item:addContent(content)
    --content:setTag(10)
    -- if i==1 then
    --     item:setItemSize(333,101+5*3)
    --     sp:setPositionY(sp:getPositionY()-(5*3/2-5))
    -- else
        item:setItemSize(333,101+5*2)
    -- end
    if isInsertTop then --插到最上面
        self.mailLv:addItem(item, 1)
        table.insert(self.mailItems,1,item)
        table.insert(self.mailContentItems,1,itemSp)
        table.insert(self.mailList,1,mailData)
        self.mailList[1].mailIndex = 1
        for i=2,#self.mailList,1 do
            self.mailList[i].mailIndex = self.mailList[i].mailIndex+1
        end
    else
        self.mailLv:addItem(item)
        table.insert(self.mailItems,item)
        table.insert(self.mailContentItems,itemSp)
        table.insert(self.mailList,mailData)
        self.mailList[#self.mailList].mailIndex = #self.mailList
    end
    
    sp:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.curMail = mailData
            if not self.curMailItemSp then
                self.curMailItemSp = sp
                self.curMailItemSp:getChildByTag(10):setVisible(true)
            else
                self.curMailItemSp:getChildByTag(10):setVisible(false)
                self.curMailItemSp = sp
                self.curMailItemSp:getChildByTag(10):setVisible(true)
            end
            self:refreshMailContent(mailData.mailIndex)
        end     
        return true
    end)
    
    if not isInit then
        self.mailLv:reload()
    end


end

function SocialWin:refreshMailContent(mailIndex)
    if not self.mailList then return end
    local mailData = self.mailList[mailIndex]
    if not mailData then return end

    --文字内容
    local content = cc.uiloader:seekNodeByName(self.r_mailLayer,"content")
    content:setString(mailData.content)
    content:setVisible(false)
     if mailData.content ~= nil and  RichTextHelper.checkIsXmlString(mailData.content) then   

        if self.r_mailLayer:getChildByTag(111) then
            self.r_mailLayer:getChildByTag(111):renderXml(mailData.content)
            self.r_mailLayer:getChildByTag(111):setVisible(true)
        else
            local srt = SuperRichText.new(mailData.content, content:getContentSize().width)
            self.r_mailLayer:addChild(srt)
            srt:setPosition(content:getPositionX(), content:getPositionY())
            srt:setTag(111)
        end
        content:setVisible(false)
    else
        if self.r_mailLayer:getChildByTag(111) then
            self.r_mailLayer:getChildByTag(111):setVisible(false)
        end
        content:setVisible(true)
    end
    --附件物品
    for i=1,5 do
        local item = cc.uiloader:seekNodeByName(self.r_mailLayer,"item"..i)
        if item then
            item:setVisible(false)
        end
        local itemName = cc.uiloader:seekNodeByName(self.r_mailLayer,"labItem"..i)
        if itemName then
            itemName:setVisible(false)
        end
    end

    if mailData.award and #mailData.award>0 then
        for i=1,#mailData.award do
            --物品图标
            local item = cc.uiloader:seekNodeByName(self.r_mailLayer,"item"..i)
            if item then
                item:setVisible(true)
                if item:getChildByTag(10) then
                    item:removeChildByTag(10, true)
                end
                local commonItem = CommonItemCell.new()
                commonItem:setData(mailData.award[i])
                commonItem:setTag(10)
                item:addChild(commonItem)
                commonItem:setPosition(item:getContentSize().width/2,item:getContentSize().height/2)
                local goodType = configHelper:getGoodTypeByGoodId(mailData.award[i].goods_id)
                if goodType then
                    if goodType == 1 or goodType == 3 or goodType == 4 or goodType == 6 or goodType == 5 then      --如果是道具或宝石，需要显示数量
                        commonItem:setCountVisible(true)
                        commonItem:setCount(mailData.award[i].num)
                    end
                end
                --[[
                commonItem:setItemClickFunc(function()
                    local goodType = configHelper:getGoodTypeByGoodId(mailData.award[i].goods_id)
                    if not goodType then return end
                    
                    if goodType == 2 then           --装备
                        local eTWin = equipTipsWin.new()
                        eTWin:setData(EquipUtil.formatEquipItem(mailData.award[i]))
                        eTWin.btnSell:setVisible(false)
                        eTWin.btnPutOn:setVisible(false)
                        eTWin.btnTakeOff:setVisible(false)
                        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,eTWin)
                    elseif goodType == 1 or goodType == 3 then      --道具
                        local itWin = itemTipsWin.new()
                        itWin:setData(mailData.award[i])
                        itWin.btnUse:setVisible(false)
                        itWin.btnSell:setVisible(false)
                        GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,itWin)
                    end
                end) 
                --]]
            end

            --物品名
            local itemName = cc.uiloader:seekNodeByName(self.r_mailLayer,"labItem"..i)
            if itemName then
                itemName:setVisible(true)
                itemName:setString(configHelper:getGoodNameByGoodId(mailData.award[i].goods_id))
            end
        end

        -- for i=#mailData.award+1,3,1 do
        --     local item = cc.uiloader:seekNodeByName(self.r_mailLayer,"item"..i)
        --     if item then
        --         item:setVisible(false)
        --     end
        --     local itemName = cc.uiloader:seekNodeByName(self.r_mailLayer,"labItem"..i)
        --     if itemName then
        --         itemName:setVisible(false)
        --     end
        -- end
    end

    --显示提取附件还是显示删除邮件
    local btnPick = cc.uiloader:seekNodeByName(self.r_mailLayer,"btnPick")
    btnPick:setTouchEnabled(true)
    if not self.btnPickListener then
        btnPick:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                btnPick:setScale(1.2)
                SoundManager:playClickSound()
            elseif event.name == "ended" then
                btnPick:setScale(1.0)
                self:onMailPickClick(self.curMail)
            end     
            return true
        end)
        self.btnPickListener = true
    end
    
    local btnDel = cc.uiloader:seekNodeByName(self.r_mailLayer,"btnDel")
    btnDel:setTouchEnabled(true)
    if not self.btnDelListener then
        btnDel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                btnDel:setScale(1.2)
                SoundManager:playClickSound()
            elseif event.name == "ended" then
                btnDel:setScale(1.0)
                self:onMailDelClick(self.curMail)
            end     
            return true
        end)
        self.btnDelListener = true
    end
    
    if mailData.award and #mailData.award>0 and mailData.state==0 then
        btnPick:setVisible(true)
        btnDel:setVisible(false)
    else
        btnPick:setVisible(false)
        btnDel:setVisible(true)
    end
end

function SocialWin:clearMailContent()
    --文字内容
    local content = cc.uiloader:seekNodeByName(self.r_mailLayer,"content")
    content:setString("")
    if self.r_mailLayer:getChildByTag(111) then
        self.r_mailLayer:getChildByTag(111):renderXml("")
    end
    --附件物品
    for i=1,3 do
        local item = cc.uiloader:seekNodeByName(self.r_mailLayer,"item"..i)
        if item then
            item:setVisible(false)
        end
        local itemName = cc.uiloader:seekNodeByName(self.r_mailLayer,"labItem"..i)
        if itemName then
            itemName:setVisible(false)
        end
    end

    --显示提取附件还是显示删除邮件
    local btnPick = cc.uiloader:seekNodeByName(self.r_mailLayer,"btnPick")
    local btnDel = cc.uiloader:seekNodeByName(self.r_mailLayer,"btnDel")
    btnPick:setVisible(false)
    btnDel:setVisible(false)
end

--邮件提取附件按钮点击回调
function SocialWin:onMailPickClick(mailData)
    if not mailData then return end
    local data = {
        id = mailData.id
    }
    GameNet:sendMsgToSocket(15003, data)
end

--删除邮件按钮点击回调
function SocialWin:onMailDelClick(mailData)
    if not mailData then return end
    local data = {
        id = mailData.id
    }
    GameNet:sendMsgToSocket(15004, data)
end

--注册监听的事件
function SocialWin:registerEvent()
    self.registerEventId = {}

    local function onWealthChange()
        self:refreshCoin()
    end
    self.registerEventId[1] = GlobalEventSystem:addEventListener(RoleEvent.UPDATE_WEALTH,onWealthChange)

    local function onMailChange(data)
        if not self.mailList then return end
        for i=1,#self.mailList do
            if self.mailList[i].id == data.data.id then
                self.mailList[i] = data.data
                self.mailList[i].mailIndex = i

                if self.mailContentItems[i] then
                    self.mailContentItems[i]:setTexture("common/mail_readed.png")
                end
                
                if self.curMail and data.data.id == self.curMail.id then
                    self:refreshMailContent(i)
                end
                return
            end
        end
        --没有找到对应id的邮件,则表示是新邮件
        self:pushMailItem(data.data,false,true)
    end
    self.registerEventId[2] = GlobalEventSystem:addEventListener(MailEvent.MAIL_CHANGE,onMailChange)

    local function onMailDelSuccess(data)
        if not self.mailList then return end
        for i=1,#self.mailList do
            if self.mailList[i].id == data.data then
                for j=i+1,#self.mailList,1 do
                    self.mailList[j].mailIndex = self.mailList[j].mailIndex-1
                end
                table.remove(self.mailList,i)

                self.mailLv:removeItem(self.mailItems[i],false)
                
                table.remove(self.mailItems,i)
                 table.remove(self.mailContentItems,i)
                if self.curMail and data.data == self.curMail.id then
                   self.curMail = nil
                   self.curMailItemSp = nil
                   if self.mailList[i] then --如果还有下一个mail,跳到下一个mail
                    self.curMailItemSp = self.mailItems[i]:getContent():getChildByTag(10)
                    self.curMailItemSp:getChildByTag(10):setVisible(true)
                    self.curMail = self.mailList[i]
                    self:refreshMailContent(self.mailList[i].mailIndex)
                    else
                        self:clearMailContent()
                   end
                   
                end
                return
            end
        end
    end
    self.registerEventId[3] = GlobalEventSystem:addEventListener(MailEvent.MAIL_DEL_SUCCESS,onMailDelSuccess)

    local function onMailPickSuccess(data)
        if not self.mailList then return end
        for i=1,#self.mailList do
            if self.mailList[i].id == data.data.id then
                self.mailList[i].state = 1

                self.mailContentItems[i]:getChildByTag(10):getChildByTag(10):setSpriteFrame("common/mail_readed.png")
                if self.curMail and data.data.id == self.curMail.id then
                    self:refreshMailContent(i)
                end
                return
            end
        end
        --没有找到对应id的邮件,则表示是新邮件
        self:pushMailItem(data.data,false,true)
    end
    self.registerEventId[4] = GlobalEventSystem:addEventListener(MailEvent.MAIL_PICK_SUCCESS,onMailPickSuccess)

end


function SocialWin:initFriend()
end


--解除监听的事件
function SocialWin:unregisterEvent()
    if not self.registerEventId or #self.registerEventId==0 then return end
    for i=1,#self.registerEventId do
        GlobalEventSystem:removeEventListenerByHandle(self.registerEventId[i])
    end
end

function SocialWin:open()
    local onFunctioinOpen = function(data)
    --[[
        local beginX = 819 
        local item = self.tagBtns[3]
        if FunctionOpenManager:getFunctionOpenById(FunctionOpenType.Social_email) then
            item:setPosition(beginX,580)
            beginX = beginX - 135
        else
            item:setVisible(false)
        end

        item = self.tagBtns[2]
        if FunctionOpenManager:getFunctionOpenById(FunctionOpenType.Social_friend) then
            item:setPosition(beginX,580)
            beginX = beginX - 135
        else
            item:setVisible(false)
        end
        --]]

    end
    onFunctioinOpen()
    if self.functionOpenEventId == nil then
        self.functionOpenEventId = GlobalEventSystem:addEventListener(GlobalEvent.UPDATE_FUNCTION_OPEN,onFunctioinOpen)
    end
end

--关闭按钮回调
function SocialWin:onCloseClick()
    GlobalWinManger:closeWin(self.winTag)
end

function SocialWin:close()
    --解除监听事件
    self:unregisterEvent()

    GlobalEventSystem:dispatchEvent(MailEvent.MAIL_WIN_STATE_CHANGE,false)
    if self.functionOpenEventId then
        GlobalEventSystem:removeEventListenerByHandle(self.functionOpenEventId)
        self.functionOpenEventId = nil
    end
    self.super.close(self)
    --self:removeSpriteFrames("res/resui/socialWin_l_mailLayer.ExportJson")
    --self:removeSpriteFrames("res/resui/socialWin_r_mailLayer.ExportJson")
end

function SocialWin:destory()
    self:close()
    self.super.destory(self)
end

return SocialWin

