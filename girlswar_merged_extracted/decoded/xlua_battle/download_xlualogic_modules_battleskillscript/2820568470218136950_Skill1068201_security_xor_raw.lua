local s=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
local h=e[1]
local a=e[3]
local r=e[4]
local n={e[5],e[6]}
t:AddBuff(t,a,r,n)
local a=o.HeroBattleInfo:GetMaxHP()
local n=math.floor(a*e[11]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,i.skilltype,n)
ModulesInit.ProcedureNormalBattle.StealFury(t,o,e[12],EBattleSrcType.SkillSmall,true)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fState,1,nil,e[13])
local a=a[1]
if a then
local o=a.HeroBattleInfo:GetMaxHP()
local o=math.floor(o*e[14]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,i.skilltype,o,a)
local s=e[15]
local n=e[16]
local i={e[17],e[18]}
local o=e[23]
a:AddBuffWithMaxFloor(t,s,n,i,1,o)
local n=e[19]
local i=e[20]
local e={e[21],e[22]}
a:AddBuffWithMaxFloor(t,n,i,e,1,o)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(t,o,i,h,0,n)
local a=a[3]
local a=a.criticalOrBlock
if a~=1 then
local a=e[7]
local o=e[8]
local e={e[9],e[10]}
t:AddBuff(t,a,o,e)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

