local t=require("Modules/Battle/BattleUtil")
local n={
}
local r=n
function n.DoAction(a,s,o)
local e=a:JudgeSkillPreView(s)
local o=o.defHeroId
local t=t:GetTargetHeroCtrl(o)
if t==nil then
return
end
local h=e[8]
local n=RandomMgr:GetBattleRandomWithRange(e[9],e[10])
local i={308201003,308201004,308201005,308201006,308201007}
local o={}
for e=1,#i do
local e=i[e]
local t=t.HeroBattleInfo:GetBuff(e)
if t==nil then
table.insert(o,e)
end
end
local o=RandomTableWithSeed(o,n)
for i=1,#o do
local o=o[i]
if o==308201003 then
local i=e[11]
local o=e[12]
local e={e[13],e[14]}
t:AddBuff(a,i,o,e)
elseif o==308201004 then
local i=e[15]
local o=e[16]
local e={e[17],e[18]}
t:AddBuff(a,i,o,e)
elseif o==308201005 then
local o=e[19]
local i=e[20]
local e={e[21],e[22]}
t:AddBuff(a,o,i,e)
elseif o==308201006 then
local i=e[23]
local o=e[24]
local e={e[25],e[26]}
t:AddBuff(a,i,o,e)
elseif o==308201007 then
local o=e[27]
local i=e[28]
local e={e[29],e[30]}
t:AddBuff(a,o,i,e)
end
end
local n=308201001
local o=a.HeroBattleInfo:GetBuff(n)
if o then
local a=o:GetBuffData()
if a[9]<e[32]then
local e=true
for a=1,#i do
local a=i[a]
local t=t.HeroBattleInfo:GetBuff(a)
if t==nil then
e=false
end
end
if e then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddAttackTask(o)
end
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,s,h)
return nil
end
function n.GetCanTriggerSkill(e)
return false
end
function n.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={e.id}
for a=3,4 do
table.insert(e,t[a])
end
for a=5,7 do
table.insert(e,t[a])
end
table.insert(e,t[31])
table.insert(e,0)
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
return r 
