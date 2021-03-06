#INCLUDE "protheus.ch"

User Function ABM_ZDT()
Private aRotina := Menudef()

Private CCADASTRO := "ABM de Descripciones t�cnicas en pedidos de venta"	// Titulo de la ventana.
	
	DbSelectArea("ZDT")
	DbSetOrder(1)
	mBrowse(6,1,22,75,"ZDT" )

return

Static Function Menudef()

Local aRotina := 	{{"Buscar", 	"AxPesqui", 0,1, 0, nil},{"Visualizar", 	"AxVisual", 0,2, 0, nil},;					
					{"Incluir"	, 	"u_ZDTInclu", 0,3, 0, nil},{"Modificar", 	"u_ZDTAlter", 0,4, 0, nil},;
					{"Borrar"	, 	"AxDeleta", 0,5, 0, nil}}					
		

Return aRotina

user function ZDTAlter (cAlias,nRecNo,nOpcX)
Local aCposEdit 	:= {"ZDT_DESTEC"}	// CAMPOS EDITABLES.

 

	AxAltera(cAlias,nRecNo,nOpcX,,aCposEdit)

return

user function ZDTInclu(cAlias,nRecNo,nOpcX)
Local cValidac := "u_ValInc()"	// VALIDACIONES GLOBALES.


	AxInclui(cAlias, nRecno, nOpcx,,,, cValidac )

return

user Function ValInc()

Local lOk := .T.

	// VALIDA QUE EL REGISTRO NO EXISTA, MEDIANTE LA CLAVE.


	lOk := ExistChav("ZDT", M->ZDT_NUMPV + M->ZDT_ITEMPV, 1 ) .and. !EMPTY(M->ZDT_NUMPV);
		 .and. !EMPTY(M->ZDT_ITEMPV) .and. !EMPTY(M->ZDT_DESTEC)
	


Return lOk