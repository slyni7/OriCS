--아르스 게티아 - 솔로몬
function c95481100.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),5,5,c95481100.lcheck)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c95481100.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23626223,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95481100.descon)
	e2:SetTarget(c95481100.destg)
	e2:SetOperation(c95481100.desop)
	c:RegisterEffect(e2)
	--copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43387895,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c95481100.copycost)
	e3:SetTarget(c95481100.copytg)
	e3:SetOperation(c95481100.copyop)
	c:RegisterEffect(e3)
end

function c95481100.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd5c)
end

function c95481100.matfilter(c)
	return c:IsSetCard(0xd5c) and c:GetOriginalLevel()>=0
end
function c95481100.matcheck(e,c)
	local g=c:GetMaterial():Filter(c95481100.matfilter,nil)
	local atk=g:GetSum(Card.GetOriginalLevel)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*100)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end

function c95481100.cfilter(c,tp,lg)
	return c:IsSetCard(0xd5c) and c:GetPreviousControler()==tp and lg:IsContains(c)
end
function c95481100.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c95481100.cfilter,1,nil,tp,lg) and e:GetHandler():GetSequence()>4
end
function c95481100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c95481100.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=tg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c95481100.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(95481100)==0 end
	e:GetHandler():RegisterFlagEffect(95481100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c95481100.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd5c)
end
function c95481100.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c95481100.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c95481100.copyfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95481100.copyfilter,tp,LOCATION_GRAVE,0,1,1,c)
end
function c95481100.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function c95481100.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
