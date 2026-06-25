local t={}
local e=t
local a={
None=0,
Battle=1,
Info=2,
King=3,
}
t.ELiubeiState=a
local i=302108227
local s=302108228
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,a,n,i,s,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.isTriggerSkillEndBuffForEver=true
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,a[1],a[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,a[3],a[4])
e.RefreshKingValueBar(t)
e.EnterBattleState(t,true)
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>1 then
if t.CurrHeroCtrl:GetLastIsSmallSkill()==false and t.CurrHeroCtrl:GetLastIsBigSkill()==false then
local o=a[5]
local a=a[6]
local e={}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,o,a,e)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
local o=t.CurrHeroCtrl.HeroId
if o==n.HeroId then
elseif o==i.HeroId then
local o=s.reduceHpValue
e.OnAfterAttacked(t,a,o)
end
elseif o.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or o.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or o.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
e.OnSkillPlayEnd(t,a)
elseif o.buffTriggerTime==BuffTriggerTime.skillEndBuff then
e.OnSkillEndBuff(t,a)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetCurState(t,e)
return e[47]
end
function t.SetCurState(a,t,e)
t[47]=e
end
function t.ClearKingValue(t,o)
local a=t:GetBuffData()
a[46]=0
local i=a[7]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=GetSkillDesc(o)

end
e.RefreshKingValueBar(t)
end
function t.AddKingValue(a,o,n)
local t=a:GetBuffData()
o=math.floor(o)
t[46]=t[46]+o
local i=t[7]
t[46]=math.min(i,t[46])
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=GetSkillDesc(n)

end
e.RefreshKingValueBar(a)
end
function t.AddKingPercent(t,a,i)
local o=t:GetBuffData()
local o=o[7]
local a=o*a*MillionCoe
e.AddKingValue(t,a,i)
end
function t.ReduceKingValue(a,o,n)
local t=a:GetBuffData()
o=math.floor(o)
local i=t[7]
if t[46]<o then
t[46]=0
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=GetSkillDesc(n)

end
e.RefreshKingValueBar(a)
return false
else
t[46]=t[46]-o
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then
local e=GetSkillDesc(n)

end
e.RefreshKingValueBar(a)
return true
end
end
function t.RemoveKingPercent(t,o,i)
local a=t:GetBuffData()
local a=a[7]
local a=a*o*MillionCoe
return e.ReduceKingValue(t,a,i)
end
function t.GetKingValue(e)
local e=e:GetBuffData()
return e[46]
end
function t.RemoveStateBuff(n,r)
local t=n:GetBuffData()
local h=e.GetCurState(n,t)
local e=0
local o=0
if h==a.Battle then
e=t[8]
elseif h==a.Info then
e=t[14]
o=i
elseif h==a.King then
e=t[36]
o=s
end
if e>0 then
n.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
if r then
if o>0 then
n.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function t.EnterBattleStateFromKing(t)
local a=t:GetBuffData()
e.EnterBattleState(t,false)
a[49]=a[45]
if a[49]<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
end
end
function t.EnterEmptyState(t,o)
local i=t:GetBuffData()
e.RemoveStateBuff(t,o)
e.SetCurState(t,i,a.None)
end
function t.EnterBattleState(t,i)
local o=t:GetBuffData()
e.RemoveStateBuff(t,i)
e.SetCurState(t,o,a.Battle)
local n=o[8]
local i=o[9]
local e={}
for a=10,13 do
table.insert(e,o[a])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,n,i,e)
end
function t.EnterInfoState(t,n)
local o=t:GetBuffData()
e.RemoveStateBuff(t,n)
e.SetCurState(t,o,a.Info)
local e=o[14]
local n=o[15]
local a={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,e,n,a)
local i=i
local a=-1
local e={}
for a=16,35 do
table.insert(e,o[a])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,e)
end
function t.EnterKingState(t,i)
local o=t:GetBuffData()
e.RemoveStateBuff(t,i)
e.SetCurState(t,o,a.King)
local i=o[36]
local e=o[37]
local a={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,e,a)
local a=s
local i=-1
local e={}
for a=38,45 do
table.insert(e,o[a])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,e)
end
function t.OnAfterAttacked(o,t,n)
e.AddKingValue(o,n,"kv_a_afterAttacked")
local e=e.GetCurState(o,t)
if e~=a.Info then
if t[48]>0 then
t[48]=t[48]-1
if t[48]<=0 then
o.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
end
end
function t.OnSkillPlayEnd(o,t)
local i=e.GetCurState(o,t)
if i==a.King then
if t[46]<=0 then
e.EnterBattleStateFromKing(o)
end
else
if t[49]>0 then
t[49]=t[49]-1
if t[49]<=0 then
o.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(s,BuffRemoveType.Expire)
end
end
end
end
function t.OnSkillEndBuff(o,t)
local s=t[7]
local n=e.GetCurState(o,t)
if n==a.Battle then
if t[46]>=s then
if o.CurrHeroCtrl:IsOnAttack()==false then
e.EnterInfoState(o,true)
else
e.EnterKingState(o,true)
end
end
elseif n==a.Info then
if t[46]>=s then
e.EnterKingState(o,false)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(o.CurrHeroCtrl,BattleHeroType.ourAll)
local n=#e
local e=0
for a=24,35,2 do
if n==t[a]then
e=t[a+1]
break
end
end
t[48]=e
if t[48]<=0 then
o.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
elseif n==a.King then
end
end
function GetSkillDesc(e)
if e=="kv_a_afterAttacked"then
return"受击时增加实际受到伤害量的“君王”值"
elseif e=="kv_a_OnShareDamge"then
return"分担的伤害"
elseif e=="kv_a_battle_state_skillPlay"then
return"武装状态攻击"
elseif e=="kv_a_battle_state_attacked"then
return"武装状态受击"
elseif e=="kv_r_fightback_dipel"then
return"反击，若被控制则改为消耗最大“君王”值50%"
elseif e=="kv_r_fightback_realhurt"then
return"反击，对目标附加额外伤害"
elseif e=="kr_c_resurgence"then
return"重生"
elseif e=="kr_c_info_state"then
return"进入见闻"
elseif e=="kv_a_skill"then
return"奥义"
end
return""
end
function t.RefreshKingValueBar(e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=e:GetBuffData()
local a=t[7]
e.CurrHeroCtrl:SetRageBar(t[46],a)
end
end
return e

