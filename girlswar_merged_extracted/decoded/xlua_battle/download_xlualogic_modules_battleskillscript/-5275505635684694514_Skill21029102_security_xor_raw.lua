local a=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,t,o,i)
local i=e:JudgeSkillPreView(t)
local i=o.addHp
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(e~=nil)then
local o=#e
for o=1,o do
local e=e[o]
a:HpHealthWithSmallSkillAndParam(e,t.skilltype,i)
end
end
return nil
end
return n 
