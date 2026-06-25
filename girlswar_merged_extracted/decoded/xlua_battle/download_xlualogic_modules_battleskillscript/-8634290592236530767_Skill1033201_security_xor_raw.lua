local e={
}
local n=e
function e.DoAction(e,i)
local o=e:JudgeSkillPreView(i)
local n=o[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=0
if(o[3]>=RandomMgr:GetBattleRandom())then
local o=o[4]
local e=t.HeroBattleInfo:DispelGranBuff(true,o,nil,nil,e.HeroId)
if(e and#e>0)then
a=a+#e
end
end
if a>0 then
e:CheckHpHealthByDispelBuff(a)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
