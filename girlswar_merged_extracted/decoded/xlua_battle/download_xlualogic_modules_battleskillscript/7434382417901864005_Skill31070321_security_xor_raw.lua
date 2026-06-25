local f=require("Modules/Battle/BattleUtil")
local r={}
local s=r
function r.DoAction(e,n)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercent)
if(t==nil)then
return nil
end
e:ReduceFury(n.costMp)
e:RemoveOneBeans()
local r=a[1]
local i=a[4]
local h=a[5]
local o={a[6],a[7]}
t:AddBuff(e,i,h,o)
local o=nil
local i=303107012
local h=e.HeroBattleInfo:GetBuff(i)
if(h)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
o=e.GetSkyChild(h)
end
local d=0
local u=a[9]*MillionCoe
local l=a[10]*MillionCoe
if n.atkType==ETriggerSkillAtkType.PursuitAttack or n.atkType==ETriggerSkillAtkType.AsistAttack then
if o then
local e=o:GetFinalAtk()
d=e*a[8]*MillionCoe
end
end
if o then
if o.HeroId~=e.HeroId and e:GetOverdrawFury()<=0 then
local t=o.HeroBattleInfo.Fury-o.HeroBattleInfo.CurrFury
o:AddFuryWithBuff(t)
local o=e.HeroBattleInfo.CurrFury
if o>=t then
e:ReduceFuryWithBuffImmediately(t)
else
local t=t-o
e:ReduceFuryWithBuffImmediately(o)
local t=math.floor(t*a[19]*MillionCoe)+a[20]
e:AddOverdrawFury(t)
end
e:CheckBattleRoundBigAndSmallSkillStatus()
end
end
local i={}
local c=303107020
local h=e.HeroBattleInfo:GetBuff(c)
if h then
local o=h:GetBuffData()
local m=o[8]
local f=o[9]
r=r+m
local c=ModulesInit.BattleBuffMgr.GetBuffScript(c)
c.AddBuffTotargetHero(h,o,t)
i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fHollow)
if#i>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(i,t)
for o=1,#i do
local o=i[o]
local i=0
if o.battleStationColumn==t.battleStationColumn and o.battleStationRow==2 then
i=r+f
else
i=m
end
local h=s.CalcRealHurt(d,o,u,l)
local t={
openAddFury=false
}
o:SetDisableDefRage(true)
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,i,0,h,t)
o:SetDisableDefRage(false)
local t=t[3]
s.AddBufffractures(e,o,a,t.criticalOrBlock)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
end
local l=s.CalcRealHurt(d,t,u,l)
local d=nil
if h then
d={
openAddFury=false
}
t:SetDisableDefRage(true)
end
local n=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,r,0,l,d)
t:SetDisableDefRage(false)
local h=n[3]
local r=h.reduceHpValue
local n=a[3]
if n>0 then
local a=math.floor(r*n*MillionCoe)
f:AddSepsisHp(e,t,a)
end
if o then
local i=a[15]
local n=a[16]
local t={a[17],a[18]}
o:AddBuffAfterRemove(e,i,n,t)
end
s.AddBufffractures(e,t,a,h.criticalOrBlock)
local o=303107027
local s=e.HeroBattleInfo:GetBuff(o)
if s then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e={}
table.insert(e,t.HeroId)
for t=1,#i do
table.insert(e,i[t].HeroId)
end
a.AddPursuitAttack(s,e)
end
local o=31070304
local e={sepsisHPRate=n,damageHpRate=a[14],defHeroIds={t.HeroId}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,o,nil,function()
if t and t:CheckHeroCanDoAction()then
local e=t:CurrHPPer()
if e<a[11]*MillionCoe then
return true
end
end
return false
end,EBattleSkillType.SkillBig,e)
end
function r.CalcRealHurt(t,e,o,a)
if t>0 then
local e=e.HeroBattleInfo.MaxHP
local o=e*o
local a=e*a
local e=math.max(t,o)
e=math.min(e,a)
e=math.floor(e)
return e
end
end
function r.AddBufffractures(i,a,e,o)
local t=e[25]
if o~=2 then
t=t+e[26]
end
local o=e[21]
local h=e[22]
local n={e[23],e[24]}
local r=a.HeroBattleInfo:GetBuff(o)
local s=0
if r then
s=r:GetFloors()
if s+t>=e[27]then
local t=e[28]
local n=e[29]
local e={e[30],e[31]}
a:AddBuff(i,t,n,e)
a.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
else
a:AddBuff(i,o,h,n,t)
end
else
a:AddBuff(i,o,h,n,t)
end
end
return s

