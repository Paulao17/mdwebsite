# mdwebsite
Converts the markdown files in `./src/` to HTML and pdf in the `./build` directory. Builds an `index.html` with all the files.

## Requirements
Requires [pandoc](pandoc.org/) and [mdpdf](https://github.com/BlueHatbRit/mdpdf)(installed locally).

## Usage
```
sh test.sh
```

## Customization
You can edit the templates and stylesheets in `./src/`.

`src/list-template.txt` : markdown for index entries (should be left unchanged)
`src/pdf-heading-template.html` : markdown for the pdf header
`src/template-index.html` : HTML5 template for the index
`src/template.html` : HTML template for each page

`$` are related to pandoc templating.
