local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,o,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore then
if type(t[1])=="table"then
if o.HeroId~=e.CurrHeroCtrl.HeroId then
local e={
fury=o.HeroBattleInfo.CurrFury,
atk=o:GetFinalAtk()
}
table.insert(t[1],e)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay then
t[1]={}
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
local a=t[1]
if type(a)=="table"and#a>0 then
local o=302102506
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local i=e:GetBuffData()
for t=1,#a do
local t=a[t]
o.TriggerInheritAction(e,i,t,ETriggerSkillAtkType.PursuitAttack)
end
end
t[1]=nil
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

