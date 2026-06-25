local e=Class('BaseProcedureBattle',{})
function e:__init()
self.isBlocking=false
end
function e:OnInit(e)

e.totalDic={}
end
function e:AfterBattleTeamReady()

end
function e:OnBattleStart()

end
function e:OnCurWavasMonstersAllDeath()

end
function e:OnNextWaves()

end
function e:OnBattleStop()

end
function e:Destroy()
end
function e:PreLoad()
self.isBlocking=true
end
function e:GetIsCloseLoadingAndBeginBattle()
return self.isBlocking
end
function e:CloseLoadingAndBeginBattle()
self.isBlocking=true
end
return e 
