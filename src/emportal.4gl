
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

MAIN
	DEFINE l_login STRING

	OPEN FORM ld FROM "emportal"
	DISPLAY FORM ld
	CALL gl_win_title_ver(APP,VER)
	CALL gl_lib.gl_init(TRUE)

	CALL gl_lib.db_connect()

	DISPLAY "Welcome - please login" TO wel

	MENU
		ON ACTION close EXIT MENU
		BEFORE MENU
			CALL DIALOG.setActionActive("act1", FALSE)
			CALL DIALOG.setActionActive("act2", FALSE)
			CALL DIALOG.setActionActive("act3", FALSE)
			CALL DIALOG.setActionActive("act4", FALSE)

		ON ACTION login
			LET l_login = do_login()
			IF l_login IS NOT NULL THEN
				DISPLAY SFMT(%"Welcome %1",l_login) TO wel
				CALL DIALOG.setActionActive("act1", TRUE)
				CALL DIALOG.setActionActive("act2", TRUE)
				CALL DIALOG.setActionActive("act3", TRUE)
				CALL DIALOG.setActionActive("act4", TRUE)
			END IF

		ON ACTION act1 CALL em_details( "V", l_login )
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