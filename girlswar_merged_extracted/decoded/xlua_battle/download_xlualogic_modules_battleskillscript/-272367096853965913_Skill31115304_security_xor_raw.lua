local a=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,r,e,e)
local e=t:JudgeSkillPreView(r)
local e=nil
local n=0
local o=303111501
local i,o=a:GetHeroMostBuffFloor(t,BattleHeroType.enemyAll,o)
if i==nil or o==0 then
local o=303111502
local t,a=a:GetHeroMostBuffFloor(t,BattleHeroType.enemyAll,o)
if t==nil or a==0 then
else
n=a
e=t
end
else
n=o
e=i
end
if(e==nil)then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local i=0
local s=0
local h=303111503
local o=t.HeroBattleInfo:GetBuff(h)
if o then
local e=o:GetBuffData()
i=e[22]
s=e[23]
end
local a=303111512
local a=t.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
i=a[12]
if o then
local e=o:GetBuffData()
local t=e[32]
local t=math.min(t*a[18],a[19])
i=i+t
e[32]=e[32]+1
end
s=a[13]
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(h)
t.AddBuffGhostsPoisonWine(o,e,nil,a[14])
end
local o={
attrId=a[15],
value=a[16],
}
e:AddAttrValueInCurAttack(o)
ModulesInit.ProcedureNormalBattle.StealFury(t,e,a[17],EBattleSrcType.SkillBig,true)
end
local a=t.HeroBattleInfo.MaxHP
local a=math.floor(a*s*n*MillionCoe)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,r,i,0,a)
return nil
end
return d 
