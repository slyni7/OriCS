--클라디스 메이든 디바인 퍼니시먼트
function c95480821.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c95480821.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83531441,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c95480821.atkcost)
	e2:SetOperation(c95480821.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetOperation(c95480821.winop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c95480821.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c95480821.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsType(TYPE_SPELL) and sc:IsSetCard(0x95)
end

function c95480821.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct={}
	for i=3,1,-1 do
		if Duel.IsPlayerCanDiscardDeckAsCost(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		Duel.DiscardDeck(tp,ct[1],REASON_COST)
		e:SetLabel(1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95480821,2))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c95480821.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=e:GetLabel()
	local g=Duel.GetDecktopGroup(1-tp,ac)
	Duel.DisableShuffleCheck()
	local ct=Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

function c95480821.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,95480820) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c95480821.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
		and Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)<=15 and e:GetHandler():GetOverlayCount()==0 and e:GetLabel()==1 then
		Duel.Win(tp,0x91)
	end
end
