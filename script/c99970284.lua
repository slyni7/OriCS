--VIRTUAL YOUTUBER: DENNOU SHOJO SIRO
local m=99970284
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소환 제약
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	
	--특수 소환
	local evtuber=Effect.CreateEffect(c)
	evtuber:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	evtuber:SetCode(EVENT_TO_GRAVE)
	evtuber:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	evtuber:SetProperty(EFFECT_FLAG_DELAY)
	evtuber:SetRange(LOCATION_HAND)
	evtuber:SetCondition(cm.spcon)
	evtuber:SetTarget(cm.sptg)
	evtuber:SetOperation(cm.spop)
	c:RegisterEffect(evtuber)
	
	--전투 파괴 내성
	YuL.ind_bat(c,LOCATION_MZONE)
	
	--효과 부여
	
		--●공격 표시 고정
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_POSITION)
		e1:SetValue(POS_FACEUP_ATTACK)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetLabelObject(e1)
		c:RegisterEffect(e2)
		
		--●강제 공격
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_MUST_ATTACK)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
		
		--●데미지
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DAMAGE)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EVENT_ATTACK_ANNOUNCE)
		e5:SetTarget(cm.damtg)
		e5:SetOperation(cm.damop)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e6:SetRange(LOCATION_MZONE)
		e6:SetTargetRange(0,LOCATION_MZONE)
		e6:SetLabelObject(e5)
		c:RegisterEffect(e6)

		--●제외
		local e7=Effect.CreateEffect(c)
		e7:SetCategory(CATEGORY_REMOVE)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCountLimit(1)
		e7:SetCondition(YuL.turn(0))
		e7:SetTarget(cm.rmtg)
		e7:SetOperation(cm.rmop)
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e8:SetRange(LOCATION_MZONE)
		e8:SetTargetRange(0,LOCATION_MZONE)
		e8:SetLabelObject(e7)
		c:RegisterEffect(e8)

	--공격력 감소
	local esiro=Effect.CreateEffect(c)
	esiro:SetCategory(CATEGORY_ATKCHANGE)
	esiro:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	esiro:SetCode(EVENT_PHASE+PHASE_END)
	esiro:SetRange(LOCATION_MZONE)
	esiro:SetCountLimit(1)
	esiro:SetOperation(cm.atkop)
	c:RegisterEffect(esiro)
	
end

--특수 소환 1
function cm.cfilter(c,e)
	return e:GetHandler():GetControler()~=c:GetOwner() and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,e) and re:IsHasType(0x7f0)
end
function cm.tdfilter(c,g)
	return g:IsContains(c) and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local cg=c:GetColumnGroup()
		local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		c:CompleteProcedure()
	end
end

--●데미지
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetAttack()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--●제외
function cm.filter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--공격력 감소
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
