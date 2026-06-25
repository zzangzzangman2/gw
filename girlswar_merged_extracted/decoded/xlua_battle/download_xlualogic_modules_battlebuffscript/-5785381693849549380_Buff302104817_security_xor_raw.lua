local e={}
local r=e
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
function e.DoActionBigSkill(t,o)
local e=t:GetBuffData()
local a={
attrId=e[1],
value=e[2],
}
t.CurrHeroCtrl:AddAttrValueInBattle(a)
local a={
attrId=e[3],
value=e[4],
}
t.CurrHeroCtrl:AddAttrValueInBattle(a)
local i=e[9]
local r=e[10]
local d=e[11]
local h={e[12],e[13]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
if#a==e[14]then
i=e[15]
end
local s=e[16]
local n=e[17]
local a={}
for t=18,26 do
table.insert(a,e[t])
end
for t=10,13 do
table.insert(a,e[t])
end
local e=math.floor(t.CurrHeroCtrl:GetFinalAtk()*e[21]*MillionCoe)
table.insert(a,e)
for e=1,#o do
local e=o[e]
e:CheckAddBuff(i,t.CurrHeroCtrl,r,d,h)
e:AddBuff(t.CurrHeroCtrl,s,n,a)
end
end
return r

