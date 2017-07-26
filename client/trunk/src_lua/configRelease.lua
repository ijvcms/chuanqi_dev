
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0
DEVELOP = true

-- display FPS stats on screen
DEBUG_FPS = false
if DEBUG >=1 then
	DEBUG_FPS = true
else
	DEVELOP = false
end


LOGIN_SCNEE_LOG = false

DEBUG_PACKAGE = true  --true 表示不采用分包机制 false表示采用分包机制
-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"--"portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 960 --960
CONFIG_SCREEN_HEIGHT = 640 --640

-- auto scale mode
-- CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"--"FIXED_WIDTH"

--更新测试
UPDATE_TEST = 210

GAME_FRAME_RATE = 45

DEBUG_LOGIN = false --true使用DEBUG登录 false 不使用

AUTO = 0 --1 自动游戏，0 不使用


DEBUG_SERVER_LIST = "[{\"name\" : \"测试服\",\"state\" : 1,\"service_id\" : 102,\"service_port\" :10011,\"ip\" : \"118.89.151.81\"},"..
					"{\"name\" : \"内网服\",\"state\" : 1,\"service_id\" : 103,\"service_port\" : 10011, \"ip\" : \"192.168.0.222\"},"..
					"{\"name\" : \"1002\",\"state\" : 1,\"service_id\" : 1002,\"service_port\" : 11002, \"ip\" : \"192.168.0.217\"},"..
					"{\"name\" : \"1001\",\"state\" : 1,\"service_id\" : 1001,\"service_port\" : 11001, \"ip\" : \"123.206.203.28\"},"..
					"{\"name\" : \"本地服1\",\"state\" : 1,\"service_id\" : 102,\"service_port\" : 10011, \"ip\" : \"192.168.0.124\"},"..
					"{\"name\" : \"本地服2\",\"state\" : 1,\"service_id\" : 202,\"service_port\" : 10202, \"ip\" : \"192.168.0.217\"}]"
					--"{\"name\" : \"ALLEN服\",\"state\" : 1,\"service_id\" : 102,\"service_port\" :10011,\"ip\" : \"192.168.0.117\"}]"
					--"{\"name\" : \"本地服4444\",\"state\" : 1,\"service_id\" : 202,\"service_port\" : 10202, \"ip\" : \"192.168.0.117\"},"..
--DEBUG_SERVER_LIST = "[{\"name\" : \"测试服\",\"state\" : 1,\"service_id\" : 102,\"service_port\" :10011,\"ip\" : \"118.89.151.81\"}]"
DEBUG_SERVER_LIST2 = "[{\"name\" : \"开天1服\",\"state\" : 1,\"service_id\" : 1001,\"service_port\" :11001,\"ip\" : \"123.206.203.28\"}]"
