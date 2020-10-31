cd /mit/mpc/web_scripts/site/blog;
unzip -o \*.zip;
links="# links:\n"
for f in formatted\ for\ website/*.docx;
    do basefname=$(basename "$f" .docx);
    python3 blog.py bb -t "$basefname";
    fname="${basefname// /}"
    /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css -B beforebody.html "$f" -o "$fname".html;
    links="${links} * [http://mpc.mit.edu/blog/$fname.html](http://mpc.mit.edu/blog/$fname.html)\n";
done;
echo -e "${links}" > links.md;
/mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css links.md -o links.html;

        # /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css "$f" -o "$fname".html --extract-media=./ --ascii;
        # do /mit/mpc/web_scripts/tools/bin/pandoc $f -o ${f%}.html --extract-media=${f%}/images