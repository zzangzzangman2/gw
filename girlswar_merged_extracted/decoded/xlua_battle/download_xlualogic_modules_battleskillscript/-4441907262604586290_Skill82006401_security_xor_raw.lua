local e=require("Modules/Battle/BattleUtil")
local o={
}
local d=o
function o.DoAction(t,n,e)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[4]
local s=0
local i=0
local h=e[5]
local d=e[6]
local l={e[7],e[8]}
if#e>8 then
local a=table.lightCopyList(a)
local a=RandomTableWithSeed(a,1)
local a=a[1]
if a then
local n=e[9]
local h=e[10]
local o={0,0}
s=math.floor(t:GetFinalAtk()*e[11]*MillionCoe)
i=a.HeroId
for t=12,18 do
if e[t]then
table.insert(o,e[t])
else
table.insert(o,0)
end
end
a:AddBuffAfterRemove(t,n,h,o)
end
end
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,h,d,l)
local a=0
if e.HeroId==i then
a=s
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,n,r,0,a)
end
return nil
end
function o.GetCanTriggerSkill(e)
return false
end
function o.DoPassiveAction(t,o)
local a=t:JudgeSkillPreView(o)
local i=a[1]
local n=a[2]
local e={}
table.insert(e,o.id)
table.insert(e,a[3])
local a=t:GetTeamStatFuryChangeInCurBigRound()
table.insert(e,a)
table.insert(e,0)
t:AddBuff(t,i,n,e)
return nil
end
return d 
