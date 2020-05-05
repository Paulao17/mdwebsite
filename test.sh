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
      echo " converting $file to pdf"
      pandoc --template src/pdf-heading-template.html $file -f gfm --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') -o build/temp-header.html # Building pdf header
      mdpdf $file $(echo $file | sed '$s/\.md$/.pdf/' | sed 's/src/build/') #--header=build/temp-header.html --f-height=0 --hHeight 22
      rm build/temp-header.html # Remove pdf header after building pdf
      echo " converting $file to html"
      pandoc -s -o $(echo $file | sed '$s/\.md$/.html/' | sed 's/src/build/') -f gfm -c /static/github.css -c /static/style.css --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') $file --template src/template.html
      echo " adding $file to index"
      pandoc --template src/list-template.md --metadata-file $(echo $file | sed '$s/\.md$/.yaml/') $file 2>&1 | sed 's/src\//build\//g' >> build/index.md # 2>&1 -> redirect stderr to stdout ; sed -> change src/ to build/
      echo " copying $file to build"
      cp $file $(echo $file | sed 's/src/build/')
    fi
done

echo "Creating index.html"
pandoc -s -o build/index.html -f gfm -c /static/github.css -c /static/style.css --metadata-file src/index.yaml build/index.md --template template.html
