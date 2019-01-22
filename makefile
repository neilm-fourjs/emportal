
export LANGCODE=en
export FGLRESOURCEPATH=$(PWD)/etc:$(PWD)/etc_$(LANGCODE)
export FGLDBPATH=$(PWD)/etc
export FGLLDPATH=$(PWD)/bin
export FGLPROFILE=$(PWD)/etc/profile.ifx:$(PWD)/etc/profile.strings
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


strings: etc_en/strings.42s etc_ar/strings.42s

etc_en/strings.str: src/*.per src/*.4gl
	cd src;for f in *.per; do fglform -m $$f >> strings.str; done;
	cd src;for f in *.4gl; do fglcomp -m $$f >> strings.str; done;
	cd src; cat strings.str | sort | uniq > ../etc_en/strings.str	
	cd src; rm *.str

etc_en/strings.42s: etc_en/strings.str
	cd etc_en; fglmkstr strings.str

etc_ar/strings.42s: etc_ar/strings.str
	cd etc_ar; fglmkstr strings.str


clean:
	find . -name \*.42? -exec rm {} \;
