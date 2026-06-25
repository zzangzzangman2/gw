local s=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eHollow)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(n,t)
e:ReduceFury(i.costMp)
local r=a[1]
local o=a[3]
local h=a[4]
local d=a[5]
t:CheckAddBuff(o,e,h,d,0)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,r)
local o=o[3]
local h=o.reduceHpValue
local o=302102908
local o=e.HeroBattleInfo:GetBuff(o)
if o then
local a=o:GetBuffData()
local a=a[5]
local a=math.floor(h*a*MillionCoe)
s:AddSepsisHp(e,t,a)
end
local a=a[6]
if(n~=nil)then
for n,t in ipairs(n)do
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,a)
local a=a[3]
local i=a.reduceHpValue
if o then
local a=o:GetBuffData()
local a=a[5]
local a=math.floor(i*a*MillionCoe)
s:AddSepsisHp(e,t,a)
end
end
end
local a=302102904
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddPursuitAttack(e,t.HeroId,ETriggerSkillAtkType.Normal)
end
return nil
end
return d 
