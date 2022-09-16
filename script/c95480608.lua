--이레귤러: 스페이스 패러독스
function c95480608.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24221808,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c95480608.rmcost)
	e1:SetTarget(c95480608.rmtg)
	e1:SetOperation(c95480608.rmop)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24221808,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c95480608.spcon)
	e2:SetTarget(c95480608.sptg)
	e2:SetOperation(c95480608.spop)
	e2:SetLabelObject(sg)
	c:RegisterEffect(e2)
end

function c95480608.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c95480608.rmfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c95480608.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c95480608.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480608.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c95480608.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95480608.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		if c:IsRelateToEffect(e) then
			local sg=e:GetLabelObject()
			if c:GetFlagEffect(95480608)==0 then
				sg:Clear()
				c:RegisterFlagEffect(95480608,RESET_EVENT+0x1680000,0,1)
			end
			sg:AddCard(tc)
			tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
		end
	end
end


function c95480608.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetFlagEffect(95480608)~=0
end
function c95480608.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c95480608.spfilter(c,rc,e,tp)
	return c:IsRelateToCard(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480608.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=g:Filter(c95480608.spfilter,nil,e:GetHandler(),e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:Select(tp,1,ft,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end