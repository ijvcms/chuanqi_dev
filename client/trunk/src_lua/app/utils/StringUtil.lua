--
-- Author: Evans
-- Date: 2014-02-20 11:07:28
--字符串工具


local StringUtil = {}
regObjInGlobal("StringUtil",StringUtil)

--除左右空格
function StringUtil.trim(s)
	local match = string.match
	return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end

--除所有空格
function StringUtil.trimAll(s)
	s = string.gsub(s, "%s+", "")
	return s
end

string.trim = StringUtil.trim

--替换关键值
--用法
--str = "$1不足以购买$2"
--tVals = {"金币","这武器"}
--rstr = ObjectUtil.replaceKeyVal(str,tVals)
--print(rstr)   输出:金币不足以购买这武器

--str = "$2不足以购买$1"
--tVals = {"这武器","金币"}
--rstr = ObjectUtil.replaceKeyVal(str,tVals)
--print(rstr)   输出:金币不足以购买这武器

--str = "$1不足以购买$2"
--tVals = "金币"
--rstr = ObjectUtil.replaceKeyVal(str,tVals)
--print(rstr)   输出:金币不足以购买金币
function StringUtil.replaceKeyVal(str,tVals)
    local s,n = string.gsub(str, "%$(%w)", function(s)
        if type(tVals) == "table" then
            return tVals[checkint(s)]
        else
            return tVals
        end
        
    end)
    return s,n
end


--将数字转换成XX亿XX万XXX
function StringUtil.convertNumber(v)
    local y
    local w = v / 10000
    if w >= 10000 then
        y = w / 10000
        w = w % 10000
    end
    -- local t = v % 10000
    -- t = string.format("%04d", t)

    w = math.floor(w)
    if y then
        return math.floor(y) .. LANG.YI .. w .. LANG.WAN
    elseif w > 0 then
        return w .. LANG.WAN
    else
        return v
    end

end

function StringUtil.convertTime(v)
    local str = ""
    local tt = math.floor(v/3600)
    if tt<10 then
        str = str.."0"
    end
    str = str..tt..":"
   
    v = v%3600
    tt = math.floor(v/60)
    if tt<10 then
        str = str.."0"
    end
    str = str .. tt..":"
    
    v = v%60
    tt = math.floor(v)
    if tt<10 then
        str = str.."0"
    end
    str = str..tt
    return str
end

function StringUtil.convertTime2(v)
    local str = ""
    tt = math.floor(v/60)
    if tt<10 then
        str = str.."0"
    end
    str = str .. tt..":"
    
    v = v%60
    tt = math.floor(v)
    if tt<10 then
        str = str.."0"
    end
    str = str..tt
    return str
end

--
-- 获取两个Unix时间戳时间的间隔，并以中文的形式返回。
-- @param t1 一个时间戳，用于被减。
-- @param t2 可选，指定一个时间戳与第一个相减，如不传递此参数默认获取现在的系统时间。
--
function StringUtil.GetUnixTimestampChineseString(t1, t2)
    t2 = t2 or os.time()
    local interval = t2 - t1
    local str = ""
    local min  = math.floor(interval / 60)
    if 0 == min then
        str = "刚才"
    elseif min < 60 then
        str = min .. "分钟前"
    elseif min < 60*24 then
        local h = math.floor(min / 60)
        str = h .. "小时前"
    elseif min < 60*24*30 then
        local d = math.floor(min / (60*24))
        str = d .. "天前"
    elseif min < 60*24*30*12 then
        local m = math.floor(min / (60*24*30))
        str = m .. "月前"
    else
        local y = math.floor(min / (60*24*30*12))
        str = y .. "年前"
    end
    return str
end

--秒转化成天和小时
function StringUtil.GetMiaoNumToDayHours(num)
    local str = ""
    local min  = num
    if 0 == min then
        str = "已结束"
    elseif min < 60*60 then
        str = math.floor(min / 60) .. "分"
    elseif min < 60*60*24 then
        local h = math.floor(min / 3600)
        str = h .. "小时"
    elseif min < 60*60*24*30 then
        local d = math.floor(min / (3600*24))
        str = d .. "天"
    elseif min < 60*60*24*30*12 then
        local m = math.floor(min / (60*60*24*30))
        str = m .. "月"
    else
        local y = math.floor(min / (60*60*24*30*12))
        str = y .. "年"
    end
    return str
end


