local e=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local e={
}
local d=e
function e.DoAction(e,i,s,t)
local a=e:JudgeSkillPreView(i)
local t=false
local n=303110703
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t=e.isMaxGodMusic(o)
end
local h=e:GetFinalAtk()
local r=math.floor(h*a[10]*MillionCoe)
if t==false then
local t=nil
if s then
if s.defHeroIds then
local e=s.defHeroIds[1]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
end
if t==nil then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(t==nil)then
return nil
end
local h=303110711
local s=e.HeroBattleInfo:GetBuff(h)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoActionSmallSkill(s)
end
local h=303110718
local s=e.HeroBattleInfo:GetBuff(h)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoBeansActionSmallSkill(s)
end
local s=a[1]
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.GainGodMusic(o,a[3])
end
local h=a[4]
local o=a[5]
local n=a[6]
t:CheckAddBuff(h,e,o,n,0)
local o=t.HeroBattleInfo.MaxHP
local o=math.floor(o*a[9]*MillionCoe)
o=math.min(o,r)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=true
if i.atkType~=ETriggerSkillAtkType.Normal then
a=false
end
local n={
openAddFury=a,
}
if a==false then
t:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,s,0,o)
if a==false then
t:SetDisableDefRage(false)
end
return nil
else
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local h=303110711
local s=e.HeroBattleInfo:GetBuff(h)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoActionSmallSkill(s)
end
local h=303110718
local s=e.HeroBattleInfo:GetBuff(h)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(h)
e.DoBeansActionSmallSkill(s)
end
local s=a[7]
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.GainGodShield(o,a[8])
end
local o=#t
for o=1,o do
local t=t[o]
local o=t.HeroBattleInfo.MaxHP
local o=math.floor(o*a[9]*MillionCoe)
o=math.min(o,r)
local a=true
if i.atkType~=ETriggerSkillAtkType.Normal then
a=false
end
local n={
openAddFury=a,
}
if a==false then
t:SetDisableDefRage(true)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,s,0,o)
if a==false then
t:SetDisableDefRage(false)
end
end
return nil
end
end
return d 
