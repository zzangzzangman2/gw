local e={
}
local c=e
function e.DoAction(t,s,e)
local a=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
local e=e.skillParams
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=0
local o=302108828
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
i=e.DoActionBigSkill(n)
end
local c=e[1]
local u=e[3]
local l=e[4]
local d={e[5],e[6]}
local n=e[7]
local o=e[8]
local h={e[9],e[10]}
local r=#a
for r=1,r do
local a=a[r]
a.HeroBattleInfo:DispelAllGranBuff(true,false,t.HeroId)
a:ReduceFuryWithSkill(e[2],t,EBattleSrcType.SkillBig,true,{ignoreImmune=true})
a:AddBuff(t,u,l,d)
a:AddBuff(t,n,o,h)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,c,0,i)
end
return nil
end
return c 
