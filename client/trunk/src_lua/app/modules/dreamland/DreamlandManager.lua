--
-- Author: gxg
-- Date: 2017-1-18
--
-- 跨服幻境之城 - Manager
--

DreamlandManager = DreamlandManager or class("DreamlandManager", BaseManager)

function DreamlandManager:ctor()
	DreamlandManager.instance = self

end

function DreamlandManager:getInstance()
	if DreamlandManager.instance == nil then
		DreamlandManager.new()
	end
	return DreamlandManager.instance
end

function DreamlandManager:isSafeArea(i)
    -- 安全区占了中间9个位置
    local is_safe = false
    if i == 45 or i==  46 or i == 47 
       or i == 55 or i==  56 or i == 57 
       or i == 65 or i ==  66 or i == 67
    then  
        is_safe = true
    end
    return is_safe
end

function DreamlandManager:clear()

end
