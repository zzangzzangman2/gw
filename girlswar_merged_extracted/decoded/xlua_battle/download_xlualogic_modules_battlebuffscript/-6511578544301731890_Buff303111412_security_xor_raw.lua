local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
ModulesInit.ProcedureNormalBattle.StealFury(t.CurrHeroCtrl,a,e[1],EBattleSrcType.SkillSmall,true)
local o=0
local i=303111401
local a=a.HeroBattleInfo:GetBuff(i)
if a then
local e=a:GetBuffData()
o=e[7]
end
local n=e[2]
local i=e[3]
local a={}
for o=4,5 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,a)
return o
end
return s

