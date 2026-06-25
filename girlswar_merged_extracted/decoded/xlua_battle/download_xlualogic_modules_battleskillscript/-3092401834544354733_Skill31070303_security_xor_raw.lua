local e=require("Modules/Battle/Formula")
local f=require("Modules/Battle/BattleUtil")
local d={}
local l=d
function d.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local h=e[1]
local o=e[4]
local n=e[5]
local s={e[6],e[7]}
a:AddBuff(t,o,n,s)
local o=nil
local s=303107012
local n=t.HeroBattleInfo:GetBuff(s)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
o=e.GetSkyChild(n)
end
local r=0
local c=e[9]*MillionCoe
local m=e[10]*MillionCoe
if i.atkType==ETriggerSkillAtkType.PursuitAttack or i.atkType==ETriggerSkillAtkType.AsistAttack then
if o then
local t=o:GetFinalAtk()
r=t*e[8]*MillionCoe
end
end
if o then
if o.HeroId~=t.HeroId and t:GetOverdrawFury()<=0 then
local a=o.HeroBattleInfo.Fury-o.HeroBattleInfo.CurrFury
o:AddFuryWithBuff(a)
local o=t.HeroBattleInfo.CurrFury
if o>=a then
t:ReduceFuryWithBuffImmediately(a)
else
local a=a-o
t:ReduceFuryWithBuffImmediately(o)
local e=math.floor(a*e[19]*MillionCoe)+e[20]
t:AddOverdrawFury(e)
end
t:CheckBattleRoundBigAndSmallSkillStatus()
end
end
local n={}
local d=303107020
local s=t.HeroBattleInfo:GetBuff(d)
if s then
local e=s:GetBuffData()
local u=e[8]
local f=e[9]
h=h+u
local o=ModulesInit.BattleBuffMgr.GetBuffScript(d)
o.AddBuffTotargetHero(s,e,a)
n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
if#n>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,a)
for e=1,#n do
local e=n[e]
local o=0
if e.battleStationColumn==a.battleStationColumn and e.battleStationRow==2 then
o=h+f
else
o=u
end
local n=l.CalcRealHurt(r,e,c,m)
local a={
openAddFury=false
}
e:SetDisableDefRage(true)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,o,0,n,a)
e:SetDisableDefRage(false)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
local r=l.CalcRealHurt(r,a,c,m)
local n=nil
if s then
n={
openAddFury=false
}
a:SetDisableDefRage(true)
end
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,h,0,r,n)
a:SetDisableDefRage(false)
local i=i[3]
local n=i.reduceHpValue
local i=e[3]
if i>0 then
local e=math.floor(n*i*MillionCoe)
f:AddSepsisHp(t,a,e)
end
if o then
local a=e[15]
local i=e[16]
local e={e[17],e[18]}
o:AddBuffAfterRemove(t,a,i,e)
end
local t=31070304
local o={sepsisHPRate=i,damageHpRate=e[14],defHeroIds={a.HeroId}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,t,nil,function()
if a and a:CheckHeroCanDoAction()then
local t=a:CurrHPPer()
if t<e[11]*MillionCoe then
return true
end
end
return false
end,EBattleSkillType.SkillBig,o)
end
function d.CalcRealHurt(t,e,a,o)
if t>0 then
local e=e.HeroBattleInfo.MaxHP
local a=e*a
local o=e*o
local e=math.max(t,a)
e=math.min(e,o)
e=math.floor(e)
return e
end
end
return l

