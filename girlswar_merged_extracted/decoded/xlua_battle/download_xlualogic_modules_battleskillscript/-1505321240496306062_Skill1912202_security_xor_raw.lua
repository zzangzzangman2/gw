local i={
}
local n=i
function i.DoAction(h,s,e)
local t={}
local i={}
local o={}
local e=e.triggerDataList
if e then
for a=1,#e do
local e=e[a]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.defHeroId)
if a then
i[a.HeroId]={a,e.removeBuffId}
n.OnAddDefHeroCtrl(a,e.realhurt,o,t)
end
local a=e.targetHeroIds
for i=1,#a do
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a[i])
if a then
n.OnAddDefHeroCtrl(a,e.realhurt,o,t)
end
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local e=#t
for e=1,e do
local e=t[e]
if e then
local t=o[e.HeroId]or 0
ModulesInit.ProcedureNormalBattle.SkillHurtWithTeam(h,e,s,0,0,t)
end
end
for t,e in pairs(i)do
local e=e
if e[1]then
e[1].HeroBattleInfo:RemoveBuffWithId(e[2],BuffRemoveType.Dispel)
end
end
return nil
end
function i.OnAddDefHeroCtrl(e,a,t,o)
if e==nil then
return
end
if t[e.HeroId]==nil then
table.insert(o,e)
t[e.HeroId]=a
else
t[e.HeroId]=t[e.HeroId]+a
end
end
return n 
