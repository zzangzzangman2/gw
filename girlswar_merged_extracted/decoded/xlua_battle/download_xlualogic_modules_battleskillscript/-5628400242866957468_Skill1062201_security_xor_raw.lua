local i=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local r=t[1]
local o=a.HeroBattleInfo:GetCurrHP()
local o=math.floor(o*t[3]*MillionCoe)
i:HpHealthWithSmallSkillAndParam(e,n.skilltype,o)
local s=a.HeroBattleInfo:GetCurrFury()
local h=e.HeroBattleInfo:GetCurrFury()
local i=0
if t[8]>=RandomMgr:GetBattleRandom()then
i=t[4]
end
if t[9]>=RandomMgr:GetBattleRandom()then
if h<s then
i=i+t[5]
end
end
ModulesInit.ProcedureNormalBattle.StealFury(e,a,i,EBattleSrcType.SkillSmall,true)
local i=false
local s=e.HeroBattleInfo:GetBuff(30106215)
if s then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
local e=a.GetFuryDamageValue(e)
o=o+math.floor(e*t[6]*MillionCoe)
else
i=true
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,r,0,o)
if i then
local a=a[1]
local t=math.floor(a*t[7]*MillionCoe)
local a=ModulesInit.BattleBuffMgr.GetBuffScript(30106214)
a.AddFuryDamageValue(e,t)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

