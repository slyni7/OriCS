--구신 울타라
function c95480006.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c95480006.pfil1,c95480006.pfil1,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c95480006.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCondition(c95480006.con2)
	e2:SetTarget(c95480006.tar2)
	e2:SetOperation(c95480006.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c95480006.val3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80532587,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c95480006.destg)
	e4:SetOperation(c95480006.desop)
	c:RegisterEffect(e4)
end
function c95480006.pfil1(c)
	return c:IsLevel(4) or c:IsRank(4)
end
function c95480006.val1(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c95480006.vfil31(c)
	return c:IsSetCard(0xb8) and c:IsType(TYPE_SYNCHRO)
end
function c95480006.vfil32(c)
	return c:IsSetCard(0xb7) and c:IsType(TYPE_FUSION)
end
function c95480006.vfil33(c)
	return c:IsSetCard(0xb6) and c:IsType(TYPE_XYZ)
end
function c95480006.val3(e,c)
	local fc=e:GetHandler()
	local fg=fc:GetMaterial()
	local label=0
	if fg:IsExists(c95480006.vfil31,1,nil) then
		label=label|1
	end
	if fg:IsExists(c95480006.vfil32,1,nil) then
		label=label|2
	end
	if fg:IsExists(c95480006.vfil33,1,nil) then
		label=label|4
	end
	local te=e:GetLabelObject()
	te:SetLabel(label)
end
function c95480006.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c95480006.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	local bs,bf,bx=false
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if label&1==1 then
		bs=g:IsExists(Card.IsCode,1,nil,49033797)
	end
	if label&2==2 then
		bf=g:IsExists(Card.IsCode,1,nil,26920296)
	end
	if label&4==4 then
		bx=g:IsExists(Card.IsCode,1,nil,95480007)
	end
	if chk==0 then
		return bs or bf or bx
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480006.op2(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if label&1==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsCode,1,1,nli,49033797)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	if label&2==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsCode,1,1,nli,26920296)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	if label&4==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsCode,1,1,nli,95480007)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c95480006.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function c95480006.filter2(c)
	return c:IsAbleToRemove()
end
function c95480006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c95480006.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(c95480006.filter1,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c95480006.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c95480006.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95480006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,c95480006.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0
		and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end