function StringUtil.table2json(t)
    local function serialize(tbl)  
        local tmp = {}  
        for k, v in pairs(tbl) do  
            local k_type = type(k)  
            local v_type = type(v)  
            local key = (k_type == "string" and "\"" .. k .. "\":")  
                or (k_type == "number" and "")  
            local value = (v_type == "table" and serialize(v))  
                            or (v_type == "boolean" and tostring(v))  
                            or (v_type == "string" and "\"" .. v .. "\"")  
                            or (v_type == "number" and v)  
            tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil  
        end  
        if table.maxn(tbl) == 0 then  
            return "{" .. table.concat(tmp, ",") .. "}"  
        else  
            return "[" .. table.concat(tmp, ",") .. "]"  
        end  
    end  

    return serialize(t)  
end

--提取分隔符字符串
--用法：StringUtil.Split("vvv,bbb,bbbb,ggg", ",")
function StringUtil.split(inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={} 
    local i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--提取如{fff}{ff}中{}内的字符 
--如果begin_str,end_str是 ( ) . % + - * ? [ ]^ $  中的一个请在字符前加上%
--用法:StringUtil.SubmiddleStr("{a, 尼玛}{b}c{ffdss}{}daef","{","}")
--StringUtil.SubmiddleStr("[a, 尼玛][b]c[{]ffdss}{}daef","%[","%]")
function StringUtil.SubMiddleStr(format_text,begin_str,end_str)
    local t = {}
    local reg = begin_str.."([^"..end_str.."]+)"..end_str
    for v in string.gmatch(format_text, reg) do
        table.insert(t,v)
    end
    return t
end

--检查一段字符串是否有中文
--return:table
--[[
用法,比如StringUtil.CheckChinese("a中文b+") 
返回的table为{
    [1] = {c = "a",isChinese = false},
    [2] = {c = "中",isChinese = true},
    [3] = {c = "文",isChinese = true},
    [4] = {c = "b",isChinese = false},
    [5] = {c = "+",isChinese = false}  
}
--]]
function StringUtil.CheckChinese(s) 
    local ret = {};
    local f = '[%z\1-\127\194-\244][\128-\191]*';
    local line, lastLine, isBreak = '', false, false;
    for v in s:gfind(f) do
        table.insert(ret, {c=v,isChinese=(#v~=1)});
    end
    return ret;
end

--- 获取utf8编码字符串正确长度的方法
-- @param str
-- @return number
function StringUtil.Utf8strlen(str)
    local len = #str
    local left = len
    local cnt = 0
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc}
    while left ~= 0 do
        local tmp=string.byte(str,-left)
        local i=#arr
        while arr[i] do
            if tmp>=arr[i] then
                left=left-i
                break
            end
            i=i-1
        end
        cnt=cnt+1
    end
    return cnt
end


--- 获取maxWidth宽度下utf8编码字符串
-- @param str
-- @param fontSize
-- @param maxWidth
-- @return subStr
--         leftStr - 剩下的字符串
function StringUtil.SubUTF8StringWithWidth(str, fontSize, maxWidth)
    local sStr = str
    local width = maxWidth
    local tChar = {}
    local nLenInByte = #sStr
    local pos = 0
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
            if curByte > 97 then
                width = width - 0.5 * fontSize
            elseif curByte >= 43 and curByte <= 59 then
                width = width - 0.57 * fontSize
            else
                width = width - 0.7 * fontSize
            end
        elseif curByte>=192 and curByte<=223 then
            byteCount = 2
            width = width - fontSize
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3
            width = width - fontSize
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
            width = width - fontSize
        end
        if byteCount > 0 then
            local char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
            table.insert(tChar,char)
            if width >= fontSize then
                pos = pos + 1
            end
        end
    end
    return table.concat(tChar, "", 1, pos), table.concat(tChar, "", pos + 1, #tChar)
end

--- 获取utf8编码字符串子串
-- @param str
-- @param number
-- @param number
-- @return number
--[[ 快
function sub(str,s,e)
  str=str:gsub('([\001-\127])','\000%1')
  str=str:sub(s*2+1,e*2)
  str=str:gsub('\000','')
  return str
  end
--]]
function StringUtil.SubUTF8String(sName,nStart,nEnd)--慢
    local sStr = sName
    local tChar = {}
    local nLenInByte = #sStr

    --dump(string.byte(sStr, 1))
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<=223 then
            byteCount = 2
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
            table.insert(tChar,char)
        end
    end
    return table.concat(tChar,"", nStart, nEnd)
end

--将一段utf8的字符串变为table
function StringUtil.CharTableUTF8String(sName)
    local sStr = sName
    local tChar = {}
    local tCharAsciiPos = {}
    local nLenInByte = #sStr

    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        local asciiPos = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            asciiPos = i
            i = i + byteCount -1
        end

        table.insert(tChar,char)
        table.insert(tCharAsciiPos,asciiPos)
    end

    return tChar,tCharAsciiPos
end


function StringUtil:replaceStr(s,t)
  local replaceW = "***"
  for i=1,#t do
    --s = string.gsub(s,t[i].word, self:formatStar(t[i].word))
    s = string.gsub(s,t[i].word, replaceW)
  end
  return s
end

function StringUtil:formatStar(str)

  local s = ""
  local len = string.utf8len(str)
  for i=1,len do
    s = s.."*"
  end
  return s
end

--判断当前时间（curTimeObj）是否在字符串（timeString）时间之前
-- curTimeObj = {hour = 1,min = 3,sec= 4}
-- timeString = "12,23,45"
function StringUtil:isBeforecurTime(timeString,curTimeObj)
    --curTimeObj = {hour = 1,min = 3,sec= 4}
    local temp = curTimeObj or os.date("*t", os.time())
    local endTime = string.split(timeString, ",")
    if  temp.hour < tonumber(endTime[1]) then
        return true
    elseif temp.hour == tonumber(endTime[1]) and temp.min < tonumber(endTime[2]) then
        return true
    elseif temp.hour == tonumber(endTime[1]) and temp.min == tonumber(endTime[2]) and temp.sec < tonumber(endTime[3]) then
        return true
    end
    return false;
end


return StringUtil





--print(string.sub("nihaiohhahahha",1)) --nihaiohhahahha
    --print(string.sub("nihaiohhahahha",1,2))--ni
    --print(string.format("%.2f%s%s%d",1.2356,"1","2","3"))--1.24123
    --print(string.find("qwertyuiop","ert"))--3, 5   find第三个参数表示从第几个字符串开始
    --print(string.find("qwert$33yuiop","$%d%d%w"))--6, 9
    --print(string.find("qwert$3334yuiop","$%d%d%w"))--6, 9
    --print(string.gsub("qwert$3334yuiop","$%d%d%w","HH"))--qwertHH4yuiop, 1
    --print(string.gsub("qwert$3334yuiop$333","$%d%d%w","HH"))--qwertHH4yuiopHH, 2
    --print(string.gsub("qwert$3334yuiop$333","$%d%d%w","HH",1))--qwertHH4yuiop$333, 1

    --print(string.gfind("qwerty uiop","%a+"))--没有这个方法
    
    -- print(string.match("{a, 尼玛}{b}cdaef", "{[^}]+}"))--{a, 尼玛}
    -- for vv in string.gmatch("{a, 尼玛}{b}cdaef", "{[^}]+}") do
    --  print(vv)  -- {a, 尼玛}   ,  {b}
    -- end

    -- for key,vv in pairs(StringUtil.split("vvv,bbb,bbbb,ggg", ",")) do
    --  print(key,vv)
    -- end  
    -- print(StringUtil.substitute("tx_{0}_{1}", "sexStr", "type"))

    -- print(string.match("{a, 尼玛}{b}cdaef", "[^{][^}]+"))--{a, 尼玛}

    -- for vv in string.gmatch("{a, 尼玛}{b}c{ffdss}{}daef", "{[^}]+}") do
    --  print(string.match(vv,"[^{}]+"))  -- {a, 尼玛}   ,  {b},{ffdss}
    -- end

    -- for key,vv in pairs(StringUtil.submiddleStr("[a, 尼玛]{b}c{ffdss}{}daef","%[","%]")) do
    --  print(key,vv)  -- a, 尼玛
    -- end
    --print(StringUtil.Trim("       fff  gg                      "),"OK")  --fff  gg
    




--  1. string库中所有的字符索引从前往后是1,2,...;从后往前是-1,-2,...

-- 2. string库中所有的function都不会直接操作字符串，而是返回一个结果

-- s = "[abc]"

-- string.len(s)        <==返回5

-- string.rep("abc", 2) <==返回"abcabc"

-- string.lower("ABC") <==返回"abc"

-- string.upper("abc") <==返回"ABC"

-- string.sub(s, 2)     <==返回"abc]"

-- string.sub(s, -2)    <==返回"c]"

-- string.sub(s, 2, -2) <==返回"abc"

-- string.format(fmt, ...)返回一个类似printf的格式化字符串

-- string.find(s, pattern, pos)

-- 第1个参数：源字符串

-- 第2个参数：待搜索之模式串

-- 第3个参数：A hint, 从pos位置开始搜索

-- 找到匹配返回：匹配串开始和结束的位置，否则返回nil

-- 简单的模式串

-- s = "hello world"

-- i, j = string.find(s, "hello")

-- print(i, j) --> 1 5

-- print(string.sub(s, i, j)) --> hello

-- print(string.find(s, "world")) --> 7 11

-- i, j = string.find(s, "l")

-- print(i, j) --> 3 3

-- print(string.find(s, "lll")) --> nil

-- 格式化的模式串

-- s = "Deadline is 30/05/1999, firm"

-- date = "%d%d/%d%d/%d%d%d%d"

-- print(string.sub(s, string.find(s, date))) --> 30/05/1999

-- 下面的表列出了Lua支持的所有字符类：

-- . 任意字符

-- %s 空白符

-- %p 标点字符

-- %c 控制字符

-- %d 数字

-- %x 十六进制数字

-- %z 代表0的字符

-- %a 字母

-- %l 小写字母

-- %u 大写字母

-- %w 字母和数字

-- 上面字符类的大写形式表示小写所代表的集合的补集。例如，'%A'非字母的字符：

-- 模式串中的特殊字符

-- ( ) . % + - * ? [ ^ $

-- '%' 用作特殊字符的转义字符

-- '%.' 匹配点；

-- '%%' 匹配字符 '%'。

-- 转义字符 '%'不仅可以用来转义特殊字符，还可以用于所有的非字母的字符。当对一个字符有疑问的时候，为安全起见请使用转义字符转义他。

-- 用'[]'创建字符集

-- '[%w_]' 匹配字母数字和下划线

-- '[01]' 匹配二进制数字

-- '[%[%]]'匹配一对方括号

-- 在'[]'中使用连字符'-'

-- '%d'    表示 '[0-9]'；

-- '%x'    表示 '[0-9a-fA-F]'

-- '[0-7]' 表示 '[01234567]'

-- 在'[]'开始处使用 '^' 表示其补集：

-- '[^0-7]' 匹配任何不是八进制数字的字符；

-- '[^\n]' 匹配任何非换行符户的字符。

-- '[^%s]' == '%S'

-- 模式修饰符

-- + 匹配前一字符1次或多次

-- * 匹配前一字符0次或多次;最长匹配

-- - 匹配前一字符0次或多次;最短匹配

-- ? 匹配前一字符0次或1次

-- ^ 匹配字符串开头

-- $ 匹配字符串结尾

-- 捕获：用()将要捕获的部分包围起来

-- pair = "name = Anna"

-- firstidx, lastidx, key, value = string.find(pair, "(%a+)%s*=%s*(%a+)")

-- print(key, value) <== name Anna

-- 拷贝捕获(%1-%9)

-- s = "abc \"it\'s a cat\""

-- _,_,_,q = string.find(s, "([\"'])(.-)%1"))

-- print(q) <== it's a cat 如果%d代表第几个捕获的拷贝。

-- string.gsub(s, pattern, reps)

-- 第1个参数：源字符串

-- 第2个参数：待替换之模式串

-- 第3个参数：替换为reps

-- 将s中所有符合pattern的字串替换为reps，返回结果串+匹配数

-- print(string.gsub("hello, world", "o", "a"))       <== hella, warld        2

-- gsub也可以用拷贝捕获技巧

-- print(string.gsub("hello, world", "(o)", "%1-%1")) <== hello-o, wo-orld    2

-- print(string.gsub("hello Lua", "(.)(.)", "%2%1")) <== ehll ouLa           4

-- function trim (s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end <== 注意匹配数用括号丢弃

-- string.gsub(s, pattern, func)

-- 第3个参数：自定义函数，对找到的匹配操作，并传出替换值

-- s, n = string.gsub("hello world", "l+", function(s) return "xxx" end)

-- print(s, n) <== hexxxo worxxxd 2

-- string.gfind(s, pattern)

-- 返回一个迭代器，迭代器每执行一次，返回下一个匹配串；

-- iter = string.gfind("a=b c=d", "[^%s+]=[^%s+]")

-- print(iter()) <== a=b

-- print(iter()) <== c=d

-- 通常用于泛性for循环,下面的例子结果同上

-- for s in string.gfind("a=b c=d", "[^%s+]=[^%s+]") do

-- print(s)

-- end