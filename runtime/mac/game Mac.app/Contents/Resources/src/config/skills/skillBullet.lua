-- this file is generated by program!
-- don't change it manaully.
-- source file: /Users/wangshaopei/Documents/work_sanguo/code(trunk)/tools/xls2lua/xls_flies/skill.xls
-- created at: Mon Aug 11 13:20:57 2014


local skillBullet = {}


skillBullet.type_map = {}
local type_map = skillBullet.type_map
type_map[2] = "art_liubeis"
type_map["art_liubeis"] = 2
type_map[1] = "art_guanyus"
type_map["art_guanyus"] = 1
type_map[3] = "art_zhangfeis"
type_map["art_zhangfeis"] = 3
type_map[4] = "art_caocaos"
type_map["art_caocaos"] = 4


skillBullet.art_liubeis = {}
local art_liubeis = skillBullet.art_liubeis

art_liubeis[1] = {
	TypeId = 2,
	TypeName = "art_liubei",
	id = 2001,
	headIcon = "actor/hero/s_general1239.png",
}

skillBullet.art_guanyus = {}
local art_guanyus = skillBullet.art_guanyus

art_guanyus[1] = {
	TypeId = 1,
	TypeName = "art_guanyu",
	id = 1001,
	headIcon = "actor/hero/s_general1101.png",
}

skillBullet.art_zhangfeis = {}
local art_zhangfeis = skillBullet.art_zhangfeis

art_zhangfeis[1] = {
	TypeId = 3,
	TypeName = "art_zhangfei",
	id = 3001,
	headIcon = "actor/hero/s_general1302.png",
}

skillBullet.art_caocaos = {}
local art_caocaos = skillBullet.art_caocaos

art_caocaos[1] = {
	TypeId = 4,
	TypeName = "art_caocao",
	id = 4001,
	headIcon = "actor/hero/s_general1305.png",
}

skillBullet.all_type= {}
local all_type = skillBullet.all_type
all_type[2] = art_liubeis
all_type[1] = art_guanyus
all_type[3] = art_zhangfeis
all_type[4] = art_caocaos



for i=1, #(skillBullet.all_type) do
	local item = skillBullet.all_type[i]
	for j=1, #item do
		item[j].__index = item[j]
		if j < #item then
			setmetatable(item[j+1], item[j])
		end
	end
end


return skillBullet

