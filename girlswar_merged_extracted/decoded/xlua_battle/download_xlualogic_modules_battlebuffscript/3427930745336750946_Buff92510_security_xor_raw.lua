local o=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,n,s,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
i.AddBuffGoldenDivineMight(e,t,t[1])
elseif a.buffTriggerTime==BuffTriggerTime.allSmallSkilAttack then
if(n.IsOurHero==e.CurrHeroCtrl.IsOurHero)then
i.AddBuffGoldenDivineMight(e,t,t[3],t[2])
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd then
local a=t[6]
local o=o:GetHeroBuffFloor(e.CurrHeroCtrl,a)
if o>0 then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e.CurrHeroCtrl:AddFuryWithBuff(o*t[4])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.skillPlayEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffGoldenDivineMight(t,e,n,s)
local a=e[6]
local h=e[7]
local r={e[8],e[9]}
local d=o:GetHeroBuffFloor(t.CurrHeroCtrl,a)
local i=false
if s then
i=t.CurrHeroCtrl:CheckAddBuff(s,t.CurrHeroCtrl,a,h,r,n)
else
i=t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,h,r,n)
end
if i then
local a=o:GetHeroBuffFloor(t.CurrHeroCtrl,a)
local a=a-d
e[14]=e[14]+a
if e[14]>=e[5]then
e[14]=e[14]-e[5]
local a={}
for t=10,13 do
table.insert(a,e[t])
end
local t=t.CurrHeroCtrl.HeroId
local e=1930101
local i={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
skillParam=a
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
o:AddTriggerAttackTask(t,e,i,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
end
return i

