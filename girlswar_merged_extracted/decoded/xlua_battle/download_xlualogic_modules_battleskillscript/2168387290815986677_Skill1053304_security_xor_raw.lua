local d=require("Modules/Battle/BattleUtil")
local e={}
local m=e
function e.DoAction(e,s,t)
local a=e:JudgeSkillPreView(s)
if t==nil then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eFront)
end
if(t==nil)then
return nil
end
e:ReduceFury(s.costMp)
local c=a[1]
local l=a[3]
local u=a[4]
local r=0
local i=0
local h=nil
local o=#t
for e=1,o do
local e=t[e]
local t=e:CurrHPPer()
if t>i then
r=e.HeroId
i=t
h=e
end
end
local function m(e)
for a=1,o do
local t=t[a]
if t.HeroId==e then
return true
end
end
return false
end
local n=0
local i={}
if h then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(h,BattleHeroType.ourAllExcludeSelf)
if t and#t>0 then
n=math.ceil(e.HeroBattleInfo:GetCurrHP()*a[8]*MillionCoe/#t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
for e=1,#t do
local a=t[e].HeroId
if m(a)==false then
table.insert(i,t[e])
end
end
end
end
local h={}
for e=1,#t do
table.insert(h,t[e])
end
for e=1,#i do
table.insert(h,i[e])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(h)
for o=1,o do
local t=t[o]
local o=t.HeroBattleInfo:GetBuffSortArr()
if#o>0 then
local i=math.max(#o*a[6],a[7])
local a={a[5],i}
t:AddBuff(e,l,u,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=""
for t=1,#o do
local t=o[t].buffId
if e==""then
e=t
else
e=e.."_"..t
end
end

end
end
local o=0
if r==t.HeroId then
t.mustBeDie=true
o=d:GetRealHurtMustDie(t)
local o=a[9]
local a=a[10]
t:AddBuff(e,o,a)
else
o=n
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,c,nil,o)
end
for t=1,#i do
local t=i[t]
local a=n
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,0,nil,a)
end
return nil
end
return m

