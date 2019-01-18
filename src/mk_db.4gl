
IMPORT os
IMPORT FGL gl_lib
IMPORT FGL lib_secure
&include "dbname.inc"

MAIN
	DEFINE l_hash_type, l_login_pass, l_salt, l_pass_hash, l_email VARCHAR(128)
	DEFINE l_dte, l_dte2 DATE

	CALL gl_lib.db_connect()

	TRY
		DISPLAY "Dropping accounts table ..."
		DROP TABLE DEF_LOGIN_TABLE 
		DROP TABLE DEF_APPUSERS_TABLE
	CATCH
		IF STATUS = -206 THEN
			DISPLAY STATUS,":",SQLERRMESSAGE
			DISPLAY "accounts drop failed."
		END IF
	END TRY

	TRY
		SELECT COUNT(*) FROM DEF_LOGIN_TABLE 
	CATCH
		DISPLAY "Creating accounts table..."
		CREATE TABLE DEF_LOGIN_TABLE (
			email       VARCHAR(60) NOT NULL,
			active      SMALLINT NOT NULL,
			forcepwchg  CHAR(1),
			hash_type		VARCHAR(12) NOT NULL, -- type of hash used.
			salt        VARCHAR(64), -- for Genero 3.10 using bcrypt we don't need this
			pass_hash   VARCHAR(128) NOT NULL,
			pass_expire DATE,
			acc_type    SMALLINT -- 0=User / 1=Admin
		)
		DISPLAY "Table Created."
	END TRY

	LET l_email = "test@test.com"
	LET l_login_pass = "Testing123"
	LET l_hash_type = lib_secure.glsec_getHashType()
	LET l_salt = lib_secure.glsec_genSalt(l_hash_type)
	LET l_pass_hash = lib_secure.glsec_genPasswordHash( l_login_pass, l_salt, l_hash_type )
	LET l_dte = TODAY+365
	TRY
		INSERT INTO DEF_LOGIN_TABLE VALUES(l_email,1,"N",	l_hash_type, l_salt, l_pass_hash, l_dte, 1)
		DISPLAY "Inserted: "||l_email||" / "||l_login_pass||" with "||l_hash_type||" hash."
	CATCH
		DISPLAY "Insert test account failed!\n",STATUS,":",SQLERRMESSAGE
	END TRY

	CREATE TABLE DEF_APPUSERS_TABLE (
			acct_id     				SERIAL NOT NULL,
			employee_no 				INTEGER,
			salutation  				VARCHAR(60),
			forenames   				VARCHAR(60) NOT NULL,
			surname   				  VARCHAR(60) NOT NULL,
			position   					VARCHAR(60),
			email       				VARCHAR(60) NOT NULL,
			primary_role 				VARCHAR(60),
			start_date					DATE,
			termination_date 		DATE,
			dob									DATE,
			holiday_days 				SMALLINT,
			holiday_days_left 	SMALLINT
	)
	LET l_dte = TODAY-365
	LET l_dte2 = DATE("01/01/1970")
	TRY
		INSERT INTO DEF_APPUSERS_TABLE 
			VALUES(1,42,"Mr","Test","Testing","Tester",l_email,"A test account",l_dte,NULL,l_dte2,20,15)
		DISPLAY "Test Account Inserted: "||l_email||" / "||l_login_pass||" with "||l_hash_type||" hash."
	CATCH
		DISPLAY "Insert test account failed!\n",STATUS,":",SQLERRMESSAGE
	END TRY
END MAIN