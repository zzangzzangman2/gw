local d=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local s=302110412
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill(n,a)
end
local r=i.atkType
if o then
r=o.triggerSkillAtkType
end
local h=302110409
local o=t.HeroBattleInfo:GetBuff(h)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.GetWineBibberBuffOneFloor(o,{triggerSkillAtkType=r})
end
local l=e[1]
local h={302110406,302110404,302110415}
for a=1,#h do
local i=h[a]
local o=t.HeroBattleInfo:GetBuff(i)
if o then
local a=0
if i==302110406 then
a=o:GetFloors()
else
local e=o:GetBuffData()
a=e[3]
end
if a>0 then
local o=t.HeroBattleInfo.MaxHP
local e=math.floor(o*e[3]*a*MillionCoe)
d:ReduceSepsisHp(t,t,e,true,true)
break
end
end
end
local r=302110406
local h=t.HeroBattleInfo:GetBuff(r)
if h then
local a=h:GetFloors()
if a>=e[9]then
t.HeroBattleInfo:RemoveBuffWithId(r,BuffRemoveType.Expire)
if n then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(s)
local t=e[11]
local e={e[12],e[13],e[14]}
a.AddBuffDionysianDescent(n,t,e)
else
local o=e[10]
local a=e[11]
local e={e[12],e[13],e[14]}
t:AddBuff(t,o,a,e)
end
end
end
local s=e[4]
local n=e[5]
local h=e[6]
local r={e[7],e[8]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(s,t,n,h,r)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,l)
local a=a[3]
local i=a.reduceHpValue
if o then
local a=o:GetBuffData()
local a=a[4]
local a=math.floor(i*a*MillionCoe)
d:AddSepsisHp(t,e,a)
end
end
return nil
end
return u

