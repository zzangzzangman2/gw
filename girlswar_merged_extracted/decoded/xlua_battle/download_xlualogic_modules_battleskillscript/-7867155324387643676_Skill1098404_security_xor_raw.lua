local e={
}
local r=e
function e.DoAction(a,e)
local e=a:JudgeSkillPreView(e)
local t=e[1]
local o=e[2]
local i={e[3],e[4],e[5],e[6],e[7]}
a:AddBuff(a,t,o,i)
local t={}
t[ProfessionType.Tank]=0
t[ProfessionType.Mage]=0
t[ProfessionType.Warrior]=0
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(o~=nil)then
local e=#o
for e=1,e do
local e=o[e]
if e.profession==ProfessionType.Tank then
t[ProfessionType.Tank]=t[ProfessionType.Tank]+1
elseif e.profession==ProfessionType.Mage then
t[ProfessionType.Mage]=t[ProfessionType.Mage]+1
elseif e.profession==ProfessionType.Warrior then
t[ProfessionType.Warrior]=t[ProfessionType.Warrior]+1
end
end
end
local o=e[8]
if t[o]and t[o]>0 then
local s=e[9]
local n=e[10]
local i={e[11],e[12]}
local e=t[o]
a:AddBuff(a,s,n,i,e)
end
local o=e[13]
if t[o]and t[o]>0 then
local s=e[14]
local n=e[15]
local i={e[16],e[17]}
local e=t[o]
a:AddBuff(a,s,n,i,e)
end
local o=e[18]
if t[o]and t[o]>0 then
local i=e[19]
local n=e[20]
local h={e[21],e[22]}
local s=t[o]
a:AddBuff(a,i,n,h,s)
local n=e[23]
local s=e[24]
local i={e[25],e[26]}
local e=t[o]
a:AddBuff(a,n,s,i,e)
end
local t=e[27]
local o=e[28]
local e={e[29],e[30],0}
a:AddBuff(a,t,o,e)
return nil
end
return r

