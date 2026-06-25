local r=require("Modules/Battle/BattleUtil")
local e={
}
local m=e
function e.DoAction(t,h)
local e=t:JudgeSkillPreView(h)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil or#a<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local d=e[1]
local c=e[6]
local f=e[7]
local y={e[8],e[9]}
local n=e[10]
local w=e[11]
local s={}
for t=12,16 do
table.insert(s,e[t])
end
local u=e[13]
local m=e[14]
local l={}
local i=e[15]
local o=#a
for o=1,o do
local a=a[o]
local o=d
local d=a.HeroBattleInfo:GetGranBuff(false)
if#d>e[4]then
o=o+e[5]
a:AddBuff(t,c,f,y)
end
a.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
a:AddBuffWithMaxFloor(t,u,m,l,i,i)
a:AddBuff(t,n,w,s)
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,h,o)
local e=e[3]
if e>0 then
local o=o[3]
local o=o.reduceHpValue
local e=math.floor(o*e*MillionCoe)
r:AddSepsisHp(t,a,e)
end
end
return nil
end
return m 
