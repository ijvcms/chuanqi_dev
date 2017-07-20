--
-- Author: zhangshunqiu    21102585@qq.com
-- Date: 2015-08-07 17:41:30
-- 资源公共类

ResUtil = ResUtil or {}

function ResUtil.getModel(modelId)
	--return string.format("model/%d/%d.ExportJson",modelId,modelId)
	return string.format("model/%s/%s.ExportJson",tostring(modelId),tostring(modelId))
end
function ResUtil.getModelPlist(modelId)
    --return string.format("model/%d/%d.ExportJson",modelId,modelId)
    return string.format("model/%s/%s.plist",tostring(modelId),tostring(modelId))
end
function ResUtil.getModelImg(modelId)
    --return string.format("model/%d/%d.ExportJson",modelId,modelId)
    return string.format("model/%s/%s.pvr.ccz",tostring(modelId),tostring(modelId))
end



function ResUtil.getEffect(effectId)
	return string.format("effect/%s/%s.ExportJson",tostring(effectId),tostring(effectId))
end
function ResUtil.getEffectPlist(modelId)
    --return string.format("effect/%d/%d.ExportJson",modelId,modelId)
    return string.format("effect/%s/%s.plist",tostring(modelId),tostring(modelId))
end
function ResUtil.getEffectPVRImg(modelId)
    --return string.format("effect/%d/%d.ExportJson",modelId,modelId)
    return string.format("effect/%s/%s.pvr.ccz",tostring(modelId),tostring(modelId))
end

function ResUtil.getPetShow(petId)
	return string.format("petShow/%spet/%spet.ExportJson",tostring(petId),tostring(petId))
end

function ResUtil.getMapBg(mapId,index)
	return string.format("map/%s/%s.jpg",mapId,index)
end

function ResUtil.getCreatRoleModel(career,sex)
	local str = ""
	if career == RoleCareer.WARRIOR then
		str = "zhanshi0"
	elseif career == RoleCareer.MAGE then
		str = "fashi0"
	elseif career == RoleCareer.TAOIST then
		str = "daoshi0"
	end
	--print(str,career,sex)
	str = str..sex
	--print(str,career,sex)
	return string.format("model/%s/%s.ExportJson",str,str),str
end

--ResUtil.getGoodsIcon(modelID)
function ResUtil.getGoodsIcon(id)
    return string.format("icons/itemIcon/%s.png",tostring(id))
end

--ResUtil.getGoodsSmallIcon(modelID)
function ResUtil.getGoodsSmallIcon(id)
    return string.format("icons/itemSmallIcon/%s.png",tostring(id))
end

function ResUtil.getRoleHead(carrer,sex)
	return string.format("icons/rolehead/head_%s.png",tostring(carrer+sex))
end

function ResUtil.getSkillIcon2(skillId)
	return string.format("icons/skill2/%s.png",tostring(skillId))
end

--获取战斗模式图片
function ResUtil.getFightModelPic(ctype)
    if ctype == FightModelType.PEACE then --和平
        return "#scene/scene_ptypehp.png", "对玩家无伤害"
    elseif ctype == FightModelType.GOODEVIL then --善恶
        return "#scene/scene_ptypese.png", "对红灰名玩家伤害"
    elseif ctype == FightModelType.TEAM then --组队
        return "#scene/scene_ptypezd.png", "非本队玩家造成伤害"
    elseif ctype == FightModelType.GUILD then --行会
        return "#scene/scene_ptypehh.png",  "非本行会玩家造成伤害"
    elseif ctype == FightModelType.ALL then --全体
        return "#scene/scene_ptypeall.png", "对任何玩家都伤害"
    elseif ctype == FightModelType.ENEMY then --仇人
        return "#scene/scene_ptypecr.png", "只对仇人造成伤害"
    elseif ctype == FightModelType.NEWPLAYER then --新手
        return "#scene/scene_ptypexs.png", "对玩家无伤害"
    elseif ctype == FightModelType.CORPS then --军团
        return "#scene/scene_ptypezj.png", "非本军团玩家造成伤害"
    elseif ctype == FightModelType.UNION then --联盟
        return "#scene/scene_ptypejm.png", "非结盟玩家造成伤害"
    end
    return ""
end

function ResUtil.getLoginSexCarrerModel(sex,career)
    local sexStr = ""
    if sex == RoleSex.MAN then
        sexStr = "1"
    elseif sex == RoleSex.WOMAN then
        sexStr = "2"
    end
    local careerStr = ""
    if career == RoleCareer.WARRIOR then
    	careerStr = "1"
	elseif career == RoleCareer.MAGE then
		careerStr = "2"
	elseif career == RoleCareer.TAOIST then
		careerStr = "3"
	end
    return string.format("common/login/creatRolePic/login_creatrole%s%s.png",careerStr,sexStr)
end

function ResUtil.getWorldBossIcon(bossId)
    return "icons/worldBoss/"..bossId..".png"
end

function ResUtil.getHonorIcon(honorId)
    return "icons/honor/honor"..honorId..".png"
end

function ResUtil.getLoginCarrerIcon(career)
    return string.format("login/login_career%s.png",tostring(career))
end

function ResUtil.getWingInnerModel(wingId)
    return "pic/wing/"..wingId..".png"
end

function ResUtil.setResFormat()

    local config = configHelper:getRgbaConfig()
    for k,v in pairs(config) do
        display.setTexturePixelFormat(v.src, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    end
end





--zhangshunqiu
---string.format("downloading %d%%",percent)
--string.format("LANG [%s] not exist!", v