local e=require("Modules/Battle/Formula")
local w=require("Modules/Battle/BattleUtil")
local d={}
local l=d
function d.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local d=e[1]
local o=e[4]
local n=e[5]
local s={e[6],e[7]}
a:AddBuff(t,o,n,s)
local o=nil
local s=302107012
local n=t.HeroBattleInfo:GetBuff(s)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
o=e.GetSkyChild(n)
end
local h=0
local m=e[9]*MillionCoe
local f=e[10]*MillionCoe
if i.atkType==ETriggerSkillAtkType.PursuitAttack or i.atkType==ETriggerSkillAtkType.AsistAttack then
if o then
local t=o:GetFinalAtk()
h=t*e[8]*MillionCoe
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
local s=d
local u=d
local n={}
local c=302107020
local r=t.HeroBattleInfo:GetBuff(c)
if r then
local e=r:GetBuffData()
local w=e[8]
local o=e[9]
local c=ModulesInit.BattleBuffMgr.GetBuffScript(c)
c.AddBuffTotargetHero(r,e,a)
if a.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
table.insert(n,e[t])
break
end
end
end
if#n>0 then
s=s+o
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,a)
for e=1,#n do
local e=n[e]
local a=l.CalcRealHurt(h,e,m,f)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s,0,a)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
u=d+w
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
end
local n=l.CalcRealHurt(h,a,m,f)
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,u,0,n)
local i=i[3]
local n=i.reduceHpValue
local i=e[3]
if i>0 then
local e=math.floor(n*i*MillionCoe)
w:AddSepsisHp(t,a,e)
end
if o then
local i=e[15]
local a=e[16]
local e={e[17],e[18]}
o:AddBuffAfterRemove(t,i,a,e)
end
local o=21070304
local t={sepsisHPRate=i,damageHpRate=e[14],defHeroIds={a.HeroId}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,o,nil,function()
if a and a:CheckHeroCanDoAction()then
local t=a:CurrHPPer()
if t<e[11]*MillionCoe then
return true
end
end
return false
end,EBattleSkillType.SkillBig,t)
end
function d.CalcRealHurt(e,t,a,o)
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
return l

