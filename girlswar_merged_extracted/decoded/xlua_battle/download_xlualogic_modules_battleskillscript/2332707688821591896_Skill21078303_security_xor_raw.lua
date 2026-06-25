local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local o={a}
t:ReduceFury(i.costMp)
local d=e[1]
local s=e[3]
local o=e[4]
local n={e[5],e[6]}
t:AddBuff(t,s,o,n)
local n=e[7]
local o=e[8]
local s={e[9],e[10]}
t:AddBuff(t,n,o,s)
local s=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
local o={}
table.insert(o,{count=e[11],rate=e[12]})
table.insert(o,{count=e[13],rate=e[14]})
table.insert(o,{count=e[15],rate=e[16]})
local h=0
local n=0
local r=RandomMgr:GetBattleRandom()
for e=1,#o do
n=n+o[e].rate
if(n>=r)then
h=o[e].count
break
end
end
local o={}
if#s>0 then
o=RandomTableWithSeed(s,h)
end
local n=t:GetFinalAtk()
local h=math.floor(n*e[17]*MillionCoe)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(o,a)
local n={}
table.insert(n,a.HeroId)
local s=#o
for e=1,s do
local e=o[e]
table.insert(n,e.HeroId)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,0,nil,h)
end
t:SetLastBigSkillTargetHeroIds(n)
local s=302107826
local n=t.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.StartAttackWithBigSkill(n)
end
local r=e[18]
local s=e[19]
local n={e[20],e[21],e[22],e[23]}
t:AddBuff(t,r,s,n)
if i.atkType~=ETriggerSkillAtkType.FightBack then
local e=t.HeroBattleInfo:GetBuff(302107828)
if e then
local o=e:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(302107828)
if a.IsFireBigSkill(e,o)==false then
a.SetFireBigSkill(e,o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMostDebuff)
if e~=nil then
e.HeroBattleInfo:DispelAllGranBuff(false)
end
end
end
else
local o=#o+1
local n=e[24]
local s=e[25]
local a=e[26]+e[27]*o
local i=t.HeroBattleInfo:GetBuff(n)
if i then
local e=i:GetBuffData()
a=a+e[1]
end
local i={a}
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
t:AddBuff(t,n,s,i)
local a=e[28]+e[29]*o
if(a>=RandomMgr:GetBattleRandom())then
local a=302107811
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local o=t:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddHorseByBigSkill(t,o,e[30])
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,d,nil,h)
return nil
end
return d

