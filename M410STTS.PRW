#INCLUDE "PROTHEUS.ch"

/*
	PUNTO DE ENTRADA AL GRABAR DATOS DE PEDIDO DE VENTA,
	LLAMANDO A FUNCIÓN PARA GRABAR DESC.TEC. EN ZDT
*/
user function M410STTS()

	if isincallstack("MATA410") .and. (ALTERA .or. INCLUI)
		u_DecorDT({||u_GrbDesTec()})
	endif

return