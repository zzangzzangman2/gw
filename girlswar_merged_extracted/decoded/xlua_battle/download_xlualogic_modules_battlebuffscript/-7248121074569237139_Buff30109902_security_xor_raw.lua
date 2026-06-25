local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(t,e)
local e={
buffId=t.buffId,
hpMaxRate=e[2],
count=e[3],
}
t.CurrHeroCtrl:AddReduceHpMaxRateInSkillActList(e)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:RemoveReduceHpMaxRateInSkillActList(e.buffId)
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false,false)
local a=30109907
local t=1
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,0)
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

