local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=t[1]
local h=t[3]
local r=t[4]
local l=t[5]
local m=0
local u=t[6]
local w=t[7]
local f=t[8]
local c=t[10]
local i=e.HeroBattleInfo:GetBuff(303101512)
local o=0
local n=#a
for o=1,n do
local a=a[o]
a:CheckAddBuff(h,e,r,l,m)
local o=c
if i then
local e=a.HeroBattleInfo:GetBuff(303101518)
if e then
local e=i:GetBuffData()
o=e[1]
end
end
local t={t[9],o}
a:CheckAddBuff(u,e,w,f,t)
end
local i=303101513
local t=e.HeroBattleInfo:GetBuff(i)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local e=e.DoBeansActionSmallSkill(t,a)
o=o+e
end
if o>0 then
local t=303101513
local t=e.HeroBattleInfo:GetBuff(t)
if(t)then
local a=t:GetBuffData()
local i=e.HeroBattleInfo.MaxHP
local a=math.floor(i*a[10]*o*MillionCoe)
e:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
end
for t=1,n do
local t=a[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,d)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

