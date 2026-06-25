local n=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,s,e)
local e=t:JudgeSkillPreView(s)
local r=303112206
local h=303112201
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMostDebuff)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=303112208
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(i,a)
end
local i=n:GetHeroBuffFloor(t,h)
local n=e[2]
local o=false
if(i<n)then
local a=math.min(e[3],n-i)
if a>0 then
local t=t.HeroBattleInfo:GetBuff(r)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(r)
if e and e.AddBuffHeartEye then
e.AddBuffHeartEye(t,a)
end
end
end
local o=e[4]
local i=e[5]
local a={e[6],e[7]}
t:AddBuff(t,o,i,a)
local o=e[8]
local a=e[9]
local e={e[10],e[11]}
t:AddBuff(t,o,a,e)
else
t.HeroBattleInfo:RemoveBuffWithId(h,BuffRemoveType.Expire)
o=true
local a=e[12]
local i=e[13]
local o={e[14],e[15]}
t:AddBuff(t,a,i,o)
local a=e[16]
local o=e[17]
local e={e[18],e[19]}
t:AddBuff(t,a,o,e)
end
local i=0
if o then
a:AddForbidEvade(31122201)
t.IgnoreBlock=true
local t=t:GetFinalDef()
i=math.ceil(t*e[20]*MillionCoe)
end
local e=e[1]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,e,0,i)
if o then
t.IgnoreBlock=false
a:RemoveForbidEvade(31122201)
end
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return d

