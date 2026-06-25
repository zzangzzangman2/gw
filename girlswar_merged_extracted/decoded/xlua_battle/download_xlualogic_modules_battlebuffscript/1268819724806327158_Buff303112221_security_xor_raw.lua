local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,o,n,s,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.now then
local t=t.CurrHeroCtrl
t:AddBuff(t,e[1],e[2],{e[3],e[4]})
t:AddBuff(t,e[5],e[6],{e[7],e[8]})
elseif i.buffTriggerTime==BuffTriggerTime.anyHeroSkillBeAttack then
if o==nil then
return
end
if o.IsOurHero~=t.CurrHeroCtrl.IsOurHero then
return
end
if o.HeroId==t.CurrHeroCtrl.HeroId then
return
end
if s.attackType~=AttackType.BigSkill then
return
end
a.TriggerEmptyMarksByOurBigSkill(t,n)
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.anyHeroSkillBeAttack then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.TriggerEmptyMarksByOurBigSkill(t,e)
local t=303112207
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ApplyEmptyMarkHurtAndInjureRes(e)
end
end
function e.DoActionOnYueZhiChaoAdded(t,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o==nil or o<=0 then
return
end
local e=t:GetBuffData()
local i=a.ShareYueZhiChaoToTopAtkHeroCtrl(t,i,e[9])
e[16]=e[16]+o+i
local i=e[10]
local o=math.floor(e[16]/i)
if o>0 then
e[16]=e[16]-o*i
a.AddBuffMirrorShield(t,o)
end
end
function e.ShareYueZhiChaoToTopAtkHeroCtrl(e,n,t)
if t==nil or t<=0 then
return 0
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMaxFinalAtk)
if a==nil then
return 0
end
local o=303112216
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if i==nil then
return 0
end
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local t=o.AddBuffYueZhiChaoTo(i,a,n,t,false)
if a.HeroId==e.CurrHeroCtrl.HeroId then
return t or 0
end
return 0
end
function e.AddBuffMirrorShield(t,e)
if e==nil or e<=0 then
return
end
local n=t:GetBuffData()
local o=t.CurrHeroCtrl
local i=o.HeroBattleInfo.MaxHP
local e=math.floor(i*n[11]*MillionCoe)*e
if e<=0 then
return
end
a.AddBuffMirrorShieldTo(t,o,e)
end
function e.AddBuffMirrorShieldTo(n,e,t)
if e==nil or e.HeroBattleInfo==nil or e.HeroBattleInfo.CurrHP<=0 then
return
end
if t==nil or t<=0 then
return
end
local a=n:GetBuffData()
local i=a[12]
local s=a[13]
local o=n.CurrHeroCtrl.HeroBattleInfo.MaxHP
local h=math.floor(o*a[15]*MillionCoe)
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddShield(o,t)
o:SetRound(s)
return
end
local t={a[14],h,t}
e:AddBuff(n.CurrHeroCtrl,i,s,t)
end
return a

