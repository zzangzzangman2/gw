local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local d=e[1]
local o=math.floor(t.HeroBattleInfo.CurrHP*e[3]*MillionCoe)
o=math.min(o,t.HeroBattleInfo.CurrHP-1)
if o>0 then
t:HpReduceImmediately(o)
end
local l=math.floor(t.HeroBattleInfo.MaxHP*e[4]*MillionCoe)
local s=e[5]
local o=e[6]
local n=(1-t:CurrHPPer())
local n={e[7],e[8],math.floor(e[9]+n*(e[10]-e[9]))}
t:AddBuff(t,s,o,n)
local r=e[12]
local h=e[13]
local s={e[14],e[15]}
local o=#a
for o=1,o do
local a=a[o]
local n=t:CurrHPPer()
if n<=e[17]*MillionCoe then
if o==1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fAttrLowExcludeSelf,e[18],HeroAttrId.fury)
for o=1,#a do
a[o]:AddFuryWithSkill(e[19])
end
t:AddFuryWithSkill(e[19])
end
elseif n<=e[16]*MillionCoe then
if o==1 then
a.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
elseif n<=e[11]*MillionCoe then
a:AddBuff(t,r,h,s)
end
local e=0
if o==1 then
e=l
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d,0,e)
end
return nil
end
return l 
