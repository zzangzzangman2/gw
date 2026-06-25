local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now or a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
e[17]=0
e[19]=0
elseif a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if(o.IsOurHero~=t.CurrHeroCtrl.IsOurHero)then
if e[17]<e[16]or e[19]<e[18]then
if(e[1]>=RandomMgr:GetBattleRandom())then
local a={
attrId=e[2],
value=e[3],
}
o:AddAttrValueInCurAttack(a)
local a=true
if e[17]<e[16]and e[19]<e[18]then
if RandomMgr:GetBattleRandom()<5000 then
a=true
else
a=false
end
elseif e[17]<e[16]then
a=true
else
a=false
end
if a==true then
e[17]=e[17]+1
local i=e[4]
local a=e[5]
local e={e[6],e[7],e[8],e[9],e[10],e[11]}
o:AddBuff(t.CurrHeroCtrl,i,a,e)
else
e[19]=e[19]+1
local a=e[12]
local i=e[13]
local e={e[14],e[15]}
o:AddBuff(t.CurrHeroCtrl,a,i,e)
end
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundEnd or e==BuffTriggerTime.allSkillAttack)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

