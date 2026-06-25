local n=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(nil)
e.HeroBattleInfo:RemoveBuffWithId(302103915,BuffRemoveType.Expire)
local h=t[1]*MillionCoe
local r=e:GetFinalAtk()
local i=0
local a=302103905
local a=e.HeroBattleInfo:GetBuff(302103905)
if a then
local t=a:GetFloors()
local e=a:GetBuffData()
i=e[1]*t
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(a~=nil)then
local s=#a
for s=1,s do
local a=a[s]
if(t[3]+i>=RandomMgr:GetBattleRandom())then
a.HeroBattleInfo:DispelGranBuff(false,1,true)
end
local i=ModulesInit.BattleBuffMgr.GetBuffScript(302103903)
i.CheckAddBuffAction(e,a)
e:ResetAttrValuesInCurAttack()
if(a:CurrHPPer()<t[4]*MillionCoe)then
local a={
attrId=t[5],
value=t[6],
}
e:AddAttrValueInCurAttack(a)
local t={
attrId=t[7],
value=t[8],
}
e:AddAttrValueInCurAttack(t)
end
n:HpHealthWithBigSkillAndParam(e,o.skilltype,r,h,nil,nil,a)
end
end
local t=302103913
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=21039304
local a=ModulesInit.BattleSkillMgr.GetSkillScript(t)
local o=n:GetSkillActData(t)
local e=a.DoAction(e,o)
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,t)
else
return nil
end
end
return r 
