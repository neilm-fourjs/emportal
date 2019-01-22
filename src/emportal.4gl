
IMPORT FGL gl_lib
IMPORT FGL em_details
IMPORT FGL em_payslips
IMPORT FGL em_holidays
IMPORT FGL em_suggestions
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
		ON ACTION act1 CALL em_details.em_details( "V", m_login )
		ON ACTION act2 CALL em_payslips.em_payslips( m_login )
		ON ACTION act3 CALL em_holidays.em_holidays( m_login )
		ON ACTION act4 CALL em_suggestions.em_suggestions( m_login )

		ON ACTION quit EXIT MENU
		ON ACTION close EXIT MENU
	END MENU

	DISPLAY "Program Finished."

END MAIN
--------------------------------------------------------------------------------