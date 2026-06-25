local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local d=e[1]
local o=nil
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.selfColumn)
if(i)then
for a=1,#i do
local a=i[a]
if a.battleStationRow==2 then
o=a
end
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[3],EBattleSrcType.SkillSmall,true)
end
end
local s=e[4]
local r=e[5]
local h=e[6]
local i={e[7],e[8]}
a:CheckAddBuff(s,t,r,h,i)
local r=e[9]
local h=e[10]
local i=e[11]
local s={e[12],e[13]}
a:CheckAddBuff(r,t,h,i,s)
local r=e[14]
local i=e[15]
local h=e[16]
local s=t:GetFinalAtk()
local e=math.floor(s*e[17]*MillionCoe)
local e={e}
a:CheckAddBuff(r,t,i,h,e)
if o then
local e=a.HeroBattleInfo:GetBuff(i)
if e then
local a=e:GetBuffData()
local i=e.buffId
local n=e:GetRound()
local e={}
for t=1,#a do
table.insert(e,a[t])
end
o:AddBuff(t,i,n,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,d)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return l

