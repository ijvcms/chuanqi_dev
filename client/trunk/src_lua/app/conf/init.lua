confPath = "app.conf"
--转换成Key value类型的配置信息
--@param fields 对应配置的fields
--@param datas 对应配置的datas
--@param Key 用什么来作为配置的索引Key 如 id 等
--@param objTable 保存到那个对象 如RoleConfig = {}
function convertKeyConfig(fields,datas,Key,objTable)     
	objTable = objTable or {}
	local keyIndex = nil
	for i=1,#fields do
		if Key == fields[i] then
			keyIndex = i
			break
		end	
	end	
	for k,v in pairs(datas) do
		local data = {}
		for i=1,#fields do
			local value=v[i]
			if type(value) == "string" then
				if string.find(value,"{.*}") == nil then
				--if value == "" then 
					data[fields[i]] = value
				else					
					if value == "{}" then
            			data[fields[i]] = {}
          			else
						data[fields[i]] = loadstring("return"..value)()
					end	
				end	
			else
					data[fields[i]] = value
			end				
		end		
		if keyIndex then
			objTable[v[keyIndex]] = data
		else
			objTable[k] = data
		end
	end		
	return objTable
end


function getConfigObject(key,config)
	local data = config.datas[key]
	if data then
		if data.initialization then
			return data
		else
			local newData = { initialization = true }
			for i=1,#config.fields do
				newData[config.fields[i]] = data[i]
			end
			config.datas[key] = newData
			return newData
		end
	end
	return nil
end

ModeRectConfig = require("app.conf.model_sizeConfig").new()
PlayerUpgradeConf = require("app.conf.player_upgradeConfig").new()

GoodsConf = require("app.conf.goodsConfig").new()
-- HookSceneConf = require("app.conf.hook_sceneConfig").new()
--HookChapterConf = require("app.conf.hook_star_rewardConfig").new()
ActivitySceneConf = require("app.conf.sceneConfig").new()
MonsterConf = require("app.conf.monsterConfig").new()
SkillConf = require("app.conf.skillConfig").new()
DailyTaskConf = require("app.conf.taskConfig").new()
SkillUIConf = require("app.conf.skill_treeConfig").new()
SkillTreeConf = convertKeyConfig(SkillUIConf.fields,SkillUIConf.datas)
local npcConf = require("app.conf.npcConfig").new()
NpcConf = convertKeyConfig(npcConf.fields,npcConf.datas,"id")
