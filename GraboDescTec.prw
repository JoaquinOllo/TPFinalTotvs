#INCLUDE "PROTHEUS.ch"

/*
	FUNCI�N LLAMADA POR M410STTS, PARA GRABAR LAS DESCRIPCIONES T�CNICAS 
	DE CADA ITEM DE UN PEDIDO DE VENTAS EN LA ZDT
*/
user function GrbDesTec()

local nX := 1 // CONTADOR PARA FOR
// VARIABLES USADA EN FOR PARA ALOJAR ITEM DE PV, C�DIGO DE PRODUCTO Y DESC.TEC. TEMPORALMENTE
local cTempItem := ""
local cTempProd := ""
local cTempDesTec := ""

aArea := GetArea()
aAreaZDT := ZDT->(GetArea())
aAreaSB1 := SB1->(GetArea())
	
/* BUCLE QUE RECORRE ACOLS, BUSCANDO ITEMS DE PV QUE NO EST�N EN __ADESCTEC NI EN ZDT,
	Y LOS GUARDA EN LA TABLA ZDT
*/
	for nX := 1 TO len(aCols)
	cTempItem := aCols[nX][nPosItem]
	cTempProd := aCols[nX][nPProduto]
		if aScan(__aDescTec, {|x| x[nPosNumPV] == cNroPedVen ; 
				.and. x[nPItemPV] == cTempItem}) == 0 ;
				.and. ExistChav( "ZDT", xFILIAL("ZDT") + cNroPedVen + cTempItem, 1 )
		// SI UN ITEM DE ACOLS NO ES ENCONTRADO EN __ADESCTEC NI EN ZDT...
		dbselectarea("SB1")
		dbsetorder(1)
			// SE BUSCA SU DESC.TEC. EN LA SB1, Y SE ALOJA EN UNA VARIABLE TEMPORAL
			if dbseek(xFilial("SB1") + cTempProd)
				cTempDesTec := SB1->B1_XDESTEC
			endif
		
			// SE PASAN LAS VARIABLES TEMPORALES COMO PAR�METROS A LA FUNCI�N DE GUARDADO
			// PARA CREAR UN REGISTRO NUEVO
			SaveInZDT(cTempItem, cTempProd, cTempDesTec)
				
		endif
	
	next nX
	
	dbselectarea("ZDT")
	dbsetorder(1)
	
	// SE RECORRE __ADESCTEC...
	for nX := 1 TO len(__aDescTec)
		// SE EVAL�A SI EL N�MERO DE PEDIDO DE VENTA DEL ARRAY ES IGUAL AL ACTUAL
		if __aDescTec[nX][nPosNumPV] == cNroPedVen
		
			// SI SE ENCUENTRA UN REGISTRO PARA ESE PEDIDO DE VENTAS E �TEM, SE LO EDITA
			if dbseek(xFILIAL("ZDT") + cNroPedVen + __aDescTec[nX][nPItemPV])
				reclock("ZDT", .F.)
				ZDT->ZDT_DESTEC := __aDescTec[nX][nPDescTec]
				msunlock()                   
				
			// SI NO SE ENCUENTRA UN REGISTRO EN ZDT, SE CREA UNO NUEVO Y GUARDAN LOS DATOS
			else			
				SaveInZDT(__aDescTec[nX][nPItemPV], __aDescTec[nX][nPosProd], __aDescTec[nX][nPDescTec])
			endif
		endif
	next nX
	
__aDescTec := {}

RestArea(aArea)
RestArea(aAreaZDT)
RestArea(aAreaSB1)
return

/*
	FUNCI�N PARA CREAR UN REGISTRO NUEVO EN ZDT Y GUARDAR LA DESC.TEC.
	DE UN ITEM DE PEDIDO DE VENTAS.
*/
static function SaveInZDT(cItem, cProducto, cDescTec)
aArea := GetArea()
aAreaZDT := ZDT->(GetArea())

	dbselectarea("ZDT")
	dbsetorder(1)
	
	ZDT->(DBAppend())
	reclock("ZDT", .F.)
	ZDT->ZDT_FILIAL := xFILIAL("ZDT")
	ZDT->ZDT_NUMPV := cNroPedVen
	ZDT->ZDT_PRODUC := cProducto
	ZDT->ZDT_ITEMPV := cItem
	ZDT->ZDT_DESTEC := cDescTec
	msunlock()

RestArea(aArea)
RestArea(aAreaZDT)
return