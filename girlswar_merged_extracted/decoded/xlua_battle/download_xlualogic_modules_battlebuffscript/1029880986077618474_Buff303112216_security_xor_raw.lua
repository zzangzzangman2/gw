local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,n,i,s,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if i==nil or o==nil then
return
end
if o.teamId==e.CurrHeroCtrl:GetTeamId()then
return
end
t.AddBuffYueZhiChao(e,i.profession,n[1])
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.allHeroSkillAttackComplete then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddbuffInBattle(e)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local i=0
local o=0
local a=0
for e=1,#n do
local e=n[e].profession
if e==ProfessionType.Tank then
i=i+1
elseif e==ProfessionType.Mage then
o=o+1
elseif e==ProfessionType.Warrior then
a=a+1
end
end
t.AddBuffYueZhiChao(e,ProfessionType.Tank,i)
t.AddBuffYueZhiChao(e,ProfessionType.Mage,o)
t.AddBuffYueZhiChao(e,ProfessionType.Warrior,a)
end
function e.AddBuffYueZhiChao(e,o,a)
if e==nil or e.CurrHeroCtrl==nil then
return 0
end
return t.AddBuffYueZhiChaoTo(e,e.CurrHeroCtrl,o,a,true)
end
function e.AddBuffYueZhiChaoTo(a,i,n,h,d)
if a==nil or a.CurrHeroCtrl==nil or i==nil then
return 0
end
if h==nil or h<=0 then
return 0
end
local e=a:GetBuffData()
local t
local s
local o
if n==ProfessionType.Tank then
t=e[2]
s=e[3]
o={e[4]}
elseif n==ProfessionType.Mage then
t=e[5]
s=e[6]
o={e[7]}
table.insert(o,0)
elseif n==ProfessionType.Warrior then
t=e[8]
s=e[9]
o={e[10],e[11],e[12],e[13]}
table.insert(o,0)
else
return 0
end
local r=0
local e=i.HeroBattleInfo:GetBuff(t)
if e then
r=e:GetFloors()
end
i:AddBuff(a.CurrHeroCtrl,t,s,o,h)
local o=0
local e=i.HeroBattleInfo:GetBuff(t)
if e then
o=e:GetFloors()
end
local e=o-r
if d~=false and i.HeroId==a.CurrHeroCtrl.HeroId and e>0 then
local t=303112221
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoActionOnYueZhiChaoAdded(a,n,e)
end
end
return e
end
return t

