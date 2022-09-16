--라인 킬러
function c84320033.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--moving
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320033,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c84320033.seqcon)
	e1:SetOperation(c84320033.seqop)
	c:RegisterEffect(e1)
	--line destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84320033,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetCost(c84320033.setcost)
	e2:SetTarget(c84320033.target)
	e2:SetOperation(c84320033.activate)
	c:RegisterEffect(e2)
end
function c84320033.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c84320033.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.bor(flag,bit.lshift(0x1,seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.bor(flag,bit.lshift(0x1,seq+1)) end
		flag=bit.bxor(flag,0xff)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
end




function c84320033.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c84320033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return true end
   local seq=e:GetHandler():GetSequence()
   local g=Group.CreateGroup()
   local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
   if tc then g:AddCard(tc) end
   tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
   if tc then g:AddCard(tc) end
   tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
   if tc then g:AddCard(tc) end
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c84320033.activate(e,tp,eg,ep,ev,re,r,rp)
   local seq=e:GetHandler():GetSequence()
   local g=Group.CreateGroup()
   local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
   if tc then g:AddCard(tc) end
   tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
   if tc then g:AddCard(tc) end
   tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
   if tc then g:AddCard(tc) end
   Duel.Destroy(g,REASON_EFFECT)
end
