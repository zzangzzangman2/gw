local e=require("Modules/Battle/Formula")
local e={
}
local u=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local a=nil
local d=i.atkType
if o then
d=o.triggerSkillAtkType
if o.defHeroIds then
local e=o.defHeroIds[1]
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local h=false
local o=0
local r=302108419
local s=t.HeroBattleInfo:GetBuff(r)
if s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
h,o=e.DoActionBigSkill(s,a)
end
local l=e[1]
if h then
l=o
end
local o=e[3]
local n=e[4]
local u={e[5],e[6]}
a:AddBuff(t,o,n,u)
local u=e[7]
local n=e[8]
local o={e[9],e[10]}
a:AddBuff(t,u,n,o)
local c=e[11]
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
table.insert(n,a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(n)
local m=e[16]
local o=e[17]
local u={e[18],e[19]}
t:AddBuff(t,m,o,u)
if d==ETriggerSkillAtkType.FightBack then
local i=e[20]
local n=e[21]
local o={e[22],e[23]}
t:AddBuff(t,i,n,o)
local e={e[22],e[23]}
a:AddBuff(t,i,n,o)
end
local d=false
local o=0
for e=1,#n do
local e=n[e]
local n
if e.HeroId==a.HeroId then
n=l
else
n=c
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,n)
local t=t[3]
local i=t.criticalOrBlock
local t=t.reduceHpValueBeforeCurrHPLimit
if i==1 then
d=true
end
if e.HeroId==a.HeroId then
if t>e.HeroBattleInfo.CurrHP then
o=t-e.HeroBattleInfo.CurrHP
o=math.min(o,e.HeroBattleInfo.MaxHP)
end
end
end
t:RemoveMustCritValueInCurAttack()
local a=e[12]
if d==false then
local o=e[13]
local e={e[14],e[15]}
t:AddBuff(t,a,o,e,1)
else
t.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
if h then
if o>0 and s then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
e.AddPursuitAttack(s,o)
end
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillBig,nil,nil,nil,21084304)
end
return nil
end
return u 
