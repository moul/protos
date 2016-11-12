TMP ?=	.tmp

all: currency/iso4217.proto country/iso3166-1.proto

currency/iso4217.proto: $(TMP)/currency_4217.json
	cat $< | go run .tmpl/currency_4217.go > $@.tmp
	mv $@.tmp $@

country/iso3166-1.proto: $(TMP)/country-codes.json
	cat $< | go run .tmpl/country_3166-1-numeric.go > $@.tmp
	mv $@.tmp $@

$(TMP)/country-codes.json:
	@mkdir -p $(TMP)
	wget -O $@ http://data.okfn.org/data/core/country-codes/r/country-codes.json

$(TMP)/currency_4217.json: $(TMP)/currency_4217.xml
	@mkdir -p $(TMP)
	cat $< | xml2json > $@.tmp
	mv $@.tmp $@

$(TMP)/currency_4217.xml:
	@mkdir -p $(TMP)
	wget http://www.currency-iso.org/dam/downloads/lists/list_one.xml -O$@


.PHONY: test
test:
	rm -rf $(TMP)
	mkdir -p $(TMP)
	for e in country currency; do \
	  protoc --go_out=.tmp $$e/*.proto || exit 1; \
	done


.PHONY: docker-test
docker-test:
	docker run -v "$(PWD):$(PWD)" -w "$(PWD)" --entrypoint=/bin/sh znly/protoc -c "make test"
