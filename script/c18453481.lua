--요괴다과회
local m=18453481
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,7)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,0)
end
function cm.tfil1(c,e,tp,eg,ep,ev,re,r,rp,chain,event)
	if not (c:IsCode(59438930) or c:IsCode(62015408) or c:IsCode(14558127) or c:IsCode(73642296)
		or c:IsCode(60643553) or c:IsCode(52038441)) then
		return false
	end
	if cm[tp]&c:GetAttribute()~=0 then
		return false
	end
	local res=false
	local te=c.eff_ct[c][0]
	local con=te:GetCondition()
	local tg=te:GetTarget()
	if event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
		if te:GetCode()==event then
			if Duel.GetCurrentChain()==1 and chain<1 then
				aux.CheckDisSumAble=true
			end
			if (not con or con(e,tp,eg,ep,ev,re,r,rp))
				and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
				res=true
			end
			aux.CheckDisSumAble=false
		end
	elseif te:GetCode()==EVENT_CHAINING then
		if chain>0 then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			if (not con or con(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
				and (not tg or tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
				res=true
			end
		end
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		if (not con or con(e,tp,eg,ep,ev,re,r,rp))
			and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			res=true
		end
	else
		local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if tres
			and (not con or con(e,tp,teg,tep,tev,tre,tr,trp))
			and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)) then
			res=true
		end
	end
	return res
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		local chain=Duel.GetCurrentChain()
		local event=e:GetCode()
		return og:IsExists(cm.tfil1,1,nil,e,tp,eg,ep,ev,re,r,rp,chain,event)
	end
	e:SetLabel(0)
	local chain=Duel.GetCurrentChain()-1
	local event=e:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=og:FilterSelect(tp,cm.tfil1,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chain,event)
	local tc=sg:GetFirst()
	local te=tc.eff_ct[tc][0]
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if tg then
			tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if tg then
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if te then
		local chain=Duel.GetCurrentChain()-1
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if te:GetCode()==EVENT_CHAINING then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			if op then
				op(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp)
			end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			if op then
				op(e,tp,eg,ep,ev,re,r,rp)
			end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if op then
				op(e,tp,teg,tep,tev,tre,tr,trp)
			end
		end
		cm[tp]=cm[tp]|te:GetHandler():GetAttribute()
	end
end
