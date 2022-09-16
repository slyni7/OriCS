CUSTOMTYPE_DELIGHT=0x8
SUMMON_TYPE_DELIGHT=0x40000500
EFFECT_MUST_BE_DEL_MATERIAL=18452700
EFFECT_DELIGHT_SUMMON=18452702
EVENT_BE_CUSTOM_MATERIAL=18452703
EFFECT_CANNOT_BE_DELIGHT_MATERIAL=18452704
CUSTOMREASON_DELIGHT=0x1

function Card.IsCanBeDelightMaterial(c,del)
	if c:IsForbidden() then
		return false 
	end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)}
	for _,te in pairs(eset) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,del) then return false end
	end
	return true
end

function Auxiliary.AddDelightProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(18452700,0))
	if max==nil then
		max=5
	end
	e1:SetValue(SUMMON_TYPE_DELIGHT)
	e1:SetLabel(0)
	e1:SetCondition(Auxiliary.DelightCondition(f,min,max,gf))
	e1:SetOperation(Auxiliary.DelightOperation(f,min,max,gf))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DELIGHT_SUMMON)
	e2:SetLabel(10000)
	e2:SetCondition(Auxiliary.DelightCondition(f,min,max,gf))
	e2:SetOperation(Auxiliary.DelightOperation(f,min,max,gf))
	c:RegisterEffect(e2)
	local mt=_G["c"..c:GetOriginalCode()]
	mt.CardType_Delight=true
	return e1
end
function Auxiliary.DelConditionFilter(c,f,dc)
	return c:IsFaceup() and (not f or f(c)) and c:IsCanBeDelightMaterial(dc)
end
function Auxiliary.DelExtraFilter(c,f,dc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(POS_FACEDOWN) and (not f or f(c)) and c:IsCanBeDelightMaterial(dc)
end
function Auxiliary.GetDelightMaterials(tp,f,dc)
	local mg=Duel.GetMatchingGroup(Auxiliary.DelConditionFilter,tp,LOCATION_MZONE,0,nil,f,dc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.DelExtraFilter,tp,LOCATION_GRAVE,0,nil,f,dc)
	mg:Merge(mg2)
	return mg
end
function Auxiliary.DelCheckGoal(sg,e,tp,dc,gf)
	return Duel.GetLocationCountFromEx(tp,tp,sg,dc)>0 and (not gf or gf(sg))
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=Duel.GetTurnCount()
		and dc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_DELIGHT,tp,false,false)
end
function Auxiliary.DelightCondition(f,min,max,gf)
	return
		function(e,c,og)
			if c==nil then
				return true
			end
			local tp=c:GetControler()
			local mg=Auxiliary.GetDelightMaterials(tp,f,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_DEL_MATERIAL)
			if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
				return false
			end
			Duel.SetSelectedCard(fg)
			return mg:CheckSubGroup(Auxiliary.DelCheckGoal,min,max,e,tp,c,gf)
		end
