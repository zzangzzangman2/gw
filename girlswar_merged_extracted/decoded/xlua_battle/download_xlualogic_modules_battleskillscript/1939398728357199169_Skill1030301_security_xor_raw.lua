local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
t:ReduceFury(i.costMp)
local d=e[1]
local a=math.floor(t.HeroBattleInfo.CurrHP*e[3]*MillionCoe)
a=math.min(a,t.HeroBattleInfo.CurrHP-1)
if a>0 then
t:HpReduceImmediately(a)
end
local l=math.floor(t.HeroBattleInfo.MaxHP*e[4]*MillionCoe)
local a=e[5]
local s=e[6]
local n=(1-t:CurrHPPer())
local n={e[7],e[8],math.floor(e[9]+n*(e[10]-e[9]))}
t:AddBuff(t,a,s,n)
local r=e[12]
local s=e[13]
local h={e[14],e[15]}
local a=#o
for n=1,a do
local a=o[n]
local o=t:CurrHPPer()
if o<=e[16]*MillionCoe then
if n==1 then
a.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
elseif o<=e[11]*MillionCoe then
a:AddBuff(t,r,s,h)
end
local e=0
if n==1 then
e=l
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d,0,e)
end
return nil
end
return d 
