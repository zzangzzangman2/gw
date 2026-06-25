local e=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
local d=a
local n=0
local r=true
local h=i.atkType
if o then
if o.realHurt then
n=o.realHurt
end
if o.openAddFury~=nil then
r=o.openAddFury
end
h=o.triggerSkillAtkType
end
if h~=ETriggerSkillAtkType.FightBack then
t:ReduceFury(i.costMp)
end
local o=302108228
local s=t.HeroBattleInfo:GetBuff(o)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
n=n+e.GetRealHurt(s)
end
local l=e[1]
local o=e[3]
local u=e[4]
local s={e[5],e[6]}
t:AddBuff(t,o,u,s)
local u=e[7]
local o=e[8]
local s={e[9],e[10]}
t:AddBuff(t,u,o,s)
t:SetMustSmallSkill()
local o=302108211
local s=t.HeroBattleInfo:GetBuff(o)
if s then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local h=s:GetBuffData()
local h=o.GetCurState(s,h)
if h==o.ELiubeiState.Info then
o.AddKingPercent(s,e[11],"kv_a_skill")
elseif h==o.ELiubeiState.Battle then
local o=a[1]
if o then
local s=e[12]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
for e=1,#a do
local e=a[e]
if e.battleStationColumn~=o.battleStationColumn then
local a={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,s,0,n)
e:SetDisableDefRage(false)
end
end
d=a
end
local o=e[13]
local a=e[14]
local e={e[15],e[16]}
t:AddBuff(t,o,a,e)
elseif h==o.ELiubeiState.King then
for t=1,#a do
local t=a[t]
local a={
attrId=e[17],
value=e[18],
}
t:AddAttrValueInCurAttack(a)
local e={
attrId=e[19],
value=e[20],
}
t:AddAttrValueInCurAttack(e)
end
end
end
local o=302108224
local e=t.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.DoActionBigSkill(e,a,h)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(d)
local e=#a
for e=1,e do
local e=a[e]
if r==false then
local t={
openAddFury=false
}
e:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,l,0,n)
if r==false then
e:SetDisableDefRage(false)
end
end
return nil
end
return u 
