--
-- Author: Alex mailto: liao131131@vip.qq.com
-- Date: 2016-01-16 02:01:41
--
module(..., package.seeall)

OMT_AUTO_CLICK_BAG = "auto_click_bag"
OMT_AUTO_CLICK_NAV = "auto_click_nav"

--菜单栏映射
OMT_NAV_OPS ={
    [WinName.MAINROLEWIN]  = GUIOP.CLICK_BOTTOM_NAV_ROLE,
	[WinName.BAGWIN]       = GUIOP.CLICK_BOTTOM_NAV_BAG,
	[WinName.SKILLVIEW]    = GUIOP.CLICK_BOTTOM_NAV_SKILL,
    ["__equip_sub_mark__"] = GUIOP.CLICK_BOTTOM_NAV_EQUIP,

	[WinName.GUILDWIN]     = GUIOP.CLICK_BOTTOM_NAV_GUILD,
	[WinName.FRIEND]    = GUIOP.CLICK_BOTTOM_NAV_SOCIAL,
	[WinName.TEAMWIN]      = GUIOP.CLICK_BOTTOM_NAV_TEAM,
	[WinName.SYSOPTIONWIN] = GUIOP.CLICK_BOTTOM_NAV_SYS_OP,

	[WinName.EQUIPSTRENGWIN] =   GUIOP.CLICK_BOTTOM_SUB_NAV_STRENG, --武器强化
	[WinName.EQUIPBAPTIZEWIN] =  GUIOP.CLICK_BOTTOM_SUB_NAV_BAPTIZE, --武器洗炼
	[WinName.EQUIPCOMPOSEWIN] =  GUIOP.CLICK_BOTTOM_SUB_NAV_COMPOSE, --武器提纯
	[WinName.EQUIPPRODUWIN] =    GUIOP.CLICK_BOTTOM_SUB_NAV_PRODU, --武器打造
	[WinName.EQUIPEXTENDSWIN] =  GUIOP.CLICK_BOTTOM_SUB_NAV_EXTENDS, --武器继承
	[WinName.MEDALUPWIN]  =      GUIOP.CLICK_BOTTOM_SUB_NAV_MEDALUP,		-- 勋章升级窗口
	[WinName.EQUIPSOULWIN] =     GUIOP.CLICK_BOTTOM_SUB_NAV_SOUL, --武器铸魂
	[WinName.WINGWIN] =          GUIOP.CLICK_BOTTOM_SUB_NAV_WING, --翅膀升级窗口

}


--
-- 判断这个字符串是否为动态Mark标签。
--
function IsDynamicMark(mark)
	-- first char is #
	return mark and string.byte(mark) == 35
end

--
-- 获取一个mark字符串中的选项数组，不符合则返回nil.
--
function GetMarkOptions(mark)
	--
	-- 如果以#开头的标记，拆分变量信息
	--
	local args = nil
	if IsDynamicMark(mark) then
		local markStr = string.sub(mark, 2)
		args = string.split(markStr, "|")
	end

	return args
end

--
-- 获取动态选项数组的类型。
--
function GetMarkOptionType(markOptions)
	return markOptions and markOptions[1] or nil
end

--
-- 获取选项列表。
--
function GetMarkOptionList(markOptions)
	local list = nil
	if markOptions and markOptions[2] then
		listStr = string.gsub(markOptions[2], "[{|}]", "")
		list = string.split(listStr, ",")
	end
	return list
end