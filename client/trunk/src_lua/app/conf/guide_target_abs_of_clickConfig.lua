-- 自动生成，请勿修改 
-- 时间：2017/01/05
-- 21102585@qq.com

local guide_target_abs_of_clickConfig = class("guide_target_abs_of_clickConfig")
function guide_target_abs_of_clickConfig:ctor()
	self.fields = {"id", "direction", "position_type", "position", "target_rect", "describe"}
	self.datas = {
		[10001] = {10001, 3, 1, "238,-223", "2,-200,222,52", "<font color='0xffffff' size='22' opacity='255'>点击任务</font><br/>"},--ok
		[10003] = {10003, 2, 8, "-245,95", "-279,78,66,66", "<font color='0xffffff' size='22' opacity='255'>点击背包</font><br/>"}, --ok

		[10005] = {10005, 2, 5, "328,-108", "282,-130,116,48", "<font color='0xffffff' size='22' opacity='255'>点击使用</font><br/>"},

		[10006] = {10006, 4, 5, "400,252", "410,269,36,36", "<font color='0xffffff' size='22' opacity='255'>点击关闭</font><br/>"}, --ok

		[10007] = {10007, 2, 8, "-192,104", "-222,87,75,75", "<font color='0xffffff' size='22' opacity='255'>点击技能</font><br/>"},
		[10008] = {10008, 1, 5, "189,245", "132,311,126,46", "<font color='0xffffff' size='22' opacity='255'>点击快捷设置</font><br/>"},
		[20001] = {20001, 1, 3, "-218,-89", "-251,-4,75,75", "<font color='0xffffff' size='22' opacity='255'>点击福利中心</font><br/>"},
		[20002] = {20002, 4, 5, "304,42", "321,62,95,39", "<font color='0xffffff' size='22' opacity='255'>点击领取第一天奖励</font><br/>"},
		[20008] = {20008, 2, 8, "259,92", "226,89,75,75", "<font color='0xffffff' size='22' opacity='255'>点击组队</font><br/>"},--老的组队
		[20009] = {20009, 1, 5, "213,243", "150,306,126,47", "<font color='0xffffff' size='22' opacity='255'>查看附近队伍尝试加入队伍</font><br/>"},--老的组队
		[20010] = {20010, 2, 8, "106,92", "69,78,66,66", "<font color='0xffffff' size='22' opacity='255'>创建或加入行会</font><br/>"},    --ok
		[20011] = {20011, 1, 3, "-348,-79", "-378,-6,60,60", "<font color='0xffffff' size='22' opacity='255'>点击日常活动</font><br/>"},  --ok
		[20012] = {20012, 1, 5, "110,-16", "51,32,116,44", "<font color='0xffffff' size='22' opacity='255'>点击参加排位赛</font><br/>"},--ok
		[20014] = {20014, 1, 5, "338,-16", "269,32,116,44", "<font color='0xffffff' size='22' opacity='255'>点击功勋任务</font><br/>"}, --ok
		[20015] = {20015, 1, 3, "-348,-79", "-378,-6,60,60", "<font color='0xffffff' size='22' opacity='255'>点击日常活动</font><br/>"}, --ok
		[20016] = {20016, 1, 3, "-466,-92", "-499,-4,75,75", "<font color='0xffffff' size='22' opacity='255'>开启挂机，无论是否在线都有经验奖励</font><br/>"},--老的挂机？？？
		[20017] = {20017, 3, 1, "209,-288", "20,-161,156,215", "<font color='0xffffff' size='22' opacity='255'>挑战高级BOSS挂机经验越丰富</font><br/>"},--老的挂机
		[20018] = {20018, 2, 5, "96,-79", "34,-97,137,38", "<font color='0xffffff' size='22' opacity='255'>点击挑战</font><br/>"},--老的挂机
		[20022] = {20022, 3, 5, "-270,51", "-450,100,230,96", "<font color='0xffffff' size='22' opacity='255'>点击限时活动</font><br/>"},  --老的限时活动系统
		[20023] = {20023, 1, 5, "-85,20", "-163,66,137,38", "<font color='0xffffff' size='22' opacity='255'>点击查看世界BOSS刷新情况</font><br/>"}, --老的限时活动系统
		[20025] = {20025, 1, 5, "-327,-16", "-384,32,116,44", "<font color='0xffffff' size='22' opacity='255'>完成日常任务获取大量经验</font><br/>"},--ok
		[20030] = {20030, 2, 8, "317,95", "285,78,66,66", "<font color='0xffffff' size='22' opacity='255'>点击设置</font><br/>"},--ok
		[20031] = {20031, 3, 5, "-318,104", "-434,141,103,68", "<font color='0xffffff' size='22' opacity='255'>点击自动喝药</font><br/>"},--ok
		[20032] = {20032, 1, 5, "-105,100", "-145,192,78,78", "<font color='0xffffff' size='22' opacity='255'>点击设置回血药</font><br/>"},--ok
		[20033] = {20033, 4, 5, "-168,82", "-154,128,78,78", "<font color='0xffffff' size='22' opacity='255'>点击选择药品</font><br/>"}, --ok
		[20034] = {20034, 1, 5, "-105,-7", "-145,85,78,78", "<font color='0xffffff' size='22' opacity='255'>点击设置魔法药</font><br/>"},--ok
		[20038] = {20038, 4, 3, "-136,-143", "-113,-118,113,45", "<font color='0xffffff' size='22' opacity='255'>点击退出副本</font><br/>"},--ok
		[10010] = {10010, 2, 8, "-100,95", "-135,78,66,66", "<font color='0xffffff' size='22' opacity='255'>点击装备</font><br/>"},--ok
		[20051] = {20051, 1, 5, "212,-117", "172,17,78,78", "<font color='0xffffff' size='22' opacity='255'>点击放入强化装备</font><br/>"},--ok
		--[20051] = {20051, 1, 5, "52,90", "12,190,78,78", "<font color='0xffffff' size='22' opacity='255'>放入强化材料</font><br/>"},--ok
		[20050] = {20050, 4, 5, "-186,111", "-144,159,287,98", "<font color='0xffffff' size='22' opacity='255'>选择装备</font><br/>"},--ok
		[20052] = {20052, 4, 5, "64,-232", "75,-208,108,46", "<font color='0xffffff' size='22' opacity='255'>一键放入材料</font><br/>"},--ok
		[20053] = {20053, 2, 5, "300,-203", "243,-210,111,42", "<font color='0xffffff' size='22' opacity='255'>进行强化</font><br/>"},--ok
		[20054] = {20054, 1, 5, "-232,22", "-274,121,79,80", "<font color='0xffffff' size='22' opacity='255'>放入洗练装备</font><br/>"},--ok
		[20055] = {20055, 4, 5, "68,-241", "88,-215,112,44", "<font color='0xffffff' size='22' opacity='255'>洗练装备</font><br/>"},--ok
		[20056] = {20056, 2, 5, "356,-206", "300,-215,112,44", "<font color='0xffffff' size='22' opacity='255'>保留属性</font><br/>"},--ok
		[20039] = {20039, 1, 5, "103,-109", "78,-50,52,52", "<font color='0xffffff' size='22' opacity='255'>点击使用小飞鞋</font><br/>"}, --ok
		[20057] = {20057, 1, 5, "-191,-222", "-245,-176,115,41", "<font color='0xfbfb9f' size='22' opacity='255'>翅膀升级</font><br/>"},--ok
	}
end
return guide_target_abs_of_clickConfig
