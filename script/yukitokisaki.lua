YukitokisakiErrorCall=function(...) return Duel.AnnounceCard(...) end

EFFECT_YUKITOKISAKI=18453313

function Auxiliary.YukitokisakiFilter(c,se)
	return c==se:GetHandler() and c:GetReasonEffect()==se
end

local dspsum=Duel.SpecialSummon
function Duel.SpecialSummon(...)
	local res=dspsum(...)
	if res>0 then
		local og=Duel.GetOperatedGroup()
		local cp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
		if cp==nil then
			return res
		end
		local eset={Duel.IsPlayerAffectedByEffect(cp,EFFECT_YUKITOKISAKI)}
		for _,te in pairs(eset) do
			local se=te:GetLabelObject()
			if te:GetLabel()==1 and og:IsExists(Auxiliary.YukitokisakiFilter,1,nil,se) then
				Debug.Message("Yukitokisaki calls an error function!")
				YukitokisakiErrorCall(cp,OPCODE_AND,OPCODE_AND)
			end
		end
		return res
	else
		return res
	end
end

local dspsumcpl=Duel.SpecialSummonComplete
function Duel.SpecialSummonComplete(...)
	local res=dspsumcpl(...)
	if res then
		local og=Duel.GetOperatedGroup()
		local cp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
		if cp==nil then
			return res
		end
		local eset={Duel.IsPlayerAffectedByEffect(cp,EFFECT_YUKITOKISAKI)}
		for _,te in pairs(eset) do
			local se=te:GetLabelObject()
			if te:GetLabel()==1 and og:IsExists(Auxiliary.YukitokisakiFilter,1,nil,se) then
				Debug.Message("Yukitokisaki calls an error function!")
				YukitokisakiErrorCall(cp,OPCODE_AND,OPCODE_AND)
			end
		end
	else
		return res
	end
end