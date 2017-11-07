#INCLUDE "PROTHEUS.ch"

user function M410STTS()

	if isincallstack("MATA410") .and. (ALTERA .or. INCLUI)
		u_DecorDT({||u_GrbDesTec()})
	endif

return