end
function Auxiliary.DelightOperation(f,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
			local mg=Auxiliary.GetDelightMaterials(tp,f,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_DEL_MATERIAL)
			Duel.SetSelectedCard(fg)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18452700,1))
			local cancel=Duel.IsSummonCancelable()
			local tg=mg:SelectSubGroup(tp,Auxiliary.DelCheckGoal,cancel,min,max,e,tp,c,gf)
			if tg then
				local rg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				local gg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				c:SetMaterial(tg)
				if #rg==0 then
					if e:GetLabel()==0 then
						sg:AddCard(c)
						c:CompleteProcedure()
					end
				end
				Duel.Remove(rg,POS_FACEDOWN,REASON_MATERIAL)
				Duel.SendtoGrave(gg,REASON_MATERIAL)
				local tc=tg:GetFirst()
				while tc do
					Duel.RaiseSingleEvent(tc,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_DELIGHT,tp,tp,0)
					tc=tg:GetNext()
				end
				Duel.RaiseEvent(tg,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_DELIGHT,tp,tp,0)
				if #rg>0 then
					if e:GetLabel()==0 then
						c:SetStatus(STATUS_SPSUMMON_STEP,true)
						c:SetStatus(STATUS_EFFECT_ENABLED,false)
						sg:AddCard(c)
					end
					local ct=Duel.GetCurrentPhase()==PHASE_STANDBY and #rg+1 or #rg
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_ATTACK)
					e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					c:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
					e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
					e2:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					e2:SetValue(1)
					c:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
					e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
					e3:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					c:RegisterEffect(e3)
					local e4=Effect.CreateEffect(c)
					e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e4:SetCountLimit(1)
					e4:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					if Duel.GetCurrentPhase()==PHASE_STANDBY then
						e4:SetLabel(Duel.GetTurnCount())
					else
						e4:SetLabel(0)
					end
					e4:SetCondition(Auxiliary.DelOpCon4)
					e4:SetOperation(Auxiliary.DelOpOp4(e1,e2,e3))
					Duel.RegisterEffect(e4,tp)
					local e5=Effect.CreateEffect(c)
					e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e5:SetCode(EVENT_ADJUST)
					e5:SetLabel(Duel.GetTurnCount()+ct)
					e5:SetCondition(Auxiliary.DelOpCon5)
					e5:SetOperation(Auxiliary.DelOpOp5)
					e4:SetLabelObject(e5)
					Duel.RegisterEffect(e5,tp)
					local e7=Effect.CreateEffect(c)
					e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e7:SetCode(EVENT_ADJUST)
					e7:SetLabel(#rg)
					e7:SetReset(RESET_PHASE+PHASE_END)
					e7:SetOperation(Auxiliary.DelOpOp7)
					Duel.RegisterEffect(e7,tp)
				end
				if e:GetLabel()==10000 then
					if #rg>0 then
						Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
						if Duel.HintSpSummon then
							Duel.HintSpSummon(c)
						else
							Duel.Hint(HINT_CARD,0,c:GetCode())
						end
						c:SetStatus(STATUS_SPSUMMON_STEP,true)
						c:SetStatus(STATUS_EFFECT_ENABLED,false)
					else
						Duel.SpecialSummon(c,SUMMON_TYPE_DELIGHT,tp,tp,false,false,POS_FACEUP)
						c:CompleteProcedure()
					end
					return
				end
			else
				return
			end
		end
end
function Auxiliary.DelOpCon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=Duel.GetTurnCount()
end
function Auxiliary.DelOpOp4(e1,e2,e3)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local te=e:GetLabelObject()
			c:SetTurnCounter(c:GetTurnCounter()-1)
			if c:GetTurnCounter()>0 then
				return
			end
			if Duel.HintSpSummon then
				Duel.HintSpSummon(c)
			else
				Duel.Hint(HINT_CARD,0,c:GetCode())
			end
			c:SetStatus(STATUS_SPSUMMON_STEP,false)
			c:SetStatus(STATUS_SPSUMMON_TURN,true)
			c:SetStatus(STATUS_EFFECT_ENABLED,true)
			Duel.RaiseSingleEvent(c,EVENT_SPSUMMON_SUCCESS,e,0,tp,tp,0)
			Duel.RaiseEvent(Group.FromCards(c),EVENT_SPSUMMON_SUCCESS,e,0,tp,tp,0)
			e1:Reset()
			e2:Reset()
			e3:Reset()
			te:Reset()
			e:Reset()
		end
end
function Auxiliary.DelOpCon5(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	return Duel.GetTurnCount()>ct or (Duel.GetTurnCount()>=ct and Duel.GetCurrentPhase()>PHASE_STANDBY)
end
function Auxiliary.DelOpOp5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_RULE)
	e:Reset()
end
function Auxiliary.DelOpOp7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local te=e:GetLabelObject()
	c:SetStatus(STATUS_SPSUMMON_STEP,true)
	c:SetStatus(STATUS_EFFECT_ENABLED,false)
	c:SetTurnCounter(ct)
	e:Reset()
end

function Card.IsDelightSummonable(c,g)
	local eset={c:IsHasEffect(EFFECT_DELIGHT_SUMMON)}
	for _,te in ipairs(eset) do
		local con=te:GetCondition()
		if con and con(te,c,g) then
			return true
		end
	end
	return false
end
function Duel.DelightSummon(tp,dc,g)
	local eset={dc:IsHasEffect(EFFECT_DELIGHT_SUMMON)}
	for _,te in ipairs(eset) do
		local op=te:GetOperation()
		if op then
			local sg=Group.CreateGroup()
			op(te,tp,0,tp,0,te,0,tp,dc,sg,g)
			return sg
		end
	end
	return false
end

function Auxiliary.NotOnFieldFilter(c)
	return c:IsStatus(STATUS_SPSUMMON_STEP)
end

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			return not con or con(e,tp,g,ep,ev,re,r,rp)
		end)
		local cost=e:GetCost()
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if chk==0 then
				return not cost or cost(e,tp,g,ep,ev,re,r,rp,0)
			end
			if cost then
				cost(e,tp,g,ep,ev,re,r,rp,1)
			end
		end)
		local tar=e:GetTarget()
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if chkc then
				return not tar or tar(e,tp,g,ep,ev,re,r,rp,1,chkc)
			end
			if chk==0 then
				return not tar or tar(e,tp,g,ep,ev,re,r,rp,0,chkc)
			end
			if tar then
				tar(e,tp,g,ep,ev,re,r,rp,1,chkc)
			end
		end)
		local op=e:GetOperation()
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if op then
				op(e,tp,g,ep,ev,re,r,rp,1)
			end
		end)
	end
end
local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,p,...)
	dregeff(e,p,...)
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			return not con or con(e,tp,g,ep,ev,re,r,rp)
		end)
		local cost=e:GetCost()
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if chk==0 then
				return not cost or cost(e,tp,g,ep,ev,re,r,rp,0)
			end
			if cost then
				cost(e,tp,g,ep,ev,re,r,rp,1)
			end
		end)
		local tar=e:GetTarget()
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if chkc then
				return not tar or tar(e,tp,g,ep,ev,re,r,rp,1,chkc)
			end
			if chk==0 then
				return not tar or tar(e,tp,g,ep,ev,re,r,rp,0,chkc)
			end
			if tar then
				tar(e,tp,g,ep,ev,re,r,rp,1,chkc)
			end
		end)
		local op=e:GetOperation()
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g
			if eg then
				g=eg:Clone()
				g:Remove(Auxiliary.NotOnFieldFilter,nil)
				if #g==0 then
					return false
				end
			end
			if op then
				op(e,tp,g,ep,ev,re,r,rp,1)
			end
		end)
	end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Delight then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Delight then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Delight then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Delight then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Delight then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Delight then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end