#INCLUDE "PROTHEUS.ch"


/*
	FUNCI�N ENCARGADA DE BUSCAR LOS DATOS DE UN ITEM DE PEDIDO DE VENTA AL PRESIONAR F5 O /DESCTEC/.
*/
user function GetDescTec()

// INICIALIZACI�N DE DEM�S VARIABLES REQUERIDAS DEL ITEM
local cDescProd := ""
local cDescTec := ""

// INICIALIZACI�N DE ARRAY TEMPORAL DONDE SE GUARDAR�N LOS DATOS ANTERIORES
local aDescTec := {} 

// RASTREO DE ARRAY P�BLICO, PARA OBTENER POSICI�N DEL �TEM EN �L, SI EST�.
local nPosArPbl := aScan (__aDescTec, {|x| x[nPosNumPV] == cNroPedVen ; 
				.and. x[nPItemPV] == cItem .and. x[nPosProd] == cProducto})

// PREPARACI�N DE �REA DE TRABAJO CON SB1 Y ZDT	
aArea := GetArea()
aAreaSB1 := SB1->(GetArea())
aAreaZDT := ZDT->(GetArea())

	if empty(cProducto)
		aDescTec := {"Alerta", "Por favor, cargue un producto para consultar y editar su descripci�n t�cnica"}
		return aDescTec
	endif

	if nPosArPbl > 0 // SI EL �TEM FUE ENCONTRADO EN EL ARRAY P�BLICO...
	// SE OBTIENEN DE �L LOS DATOS FALTANTES
		cDescTec 	:= __aDescTec[nPosArPbl][nPDescTec]
		cDescProd 	:= __aDescTec[nPosArPbl][nPDescPr]
	else
	// SI EL �TEM NO FUE ENCONTRADO EN ARRAY P�BLICO, SE BUSCA EN ZDT		
		dbselectarea("ZDT")
		dbsetorder(1)
		if dbseek(xFilial("ZDT") + cNroPedVen + cItem)
	   		cDescTec := ZDT -> ZDT_DESTEC
		endif
	endif
	
 
    // CAMBIO DE �REA DE TRABAJO A SB1
    dbselectarea("SB1")
	dbsetorder(1)
    // SI TODAV�A FALTA COMPLETAR ALG�N DATO, SE BUSCA EL PRODUCTO EN SB1
    	
	if (EMPTY(cDescProd) .or. EMPTY(cDescTec)) .and. dbseek(xFilial("SB1") + cProducto)
		cDescProd := SB1 -> B1_DESC
		// LA DESCRIPCI�N T�CNICA S�LO SE OBTIENE DE SB1 SI DICHA VARIABLE SIGUE VAC�A
		cDescTec := IIF(EMPTY(cDescTec), SB1 -> B1_XDESTEC, cDescTec)
	endif
	
	// LOS DATOS SE AGREGAN AL ARRAY TEMPORAL
	AADD(aDescTec, cNroPedVen)
	AADD(aDescTec, cItem)
	AADD(aDescTec, cProducto)
	AADD(aDescTec, cDescProd)
	AADD(aDescTec, cDescTec)	

RestArea(aAreaZDT)
RestArea(aAreaSB1)
RestArea(aArea)
return aDescTec // SE DEVUELVE DICHO ARRAY TEMPORAL