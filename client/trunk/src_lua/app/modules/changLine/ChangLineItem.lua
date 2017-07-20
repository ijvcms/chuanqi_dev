--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2016-05-30 21:43:39
--
--
local ChangLineItem = class("ChangLineItem", function()
	return display.newNode()
end)
function ChangLineItem:ctor(winTag,data,winconfig)
   	self.root = cc.uiloader:load("resui/changeLineItem.ExportJson")
	self:addChild(self.root)
    
    self.stateIcon = cc.uiloader:seekNodeByName(self.root, "stateIcon")
    self.stateIcon2 = cc.uiloader:seekNodeByName(self.root, "stateIcon2")
  	self.lineLabel = cc.uiloader:seekNodeByName(self.root, "lineLabel")

  	self.LineBtn = cc.uiloader:seekNodeByName(self.root, "LineBtn")
end


--
function ChangLineItem:setData(data)
	  --self.changlineLab:setString(math.round(2345)..":")
	  self.lineLabel:setString(data.line_num.." 线")
	  if data.state == 0 then
	      self.stateIcon:setVisible(true)
	      self.stateIcon2:setVisible(false)
	  elseif data.state == 1 then
	  		self.stateIcon2:setVisible(true)
	      self.stateIcon:setVisible(false)
	  end
end


--清理界面
function ChangLineItem:destory()
	  
end

return ChangLineItem