local e=require("Modules/Battle/BattleUtil")
local r=require("DataNode/DataManager/DataMgr/DataUtil")
local e={}
local d=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(s.costMp)
local h=e[1]
local n=a.HeroBattleInfo:GetBuff(e[3])
local i=a.HeroBattleInfo:GetBuff(e[9])
local o=false
if i==nil then
local i=e[11]
local n=e[12]
local e=e[13]
o=a:CheckAddBuff(i,t,n,e)
end
if n and i then
local i=e[14]
local o=e[15]
local e={e[16],e[17]}
a:AddBuff(t,i,o,e)
else
local o=true
if n==nil and i==nil then
local e=r:GetBuffCfg(e[9])
local e=a.HeroBattleInfo:GetControlBuff(e.isControl)
if e then
o=true
else
if RandomMgr:GetBattleRandom()<5000 then
o=true
else
o=false
end
end
elseif n==nil then
o=true
else
o=false
end
if o==true then
local i=e[3]
local o=e[4]
local e={e[5],e[6],e[7],e[8]}
a:AddBuff(t,i,o,e)
else
local o=e[9]
local e=e[10]
a:AddBuff(t,o,e,0)
end
end
local o=t.CurrBattleTeam:GetFrontOrBackHeros(false)
if#o>0 then
local a=e[18]
local i=e[19]
local e={e[20],e[21]}
for n=1,#o do
local o=o[n]
o:AddBuff(t,a,i,e)
end
end
local o=t.CurrBattleTeam:GetFrontOrBackHeros(true)
if#o>0 then
local a=e[22]
local n=e[23]
local e={e[24],e[25]}
for i=1,#o do
local o=o[i]
o:AddBuff(t,a,n,e)
end
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fAttrLowExcludeSelf,e[26],HeroAttrId.fury)
for t=1,#o do
o[t]:AddFuryWithSkill(e[27])
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMostDebuff)
if e~=nil and e.HeroId~=t.HeroId then
e.HeroBattleInfo:DispelAllGranBuff(false)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,h)
return nil
end
return d

