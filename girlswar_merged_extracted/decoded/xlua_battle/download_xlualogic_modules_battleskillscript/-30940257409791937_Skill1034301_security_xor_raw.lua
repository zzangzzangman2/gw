local e={}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local i=t[1]
local n=t[3]
local s=t[4]
local o={t[5]}
e:AddBuff(e,n,s,o)
local n=t[6]
local s=t[7]
local o={t[8]}
e:AddBuff(e,n,s,o)
local n=t[9]
local o=0
if(a.skilltype and a.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
o=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*n*MillionCoe*(1+o),false,EBattleSrcType.SkillBig)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(o~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
if(o.HeroBattleInfo:GetBuff(t[10]))then
i=i+t[11]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,a,i)
end
return nil
end
return s

