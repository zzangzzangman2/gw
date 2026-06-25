local o=require("Modules/Battle/Formula")
local e={}
local r=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(s.costMp)
local n=e[1]
local i=o:GetInjureResData(t)
local i=i.defFinalInjureResRate
local o=o:GetInjureResData(a)
local o=o.defFinalInjureResRate
if o>i then
local a=e[3]
local o=e[4]
local e={e[5],e[6]}
t:AddBuff(t,a,o,e)
end
if e[7]==a.profession then
n=n+e[8]
end
local o=t:GetFinalAtk()
local h=math.floor(o*e[11]*MillionCoe)
local o=nil
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAllExcludeSelf)
if#i>0 then
for e=1,#i do
if i[e].battleStationColumn==a.battleStationColumn then
o=i[e]
break
end
end
if o==nil then
local e=RandomTableWithSeed(i,1)
o=e[1]
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,n,0,h)
if o then
local t=e[9]
local a={}
local e={skillHurtRate=e[10],realHurt=h,defHeroIds={o.HeroId}}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,t,nil,nil,EBattleSkillType.SkillBig,e)
else
return nil
end
end
return r

