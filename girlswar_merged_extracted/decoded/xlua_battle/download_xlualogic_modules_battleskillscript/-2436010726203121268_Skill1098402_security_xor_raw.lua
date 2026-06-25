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
local n=e[9]
local i=e[10]
local e={e[11],e[12]}
local t=t[o]
a:AddBuff(a,n,i,e,t)
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
local s=e[19]
local i=e[20]
local h={e[21],e[22]}
local n=t[o]
a:AddBuff(a,s,i,h,n)
local n=e[23]
local i=e[24]
local e={e[25],e[26]}
local t=t[o]
a:AddBuff(a,n,i,e,t)
end
return nil
end
return r

