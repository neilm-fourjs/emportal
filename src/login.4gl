
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

	CALL gl_win_title_ver(APP,VER)
	CALL gl_lib.gl_init(TRUE)

	CALL gl_lib.db_connect()
	CALL setLang( fgl_getEnv("LANGCODE") )

	LET m_login = do_login()
	IF m_login IS NULL THEN EXIT PROGRAM END IF

	RUN "fglrun emportal.42r "||m_login
END MAIN
--------------------------------------------------------------------------------
#+ Do the login call
#+ @returns NULL or valid email address for an account
FUNCTION do_login() RETURNS STRING
	DEFINE l_login STRING

	WHILE TRUE
		LET int_flag = FALSE
-- Call the login library function to get a valid login email address.
		LET l_login = lib_login.login(APP, VER, FALSE)
		LET int_flag = FALSE
		IF l_login = "change_lang" THEN CONTINUE WHILE END IF
		IF l_login = "Cancelled" THEN EXIT WHILE END IF
		CALL gl_lib.gl_winMessage(%"Login Okay",SFMT(%"Login for user %1 accepted.",l_login),"information")
		RETURN l_login
	END WHILE
	RETURN NULL
END FUNCTION