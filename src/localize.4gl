
IMPORT FGL gl_lib

&include "schema.inc"

CONSTANT VER = "1.0"
CONSTANT APP = %"Localize"

DEFINE m_strs DYNAMIC ARRAY OF RECORD
		done BOOLEAN,
		original STRING,
		translated STRING
	END RECORD
DEFINE m_code CHAR(2)
MAIN

	LET m_code = "ar"

	OPEN FORM f1 FROM "localize"
	DISPLAY FORM f1

	DISPLAY fgl_getEnv("LANG") TO lang
	DISPLAY m_code TO code

	CALL gl_win_title_ver(APP,VER)
	CALL gl_lib.gl_init(TRUE)

	CALL gl_lib.db_connect()

	CALL getStrings()

	DISPLAY ARRAY m_strs TO strs.*
		ON ACTION save CALL saveStringsToFile("../etc/strings_"||m_code||".str")
		ON ACTION quit EXIT DISPLAY
	END DISPLAY

END MAIN
--------------------------------------------------------------------------------
FUNCTION getStrings()
	CALL getStringsFromFile("../etc/strings_"||m_code||".str")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getStringsFromFile(l_file STRING)
	DEFINE c base.Channel
	DEFINE l_line STRING
	DEFINE x SMALLINT
	LET c = base.Channel.create()
	CALL c.openFile(l_file,"r")
	WHILE NOT c.isEof()
		LET l_line = c.readLine()
		IF l_line.getLength() > 1 THEN
			LET x = l_line.getIndexOf("\"",2)
			CALL m_strs.appendElement()
			LET m_strs[ m_strs.getLength() ].done = FALSE
			LET m_strs[ m_strs.getLength() ].original = l_line.subString(2,x-1)
			LET m_strs[ m_strs.getLength() ].translated = l_line.subString(x+3, l_line.getLength() - 1)
			IF m_strs[ m_strs.getLength() ].original != m_strs[ m_strs.getLength() ].translated THEN
				LET m_strs[ m_strs.getLength() ].done = TRUE
			END IF
		END IF
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION saveStringsToFile(l_file STRING)
	DEFINE c base.Channel
	DEFINE x SMALLINT
	DEFINE l_line STRING
	LET c = base.Channel.create()
	CALL c.openFile(l_file,"w")
	FOR x = 1 TO  m_strs.getLength()
		LET l_line = "\"",m_strs[ x ].original.trim(),"\"=\"",m_strs[ x ].translated.trim(),"\""
		CALL c.writeLine(l_line)
	END FOR
	CALL c.close()
	RUN "fglmkstr "||l_file
END FUNCTION