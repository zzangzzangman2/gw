local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,o,i,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local n=nil
if i and i.isFightBack==true then
n=ETriggerSkillAtkType.FightBack
local a=30105106
local e=t.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.OnFightBack(e,e:GetBuffData())
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local d=e[1]
local s=e[3]
local i=e[4]
local h={e[5],e[6]}
t:AddBuff(t,s,i,h)
local s=e[7]
local h=e[8]
local i={e[9],e[10]}
t:AddBuff(t,s,h,i)
local i={
attrId=e[11],
value=e[12],
}
t:AddAttrValueInCurAttack(i)
local i=#a
for i=1,i do
local a=a[i]
local i={
attrId=e[13],
value=e[14],
}
a:AddAttrValueInCurAttack(i)
local i=e[15]
local s=e[16]
local r=e[17]
local h=a.HeroBattleInfo:GetMaxHP()
local h=h*e[20]*MillionCoe
local e={e[18],e[19],h}
a:CheckAddBuff(i,t,s,r,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,d,0,0,{triggerSkillAtkType=n})
end
return nil
end
return d

