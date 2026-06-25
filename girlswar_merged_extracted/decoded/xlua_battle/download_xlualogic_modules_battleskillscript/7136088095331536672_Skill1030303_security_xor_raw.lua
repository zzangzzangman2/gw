local e=require("Modules/Battle/BattleUtil")
local e={
}
local l=e
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
local r=math.floor(t.HeroBattleInfo.MaxHP*e[4]*MillionCoe)
local n=e[5]
local s=e[6]
local a=(1-t:CurrHPPer())
local a={e[7],e[8],math.floor(e[9]+a*(e[10]-e[9]))}
t:AddBuff(t,n,s,a)
local h=e[12]
local l=e[13]
local s={e[14],e[15]}
local a=#o
for a=1,a do
local n=o[a]
local o=t:CurrHPPer()
if o<=e[20]*MillionCoe then
if a==1 then
local e=e[21]*MillionCoe
local e=t.HeroBattleInfo.MaxHP*e
t:HpHealthImmediately(e,EBattleSrcType.SkillBig,t.HeroId,0)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMostDebuff)
if e~=nil then
e.HeroBattleInfo:DispelAllGranBuff(false)
end
end
elseif o<=e[17]*MillionCoe then
if a==1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fAttrLowExcludeSelf,e[18],HeroAttrId.fury)
for o=1,#a do
a[o]:AddFuryWithSkill(e[19])
end
t:AddFuryWithSkill(e[19])
end
elseif o<=e[16]*MillionCoe then
if a==1 then
n.HeroBattleInfo:DispelAllGranBuff(true,nil,t.HeroId)
end
elseif o<=e[11]*MillionCoe then
n:AddBuff(t,h,l,s)
end
local e=0
if a==1 then
e=r
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,n,i,d,0,e)
end
return nil
end
return l 
