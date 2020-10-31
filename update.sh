echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    source /mit/mpc/web_scripts/site/blogger.sh;
    bash -l
'

# echo MIT username:
# read user
# ssh -t $user@athena.dialup.mit.edu '
#     cd /mit/mpc/web_scripts/site;
#     svn update;
#     cd blog;
#     unzip -o \*.zip;
#     links="# links:\n"
#     for f in formatted\ for\ website/*.docx;
#         do basefname=$(basename "$f" .docx);
#         python3 blog.py bb -t "$basefname";
#         fname="${basefname// /}"
#         /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css -B beforebody.html "$f" -o "$fname".html;
#         links="${links} * [http://mpc.mit.edu/blog/$fname.html](http://mpc.mit.edu/blog/$fname.html)\n";
#     done;
#     echo -e "${links}" > links.md;
#     /mit/mpc/web_scripts/tools/bin/pandoc -s -c ../assets/css/blog.css links.md -o links.html;
#     bash -l
# '