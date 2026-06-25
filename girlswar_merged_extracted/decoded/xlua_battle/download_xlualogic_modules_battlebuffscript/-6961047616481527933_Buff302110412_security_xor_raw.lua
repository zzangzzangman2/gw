local i=require("Modules/Battle/Formula")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
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
function a.DoActionBigSkill(e,a)
local t=e:GetBuffData()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local i=i:GetFinalBlood(e.CurrHeroCtrl)
local n=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*i*t[3]*MillionCoe)
for a=1,#o do
local a=o[a]
local o=t[1]
local i=t[2]
local t={n}
a:AddBuff(e.CurrHeroCtrl,o,i,t)
end
local n=302110420
local i=1
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,o)
for o=1,#a do
local o=a[o]
local a=t[4]
local i=t[5]
local n=t[6]
local s=e.CurrHeroCtrl:GetFinalAtk()
local s=math.floor(s*t[7]*MillionCoe)
local t={s,t[8]}
o:CheckAddBuff(a,e.CurrHeroCtrl,i,n,t)
end
end
function a.AddBuffDionysianDescent(e,o,a)
local t=e:GetBuffData()
local i=t[9]
for o=10,13 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
end
return h

