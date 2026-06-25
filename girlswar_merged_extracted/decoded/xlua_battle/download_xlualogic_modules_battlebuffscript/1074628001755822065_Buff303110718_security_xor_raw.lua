local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e[1]
local a=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=e[5]
local o=e[6]
local i={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#o>0 then
local a={
}
for t,e in pairs(ProfessionType)do
a[e]=0
end
for e=1,#o do
local e=o[e].profession
a[e]=a[e]+1
end
local o=e[9]
local i=a[e[10]]
if i>0 then
local s=e[11]
local a=e[12]
local n={e[13],e[14]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,s,a,n,i,o)
local n=e[15]
local a=e[16]
local e={e[17],e[18]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,a,e,i,o)
end
local i=a[e[19]]
if i>0 then
local s=e[20]
local n=e[21]
local a={e[22],e[23]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,s,n,a,i,o)
local n=e[24]
local a=e[25]
local e={e[26],e[27]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,a,e,i,o)
end
local a=a[e[28]]
a=math.min(a,o)
if a>0 then
local i=e[29]
local n=e[30]
local s={e[31],e[32]}
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,i,n,s,a,o)
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e[33]*a)
local o=e[37]+e[38]*a
local i=e[34]
local a=e[35]
local e={e[36],o}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,e)
end
end
t.isExec=true
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.DoBeansActionSmallSkill(t)
local e=t:GetBuffData()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local a=e[39]
local i=e[40]
for n=1,#o do
local e={e[41],e[42]}
o[n]:AddBuff(t.CurrHeroCtrl,a,i,e)
end
local e={e[41],e[42]*e[43]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,e)
end
return h

