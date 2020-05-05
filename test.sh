echo "Emptying current build directory /build"
for file in build/*; do
  rm -rf $file
  echo " removed $file"
done

echo "Replicating folders"
for directory in src/*/ ; do
  mkdir $(echo $directory | sed 's/src/build/')
  echo " created $(echo $directory | sed 's/src/build/')"
done

echo "Copying static files"
cp -R src/static/ build/

echo "Creating index.md"
touch build/index.md

echo "Converting files"
for file in src/*.md src/*/*.md
  do
    if [ -f "$file" ]
    then
      echo " converting $file to html"
      pandoc -s -o $(echo $file | sed '$s/\.md$/.html/' | sed 's/src/build/') -f gfm -c /static/github.css -c /static/style.css --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') $file --template src/template.html
      echo " adding $file to index"
      pandoc --template src/list-template.txt --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') $file 2>&1 | sed 's/src\///g' | sed 's/.md/.html/' | sed 's/.md/.pdf/' >> build/index.md # 2>&1 -> redirect stderr to stdout ; sed -> correct links
      echo " copying $file to build"
      cp $file $(echo $file | sed 's/src/build/')
      echo " converting $file to pdf"
      pandoc --template src/pdf-heading-template.html $file -f gfm --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') -o build/temp-header.md # Building pdf header
      cat $(echo $file | sed 's/src/build/') >> build/temp-header.md
      mv build/temp-header.md $(echo $file | sed 's/src/build/') # Replace old by md with header
      mdpdf $(echo $file | sed 's/src/build/')
    fi
done

echo "Creating index.html"
pandoc -s -o build/index.html -f gfm -c /static/github.css -c /static/style.css --metadata-file src/index.yaml build/index.md --template src/template-index.html
