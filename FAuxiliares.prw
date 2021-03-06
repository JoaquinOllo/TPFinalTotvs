#INCLUDE "PROTHEUS.ch"

/*
	FUNCI�N DECORADORA QUE INICIALIZA VARIABLES PRIVADAS CON REFERENCIA A �NDICES 
	DE ARRAY P�BLICO __aDescTec para consultarlos m�s f�cilmente. Recibe como par�metro 
	la funci�n que contendr�, sin comillas, y la alojar� en un bloque de c�digo para ejecutarla
*/
User function DecorDT(funcion)

// POSICI�N DE DATOS DEL ARRAY P�BLICO
private nPosNumPV 	:= 1 // N�MERO DE PEDIDO DE VENTA
private nPItemPV 	:= 2 // ITEM EN PEDIDO DE VENTA
private nPosProd 	:= 3 // C�DIGO DE PRODUCTO
private nPDescPr 	:= 4 // DESCRIPCI�N DEL PRODUCTO
private nPDescTec 	:= 5 // DESCRIPCI�N T�CNICA

// RASTREO DE NRO PEDIDO DE VENTA EN MEMORIA
private cNroPedVen := M->C5_NUM

// RASTREO DE AHEADER BUSCANDO LA POSICI�N DE LOS CAMPOS C6_ITEM Y C6_PRODUTO
// Y SE ALOJA EL N�MERO DEVUELTO POR ASCAN EN UNA VARIABLE DE POSICI�N
private nPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
private nPosItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})

	EVAL(funcion)	

return