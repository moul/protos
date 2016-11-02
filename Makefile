TMP ?=	.tmp

currency.proto: $(TMP)/currency_4217.json
	cat $< | json2template .tmpl/currency_4217.tmpl > $@.tmp
	mv $@.tmp $@

$(TMP)/currency_4217.json: $(TMP)/currency_4217.xml
	cat $< | xml2json > $@

$(TMP)/currency_4217.xml:
	mkdir -p .tmp
	wget http://www.currency-iso.org/dam/downloads/lists/list_one.xml -O$@
