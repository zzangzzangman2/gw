local e={}
local r=e
function e.DoAction(e,h)
local t=e:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=t[1]
local n=303102504
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o)
end
local s=0
local n=e.HeroBattleInfo:GetBuff(303102503)
if n then
local e=n:GetBuffData()
s=e[2]
end
local n=s*t[3]
n=math.min(n,t[4])
i=i+n
if(a.profession==ProfessionType.Mage or o)then
local t={
attrId=t[5],
value=t[6],
}
e:AddAttrValueInCurAttack(t)
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(n~=nil)then
local s=t[7]
local a=t[8]
local i={t[9],t[10],e.HeroId}
local t=#n
for t=1,t do
local t=n[t]
if(t.profession==ProfessionType.Mage or o)then
t:AddBuff(e,s,a,i)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,h,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

