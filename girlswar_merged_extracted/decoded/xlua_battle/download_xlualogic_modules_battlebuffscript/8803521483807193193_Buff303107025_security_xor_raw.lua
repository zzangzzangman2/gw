local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=t[1]
local a=t[2]
local i={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,a,i)
local n=t[5]
local i=t[6]
local a={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,a)
o.AddBuffMuscleStrength(e,t,t[17])
e.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffMuscleStrength(t,e,a)
local o=e[9]
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i then
i:AddFloors(a)
else
local i=e[10]
local e={e[11],e[12],e[13],e[14],e[15],e[16]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
end
function a.DoBeansActionSmallSkill(t)
local e=t:GetBuffData()
local a=e[18]
o.AddBuffMuscleStrength(t,e,e[19])
return a
end
return o

