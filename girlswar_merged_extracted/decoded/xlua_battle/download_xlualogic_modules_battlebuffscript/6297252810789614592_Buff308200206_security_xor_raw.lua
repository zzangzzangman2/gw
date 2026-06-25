local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if(i.IsOurHero==e.CurrHeroCtrl.IsOurHero)then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if#t>0 then
local o=o:FindMostBigAtk(t)
if o.HeroId==i.HeroId then
local i=a[1]
local n=a[2]
local t={}
for e=3,8 do
table.insert(t,a[e])
end
table.insert(t,1)
o:AddBuff(e.CurrHeroCtrl,i,n,t)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

