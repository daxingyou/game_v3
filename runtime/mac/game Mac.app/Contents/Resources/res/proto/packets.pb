
Í
packets.protomessage.packets"#
Packet
cmd (
body ("&
CSC_SysHeartBeat

servertime ("$
CS_Login
uid (
acc (	"ß
SC_Login
success (
playerid (6
content (2%.message.packets.SC_Login.contentData
errCode (
errMsg (	û
contentData
aid (
sid (
name (	
exp (
level (
RMB (
money (

max_vigour (
vigour	 (
rvt
 (")

CS_AskInfo
type (
param ("

CS_Command
content (	"8
SC_MSG
errCode (
msg (	
showtype ("?
SC_BroadCast
type (
times (:3
content (	"L

SC_NewHero
result (.
heroinfo (2.message.packets.SC_HeroInfo"ç
SC_HeroInfo
dataId (
level (
quality (
stars (
exp (
favor (
armId (6
skills (2&.message.packets.SC_HeroInfo.skillinfo,
equips	 (2.message.packets.SC_ItemInfo.
	skillinfo

templateId (
level ("J
SC_AskHeros
result (+
heros (2.message.packets.SC_HeroInfo"1
SC_FormationInfo
index (
dataId ("I
SC_AskFormations5

formations (2!.message.packets.SC_FormationInfo"W
CS_UpdateFormation
pos (4
	formation (2!.message.packets.SC_FormationInfo"\
SC_FormationResult
errocode (4
	formation (2!.message.packets.SC_FormationInfo" 
SC_AskItemBag
result (5
items (2&.message.packets.SC_AskItemBag.ItemBagÒ
ItemBag,
equips (2.message.packets.SC_ItemInfo.
comitems (2.message.packets.SC_ItemInfo.
material (2.message.packets.SC_ItemInfo*
gems (2.message.packets.SC_ItemInfo,
debris (2.message.packets.SC_ItemInfo"U

SC_NewItem
result (*
info (2.message.packets.SC_ItemInfo
num (":
SC_ItemInfo
dataId (
num (
elevel ("6

CS_UseItem
item_dataId (
hero_dataId ("t

SC_UseItem
result (*
item (2.message.packets.SC_ItemInfo*
hero (2.message.packets.SC_HeroInfo"7
CS_Compound
item_dataId (
hero_dataId ("}
SC_Compound
result (1
result_item (2.message.packets.SC_ItemInfo+
stuff (2.message.packets.SC_ItemInfo"<
CS_EquipEnhance
hero_dataId (
equip_dataId ("!
SC_EquipEnhance
result ("V
SC_UpdateHeroEquip
hero_dataId (+
equip (2.message.packets.SC_ItemInfo"Ñ
SC_UpdateKeys
hero_dataId (5
kvs (2(.message.packets.SC_UpdateKeys.key_value'
	key_value
key (	
value ("=
SC_AskStages-
stages (2.message.packets.SC_StageInfo"8
SC_StageInfo

Id (
count (
stars ("5
CS_FightBegin
stageId (
client_time ("0
SC_FightBegin
stageId (
result ("á
CS_FightEnd
stageId (
win (
cbegin_time (
	cend_time (
round_count (
count (
all_hp ("Z
SC_FightEnd
stageId (
stars (+
award (2.message.packets.SC_ItemInfo"6
missioninfo

Id (
flag (
param ("9
SC_MissionList'
m (2.message.packets.missioninfo"&
CS_MissionOP

op (

Id ("$

SC_Mission

op (

Id (":
SC_FlushMission'
m (2.message.packets.missioninfo"„
mailinfo
sno (
mailtype (
sender (	
sendtime (
title (	
content (	
money (
RMB (2
items	 (2#.message.packets.mailinfo.itemsinfo&
	itemsinfo

Id (
count ("V

SC_MailRet
type (+
maillist (2.message.packets.mailinfo
param (