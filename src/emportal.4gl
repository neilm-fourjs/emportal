
IMPORT FGL gl_lib

&include "schema.inc"

CONSTANT VER = "1.1"
CONSTANT APP = %"Employee Portal"

DEFINE m_login STRING

MAIN

	CALL gl_win_title_ver(APP,VER)
	CALL gl_lib.gl_init(TRUE)

	OPEN FORM f1 FROM "emportal"
	DISPLAY FORM f1

	CALL gl_lib.db_connect()

	LET m_login = ARG_VAL(1)
	IF m_login.getLength() < 2 THEN EXIT PROGRAM END IF
	DISPLAY SFMT(%"Welcome %1",m_login) TO wel
	MENU
		ON ACTION act1 CALL em_details( "V", m_login )
		ON ACTION act2 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")
		ON ACTION act3 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")
		ON ACTION act4 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")

		ON ACTION quit EXIT MENU
		ON ACTION close EXIT MENU
	END MENU

	DISPLAY "Program Finished."

END MAIN
--------------------------------------------------------------------------------