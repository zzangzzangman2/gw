local e=require("Modules/Battle/Formula")
local f=require("Modules/Battle/BattleUtil")
local l={}
local d=l
function l.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercent)
if(e==nil)then
return nil
end
a:ReduceFury(o.costMp)
local h=t[1]
local s=t[4]
local n=t[5]
local i={t[6],t[7]}
e:AddBuff(a,s,n,i)
local i=nil
local n=303107012
local s=a.HeroBattleInfo:GetBuff(n)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.GetSkyChild(s)
end
local r=0
local m=t[9]*MillionCoe
local c=t[10]*MillionCoe
if o.atkType==ETriggerSkillAtkType.PursuitAttack or o.atkType==ETriggerSkillAtkType.AsistAttack then
if i then
local e=i:GetFinalAtk()
r=e*t[8]*MillionCoe
end
end
local n={}
local u=303107020
local s=a.HeroBattleInfo:GetBuff(u)
if s then
local t=s:GetBuffData()
local l=t[8]
local f=t[9]
h=h+l
local i=ModulesInit.BattleBuffMgr.GetBuffScript(u)
i.AddBuffTotargetHero(s,t,e)
n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fHollow)
if#n>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,e)
for t=1,#n do
local t=n[t]
local i=0
if t.battleStationColumn==e.battleStationColumn and t.battleStationRow==2 then
i=h+f
else
i=l
end
local n=d.CalcRealHurt(r,t,m,c)
local e={
openAddFury=false
}
t:SetDisableDefRage(true)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,o,i,0,n,e)
t:SetDisableDefRage(false)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
local r=d.CalcRealHurt(r,e,m,c)
local n=nil
if s then
n={
openAddFury=false
}
e:SetDisableDefRage(true)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,h,0,r,n)
e:SetDisableDefRage(false)
local o=o[3]
local n=o.reduceHpValue
local o=t[3]
if o>0 then
local t=math.floor(n*o*MillionCoe)
f:AddSepsisHp(a,e,t)
end
if i then
local o=t[15]
local e=t[16]
local t={t[17],t[18]}
i:AddBuffAfterRemove(a,o,e,t)
end
local i=31070304
local a={sepsisHPRate=o,damageHpRate=t[14],defHeroIds={e.HeroId}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,i,nil,function()
if e and e:CheckHeroCanDoAction()then
local e=e:CurrHPPer()
if e<t[11]*MillionCoe then
return true
end
end
return false
end,EBattleSkillType.SkillBig,a)
end
function l.CalcRealHurt(e,t,a,o)
if e>0 then
local t=t.HeroBattleInfo.MaxHP
local a=t*a
local t=t*o
local e=math.max(e,a)
e=math.min(e,t)
e=math.floor(e)
return e
end
end
return d

