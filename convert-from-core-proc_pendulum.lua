function Auxiliary.EnablePendulumAttribute(c,reg)
	Pendulum.AddProcedure(c,reg)
end
function Auxiliary.PConditionFilter(c,e,tp,lscale,rscale)
	return Pendulum.Filter(c,e,tp,lscale,rscale)
end