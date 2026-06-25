local c=require("Modules/Battle/BattleUtil")
local i=require("Modules/Battle/Formula")
local e={}
local r=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
e:ReduceFury(a.costMp)
local h=t[1]
local d=t[3]
local u=t[4]
local l=t[5]
local n=e:GetFinalAtk()
local n=math.floor(n*t[6]*MillionCoe)
local s={n}
local n=e.HeroBattleInfo:GetMaxHP()
local r=t[7]*MillionCoe
local i=i:CalculateHeroAttackCriticalRate(e,nil)
local i=i.attackCriticalRate
local i=r+i*t[8]*MillionCoe
i=math.min(i,t[9]*MillionCoe)
local t=n*i
local t=c:HpHealthWithBigSkillAndParam(e,a.skilltype,t,1,true,true)
local i=e.HeroBattleInfo:GetCurrHP()
if t.resultType==EHealResultType.Heal and i>=n then
local a=t.originHealValue-t.value
if a>0 then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
t:HpHealthSimple(e,a,EBattleSrcType.SkillBig)
end
end
end
local t=#o
for t=1,t do
local t=o[t]
t:CheckAddBuff(d,e,u,l,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
end
return nil
end
return r

