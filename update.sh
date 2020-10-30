echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    cd blog;
    unzip -o \*.zip;
    for f in formatted\ for\ website/*.docx;
        do fname=$(basename "$f" .docx);
        python3 blog.py bb -t "$f";
        /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css -B beforebody.html "$f" -o "$fname".html;
    done;
    bash -l
'

        # /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css "$f" -o "$fname".html --extract-media=./ --ascii;
        # do /mit/mpc/web_scripts/tools/bin/pandoc $f -o ${f%}.html --extract-media=${f%}/images