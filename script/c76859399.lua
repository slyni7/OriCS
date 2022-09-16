--인스톨 넥서스
local m=76859399
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCountLimit(1,m)
	WriteEff(e3,1,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","HGR")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e5,5,"NC")
	WriteEff(e5,1,"TO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","M")
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e6,6,"C")
	WriteEff(e6,4,"NTO")
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=true
		cm[1]=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsAttribute(ATTRIBUTE_LIGHT) then
			cm[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=true
	cm[1]=true
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm[tp]
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctar11(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.tfil1(c)
	return (c:IsSetCard(0x2c1) or c:IsSetCard(0x2c5)) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"HDO",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"HDO")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"HDO",0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) then
			c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		end
		if tc:IsType(TYPE_TRAP) and tc:IsLoc("G") then
			local e1=MakeEff(tc,"Qo","G")
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetTarget(cm.otar11)
			e1:SetOperation(cm.oop11)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SUMMON)
			c:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EVENT_FLIP_SUMMON)
			c:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EVENT_SPSUMMON)
			c:RegisterEffect(e4)
		end
	end
end
function cm.otar11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res=false
		local chain=Duel.GetCurrentChain()
		local event=e:GetCode()
		local i=0
		repeat
			local te=c.eff_ct[c][i]
			local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
			elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
				if te:GetCode()==event then
					if (not con or con(te,tp,eg,ep,ev,re,r,rp))
						and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
						res=true
					end
					if res then
						break
					end
				end
			elseif te:GetCode()==EVENT_CHAINING then
				if chain>0 then
					local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
					local cc=ce:GetHandler()
					local cg=Group.FromCards(cc)
					local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
					if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
						and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
						res=true
						break
					end
				end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
					res=true
					break
				end
			else
				local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if tres
					and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
					and (not tg or tg(te,tp,teg,tep,tev,tre,tr,trp,0)) then
					res=true
					break
				end
			end
			i=i+1
		until not c.eff_ct[c][i]
		return res
	end
	local off=1
	local ops={}
	local opval={}
	local chain=Duel.GetCurrentChain()-1
	local event=e:GetCode()
	local i=0
	repeat
		local te=c.eff_ct[c][i]
		local res=false
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
			if te:GetCode()==event then
				if Duel.GetCurrentChain()==1 then
					aux.CheckDisSumAble=true
				end
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
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
				if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
					and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
					res=true
				end
			end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			if (not con or con(te,tp,eg,ep,ev,re,r,rp))
				and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
				res=true
			end
		else
			local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if tres
				and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
				and (not tg or tg(te,tp,teg,tep,tev,tre,tr,trp,0)) then
				res=true
			end
		end
		if res then
			ops[off]=te:GetDescription()
			opval[off-1]=te
			off=off+1
		end
		i=i+1
	until not c.eff_ct[c][i]
	local ae=nil
	if off==2 then
		ae=opval[0]
	else
		local op=Duel.SelectOption(tp,table.unpack(ops))
		ae=opval[op]
	end
	e:SetCategory(ae:GetCategory())
	e:SetProperty(ae:GetProperty())
	local tg=ae:GetTarget()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if tg then
			tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if tg then
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
	ae:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(ae)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetLabelObject()
	if not ae then
		return
	end
	local chain=Duel.GetCurrentChain()-1
	e:SetLabelObject(ae:GetLabelObject())
	local op=ae:GetOperation()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if op then
			op(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if op then
			op(e,tp,teg,tep,tev,tre,tr,trp)
		end
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm[tp] and c:IsAbleToGraveAsCost()
			and (Duel.GetFlagEffect(tp,m)+Duel.GetFlagEffect(tp,m+50)==0 and not Duel.IsPlayerAffectedByEffect(tp,76859317))
	end
	Duel.SendtoGrave(c,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.tfil4(c,e,tp,mc)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"E",0,1,nil,e,tp,c)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"E",0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm[tp]
			and ((Duel.GetFlagEffect(tp,m)==0 or Duel.IsPlayerAffectedByEffect(tp,76859317)) and Duel.GetFlagEffect(tp,m+50)==0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1)
end
function cm.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm[tp] and c:IsAbleToGraveAsCost()
			and Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end