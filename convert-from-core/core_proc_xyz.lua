function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	Xyz.AddProcedure(c,f,lv,ct,alterf,desc,maxct,op)
end
function Auxiliary.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,desc,op)
	Xyz.AddProcedure(c,f,nil,minc,alterf,desc,maxc,op,false,gf)
end