local e=require("Modules/Battle/Formula")
local w=require("Modules/Battle/BattleUtil")
local l={}
local u=l
function l.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eMinHpPercent)
if(e==nil)then
return nil
end
a:ReduceFury(o.costMp)
local d=t[1]
local s=t[4]
local n=t[5]
local i={t[6],t[7]}
e:AddBuff(a,s,n,i)
local i=nil
local n=302107012
local s=a.HeroBattleInfo:GetBuff(n)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.GetSkyChild(s)
end
local h=0
local f=t[9]*MillionCoe
local m=t[10]*MillionCoe
if o.atkType==ETriggerSkillAtkType.PursuitAttack or o.atkType==ETriggerSkillAtkType.AsistAttack then
if i then
local e=i:GetFinalAtk()
h=e*t[8]*MillionCoe
end
end
local r=d
local c=d
local n={}
local l=302107020
local s=a.HeroBattleInfo:GetBuff(l)
if s then
local t=s:GetBuffData()
local i=t[8]
local w=t[9]
local l=ModulesInit.BattleBuffMgr.GetBuffScript(l)
l.AddBuffTotargetHero(s,t,e)
if e.battleStationRow==1 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==2 then
table.insert(n,e[t])
break
end
end
end
if#n>0 then
r=r+w
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,e)
for e=1,#n do
local e=n[e]
local t=u.CalcRealHurt(h,e,f,m)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,r,0,t)
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
c=d+i
end
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
end
local n=u.CalcRealHurt(h,e,f,m)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,c,0,n)
local o=o[3]
local n=o.reduceHpValue
local o=t[3]
if o>0 then
local t=math.floor(n*o*MillionCoe)
w:AddSepsisHp(a,e,t)
end
if i then
local n=t[15]
local o=t[16]
local e={t[17],t[18]}
i:AddBuffAfterRemove(a,n,o,e)
end
local i=21070304
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
return u

