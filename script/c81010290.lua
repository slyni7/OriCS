--단풍물이 든 수면

function c81010290.initial_effect(c)

	--summon method
	c:EnableReviveLimit()
	
	--search to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010290,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81010290)
	e3:SetCondition(c81010290.shcn)
	e3:SetTarget(c81010290.shtg)
	e3:SetOperation(c81010290.shop)
	c:RegisterEffect(e3)
	
	--bounce + 1000 damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010290,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c81010290.bdco)
	e4:SetTarget(c81010290.bdtg)
	e4:SetOperation(c81010290.bdop)
	c:RegisterEffect(e4)
	
end

--search to hand
function c81010290.shcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end

function c81010290.shtgfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
	and c:IsSetCard(0xca1)
end
function c81010290.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010290.shtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010290.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010290.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--bounce + 1000 damage
function c81010290.bdcofilter(c)
	return c:IsReleasable() and c:IsRace(RACE_BEASTWARRIOR)
end
function c81010290.bdco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010290.bdcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81010290.bdcofilter,tp,loc,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c81010290.bdtgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c81010290.bdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsLocation(LOCATION_ONFIELD)
			and chkc:IsControler(1-tp)
			and c81010290.bdtgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81010290.bdtgfilter,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81010290.bdtgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end

function c81010290.bdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsFacedown() and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,1,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
