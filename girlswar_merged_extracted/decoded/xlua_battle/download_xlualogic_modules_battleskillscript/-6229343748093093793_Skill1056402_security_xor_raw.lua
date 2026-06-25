local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=1
if t.battleStationRow==1 or#o==1 then
a=2
end
local i=t.HeroBattleInfo:GetMaxHP()
local a=math.floor(i*a*e[1]*MillionCoe)
t.HeroBattleInfo:AddHPAndMaxHP(a)
local i=e[2]
local n=e[3]
local a={}
for o=4,11 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
local i=e[12]
local a=e[13]
local n={e[14],e[15],e[16]}
t:AddBuff(t,i,a,n)
local n=e[17]
local i=e[18]
local a={}
for o=19,24 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local i=e[25]
local n=e[26]
local a={}
for t=27,29 do
table.insert(a,e[t])
end
table.insert(a,0)
for o=51,53 do
table.insert(a,e[o])
end
t:AddBuff(t,i,n,a)
if t.battleStationRow==1 then
local n=e[30]
local i=e[31]
local a={}
for o=32,35 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
end
local n=e[36]
local i=e[37]
local a={}
for t=38,41 do
table.insert(a,e[t])
end
table.insert(a,{})
t:AddBuff(t,n,i,a)
local n=e[42]
local i=e[43]
local a={}
for o=44,50 do
table.insert(a,e[o])
end
t:AddBuff(t,n,i,a)
local s=e[51]
local n=e[52]
local a={0}
local i=e[53]
t:AddBuff(t,s,n,a,i)
if t.battleStationRow==2 and#o>1 then
local a=e[54]
local e=e[55]
t:AddBuff(t,a,e,0)
end
return nil
end
return h

