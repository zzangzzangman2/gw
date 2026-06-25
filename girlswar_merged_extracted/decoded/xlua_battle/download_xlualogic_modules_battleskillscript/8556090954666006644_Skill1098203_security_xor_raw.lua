local n=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,o,a)
local t=e:JudgeSkillPreView(o)
local i=a.defHeroIds
local a=nil
if i then
local e=i[1]
a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
if(a==nil)then
return nil
end
local s=t[1]
local i=e:GetFinalAtk()
local i=math.floor(i*t[3]*MillionCoe)
n:HpHealthWithSmallSkillAndParam(e,o.skilltype,i)
local i=t[4]
local n=t[5]
local h=t[6]
a:CheckAddBuff(i,e,n,h,0)
local t=t[7]
e:AddFuryWithSkill(t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,s)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

