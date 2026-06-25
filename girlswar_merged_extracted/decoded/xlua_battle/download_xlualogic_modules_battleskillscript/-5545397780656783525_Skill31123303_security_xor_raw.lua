local o=require("Modules/Battle/BattleUtil")
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
local r=#a
local n=303112302
local i=t[4]
if o:GetHeroBuffFloor(e,n)>=t[5]then
i=t[6]
end
local s=0
for n=1,r do
local n=a[n]
local a=n.HeroBattleInfo:GetGranBuff(true,true)
local h=#a
for h=1,h do
local a=a[h]
local a=a.buffId
if t[2]>=RandomMgr:GetBattleRandom()then
local h=o:IsCanStealBuffById(a)and s<i
local i=n.HeroBattleInfo:DispelGranBuffById(a,e.HeroId,t[3])
if#i>0 and h then
local i=i[1]
local t={
buffId=i.buffId,
round=i.round,
buffData=i.buffData,
floors=t[3],
}
local o=o:AddBuffWithBuffCopy(e,n,t)
if o then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
local a=303112305
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.SyncExSkillStolenGranBuffToSelfRow(e,t)
end
s=s+1
end
end
end
end
local o=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
local n=o-1
local o=nil
local i=0
for e=1,r do
local t=a[e]
local e=t:GetTotalDamageInBigRound(n)
if e>i then
i=e
o=t
end
end
if o==nil then
o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxFinalAtk)
end
local s=303112315
local i=e.HeroBattleInfo:GetBuff(s)
local n=t[1]
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
n=n+e.ModifyExSkillBaseHurtRate(i)
e.DoBeansActionAfterExSkill(i,a)
end
for i=1,r do
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

