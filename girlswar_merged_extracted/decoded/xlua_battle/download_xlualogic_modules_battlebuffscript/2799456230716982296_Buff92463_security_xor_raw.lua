local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneDebuffWithBuffList(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmuneDebuffWithBuffList(e.buffId)
end
function t.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ImmuneDebuff(e,t,a)
local i=e:GetBuffData()
if o:IsDispelDeBuff(t.buffId)then
local n=e:GetFloors()
if(i[5]*n>=RandomMgr:GetBattleRandom())then
local e=o:AddBuffWithBuffCopy(a,e.CurrHeroCtrl,t,{buffAddType=EBuffAddType.FightBack,buffTriggerAddType=EBuffAddType.FightBack})
if ModulesInit.ProcedureNormalBattle.IsSkillAttackType(EBattleSkillAttackType.None)then
if e and a.HeroBattleInfo then
a.HeroBattleInfo:PlayBattleEffectWithBuffId(t.buffId)
end
end
return true
end
end
return false
end
return n

