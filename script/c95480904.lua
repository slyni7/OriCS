--영매후 토라
function c95480904.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd42),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,95480904)
	e1:SetCondition(c95480904.con1)
	e1:SetOperation(c95480904.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480904,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480996)
	e2:SetCondition(c95480904.con2)
	e2:SetTarget(c95480904.tar2)
	e2:SetOperation(c95480904.op2)
	c:RegisterEffect(e2)
end
c95480904.additional_psummon=false
function c95480904.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c95480904.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(95480904)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_USE_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c95480904.con12)
	e2:SetValue(c95480904.val12)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(c95480904.op13)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	c95480904.op13(e,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_ADJUST)
	e6:SetOperation(c95480904.op16)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function c95480904.con12(e)
	return c95480904.additional_psummon
end
function c95480904.val12(e,c,fp,rp,r)
	return e:GetHandler():GetLinkedZone()
end
function c95480904.op13(e,tp)
	local c=e:GetHandler()
	if not c:IsHasEffect(95480904) then
		e:Reset()
		return
	end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz and lpz:GetFlagEffect(95480904)<1 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(95480904,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCondition(c95480904.con131)
		e1:SetOperation(c95480904.op131)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		lpz:RegisterEffect(e1)
		lpz:RegisterFlagEffect(95480904,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	local olpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local orpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if olpz and orpz and olpz:GetFlagEffect(95480904)<1
		and olpz:GetFlagEffectLabel(31531170)==orpz:GetFieldID()
		and orpz:GetFlagEffectLabel(31531170)==olpz:GetFieldID() then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95480904,0))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
		e2:SetRange(LOCATION_PZONE)
		e2:SetCondition(c95480904.con132)
		e2:SetOperation(c95480904.op132)
		e2:SetValue(SUMMON_TYPE_PENDULUM)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(c)
		olpz:RegisterEffect(e2)
		olpz:RegisterFlagEffect(95480904,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c95480904.nfil131(c,e,tp,ls,rs)
	c95480904.additional_psummon=true
	local res=c:IsSetCard(0xd42) and aux.PConditionFilter(c,e,tp,ls,rs,{false})
	c95480904.additional_psummon=false
	return res
end
function c95480904.con131(e,c,og)
	if c==nil then
		return true
	end
	local lo=e:GetLabelObject()
	if not lo:IsHasEffect(95480904) then
		return false
	end
	local tp=c:GetControler()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not rpz or c==rpz or Duel.GetFlagEffect(tp,95480904)>0 then
		return false
	end
	local ls=c:GetLeftScale()
	local rs=rpz:GetRightScale()
	if ls>rs then
		ls,rs=rs,ls
	end
	local loc=0
	c95480904.additional_psummon=true
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		loc=loc+LOCATION_HAND
	end
	if Duel.GetLocationCountFromEx(tp)>0 then
		loc=loc+LOCATION_EXTRA
	end
	c95480904.additional_psummon=false
	if loc==0 then
		return false
	end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(c95480904.nfil131,1,nil,e,tp,ls,rs)
end
function c95480904.op131(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local ls=c:GetLeftScale()
	local rs=rpz:GetRightScale()
	if ls>rs then
		ls,rs=rs,ls
	end
	c95480904.additional_psummon=true
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	c95480904.additional_psummon=false
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then
			ft1=1
		end
		if ft2>0 then
			ft2=1
		end
		ft=1
	end
	local loc=0
	if ft1>0 then
		loc=loc+LOCATION_HAND
	end
	if ft2>0 then
		loc=loc+LOCATION_EXTRA
	end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(c95480904.nfil131,nil,e,tp,ls,rs)
	else
		tg=Duel.GetMatchingGroup(c95480904.nfil131,tp,loc,0,nil,e,tp,ls,rs)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then
		ft2=ect
	end
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
		if g:GetCount()==0 or ft==0 then break end
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
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1-1
			else
				ft2=ft2-1
			end
			ft=ft-1
		end
	end
	if sg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,95480904)
		Duel.RegisterFlagEffect(tp,95480904,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
		c95480904.additional_psummon=true
	end
end
function c95480904.con132(e,c,og)
	if c==nil then
		return true
	end
	local lo=e:GetLabelObject()
	if not lo:IsHasEffect(95480904) then
		return false
	end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if not rpz or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) or Duel.GetFlagEffect(tp,95480904)>0 then
		return false
	end
	local ls=c:GetLeftScale()
	local rs=rpz:GetRightScale()
	if ls>rs then
		ls,rs=rs,ls
	end
	c95480904.additional_psummon=true
	local ft=Duel.GetLocationCountFromEx(tp)
	c95480904.additional_psummon=false
	if ft<1 then
		return false
	end
	if og then
		return og:IsExists(c95480904.nfil131,1,nil,e,tp,ls,rs)
	else
		return Duel.IsExistingMatchingCard(c95480904.nfil131,tp,LOCATION_EXTRA,0,1,nil,e,tp,ls,rs)
	end
end
function c95480904.op132(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local ls=c:GetLeftScale()
	local rs=rpz:GetRightScale()
	if ls>rs then
		ls,rs=rs,ls
	end
	c95480904.additional_psummon=true
	local ft=Duel.GetLocationCountFromEx(tp)
	c95480904.additional_psummon=false
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=1
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft then
		ft=ect
	end
	local tg=nil
	if og then
		Duel.Hint(SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c95480904.nfil131,0,ft,nil,e,tp,ls,rs)
		if g then
			sg:Merge(g)
		end
	else
		Duel.Hint(SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c95480904.nfil131,tp,LOCATION_EXTRA,0,0,ft,nil,e,tp,ls,rs)
		if g then
			sg:Merge(g)
		end
	end
	if sg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,31531170)
		Duel.Hint(HINT_CARD,0,95480904)
		Duel.RegisterFlagEffect(tp,95480904,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
		c95480904.additional_psummon=true
	end
end
function c95480904.op16(e,tp,eg,ep,ev,re,r,rp)
	c95480904.additional_psummon=false
end
function c95480904.nfil2(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
end
function c95480904.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480904.nfil2,1,nil,tp)
end
function c95480904.tfil2(c)
	return c:IsFaceup() and c:IsSetCard(0xd42) and c:IsAbleToHand()
end
function c95480904.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95480904.tfil2,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c95480904.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480904.tfil2,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end