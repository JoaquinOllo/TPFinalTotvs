#INCLUDE "PROTHEUS.ch"


/*
	FUNCIÓN ENCARGADA DE BUSCAR LOS DATOS DE UN ITEM DE PEDIDO DE VENTA AL PRESIONAR F5 O /DESCTEC/.
*/
user function GetDescTec()

// INICIALIZACIÓN DE DEMÁS VARIABLES REQUERIDAS DEL ITEM
local cDescProd := ""
local cDescTec := ""

// INICIALIZACIÓN DE ARRAY TEMPORAL DONDE SE GUARDARÁN LOS DATOS ANTERIORES
local aDescTec := {} 

// RASTREO DE ARRAY PÚBLICO, PARA OBTENER POSICIÓN DEL ÍTEM EN ÉL, SI ESTÁ.
local nPosArPbl := aScan (__aDescTec, {|x| x[nPosNumPV] == cNroPedVen ; 
				.and. x[nPItemPV] == cItem .and. x[nPosProd] == cProducto})

// PREPARACIÓN DE ÁREA DE TRABAJO CON SB1 Y ZDT	
aArea := GetArea()
aAreaSB1 := SB1->(GetArea())
aAreaZDT := ZDT->(GetArea())

	if empty(cProducto)
		aDescTec := {"Alerta", "Por favor, cargue un producto para consultar y editar su descripción técnica"}
		return aDescTec
	endif

	if nPosArPbl > 0 // SI EL ÍTEM FUE ENCONTRADO EN EL ARRAY PÚBLICO...
	// SE OBTIENEN DE ÉL LOS DATOS FALTANTES
		cDescTec 	:= __aDescTec[nPosArPbl][nPDescTec]
		cDescProd 	:= __aDescTec[nPosArPbl][nPDescPr]
	else
	// SI EL ÍTEM NO FUE ENCONTRADO EN ARRAY PÚBLICO, SE BUSCA EN ZDT		
		dbselectarea("ZDT")
		dbsetorder(1)
		if dbseek(xFilial("ZDT") + cNroPedVen + cItem)
	   		cDescTec := ZDT -> ZDT_DESTEC
		endif
	endif
	
 
    // CAMBIO DE ÁREA DE TRABAJO A SB1
    dbselectarea("SB1")
	dbsetorder(1)
    // SI TODAVÍA FALTA COMPLETAR ALGÚN DATO, SE BUSCA EL PRODUCTO EN SB1
    	
	if (EMPTY(cDescProd) .or. EMPTY(cDescTec)) .and. dbseek(xFilial("SB1") + cProducto)
		cDescProd := SB1 -> B1_DESC
		// LA DESCRIPCIÓN TÉCNICA SÓLO SE OBTIENE DE SB1 SI DICHA VARIABLE SIGUE VACÍA
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