local r=require("Modules/Battle/BattleUtil")
local t={
302108805,
302108806,
302108807,
302108808,
302108809,
302108810,
302108811,
}
local s=302108811
local e={
}
local e=e
function e.AddMultiMusicBuff(i,n,o)
local a={}
local h={}
for e=1,#t do
local e=t[e]
local t=i.HeroBattleInfo:GetBuff(e)
if t==nil then
table.insert(a,e)
else
table.insert(h,e)
end
end
if o~=nil then
local t={}
if#a>o then
t=RandomTableWithSeed(a,o)
elseif#a==o then
t=a
else
t=a
local e=o-#a
local e=RandomTableWithSeed(h,e)
for a=1,#e do
table.insert(t,e[a])
end
end
local a=e.AddMusicBuffByList(i,n,t,i)
local t=i.HeroBattleInfo:GetBuff(s)
if t then
e.AddMusicBuffToMates(i,n,a)
end
end
end
function e.GetttrAddValue(n,o,t)
local e=false
local a=0
local i=o[21]
local n=n.HeroBattleInfo:GetBuff(i)
if n then
e=true
else
for a=1,#t do
local t=t[a]
if t==i then
e=true
end
end
end
if e then
a=o[23]
end
return a
end
function e.AddMusicBuffByList(t,o,a,s)
local i=e.GetttrAddValue(t,o,a)
for n=1,#a do
local a=a[n]
e.AddMusicBuffById(t,o,i,a,s)
end
if e.IsMusicHero(t)then
if e.HasAllMusicBuff(t)then
local e=t.BigSkillId
local e=r:GetSkillActData(e)
local a=t:JudgeSkillPreView(e)
local o=a[62]
local i=a[63]
local e={}
for t=64,74 do
table.insert(e,a[t])
end
table.insert(e,0)
table.insert(e,0)
t:AddBuff(t,o,i,e)
end
end
return i
end
function e.AddMusicBuffById(o,t,i,a,n)
if a==302108805 then
e.AddMusicBuff1(o,t,i,n)
elseif a==302108806 then
e.AddMusicBuff2(o,t,i,n)
elseif a==302108807 then
e.AddMusicBuff3(o,t,i,n)
elseif a==302108808 then
e.AddMusicBuff4(o,t,i,n)
elseif a==302108809 then
e.AddMusicBuff5(o,t,i,n)
elseif a==302108810 then
e.AddMusicBuff6(o,t,i,n)
elseif a==302108811 then
e.AddMusicBuff7(o,t,i,n)
end
end
function e.AddMusicBuff1(a,e,t,o)
local n=e[1]
local i=e[2]
local e={e[3],e[4],t}
a:AddBuff(o,n,i,e)
end
function e.AddMusicBuff2(t,e,a,o)
local n=e[5]
local i=e[6]
local e={e[7],e[8],a}
t:AddBuff(o,n,i,e)
end
function e.AddMusicBuff3(i,e,n,a)
local o=e[9]
local t=e[10]
local e={e[11],e[12],n}
i:AddBuff(a,o,t,e)
end
function e.AddMusicBuff4(a,e,t,o)
local n=e[13]
local i=e[14]
local e={e[15],e[16],t}
a:AddBuff(o,n,i,e)
end
function e.AddMusicBuff5(n,e,o,i)
local a=e[17]
local t=e[18]
local e={e[19],e[20],o}
n:AddBuff(i,a,t,e)
end
function e.AddMusicBuff6(a,e,o,i)
local n=e[21]
local s=e[22]
local e={e[23]}
a:AddBuff(i,n,s,e)
for e=1,#t do
local e=t[e]
local t=a.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e.ResetAttrValue then
e.ResetAttrValue(t,o)
end
end
end
end
function e.AddMusicBuff7(t,e,o,a)
local o=e[25]
local e={e}
t:AddBuff(a,s,o,e)
end
function e.AddMusicBuffToMates(a,i,o)
local o={}
for e=1,#t do
local e=t[e]
if s~=e then
local t=a.HeroBattleInfo:GetBuff(e)
if t then
table.insert(o,e)
end
end
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAllExcludeSelf)
for n=1,#t do
e.AddMusicBuffByList(t[n],i,o,a)
end
end
function e.RemoveMatesMusicBuff(t)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local o=t.HeroId
for t=1,#a do
e.RemoveMusicBuffByReleaseHeroId(a[t],o)
end
end
function e.RemoveMusicBuffByReleaseHeroId(e,o)
if e and e.HeroBattleInfo then
for a=1,#t do
local t=t[a]
if s~=t then
local a=e.HeroBattleInfo:GetBuff(t)
if a and a.releaseHeroId==o then
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
end
function e.HasAllMusicBuff(e)
if e and e.HeroBattleInfo then
for a=1,#t do
local t=t[a]
local e=e.HeroBattleInfo:GetBuff(t)
if e==nil then
return false
end
end
end
return true
end
function e.ClearAllMusicBuff(e)
if e and e.HeroBattleInfo then
for a=1,#t do
local t=t[a]
local a=e.HeroBattleInfo:GetBuff(t)
if a then
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
return true
end
function e.IsMusicHero(e)
if e.BigSkillId==21088301
or e.BigSkillId==21088302
or e.BigSkillId==21088303 then
return true
end
return false
end
return e

