local i=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local h=e[1]
local n=e[3]
local s=e[4]
local r={e[5],e[6]}
t:AddBuff(t,n,s,r)
local s=e[7]
local n=e[8]
local d=e[9]
local r={e[10],e[11]}
a:CheckAddBuff(s,t,n,d,r)
local n=math.floor(t.HeroBattleInfo.MaxHP*e[12]*MillionCoe)
i:HpHealthWithSmallSkillAndParam(t,o.skilltype,n)
t:AddFuryWithSkill(e[13])
if e[14]==a.profession then
local o=e[15]
local i=e[16]
local e={e[17],e[18]}
a:AddBuff(t,o,i,e)
elseif e[19]==a.profession then
local i=e[20]
local o=e[21]
local e={e[22],e[23]}
a:AddBuff(t,i,o,e)
elseif e[24]==a.profession then
local o=e[25]
local i=e[26]
local e={e[27],e[28]}
a:AddBuff(t,o,i,e)
end
local n=0
local e=30106415
local i=t.HeroBattleInfo:GetBuff(30106415)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e and e.GetRealHurt then
n=e.GetRealHurt(i,a)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h,0,n)
t:FuryHealth(FuryHealthType.Attack)
local e=nil
local t=t.HeroBattleInfo:GetBuff(30106417)
if t then
e=2
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(nil,nil,nil,nil,EBattleSkillType.SkillSmall,nil,e)
end
return nil
end
return r

