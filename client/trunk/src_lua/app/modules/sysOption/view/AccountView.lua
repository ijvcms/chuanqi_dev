local AccountView = class("AccountView", function()
    return display.newNode()
end)

function AccountView:ctor()
    local win = cc.uiloader:load("resui/SOW_Account.ExportJson")
    self:addChild(win)
    local roleManager = RoleManager:getInstance()
    local roleInfo = roleManager.roleInfo
    --名称
    local labName = cc.uiloader:seekNodeByName(win,"labName")
    labName:setString(roleInfo.name)
    --称号(暂时用职业 yjc)
    local labAlias = cc.uiloader:seekNodeByName(win,"labAlias")
    labAlias:setString(RoleCareerName[roleInfo.career]) 
    --ID
    local labID = cc.uiloader:seekNodeByName(win,"labID")
    labID:setString(roleInfo.player_id)
    --服务器
    local labServer = cc.uiloader:seekNodeByName(win,"labServer")
    
    if GlobalModel.selServerInfo then
        labServer:setString(GlobalModel.selServerInfo.name)
    end
    --兑换码
    local btnExchange = cc.uiloader:seekNodeByName(win,"btnExchange")
    btnExchange:setTouchEnabled(true)
    btnExchange:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnExchange:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnExchange:setScale(1.0)
            
            local ExchangeMarkView = require("app.modules.sysOption.view.ExchangeMarkView").new()
            GlobalEventSystem:dispatchEvent(GlobalEvent.SHOW_BOX,ExchangeMarkView) 
        end     
        return true
    end)

    --角色选择按钮
    local btnRoleSel = cc.uiloader:seekNodeByName(win,"btnRoleSel")
    btnRoleSel:setTouchEnabled(true)
    btnRoleSel:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnRoleSel:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnRoleSel:setScale(1.0)
            local function enterFun()
                GameNet:sendMsgToSocket(10007,{flag=1})
            end
            GlobalMessage:alert({
                enterTxt = "确定",
                backTxt= "取消",
                tipTxt = "是否确定回到选择角色界面?",
                enterFun = handler(self, enterFun),
                tipShowMid = true,
            })
        end     
        return true
    end)
    --注销账号
    local btnLogout = cc.uiloader:seekNodeByName(win,"btnLogout")
    btnLogout:setTouchEnabled(true)
    btnLogout:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnLogout:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnLogout:setScale(1.0)
            local function enterFun()
                if DEBUG_LOGIN == false then
                    ChannelAPI:logout()
                else
                    GameNet:sendMsgToSocket(10007,{flag=2})
                end
                GlobalController.fight.hadOpenSign = nil
            end
            GlobalMessage:alert({
                enterTxt = "确定",
                backTxt= "取消",
                tipTxt = "是否确定注销账号?",
                enterFun = handler(self, enterFun),
                tipShowMid = true,
            })
        end     
        return true
    end)
    --退出游戏
    local btnExit = cc.uiloader:seekNodeByName(win,"btnExit")
    btnExit:setTouchEnabled(true)
    btnExit:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            btnExit:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            btnExit:setScale(1.0)
            local exitFun = function()
                local function enterFun()
                    os.exit()
                end
                -- GlobalMessage:alert({
                --     enterTxt = "确定",
                --     backTxt= "取消",
                --     tipTxt = "是否确定退出游戏?",
                --     enterFun = handler(self, enterFun),
                --     tipShowMid = true,
                -- })
                GlobalAlert:pop({tipTxt = "是否确定退出游戏?",enterFun = handler(self, enterFun),hideBackBtn = false,alertName = "hasExitGame"})
            end
            if DEBUG_LOGIN then
                exitFun()
            else
                ChannelAPI:exit(exitFun)
            end
        end     
        return true
    end)
    local channelId = ChannelAPI:getChannelId()
    if channelId == "1888" or  ( string.sub(channelId, 1, 1) == "3" and string.sub(channelId, 1, 2) ~= "36" and channelId ~= "3008" and channelId ~= "3009" and channelId ~= "3010" and channelId ~= "3011" and channelId ~= "3012" ) then--自营IOS
        btnLogout:setVisible(true)
        btnExit:setPositionX(btnExit:getPositionX() + 50)
        btnRoleSel:setPositionX(btnRoleSel:getPositionX() - 50)
    end
end

function AccountView:open()
end

function AccountView:destory()
    
end

return AccountView