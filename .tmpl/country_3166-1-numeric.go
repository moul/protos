package main

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"strconv"
	"text/template"

	"github.com/moul/funcmap"
)

var tmplStr = `syntax = "proto3";

/** Country codes - ISO 3166-1 numeric
 *
 * http://www.iso.org/iso/home/standards/country_codes.htm
 */

package country;

enum CountryCode {
  _ = 0; // zero vale

{{range .}}{{if gt .ISO31661Numeric 0}}{{if .ISO31661Alpha3}}/**
 * {{.Name}}
 */
  {{.ISO31661Alpha3}} = {{.ISO31661Numeric}};

{{end}}{{end}}{{end}}}
`

type country struct {
	Name               string `json:"name"`
	ISO31661Alpha3     string `json:"ISO3166-1-Alpha-3"`
	ISO31661NumericStr string `json:"ISO3166-1-numeric"`
	ISO31661Numeric    int
}

type countries []country

func main() {
	inputStr, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	var input countries
	if err := json.Unmarshal(inputStr, &input); err != nil {
		panic(err)
	}

	for idx, country := range input {
		input[idx].ISO31661Numeric, _ = strconv.Atoi(country.ISO31661NumericStr)
	}

	tmpl, err := template.New("").Funcs(funcmap.FuncMap).Parse(tmplStr)
	if err != nil {
		panic(err)
	}

	if err := tmpl.Execute(os.Stdout, input); err != nil {
		panic(err)
	}
}
