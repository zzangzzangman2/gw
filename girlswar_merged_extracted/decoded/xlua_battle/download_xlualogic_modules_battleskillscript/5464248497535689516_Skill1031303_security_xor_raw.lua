local l=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eAttrLow,e[2],HeroAttrId.hpPer)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local s=e[1]
local i=e[3]
local n=e[4]
local h={e[5],e[6]}
t:AddBuff(t,i,n,h)
local h=e[9]
local r=e[10]
local d={e[11],e[12]}
local i={}
local n=#a
for n=1,n do
local a=a[n]
a:AddBuff(t,h,r,d)
local n=s
if a:CurrHPPer()<e[7]*MillionCoe then
n=n+e[8]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
table.insert(i,a.HeroId)
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e[13],{},l:Handler(i,function(e)
for t=1,#e do
local e=e[t]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return true
end
end
return false
end))
end
return d 
