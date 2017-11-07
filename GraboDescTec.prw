#INCLUDE "PROTHEUS.ch"

user function GrbDesTec()

local nX := 1

aArea := GetArea()
aAreaZDT := ZDT->(GetArea())

	dbselectarea("ZDT")
	dbsetorder(1)
	
	for nX := 1 TO len(__aDescTec)
		if __aDescTec[nX][nPosNumPV] == cNroPedVen
			if dbseek(xFILIAL("ZDT") + cNroPedVen + __aDescTec[nX][nPItemPV])
				reclock("ZDT", .F.)
				ZDT->ZDT_DESTEC := __aDescTec[nX][nPDescTec]
				msunlock()
			else
				ZDT->(DBAppend())
				reclock("ZDT", .F.)
				ZDT->ZDT_FILIAL := xFILIAL("ZDT")
				ZDT->ZDT_NUMPV := __aDescTec[nX][nPosNumPV]
				ZDT->ZDT_PRODUC := __aDescTec[nX][nPosProd]
				ZDT->ZDT_ITEMPV := __aDescTec[nX][nPItemPV]
				ZDT->ZDT_DESTEC := __aDescTec[nX][nPDescTec]
				msunlock()
			endif
		endif
	next nX
	
__aDescTec := {}

RestArea(aArea)
RestArea(aAreaZDT)
return