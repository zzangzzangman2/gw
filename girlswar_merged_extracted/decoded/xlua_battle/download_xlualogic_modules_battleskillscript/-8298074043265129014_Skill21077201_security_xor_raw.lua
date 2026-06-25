local s=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(t,i,o,e)
local e=t:JudgeSkillPreView(i)
local a=nil
if o and o.defHeroIds then
local e=o.defHeroIds[1]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if e then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.selfColumn)
end
end
local n=nil
if o then
n=o.triggerSkillAtkType
end
if a==nil or#a<=0 then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
end
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local l=e[1]
if e[5]>0 then
local a=302107709
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddNightmareEnergy(t,e[5])
end
end
local u=e[6]
local d=e[7]
local h=e[8]
local o={}
for t=9,14 do
table.insert(o,e[t])
end
local r=#a
for r=1,r do
local a=a[r]
if e[3]>0 then
local a=a.HeroBattleInfo:GetMaxHP()
local e=math.floor(a*e[3]*MillionCoe)
s:HpHealthWithSmallSkillAndParam(t,i.skilltype,e)
end
if e[4]>0 then
ModulesInit.ProcedureNormalBattle.StealFury(t,a,e[4],EBattleSrcType.SkillSmall,true)
end
a:CheckAddBuff(u,t,d,h,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,l,0,0,{triggerSkillAtkType=n})
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return u

