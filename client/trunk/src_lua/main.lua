
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    -- report lua exception
    if buglyReportLuaException then
    	buglyReportLuaException(tostring(errorMessage), debug.traceback())
    end
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
require("app.MyApp").new():run()

-- local str = '{"code":1,"open_id":9663,"plat":1000,"service_list":[{"name":"\u5f00\u59291\u670d","state":1,"service_id":1001,"service_port":10011,"ip":"123.206.203.28"}]}'
-- local  jsonData = json.decode(str)
-- dump(jsonData)
--require("app.scenes.BaseScene"):run("BCBKScene")
--require("app.scenes.BaseScene"):run("DPZScene")