--Aranea Rabbit Dreamer
local s,id=GetID()
function s.initial_effect(c)
    
    --특수 소환 + 회수
    local e1=MakeEff(c,"Qo","H")
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCL(1,id)
    WriteEff(e1,1,"TO")
    c:RegisterEffect(e1)
    
    --레벨 변경 / 공수 증가
    local e2=MakeEff(c,"S","M")
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CHANGE_LEVEL)
    e2:SetValue(5)
    e2:SetCondition(s.isTuner)
    c:RegisterEffect(e2)
    local e3=MakeEff(c,"S","M")
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(1500)
    e3:SetCondition(aux.NOT(s.isTuner))
    c:RegisterEffect(e3)
    local e31=e3:Clone()
    e31:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e31)
    
    --서치 / 샐비지 + 파괴
    local e4=MakeEff(c,"STo")
    e4:SetCategory(CATEGORY_SEARCH_CARD+CATEGORY_DESTROY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCL(1,{id,1})
    WriteEff(e4,4,"TO")
    c:RegisterEffect(e4)
    local e41=e4:Clone()
    e41:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e41)
    
    --공수 증감
    YuL.AraneaMainEffect(c)

end

--특수 소환 + 회수
function s.tar1fil(c)
    return c:IsSetCard(0xe14) and c:IsAbleToDeck()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tar1fil(chkc) end
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.tar1fil,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.tar1fil,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_REMOVE_TYPE)
        e1:SetValue(TYPE_TUNER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
    Duel.SpecialSummonComplete()
    if tc:IsRelateToEffect(e) then
        Duel.BreakEffect()
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end

--레벨 변경 / 공수 증가
function s.isTuner(e)
    return e:GetHandler():IsType(TYPE_TUNER)
end

--서치 / 샐비지 + 파괴
function s.tar4fil(c)
    return c:IsST() and c:IsSetCard(0xe14) and c:IsAbleToHand()
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tar4fil,tp,LSTN("DG"),0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LSTN("DG"))
end
function s.op4fil(c,def)
    return c:IsFaceup() and (def>c:GetAttack() or def>c:GetDefense())
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.tar4fil,tp,LSTN("DG"),0,1,1,nil)
    if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleDeck(tp)
    local dg=Duel.GetMatchingGroup(s.op4fil,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetDefense())
    if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=dg:Select(tp,1,1,nil)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end
