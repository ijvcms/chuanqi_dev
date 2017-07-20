--
-- Author: Yi hanneng
-- Date: 2016-08-10 21:14:43
--
local UIAsynListViewItem = import("app.gameui.listViewEx.UIAsynListViewItem")
local BossDLItem = BossDLItem or class("BossDLItem", UIAsynListViewItem)
function BossDLItem:ctor()
	--self.ccui = cc.uiloader:load("resui/BossDLItem.ExportJson")
     
    self:init()
end

function BossDLItem:init()
	self.itemList = {}
	self.itemList[1] = SuperRichText.new(nil,640)
	self:addChild(self.itemList[1])
end

function BossDLItem:setData(data)
	if data == nil or #data.monster_goods == 0 then
        return 
    end
    for i=#self.itemList,#data.monster_goods+1, -1 do
    	self.itemList[i]:setVisible(false)
    end
    if data.date and data.date == 1 then
    	if self.timelayer == nil then
    		self.timelayer = display.newNode()
	        self.timeLabel = cc.ui.UILabel.new({text = os.date("%Y-%m-%d",data.kill_time), size = 22, color = cc.c3b(231,211,173)})
	        self.timelayer:addChild(self.timeLabel)
	
	        self.timeLabel:setPosition(200, 0)

	        self.timelayer:setContentSize(cc.size(300, self.timeLabel:getContentSize().height) )
	        self:addChild(self.timelayer)
	    else
	    	self.timeLabel:setString(os.date("%Y-%m-%d",data.kill_time))
	    	self.timelayer:setVisible(true)
    	end
    end
  
    local playerName = "<font color='00ff00' size='20' opacity='255' fontName = '微软雅黑'>"..data.planer_name.."</font>"
    local sceneName = "<font color='cba573' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getSceneName(data.scene_id).."</font>"
    local monsterName = "<font color='ff0000' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getMonsterNameById(data.monster_id).."</font>"
    local allgoodsName  = ""

    for j=1,#data.monster_goods do
         
            -- local playerName = "<font color='00ff00' size='20' opacity='255' fontName = '微软雅黑'>"..data.planer_name.."</font>"
       --      local sceneName = "<font color='cba573' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getSceneName(data.scene_id).."</font>"
       --      local monsterName = "<font color='ff0000' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getMonsterNameById(data.monster_id).."</font>"
            local goodsName  = ""
            local quality = configHelper:getGoodQualityByGoodId(data.monster_goods[j])
            
            if quality then
                 
                if quality == 1 then            --白
                    goodsName = "<font color='ffffff' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                elseif quality == 2 then        --绿
                    goodsName = "<font color='00ff0d' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                elseif quality == 3 then        --蓝
                    goodsName = "<font color='50b3d3' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                elseif quality == 4 then        --紫
                    goodsName = "<font color='e32fd8' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                elseif quality == 5 then        --橙
                    goodsName = "<font color='f29e19' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                elseif quality == 6 then        --红
                    goodsName = "<font color='eb0c0c' size='20' opacity='255' fontName = '微软雅黑'>"..configHelper:getGoodNameByGoodId(data.monster_goods[j])
                end 

            end
            if j == 1 then
                allgoodsName = allgoodsName..goodsName.."</font>"
            else
                allgoodsName = allgoodsName..","..goodsName.."</font>"
            end

      --       --line = line + 1
      --       --StringUtil.convertTime(data.drop_list[i].kill_time)
      --       if self.itemList[j] == nil then
      --        self.itemList[j] = SuperRichText.new(nil,700)
      --        self:addChild(self.itemList[j])
      --       end
     
      --       self.itemList[j]:setVisible(true)
         --    self.itemList[j]:renderXml("<font color='cba573' size='20' opacity='255' fontName = '微软雅黑'>"..os.date("%H:%M:%S",data.kill_time).."  "..playerName.." 在"..sceneName.."将 "..monsterName.." 打倒在地，掉落 "..goodsName.."!</font>")
            -- self.itemList[j]:setPosition( 0, j*self.itemList[j]:getContentSize().height - self.itemList[j]:getContentSize().height/2)
       
            
    end
    if self.itemList[1] == nil then
        self.itemList[1] = SuperRichText.new(nil,640)
        self:addChild(self.itemList[1])
    end
    self.itemList[1]:setVisible(true)
    self.itemList[1]:renderXml("<font color='cba573' size='20' opacity='255' fontName = '微软雅黑'>"..os.date("%H:%M:%S",data.kill_time).."  "..playerName.." 在"..sceneName.."将 "..monsterName.." 打倒在地，掉落 "..allgoodsName.."!</font>")
    self.itemList[1]:setPosition( 0, 1*self.itemList[1]:getContentSize().height - self.itemList[1]:getContentSize().height/2)

    if data.date and data.date == 1 then
 
        self.timelayer:setPosition(100,self.itemList[1]:getPositionY() + self.itemList[1]:getContentSize().height + 30)
        if self.itemList[1] then
            self:setContentSize(cc.size(640, self.itemList[1]:getContentSize().height*1 + self.timelayer:getContentSize().height + self.itemList[1]:getContentSize().height + 20))
        end
    else
        if self.timelayer then
            self.timelayer:setVisible(false)
        end
        if self.itemList[1] then
            self:setContentSize(cc.size(640, self.itemList[1]:getContentSize().height*1 + 14))
        end
    end

    
    
end
 
function BossDLItem:destory()
end

return BossDLItem