
#+ Login Demo
#+ The purpose of this demo is to show an example of how 
#+ to use the lib_login & lib_secure libraries
#+
#+ This module initially written by: Neil J.Martin ( neilm@4js.com ) 
#+

# Login Demo Program

IMPORT FGL lib_login
IMPORT FGL gl_lib
CONSTANT VER = "1.1"
CONSTANT APP = %"Employee Portal"

DEFINE m_login STRING

MAIN
	DEFINE l_cmd STRING
	CALL gl_win_title_ver(APP,VER)
	CALL gl_lib.gl_init(TRUE)

	CALL gl_lib.db_connect()
	CALL setLang( fgl_getEnv("LANGCODE") )

	LET m_login = lib_login.login(APP, VER, FALSE)
	IF m_login = "Cancelled" THEN EXIT PROGRAM END IF

	IF m_login = "change_lang" THEN
 		LET l_cmd = "fglrun login.42r"
	ELSE
		CALL gl_lib.gl_winMessage(%"Login Okay",SFMT(%"Login for user %1 accepted.",m_login),"information")
		LET l_cmd = "fglrun emportal.42r "||m_login
	END IF
	CALL ui.Interface.refresh()
	RUN l_cmd WITHOUT WAITING
	SLEEP 2
END MAIN
--------------------------------------------------------------------------------