
export FGLRESOURCEPATH=$(PWD)/etc
export FGLLDPATH=$(PWD)/bin
export FGLPROFILE=$(FGLRESOURCEPATH)/profile.ifx
export LANG=ar_AE.8859-6
#export CLIENT_LOCALE=$(LANG)

bin/emportal.42r: src/*.4gl src/*.per
	gsmake emportal.4pw

run: bin/emportal.42r
	cd bin && fglrun emportal.42r

bin_mk_db/mk_db.42r: src/mk_db.4gl src/gl_lib.4gl src/lib_secure.4gl src/dbname.inc
	gsmake -t mk_db emportal.4pw

mkdb: bin_mk_db/mk_db.42r
	cd bin_mk_db && fglrun mk_db.42r
