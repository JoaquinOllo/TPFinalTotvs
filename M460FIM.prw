#INCLUDE "PROTHEUS.ch"

/*
	PUNTO DE ENTRADA DE GRABACIÓN DE NOTA FISCAL, QUE IMPRIME LAYOUT DE FACTURA DE PEDIDO DE VENTAS.
*/
user function M460FIM()

	if ISINCALLSTACK("MATA468N") .and. MsgYesNo("Desea imprimir el layout de la factura?", "Confirmación")
		msgalert("imprimiendo factura", "informe")
	endif                      	

return