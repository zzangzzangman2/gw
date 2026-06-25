local s=require("Modules/Battle/Formula")
local e={
}
local c=e
function e.DoAction(t,i,a,e)
local a=t:JudgeSkillPreView(i)
local e=e.drSkillArgs
local h=302110121
local r=t.HeroBattleInfo:GetBuff(h)
local o=r:GetBuffData()
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
t:ReduceFury(i.costMp)
local u=o[2]
local d=e[3]
local n=e[4]
local l={e[5],e[6]}
t:AddBuff(t,d,n,l)
local d=e[7]
local l=e[8]
local n={e[9],e[10]}
t:AddBuff(t,d,l,n)
local l=e[11]
local n=e[12]
local d={e[13],e[14]}
a:AddBuff(t,l,n,d)
local l=e[15]
local d=e[16]
local n={e[17],e[18]}
a:AddBuff(t,l,d,n)
local n=t.HeroBattleInfo.MaxHP
local n=math.floor(n*e[19]*MillionCoe)
local d=s:GetFinalThorn(t)
local s=e[20]
local l=e[21]
local e={e[22],math.floor(e[23]*d)}
t:AddBuff(t,s,l,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local s=t.HeroBattleInfo:GetCurrHP()
local e=t.HeroBattleInfo.MaxHP-s
n=n+math.floor(e*o[3]*MillionCoe)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,u,0,n)
local e=e[3]
local i=e.reduceHpValue
local e=o[4]
local n=math.min(i,s)
if(a.profession==o[5])then
e=o[6]
end
local e=math.floor(i*e*MillionCoe)
t:HpHealthWithBuff(e,EBattleSrcType.Buff,r.releaseHeroId,h,true)
return nil
end
return c 
