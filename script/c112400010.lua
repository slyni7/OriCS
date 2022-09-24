--ゼリーキング
--CARD_BLUEEYES_SPIRIT	=59822133
--CARD_SUMMON_GATE		=29724053
function c112400010.initial_effect(c)
	--synchro summon
	if Synchro then
		Synchro.AddProcedure(c,c112400010.sstfilter,1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0x4ec1),1,99)
	else
		aux.AddSynchroProcedure(c,c112400010.sstfilter,aux.FilterBoolFunction(Card.IsSetCard,0x4ec1),1)
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--me1(attack in def pos)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_DEFENSE_ATTACK)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400010.me1filter))
	me1:SetValue(1)
	c:RegisterEffect(me1)
	--me2(draw 1~2 cards)
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(112400010,0))
	me2:SetCategory(CATEGORY_REMOVE)
	me2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	me2:SetCode(EVENT_SPSUMMON_SUCCESS)
	me2:SetProperty(EFFECT_FLAG_DELAY)
	me2:SetCondition(c112400010.drcon)
	me2:SetTarget(c112400010.drtg)
	me2:SetOperation(c112400010.drop)
	c:RegisterEffect(me2)
	--me3(spsummon 1~4 monsters)
	local me3=Effect.CreateEffect(c)
	me3:SetDescription(aux.Stringid(112400010,1))
	me3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me3:SetType(EFFECT_TYPE_IGNITION)
	me3:SetRange(LOCATION_MZONE)
	me3:SetCountLimit(1,112400010)
	me3:SetTarget(c112400010.sptg)
	me3:SetOperation(c112400010.spop)
	c:RegisterEffect(me3)
	--me4(retuning synchro)
	local me4=Effect.CreateEffect(c)
	me4:SetDescription(aux.Stringid(112400010,2))
	me4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me4:SetType(EFFECT_TYPE_IGNITION)
	me4:SetRange(LOCATION_MZONE)
	me4:SetTarget(c112400010.syntg)
	me4:SetOperation(c112400010.synop)
	c:RegisterEffect(me4)
	--pe1(multiple pendulum)
	local pe1=Effect.CreateEffect(c)
	if not Pendulum then --KoishiPro or Core
		pe1:SetDescription(aux.Stringid(112400010,4))
		pe1:SetType(EFFECT_TYPE_FIELD)
		pe1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetTargetRange(1,0)
		pe1:SetValue(aux.TRUE)
		c:RegisterEffect(pe1)
	else --EDOPro
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(112400010)
		e1:SetRange(LOCATION_PZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		c:RegisterEffect(e1)
		pe1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		pe1:SetCode(EVENT_ADJUST)
		pe1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		pe1:SetRange(LOCATION_PZONE)
		pe1:SetCondition(c112400010.checkcon)
		pe1:SetOperation(c112400010.checkop)
		c:RegisterEffect(pe1)
	end
	--pe2(spsummon 1~3 monsters)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400010,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	pe2:SetCode(EVENT_SPSUMMON_SUCCESS)
	pe2:SetProperty(EFFECT_FLAG_DELAY)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCondition(c112400010.pe2con)
	pe2:SetTarget(c112400010.pe2tg)
	pe2:SetOperation(c112400010.pe2op)
	c:RegisterEffect(pe2)
end
c112400010.listed_series={0x4ec1}
c112400010.listed_names={112400002,112400011}
c112400010.card_code_list={[112400002]=true,[112400011]=true}
c112400010.material_setcode=0x4ec1
--synchro summon
function c112400010.sstfilter(c,sc,sumtype,tp)
	return c:IsSetCard(0x4ec1,sc,sumtype,tp) or c:IsHasEffect(112400008)
end
--me1(attack in def pos)
function c112400010.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(draw 1~2 cards)
function c112400010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c112400010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112400010.cffilter(c)
	return c:IsSetCard(0x4ec1) and not c:IsPublic()
end
function c112400010.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c112400010.cffilter,tp,LOCATION_HAND,0,3,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(112400010,11)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local cg=Duel.SelectMatchingCard(tp,c112400010.cffilter,tp,LOCATION_HAND,0,3,3,nil)
			if #cg>2 then
				Duel.ConfirmCards(1-tp,cg)
				Duel.ShuffleHand(tp)
				Duel.Draw(tp,1,REASON_EFFECT)
			end
	end
end
--me3(spsummon 1~4 monsters)
function c112400010.exfilter1(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c112400010.spfilter(c,e,tp)
	return c:GetDefense()==1700 and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (not c:IsLocation(LOCATION_EXTRA) or c112400010.exfilter1(c))
end
function c112400010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetMZoneCount(tp)>0 then loc=loc+LOCATION_HAND+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0
			and Duel.IsExistingMatchingCard(c112400010.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function c112400010.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetMZoneCount(tp)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=math.min(4,Duel.GetUsableMZoneCount(tp))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT or 59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_DECK end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local ect=_G["c"..(CARD_SUMMON_GATE or 29724053)] and Duel.IsPlayerAffectedByEffect(tp,CARD_SUMMON_GATE or 29724053) and (_G["c"..(CARD_SUMMON_GATE or 29724053)])[tp]
	if ect~=nil then ft2=math.min(ft2,ect) else ect=ft end
	local ct=4
	local sg=Duel.GetMatchingGroup(c112400010.spfilter,tp,loc,0,nil,e,tp)
	if #sg==0 then return end
		if aux.SelectUnselectGroup then --EDOPro
			local rescon=function(ft1,ft2,ect,ft)
				return	function(sg,e,tp,mg)
							local expct=sg:FilterCount(c112400010.exfilter1,nil)
							local mct=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
							local exct=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
							local groupcount=#sg
							local classcount=sg:GetClassCount(Card.GetLevel)
							local res=ft2>=expct and ft1>=mct and ect>=exct and ft>=groupcount and classcount==groupcount
							return res, not res
						end
			end
			local rg=aux.SelectUnselectGroup(sg,e,tp,1,ft,rescon(ft1,ft2,ect,ft),1,tp,HINTMSG_SPSUMMON)
			Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
		else --KoishiPro
			local gcheck=function(g,ft1,ft2,ect,ft)
				return g:GetClassCount(Card.GetLevel)==#g and #g<=ft
					and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ft1
					and g:FilterCount(c112400010.exfilter1,nil)<=ft2
					and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
			end
			local rg=sg:SelectSubGroup(tp,gcheck,false,1,4,ft1,ft2,ect,ft)
			Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
		end
end
--me4(retuning synchro)
function c112400010.synfilter(c,e,tp)
	return c:IsCode(112400011) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and e:GetHandler():IsCanBeSynchroMaterial(c)
end
function c112400010.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400010.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_SYNCHRO)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400010.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c,TYPE_SYNCHRO)<1 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400010.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(Group.FromCards(c))
		Duel.SendtoGrave(c,REASON_MATERIAL+REASON_SYNCHRO)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
--pe1(multiple pendulum) (EDOPro)
function c112400010.checkcon(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),112400010)
end
function c112400010.checkop(e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz~=nil and lpz:GetFlagEffect(112400010)<=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(112400010,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCondition(c112400010.pencon)
		e1:SetOperation(c112400010.penop)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		lpz:RegisterEffect(e1)
		lpz:RegisterFlagEffect(112400010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	local olpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	if olpz~=nil and olpz:GetFlagEffect(112400011)<=0 and olpz:GetFlagEffect(31531170)>0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(112400010,4))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e2:SetRange(LOCATION_PZONE)
		e2:SetCondition(c112400010.pencon2)
		e2:SetOperation(c112400010.penop2)
		e2:SetValue(SUMMON_TYPE_PENDULUM)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		olpz:RegisterEffect(e2)
		olpz:RegisterFlagEffect(112400011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c112400010.pencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsPlayerAffectedByEffect(tp,112400010) then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz or Duel.GetFlagEffect(tp,29432356)>0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetMZoneCount(tp)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(Pendulum and Pendulum.Filter or aux.PConditionFilter,1,nil,e,tp,lscale,rscale)
end
function c112400010.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetMZoneCount(tp)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT or 59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local pfilter=Pendulum and Pendulum.Filter or aux.PConditionFilter
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(pfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(pfilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=_G["c"..(CARD_SUMMON_GATE or 29724053)] and Duel.IsPlayerAffectedByEffect(tp,CARD_SUMMON_GATE or 29724053) and (_G["c"..(CARD_SUMMON_GATE or 29724053)])[tp]
	if ect~=nil then ft2=math.min(ft2,ect) end
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		local loc=0
		if ft1>0 then loc=loc+LOCATION_HAND end
		if ft2>0 then loc=loc+LOCATION_EXTRA end
		local g=tg:Filter(Card.IsLocation,sg,loc)
		if #g==0 or ft==0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Group.SelectUnselect(g,sg,tp,true,true)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1+1
			else
				ft2=ft2+1
			end
			ft=ft+1
		else
			sg:AddCard(tc)
			if Pendulum and (c:IsHasEffect(511007000)~=nil or rpz:IsHasEffect(511007000)~=nil) then --EDOPro
				if not pfilter(tc,e,tp,lscale,rscale) then
					local pg=sg:Filter(aux.TRUE,tc)
					local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					sg:Sub(pg)
					ft1=ft1+ct3
					ft2=ft2+ct4
					ft=ft+ct0
				else
					local pg=sg:Filter(aux.NOT(pfilter),nil,e,tp,lscale,rscale)
					sg:Sub(pg)
					if #pg>0 then
						if pg:GetFirst():IsLocation(LOCATION_HAND) then
							ft1=ft1+1
						else
							ft2=ft2+1
						end
						ft=ft+1
					end
				end
			end
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1-1
			else
				ft2=ft2-1
			end
			ft=ft-1
		end
	end
	if #sg>0 then
		Duel.RegisterFlagEffect(tp,29432356,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.Hint(HINT_CARD,0,112400010)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	end
end
function c112400010.pencon2(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	if not Duel.IsPlayerAffectedByEffect(tp,112400010) then return false end
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) or Duel.GetFlagEffect(tp,29432356)>0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft<=0 then return false end
	local pfilter=Pendulum and Pendulum.Filter or aux.PConditionFilter
	if og then
		return og:IsExists(pfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(pfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c112400010.penop2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local ect=_G["c"..(CARD_SUMMON_GATE or 29724053)] and Duel.IsPlayerAffectedByEffect(tp,CARD_SUMMON_GATE or 29724053) and (_G["c"..(CARD_SUMMON_GATE or 29724053)])[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	local pfilter=Pendulum and Pendulum.Filter or aux.PConditionFilter
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,pfilter,0,ft,nil,e,tp,lscale,rscale)
		if g then
			sg:Merge(g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,pfilter,tp,LOCATION_EXTRA,0,0,ft,nil,e,tp,lscale,rscale)
		if g then
			sg:Merge(g)
		end
	end
	if #sg>0 then
		Duel.Hint(HINT_CARD,0,112400010)
		Duel.Hint(HINT_CARD,0,31531170)
		Duel.RegisterFlagEffect(tp,29432356,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	end
end
--pe2(spsummon 1~3 "Jellypi")
function c112400010.pe2filter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c112400010.pe2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c112400010.pe2filter,1,nil,tp)
end
function c112400010.pe2spfilter(c,e,tp)
	if not (c:IsCode(112400002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c112400010.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c112400010.pe2spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c112400010.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and not c:IsType(TYPE_LINK)
end
function c112400010.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or c:IsFaceup())
end
function c112400010.pe2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft1=Duel.GetMZoneCount(tp)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=math.min(3,Duel.GetUsableMZoneCount(tp))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT or 59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	local ect=_G["c"..(CARD_SUMMON_GATE or 29724053)] and Duel.IsPlayerAffectedByEffect(tp,CARD_SUMMON_GATE or 29724053) and (_G["c"..(CARD_SUMMON_GATE or 29724053)])[tp] or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_DECK end
	if ect>0 and (ft2>0 or ft3>0) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(c112400010.pe2spfilter,tp,loc,0,nil,e,tp)
	if #sg==0 then return end
	if aux.SelectUnselectGroup then --EDOPro
		local rescon=function(ft1,ft2,ft3,ect,ft)
			return	function(sg,e,tp,mg)
						local exnpct=sg:FilterCount(c112400010.exfilter2,nil,LOCATION_EXTRA)
						local expct=sg:FilterCount(c112400010.exfilter3,nil,LOCATION_EXTRA)
						local mct=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
						local exct=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
						local groupcount=#sg
						local res=ft2>=exnpct and ft3>=expct and ft1>=mct and ect>=exct and ft>=groupcount
						return res, not res
					end
		end
		local rg=aux.SelectUnselectGroup(sg,e,tp,1,ft,rescon(ft1,ft2,ft3,ect,ft),1,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
	else --KoishiPro
		local gcheck=function(g,ft1,ft2,ft3,ect,ft)
			return #g<=ft
				and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ft1
				and g:FilterCount(c112400010.exfilter2,nil)<=ft2
				and g:FilterCount(c112400010.exfilter3,nil)<=ft3
				and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
		end
		local rg=sg:SelectSubGroup(tp,gcheck,false,1,3,ft1,ft2,ft3,ect,ft)
		Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
	end
end
