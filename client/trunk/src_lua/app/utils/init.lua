--
-- Author: Evans
-- Date: 2014-08-04 14:56:06
--

import(".ObjectUtil")
import(".DisplayUtil")
import(".StringUtil")
import(".EffectUtil")
import(".fix")
import(".TipsHelper")
import(".EquipUtil")
import(".RichTextHelper")

cc.utils = import(cc.PACKAGE_NAME .. ".cc.utils.init")

function display.setLabelFilter(label)
	-- label:enableShadow(cc.c4b(0 , 0, 0, 1 ), cc.size(2,-2))
	-- label:enableOutline(cc.c4b(1,1,0,1),3)
	-- label:enableGlow(cc.c4b(1,1,0,1))
end
 
function serialize(obj)
    if  type(obj) == "table" then
        if obj.class == nil then
            return  json.encode(obj)
        else
            local kv = {}
            for k, v in pairs(obj) do
               if k ~= "class" then
                  table.insert(kv,"\"")
                  table.insert(kv,k)
                  table.insert(kv,"\":")
                  local t = type(v)
                  if t == "number" then
                      table.insert(kv, tostring(v))
                  elseif t == "string" then
                      table.insert(kv,"\"")
                      table.insert(kv,v)
                      table.insert(kv,"\"")
                  elseif t == "table" then
                      table.insert(kv,json.encode(v))
                  else
                      table.insert(kv,"\"\"")
                  end
                  table.insert(kv,",")
               end
               
            end
            return string.format("{%s}", table.concat(kv, "", 1, #kv - 1))
        end
    end
    return nil  
end   
  
function unserialize(lua)  
    local t = type(lua)  
    if t == "nil" or lua == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        lua = tostring(lua)  
    else  
        error("can not unserialize a " .. t .. " type.")  
    end  
    lua = "return " .. lua  
    local func = loadstring(lua)  
    if func == nil then  
        return nil  
    end  
    return func()  
end


function create_array(size)
    if size > 64 then
        return {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
    elseif size > 32  then
        return {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
    elseif size > 16 then
        return {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true}
    elseif size > 8 then
        return {true,true,true,true,true,true,true,true,true}
    elseif size > 4 then
        return {true,true,true,true,true}
    elseif size > 2 then
        return {true,true,true}
    elseif size > 1 then
        return {true,true}
    elseif size == 1 then
        return {true}
    else
        return {}
    end
end

function getDayCountOfMonth(month,year)
 
    if month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12 then
        return 31
    elseif month == 4 or month == 6 or month == 9 or month == 11 then
        return 30
    end

    if year % 400 == 0 or (year % 100 ~= 0 and year % 4 == 0) then
        return 29;
    else
        return 28;
    end
end

function getStartNumber(month,year)

    local  baseNumber;     
    local startNumber;
    
    if year % 400 == 0 or (year % 100 ~= 0 and year % 4 == 0 ) then

        if month == 1 or  month == 4 or month == 7 then
            baseNumber = 0
        elseif month == 2 or month == 8 then
            baseNumber = 3
        elseif month == 3 or month == 11 then
            baseNumber = 4
        elseif month == 5 then
            baseNumber = 2
        elseif month == 6 then
            baseNumber = 5
        elseif month == 9 or month == 12 then
            baseNumber = 6
        elseif month == 10 then
            baseNumber = 1                                    
        end
     
        startNumber = (year + year/4 + year/400 - year/100 - 2 + baseNumber + 1) % 7 

    else

        if month == 1 or  month == 10  then
            baseNumber = 0
        elseif month == 2 or month == 3 or month == 11 then
            baseNumber = 3
        elseif month == 4 or month == 7 then
            baseNumber = 6
        elseif month == 5 then
            baseNumber = 1
        elseif month == 6 then
            baseNumber = 4
        elseif month == 8 then
            baseNumber = 2
        elseif month == 9 or month == 12 then
            baseNumber = 5                                   
        end
        startNumber = (year + year/4 + year/400 - year/100 - 1 + baseNumber + 1) % 7 
    end
    return startNumber 
end

function darkNode(node)
    local vertDefaultSource = "\n"..
    "attribute vec4 a_position; \n" ..
    "attribute vec2 a_texCoord; \n" ..
    "attribute vec4 a_color; \n"..                                                    
    "#ifdef GL_ES  \n"..
    "varying lowp vec4 v_fragmentColor;\n"..
    "varying mediump vec2 v_texCoord;\n"..
    "#else                      \n" ..
    "varying vec4 v_fragmentColor; \n" ..
    "varying vec2 v_texCoord;  \n"..
    "#endif    \n"..
    "void main() \n"..
    "{\n" ..
    "gl_Position = CC_PMatrix * a_position; \n"..
    "v_fragmentColor = a_color;\n"..
    "v_texCoord = a_texCoord;\n"..
    "}"
    
    local pszFragSource = "#ifdef GL_ES \n" ..
    "precision mediump float; \n" ..
    "#endif \n" ..
    "varying vec4 v_fragmentColor; \n" ..
    "varying vec2 v_texCoord; \n" ..
    "void main(void) \n" ..
    "{ \n" ..
    "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
    "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b); \n"..
    "gl_FragColor.w = c.w; \n"..
    "}"

    local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource,pszFragSource)
    
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
    pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    pProgram:link()
    pProgram:updateUniforms()
    node:setGLProgram(pProgram)
end
