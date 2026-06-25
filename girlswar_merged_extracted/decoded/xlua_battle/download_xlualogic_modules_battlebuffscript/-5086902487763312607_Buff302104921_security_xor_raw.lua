local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local function t()
o[8]=e.CurrHeroCtrl:GetAllSkillUseCountExludeAttachSkill()
end
if e.CurrHeroCtrl:IsOurTeamAttack()then
if ModulesInit.ProcedureNormalBattle.OurTeamFirstAttack then
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
t()
end
else
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
t()
end
end
else
if ModulesInit.ProcedureNormalBattle.OurTeamFirstAttack then
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
t()
end
else
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
t()
end
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoLimitAction(a,e)
local o=e[8]or 0
local t=a.CurrHeroCtrl:GetAllSkillUseCountExludeAttachSkill()
local o=math.max(0,t-o)
local t=e[1]
if o==0 then
t=e[1]
elseif o==1 then
t=e[2]
else
t=e[3]
end
local o=e[4]
local i=e[5]
local e={e[6],e[7]}
if t>0 then
local e=a.CurrHeroCtrl:CheckAddBuff(t,a.CurrHeroCtrl,o,i,e)
if e then
a.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
end
return e
else
return false
end
end
return i

