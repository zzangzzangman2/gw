local i=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,a)
local o=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
e.HeroBattleInfo:RemoveBuffWithId(302103915,BuffRemoveType.Expire)
local s=o[1]*MillionCoe
local h=e:GetFinalAtk()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(t~=nil)then
local n=#t
for n=1,n do
local t=t[n]
if(o[3]>=RandomMgr:GetBattleRandom())then
t.HeroBattleInfo:DispelGranBuff(false,1)
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(302103903)
o.CheckAddBuffAction(e,t)
i:HpHealthWithBigSkillAndParam(e,a.skilltype,h,s,nil,nil,t)
end
end
local t=302103913
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=21039304
local a=ModulesInit.BattleSkillMgr.GetSkillScript(t)
local o=i:GetSkillActData(t)
local e=a.DoAction(e,o)
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,t)
else
return nil
end
end
return s 
