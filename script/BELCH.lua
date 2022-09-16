BELCH={}
--신식 턴제 파개
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
   cregeff(c,e,forced,...)
   local code=c:GetOriginalCode()
   local mt=_G["c"..code]
      if code==72710085 and mt.eff_ct[c][1]==e then
      e:SetCountLimit(9999)
      e:SetCost(BELCH.tgcost)
   end
end
function BELCH.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsPlayerAffectedByEffect(tp,52642107) then
		if chk==0 then return true end
	else if chk==0 then return Duel.GetFlagEffect(tp,72710085)<1 end
	end
	Duel.RegisterFlagEffect(tp,72710085,RESET_PHASE+PHASE_END,0,1)
end

