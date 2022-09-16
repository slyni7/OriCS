cyan=cyan or {}
Cyan=cyan

if YGOPRO_VERSION~="Percy/EDO" then
	local slv=Card.GetSynchroLevel
	function Card.GetSynchroLevel(c,sc)
		local le={c:IsHasEffect(EFFECT_LINK_TUNER)}
		for _,te in pairs(le) do
			local f=te:GetValue()
			if f and type(f)=="function" then return f(c,sc) end 
		end
		return slv(c,sc)
	end
	local csm=Card.IsCanBeSynchroMaterial
	function Card.IsCanBeSynchroMaterial(c,sc,...)
		local le={c:IsHasEffect(EFFECT_LINK_TUNER)}
		for _,te in pairs(le) do
			local f=te:GetValue()
			if f and type(f)=="function" and  f(c,sc,...) then return true end
		end
		return csm(c,sc,...)
	end
end
--몬스터 존 이외 카드 랭크 커스텀
-- local gr=Card.GetRank
-- function Card.GetRank(c)
   -- local m=_G["c"..c:GetCode()]
   -- if m.UseRankCustom and c:IsLocation(0x2f8) then
      -- return m.UseRankCustom
   -- end
   -- return gr(c)
-- end

-- local ir=Card.IsRank
-- function Card.IsRank(c,v)
   -- local m=_G["c"..c:GetCode()]
   -- if m.UseRankCustom and c:IsLocation(0x2f8) then
      -- if m.UseRankCustom==v then return true
      -- else return false end
   -- end
   -- return ir(c,v)
-- end

--소멸
function Duel.Delete(e,sg)	
	local over=Group.CreateGroup()
	if aux.GetValueType(sg)=="Group" then
		local tc=sg:GetFirst()
			while tc do
				if tc:IsLocation(LOCATION_REMOVED) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_REMOVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				end
				local ov=tc:GetOverlayGroup()
				over:Merge(ov)
				if tc:GetAdmin() then
					over:AddCard(tc:GetAdmin())
				end
				tc=sg:GetNext()
			end
		local tg=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		sg:Sub(tg)
		Duel.SendtoGrave(over,REASON_RULE)
		Duel.SendtoGrave(tg,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	else
		local ov=sg:GetOverlayGroup()
		over:Merge(ov)
		if sg:GetAdmin() then
			over:AddCard(sg:GetAdmin())
		end
		Duel.SendtoGrave(over,REASON_RULE)
		if sg:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.SendtoGrave(sg,REASON_RULE)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	end
end

--자주 쓰는 함수들
--반역교향 필터
function cyan.MAfilter(c)
	return (c:IsSetCard(0x60a) or c:IsSetCard(0x60b))
end
--패를 x장 버리고 발동(ct=매수)
function cyan.dhcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil) end
		Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_COST+REASON_DISCARD)
	end
end

--패를 x장 묘지로 보내고 발동(ct=매수)
function cyan.htgcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,ct,nil) end
		Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,ct,ct,REASON_COST)
	end
end

pcall(dofile,"expansions/script/proc_access.lua")