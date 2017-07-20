--
-- Author: Evans
-- Date: 2013-12-11 11:44:36
--
local ObjectUtil = {}


--在全局中添加一个变量
function regObjInGlobal(name,obj)
    _G[name] = obj
    package.loaded[name] = obj
end

local function search( k,pList )
    for i=1,#pList do
        local v = pList[i][k]
        if v then
            return v
        end
    end
end


local function setInterface( obj,pList )
    local target
    if type(obj) == "userdata" then
        target = tolua.getpeer(obj)
        if not target then
            target = {}
            tolua.setpeer(obj, target)
        end
        -- pList[#pList + 1] = getmetatable(target)
    else
        target = obj
        -- target.funcA()
        -- pList[#pList + 1] = target
    end
    pList[#pList + 1] = getmetatable(target)

    setmetatable(target, {__index = function ( t,k )
        local v = search(k,pList)
        t[k] = v
        return v
    end})
end

--多继承(实现接口)
--
--classname 类名
--super 超类(可以是function/table)
--pList 其他父类
function ObjectUtil.multiClass( classname,super,pList )
    local superType = type(super)
    local cls
    cls = class(classname, super)

    -- dump(super)

    if pList then
        if superType == "function" or (super and super.__ctype == 1) then
            cls.new = function( ... )
                local instance = cls.__create(...)
                -- copy fields from class to native object
                setInterface(instance,pList)
                for k,v in pairs(cls) do instance[k] = v end
                instance.class = cls
                instance:ctor(...)
                return instance
            end
        else
            cls.new = function( ... )
                local instance = setmetatable({}, cls)
                setInterface(instance,pList)
                instance.class = cls
                instance:ctor(...)
                return instance
            end
        end
    end

    regObjInGlobal(classname,cls) 

    return cls
end

function checkObjType(obj,checkType,atLevel)
    if type(obj) ~= checkType then
        if atLevel then
            error("param type error",atLevel + 1)
        end
        
        return false
    else
        return true
    end

end

--将对象设为单例对象
--使用方法:放在类的ctor方法里
function ObjectUtil.setToSingleton(target)
    assert(target.__cname,"The class object is specified param in this method!")
    if _G[target.__cname] then
        error(string.format("The instance of this class(%s) already exists!Do not new again", target.__cname),2)
    else
        _G[target.__cname] = target
        _G[target.__cname].instance = target
    end
    return target
end

--获取单例对象
function ObjectUtil:getSingleton(class,...)
    assert(class.__cname,"class error!")
    local obj = _G[class.__cname]
    if obj then
        return obj
    else
        return class.new(...)
    end
end

function ObjectUtil.dumpChildrenRC(target)
    --target
    print(tostring(target) .. " getReferenceCount:" .. target:getReferenceCount())
    --children
    local cl = target:getChildren()
    if cl and cl:count() > 0 then
        local child
        for i=0,cl:count() - 1 do
            child = tolua.cast(cl:objectAtIndex(i), "CCNode")
            assert(child,"Child is not CCNode")
            ObjectUtil.dumpChildrenRC(child)
        end
    end
end

--由字符样式创建CCLabelAtlas
function ObjectUtil.createLabelAtlas(numStyle)
    return CCLabelAtlas:create(numStyle[1], numStyle[2],numStyle[3],numStyle[4],numStyle[5])
end


--对象池
__objPool__ = {}
--扩展为循环再用对象
function ObjectUtil.extendToReuseObj(obj)
    if not tolua.cast(obj, "CCNode") then
        printError("can not extend this obj")
    end
    --初始化
    if not obj.initObj then
        printError("function 'initObj' must be implemented!")
        -- obj.initObj = function(self,...)
        --     return self
        -- end
    end
    --放回对象池
    obj.saveObj = function(self)
        local classname = self.getReuseClassName
            and self:getReuseClassName() or self.__cname

        if not classname then
            return
        end
        if not __objPool__[classname] then
            __objPool__[classname] = {}
        end
        table.insert(__objPool__[classname], self)

        if not IS_RELEASE then
            printInfo("save [%s] obj to objPool,left %s", classname,#__objPool__[classname])
        end
        -- dump(__objPool__[self.__cname], string.format("objPool[%s]", self.__cname))
    end
    --扩展方法
    local of = obj.cleanup_
    obj.cleanup_ = function(self)
        if of then
            of(self)
        end
        
        self:saveObj()
    end

    local of = obj.removeSelf
    obj.removeSelf = function(self)
        of(self)
        self:cleanup_()
    end
    --事件
    -- if not obj.__node_event_handle__ then
    --     obj:setNodeEventEnabled(true)
    -- end
    -- local of = obj.onCleanup
    -- obj.onCleanup = function(self)
    --     of(self)
    --     self:saveObj()
    -- end

end

--从对象池里取出对象
function ObjectUtil.getReuseObj(classname,...)
    if not __objPool__[classname]
        or #__objPool__[classname] == 0 then
        return nil
    end

    local obj = table.remove(__objPool__[classname])
    obj:initObj(...)

    if not IS_RELEASE then
        printInfo("get [%s] obj from objPool,left %s", obj.__cname,#__objPool__[classname])
    end

    return obj
end

--可重用类
function reuseClass(classname,super)
    local cls = class(classname, super)
    local of = cls.new
    cls.new = function(...)
        local instance = ObjectUtil.getReuseObj(classname,...)
        if not instance then
            instance = of(...)
            instance:retain()
            ObjectUtil.extendToReuseObj(instance)
        end
        return instance
    end

    return cls
end


regObjInGlobal("ObjectUtil",ObjectUtil) 

return ObjectUtil