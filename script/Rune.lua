--룽틸리티 가즈아!

Rune={}

--kemu 소환

function Rune.kemuProcedure(c)
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetRange(LOCATION_HAND)
	e0:SetValue(1)
    e0:SetCondition(Rune.kemucon)
    e0:SetOperation(Rune.kemuop)
    c:RegisterEffect(e0)
end
function Rune.kemufilter(c)
    return c:IsFaceup() and c:IsSetCard(0x34a) and c:GetOverlayCount()==0
end
function Rune.kemucon(e,c)
	if c==nil then return true end
    return Duel.IsExistingMatchingCard(Rune.kemufilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function Rune.kemuop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.SelectMatchingCard(tp,Rune.kemufilter,tp,LOCATION_MZONE,0,1,1,nil)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    Duel.Overlay(c,tc)
end

--엑시즈 소재 x개 제거하고 발동

function Rune.RemoveOverlay(x)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,x,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,x,x,REASON_COST)
	end
end

--이 카드의 ①의 효과로 특소 성공시
function Rune.kemuSum()
	return function(e,tp,eg,ep,ev,re,r,rp)
	   return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
	end
end

CARD_WAVE_CANNON=38992735
function Card.IsWaveCannon(c)
	return c:IsCode(CARD_WAVE_CANNON)
end
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	cregeff(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if code==CARD_WAVE_CANNON and mt.eff_ct[c][0]==e then
		c:SetUniqueOnField(1,0,function(c)
			local tp=c:GetControler()
			if Duel.IsPlayerAffectedByEffect(tp,17271001) then
				return c:GetCode()==CARD_WAVE_CANNON
			end
			return false
		end)
	end
end