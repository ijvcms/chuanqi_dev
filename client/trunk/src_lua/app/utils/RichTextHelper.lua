xmlSimple = require("app.utils.xmlSimple")

--
local RichTextHelper = {}
regObjInGlobal("RichTextHelper",RichTextHelper)

--检查一个字符串是否为xml字符串
function RichTextHelper.checkIsXmlString(str)
	local xml = xmlSimple.newParser() 
	local parse = xml:ParseXmlText(str)
	return (#(parse:children())>0)
end

return RichTextHelper