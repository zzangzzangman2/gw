local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o,e,a)
local a=t:JudgeSkillPreView(o)
local e=e.cfgArgs
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local h=e[2]
local i=e[3]
local n=e[4]
local s={e[5]}
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(h,t,i,n,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,r)
end
t.HeroBattleInfo:RemoveBuffWithId(302110410,BuffRemoveType.Expire)
return nil
end
return h 
