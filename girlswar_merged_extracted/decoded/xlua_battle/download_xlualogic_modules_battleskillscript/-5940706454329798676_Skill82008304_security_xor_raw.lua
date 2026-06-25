local e=require("Modules/Battle/BattleUtil")
local a={
}
local s=a
function a.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=a[1]
local o=e:GetFinalAtk()
local s=math.floor(o*a[4]*MillionCoe)
local o=#t
for o=1,o do
local o=t[o]
local t=o.HeroBattleInfo.CurrHP
local t=math.floor(t*a[3]*MillionCoe)
t=math.min(t,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,n,0,t)
end
local t=308200803
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddAttackTask(e)
end
return nil
end
function a.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[5]
local o=e[6]
local a={}
for o=7,11 do
table.insert(a,e[o])
end
t:AddBuff(t,i,o,a)
return nil
end
return s 
