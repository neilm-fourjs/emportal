
IMPORT FGL gl_lib
IMPORT FGL lib_secure
IMPORT FGL lib_login
&include "schema.inc"

FUNCTION em_details( l_mode CHAR(1), l_email STRING )
	DEFINE l_rec1 RECORD LIKE DEF_LOGIN_TABLE.*
	DEFINE l_rec2 RECORD LIKE DEF_APPUSERS_TABLE.*
	DEFINE l_rules, l_login_pass STRING

	IF l_mode = "N" THEN
		LET l_rec2.acct_id = 0
		LET l_rec1.acc_type = 0
		LET l_rec1.active = TRUE
		LET l_rec1.forcepwchg = "Y"
		LET l_rec1.pass_expire = TODAY + 6 UNITS MONTH
	ELSE
		SELECT * INTO l_rec1.* FROM DEF_LOGIN_TABLE WHERE email = l_email
		SELECT * INTO l_rec2.* FROM DEF_APPUSERS_TABLE WHERE email = l_email
	END IF

	OPEN WINDOW w_em_details WITH FORM "em_details"

	IF l_mode = "V" THEN -- View Only
-- hide password group
		CALL ui.Window.getCurrent().getForm().setElementHidden("pgrp", TRUE)
		DISPLAY BY NAME l_rec1.*
		DISPLAY BY NAME l_rec2.*
		MENU "" ON ACTION back EXIT MENU END MENU
		CLOSE WINDOW w_em_details
		RETURN
	END IF

	LET l_rules = lib_secure.glsec_passwordRules( C_DEFPASSLEN )
	DISPLAY BY NAME l_rules

	INPUT BY NAME l_rec1.*, l_login_pass, l_rec2.* ATTRIBUTES(WITHOUT DEFAULTS, FIELD ORDER FORM, UNBUFFERED)
		AFTER FIELD email
			IF lib_login.sql_checkEmail(l_rec2.email) THEN
				CALL gl_lib.gl_winMessage(%"Error",%"This Email is already registered.","exclamation")
				NEXT FIELD email
			END IF
		AFTER FIELD pass_expire
			IF l_rec1.pass_expire < (TODAY + 1 UNITS MONTH) THEN
				ERROR %"Password expire date can not be less than 1 month."
				NEXT FIELD pass_expire
			END IF
		AFTER FIELD l_login_pass
			LET l_rules = lib_secure.glsec_isPasswordLegal( C_DEFPASSLEN )
			IF l_rules != "Okay" THEN
				ERROR l_rules
				NEXT FIELD l_login_pass
			END IF
		BEFORE INPUT
			CALL DIALOG.setFieldActive("accounts.acct_id",FALSE)
			CALL DIALOG.setFieldActive("accounts.forcepwchg",FALSE)
			CALL DIALOG.setFieldActive("accounts.active",FALSE)
			CALL DIALOG.setFieldActive("accounts.acct_type",FALSE)
		ON ACTION generate
			LET l_login_pass = lib_secure.glsec_genPassword()
			CALL gl_lib.gl_winMessage(%"Password",SFMT(%"Your Generated Password is:\n%1\nDon't forget it!",l_login_pass),"information")
	END INPUT

	CLOSE WINDOW w_em_details

	IF NOT int_flag THEN
		LET l_rec1.hash_type = lib_secure.glsec_getHashType()
		LET l_rec1.salt = lib_secure.glsec_genSalt(l_rec1.hash_type) -- NOTE: for Genero 3.10 we don't need to store this
		LET l_rec1.pass_hash = lib_secure.glsec_genPasswordHash(l_login_pass ,l_rec1.salt, l_rec1.hash_type)
		INSERT INTO DEF_LOGIN_TABLE VALUES l_rec1.*
	END IF

	LET int_flag = FALSE
END FUNCTION
--------------------------------------------------------------------------------
#+ Populate the combox objects
#+ NOTE: This function is normally called by INITIALIZER statement in a per file.
#+
#+ @param l_cb A valid ui.ComboBox object
FUNCTION pop_combo(l_cb)
	DEFINE l_cb ui.ComboBox
	CASE l_cb.getColumnName()
		WHEN "acc_type"
			CALL l_cb.addItem(0,%"Normal User")
			CALL l_cb.addItem(1,%"Admin User")
	END CASE
END FUNCTION
--------------------------------------------------------------------------------