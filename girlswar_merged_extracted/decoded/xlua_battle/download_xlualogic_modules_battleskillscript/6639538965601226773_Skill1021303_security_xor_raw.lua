local e={
}
local s=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
if(e.CurrSkillChangeTimes<t[14])then
if(e:CurrHPPer()<t[12]*MillionCoe)then
e.CurrSkillChangeTimes=e.CurrSkillChangeTimes+1
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[13])
end
end
e:ReduceFury(o.costMp)
local s=t[1]
local n=t[3]
local i=t[4]
local a={t[5]}
e:AddBuff(e,n,i,a)
local n=t[6]
local a=t[7]
local i={t[8]}
e:AddBuff(e,n,a,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s)
local i=t[9]
local o=t[10]
local t=t[11]
local n=require("Modules/Battle/Formula")
if n:CalculateCtrlSuccess(o,i,e,a)then
a:AddBuff(e,o,t,nil)
end
return nil
end
return s 
