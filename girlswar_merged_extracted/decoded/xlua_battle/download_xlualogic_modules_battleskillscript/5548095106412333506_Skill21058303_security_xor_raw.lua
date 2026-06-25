local e=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(o==nil)then
return nil
end
t:ReduceFury(i.costMp)
local d=e[1]
local a={}
table.insert(a,o)
local h=0
local r=0
local n=302105822
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o,BattleHeroType.fHollow)
for t=1,#e do
table.insert(a,e[t])
end
h,r=t.DoActionBigSkill(s)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=t.HeroBattleInfo:GetBuff(302105804)
if n then
local a=n:GetFloors()
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=e[6]
local i=e[7]
local s={e[8],e[9]*a}
t:AddBuff(t,o,i,s)
local s=e[10]
local o=e[11]
local i={e[12],e[13]*a}
t:AddBuff(t,s,o,i)
local i=e[14]
local o=e[15]
local e={e[16],e[17]*a}
t:AddBuff(t,i,o,e)
t.HeroBattleInfo:RemoveBuffWithId(n.buffId,BuffRemoveType.Expire)
end
local n=t.HeroBattleInfo:GetBuff(302105810)
if n==nil and t:CurrHPPer()<e[18]*MillionCoe then
local a=e[19]
local o=e[20]
local e={e[21]}
t:AddBuff(t,a,o,e)
end
for n=1,#a do
local a=a[n]
if ModulesInit.ProcedureNormalBattle.IsPVE()==false or e[22]==1 then
local i=e[3]
local o=e[4]
local e={e[5]}
a:AddBuff(t,i,o,e)
end
local e=h
if a.HeroId==o.HeroId then
e=d
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,e,0,r)
end
return nil
end
return l

