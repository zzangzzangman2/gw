local n=require("Modules/Battle/Formula")
local h=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(i==nil)then
return nil
end
t:ReduceFury(o.costMp)
local r=e[1]
local s=e[4]
local d=e[5]
local a={e[6],e[7]}
t:AddBuff(t,s,d,a)
local a=e[8]
local s=e[9]
local d={e[10],e[11]}
t:AddBuff(t,a,s,d)
local s=e[12]
local a=e[13]
local d={e[14],e[15]}
t:AddBuff(t,s,a,d)
local a=e[16]
local d=e[17]
local s={e[18],e[19]}
t:AddBuff(t,a,d,s)
local s=math.floor(t:GetFinalAtk()*(e[20])*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fState,1,nil,e[21])
local a=a[1]
if a then
if a.HeroId~=t.HeroId then
t.HeroBattleInfo:DispelAllGranBuff(false)
a.HeroBattleInfo:DispelAllGranBuff(false)
local i=math.floor(a:GetFinalAtk()*e[22]*MillionCoe)
local i=n:AddAtkToHero(t,i)
i=math.floor(i*OneMillion)
local i={
attrId=HeroAttrId.atkRate,
value=i,
}
t:AddAttrValueInBattle(i)
local i=n:GetInjureData(a)
local i=i.attackFinalInjureRate*OneMillion
local i=math.floor(i*e[23]*MillionCoe)
local i={
attrId=HeroAttrId.injureRateAdd,
value=i,
}
t:AddAttrValueInBattle(i)
if a:IsUseSkillByRoundAndSkillType(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound,EBattleSkillType.SkillBig)==false then
a:AddFuryWithSkill(e[24])
else
local i=t.HeroBattleInfo:GetMaxHP()
local e=math.floor(i*e[25]*MillionCoe)
h:HpHealthWithBigSkillAndParam(t,o.skilltype,e,1)
h:HpHealthWithBigSkillAndParam(t,o.skilltype,e,1,nil,nil,a)
end
else
local e={
attrId=e[26],
value=e[27],
}
t:AddAttrValueInBattle(e)
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(i,BattleHeroType.fHollow)
if#a>0 then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrlsAndHeroCtrl(a,i)
else
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(i)
end
local i=ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,r,0,s)
local n=i[1]
local i=i[3]
local e=e[3]
local i=s+n*e*MillionCoe
if#a>0 then
for e=1,#a do
local e=a[e]
local a={
openAddFury=false
}
e:SetDisableDefRage(true)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,0,0,i,a)
e:SetDisableDefRage(false)
end
end
return nil
end
return r

