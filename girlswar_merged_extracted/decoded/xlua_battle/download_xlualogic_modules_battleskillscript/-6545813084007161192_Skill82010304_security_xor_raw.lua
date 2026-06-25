local e=require("Modules/Battle/BattleUtil")
local s={
}
local l=s
function s.DoAction(t,r)
local e=t:JudgeSkillPreView(r)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local o=RandomMgr:GetBattleRandomWithRange(0,#a)
local n=#a-o
local i=false
if e[9]>0 and o==n then
i=true
end
if o>n or i==true then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local o=#a
for o=1,o do
local a=a[o]
local o=a.HeroBattleInfo.MaxHP
local e=math.floor(o*e[3]*MillionCoe)
a:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.HeroId,0)
end
if e[4]>0 then
local t=RandomTableWithSeed(a,e[4])
local t=t[1]
if t then
t.HeroBattleInfo:DispelGranBuff(false,e[5],true)
end
end
end
local h=0
if o<n or i==true then
local t=t:GetFinalAtk()
h=math.floor(t*e[6]*MillionCoe)
end
local s=#a
for s=1,s do
local a=a[s]
local s=e[7]
if s>0 and(o<n or i==true)then
local e=e[8]
local o={}
a:AddBuff(t,s,e,o)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,r,d,0,h)
end
return nil
end
function s.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return l 
