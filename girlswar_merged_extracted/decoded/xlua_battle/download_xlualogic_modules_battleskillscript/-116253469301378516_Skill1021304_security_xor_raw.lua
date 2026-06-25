local e={}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local o=0
if(a.skilltype and a.skilltype==1)then
local t=e.HeroBattleInfo:TriggerBuffAndReturnValue(BuffTriggerTime.hpHealthWithSkill)
if(t)then
o=t*MillionCoe
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
e:HpHealthWithNormalSkill(e,e.HeroBattleInfo.MaxHP*t[1]*MillionCoe*(1+o),false,EBattleSrcType.SkillBig)
e.HeroBattleInfo:DispelAllGranBuff(false)
local n=t[2]
local s=t[3]
local i={t[4]}
local o=t[5]
local a=t[6]
local t={t[7]}
e:AddBuff(e,n,s,i)
e:AddBuff(e,o,a,t)
return nil
end
return i

