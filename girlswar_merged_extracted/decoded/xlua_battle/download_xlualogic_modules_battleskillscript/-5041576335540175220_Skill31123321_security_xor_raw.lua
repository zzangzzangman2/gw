local n=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(e,h,t,t)
local t=e:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if a==nil then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(h.costMp)
e:RemoveOneBeans()
local i=#a
local r=303112302
local o=t[4]
if n:GetHeroBuffFloor(e,r)>=t[5]then
o=t[6]
end
local s=0
for i=1,i do
local i=a[i]
local a=i.HeroBattleInfo:GetGranBuff(true,true)
local h=#a
for h=1,h do
local a=a[h]
local a=a.buffId
if t[2]>=RandomMgr:GetBattleRandom()then
local h=n:IsCanStealBuffById(a)and s<o
local o=i.HeroBattleInfo:DispelGranBuffById(a,e.HeroId,t[3])
if#o>0 and h then
local o=o[1]
local o={
buffId=o.buffId,
round=o.round,
buffData=o.buffData,
floors=t[3],
}
n:AddBuffWithBuffCopy(e,i,o)
e.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
local t=303112305
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.SyncExSkillStolenGranBuffToSelfRow(e,o)
end
s=s+1
end
end
end
end
local o=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local d=o-1
local o=nil
local s=0
for e=1,i do
local t=a[e]
local e=t:GetTotalDamageInBigRound(d)
if e>s then
s=e
o=t
end
end
if o==nil then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxFinalAtk)
end
local n=n:GetHeroBuffFloor(e,r)
if n<t[8]then
local a=303112301
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffDestiny(e,e:GetBuffData(),t[9])
end
end
if n>=t[8]then
local s=t[10]
local n=t[11]
local o=t[12]
for t=1,i do
local t=a[t]
t:CheckAddBuff(s,e,n,o,0)
end
end
local r=303112315
local s=e.HeroBattleInfo:GetBuff(r)
local n=t[1]
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
n=n+e.ModifyExSkillBaseHurtRate(s)
e.DoBeansActionAfterExSkill(s,a)
end
for i=1,i do
local i=a[i]
local a=n
if i==o then
a=a+t[7]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,h,a)
end
return nil
end
return d

