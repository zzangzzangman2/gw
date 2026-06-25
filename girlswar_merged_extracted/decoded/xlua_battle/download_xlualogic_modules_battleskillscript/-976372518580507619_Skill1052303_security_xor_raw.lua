local m=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local d=e[1]
local l=e[3]
local n=e[4]
local c=e[5]
local u={e[6]}
local o=t.CurrBattleTeam:GetFrontOrBackHeros(true)
for a=1,#o do
local o=o[a]
local i=e[8]
local a=e[9]
local e={e[10],e[11]}
o:AddBuff(t,i,a,e)
end
local h=0
local o=nil
local s=#a
for r=1,s do
local a=a[r]
a:CheckAddBuff(l,t,n,c,u)
if a.battleStationRow==2 then
o=a
end
local o=d
if a.HeroBattleInfo:GetBuff(n)then
o=o+e[7]
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
if s>=2 and a.battleStationRow==1 then
if e and#e>=3 then
h=e[3].criticalOrBlock
end
end
end
if h==2 then
return nil
else
if o then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,e[12],{o},m:Handler(o.HeroId,function(e)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e and e.HeroBattleInfo and e.HeroBattleInfo.CurrHP>0
and e:IsNotUsualState()==false and e.WillNotUsual==false then
return true
end
return false
end))
else
return nil
end
end
return nil
end
return l

