local n=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=t[1]
local r=t[3]
local s=t[4]
local o=t[5]
a:CheckAddBuff(r,e,s,o,0)
local o=1
local s=e.HeroBattleInfo:GetBuff(30109902)
if s then
o=t[8]
end
local s=e:GetFinalAtk()
local s=math.floor(s*o*t[6]*MillionCoe)
n:HpHealthWithSmallSkillAndParam(e,i.skilltype,s)
e:AddFuryWithSkill(t[7]*o)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,h)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

