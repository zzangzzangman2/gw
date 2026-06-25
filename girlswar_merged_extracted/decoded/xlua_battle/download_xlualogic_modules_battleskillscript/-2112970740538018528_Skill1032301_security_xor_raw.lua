local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFront)
if(a==nil)then
return nil
end
local i=#a
if i<=0 then
return nil
end
e:ReduceFury(o.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=t[1]
local u=t[6]*MillionCoe/i
local c=t[7]*MillionCoe
local h=t[4]
local r=t[5]
local l=t[3]
local s=t[5]
local t=0
local n={}
for o=1,i do
local a=a[o]
local o=a:GetFinalDef()*u
a:AddBuff(e,h,r,{o,e.HeroId})
t=t+o
table.insert(n,a.HeroId)
end
t=math.min(t,e:GetFinalDef()*c)
e:AddBuff(e,l,s,{t,n})
local t=#a
for t=1,t do
local t=a[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,d)
end
return nil
end
return l 
