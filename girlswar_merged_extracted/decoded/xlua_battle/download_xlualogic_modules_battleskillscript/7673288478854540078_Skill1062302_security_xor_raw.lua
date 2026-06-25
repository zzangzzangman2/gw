local e=require("Modules/Battle/Formula")
local e={}
local h=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
t:ReduceFury(n.costMp)
local h=e[1]
t.MustSmallSkill=true
t:SetCurrRoundCanTriggerSmallSkill()
t:RefreshMustSmallSkill()
t:CheckBattleRoundBigAndSmallSkillStatus()
local o=e[4]
local i=t.HeroBattleInfo:GetBuff(o)
if i==nil then
local a=e[5]
t:AddBuff(t,o,a,0)
local a=t.HeroBattleInfo.MaxHP
local e=math.floor(a*e[6]*MillionCoe)
local a=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
a.AddFuryDamageValue(t,e)
end
local i=e[7]
local o=e[8]
local s={e[9],e[10]}
a:AddBuff(t,i,o,s)
local s=e[11]
local i=e[12]
local o={e[13],e[14]}
a:AddBuff(t,s,i,o)
local o=e[15]
local i=e[16]
local s={e[17],e[18]}
a:AddBuff(t,o,i,s)
local s=e[19]
local i=e[20]
local o={e[21],e[22]}
a:AddBuff(t,s,i,o)
local i=t.CurrBattleTeam:GetFrontOrBackHeros(false)
local o={}
for e=1,#i do
if i[e]:IsFullFury()==false then
table.insert(o,i[e])
end
end
local i=#o
if i>0 then
local t=math.floor(e[23]/i)
t=math.min(t,e[24])
for e=1,#o do
o[e]:AddFuryWithSkill(t)
end
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
local o=o.GetFuryDamageValue(t)
local i=0
if a.profession==e[25]then
i=math.floor(o*e[26]*MillionCoe)
elseif a.profession==e[27]then
i=math.floor(o*e[28]*MillionCoe)
elseif a.profession==e[29]then
i=math.floor(o*e[30]*MillionCoe)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,h,0,i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.fHollow)
if#t>0 then
local i={}
for t=25,30 do
table.insert(i,e[t])
end
local a={}
for e=1,#t do
table.insert(a,t[e].HeroId)
end
local t=1062304
local e={skillHurtRate=e[3],defHeroIds=a,professionAddRates=i,furyDamageValue=o}
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Sequence,t,nil,nil,EBattleSkillType.SkillBig,e)
else
return nil
end
end
return h

