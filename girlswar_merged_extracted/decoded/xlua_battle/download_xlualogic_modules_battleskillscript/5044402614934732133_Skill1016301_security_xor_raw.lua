local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
e:ReduceFury(i.costMp)
local r=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=t[3]
local s=t[4]
local n=math.floor(e:GetFinalAtk()*(1+t[7])*MillionCoe)
local o=math.floor(a:GetFinalAtk()*t[5]*MillionCoe)
o=math.min(o,n)
local n=math.floor(e:GetFinalDef()*(1+t[8])*MillionCoe)
local t=math.floor(a:GetFinalDef()*t[6]*MillionCoe)
t=math.min(t,n)
e:AddBuff(e,h,s,{o,t})
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,r)
return nil
end
return s 
