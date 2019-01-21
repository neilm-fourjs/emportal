
export FGLRESOURCEPATH=$(PWD)/etc
export FGLDBPATH=$(PWD)/etc
export FGLLDPATH=$(PWD)/bin
export FGLPROFILE=$(FGLRESOURCEPATH)/profile.ifx:$(FGLRESOURCEPATH)/profile.ar
#export LANG=ar_AE.8859-6
#export CLIENT_LOCALE=$(LANG)

bin/emportal.42r: src/*.4gl src/*.per
	gsmake emportal.4pw

run: bin/emportal.42r strings
	cd bin && fglrun emportal.42r

bin_mk_db/mk_db.42r: src/mk_db.4gl src/gl_lib.4gl src/lib_secure.4gl src/dbname.inc
	gsmake -t mk_db emportal.4pw

mkdb: bin_mk_db/mk_db.42r
	cd bin_mk_db && fglrun mk_db.42r


strings: etc/strings.42s etc/strings_ar.42s

etc/strings.str: src/*.per src/*.4gl
	cd src;for f in *.per; do fglform -m $$f >> strings.str; done;
	cd src;for f in *.4gl; do fglcomp -m $$f >> strings.str; done;
	cd src; cat strings.str | sort | uniq > ../etc/strings.str	
	cd src; rm *.str

etc/strings.42s: etc/strings.str
	cd etc; fglmkstr strings.str

etc/strings_ar.42s: etc/strings_ar.str
	cd etc; fglmkstr strings_ar.str

