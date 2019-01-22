
#+ Login Demo
#+ The purpose of this demo is to show an example of how 
#+ to use the lib_login & lib_secure libraries
#+
#+ This module initially written by: Neil J.Martin ( neilm@4js.com ) 
#+

# Login Demo Program

IMPORT FGL lib_login
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

	DISPLAY %"Welcome - please login" TO wel
	LET m_login = do_login()
	IF m_login IS NULL THEN EXIT PROGRAM END IF

	MENU
		ON ACTION close EXIT MENU
		BEFORE MENU
			CALL set_actions( DIALOG )

		ON ACTION login
			LET m_login = do_login()
			CALL set_actions( DIALOG )

		ON ACTION act1 CALL em_details( "V", m_login )
		ON ACTION act2 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")
		ON ACTION act3 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")
		ON ACTION act4 CALL gl_lib.gl_winMessage("Demo","Not Done Yet","information")

		ON ACTION quit EXIT MENU
	END MENU

	DISPLAY "Program Finished."

END MAIN
--------------------------------------------------------------------------------
#+ Do the login call
#+ @returns NULL or valid email address for an account
FUNCTION do_login() RETURNS STRING
	DEFINE l_login STRING

	LET int_flag = FALSE
-- Call the login library function to get a valid login email address.
	LET l_login = lib_login.login(APP, VER, FALSE)
	LET int_flag = FALSE
	IF l_login != "Cancelled" THEN
		CALL gl_lib.gl_winMessage(%"Login Okay",SFMT(%"Login for user %1 accepted.",l_login),"information")
		RETURN l_login
	END IF
	RETURN NULL
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION set_actions(d ui.Dialog)
	IF m_login IS NOT NULL THEN
		DISPLAY SFMT(%"Welcome %1",m_login) TO wel
		CALL d.setActionActive("act1", TRUE)
		CALL d.setActionActive("act2", TRUE)
		CALL d.setActionActive("act3", TRUE)
		CALL d.setActionActive("act4", TRUE)
		CALL ui.Window.getCurrent().getForm().setElementText("login",%"Logout")
		CALL ui.Window.getCurrent().getForm().setElementImage("login","fa-unlock")
	ELSE
		CALL ui.Window.getCurrent().getForm().setElementText("login",%"Login")
		CALL ui.Window.getCurrent().getForm().setElementImage("login","fa-lock")
		CALL d.setActionActive("act1", FALSE)
		CALL d.setActionActive("act2", FALSE)
		CALL d.setActionActive("act3", FALSE)
		CALL d.setActionActive("act4", FALSE)
	END IF
END FUNCTION