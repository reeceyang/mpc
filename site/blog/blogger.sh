cd "$(dirname "$0")"
pandoc="$(pwd)"/../../../tools/bin/pandoc
unzip -o \*.zip;
links="# links:\n"
for f in formatted\ for\ website/*.docx;
    do basefname=$(basename "$f" .docx);
    title=$(python3 blog.py lt -t "$basefname");
    author=$(python3 blog.py la -t "$basefname");
    echo $title " " $author;
    fname="${basefname// /}"
	$pandoc --lua-filter prepare_post.lua "$f" -o "$fname".html \
    	--extract-media="media-$fname" --metadata title="$title" --metadata author="$author";
    links="${links} * [http://mpc.mit.edu/blog/$fname.html](http://mpc.mit.edu/blog/$fname.html)\n";
done;
echo -e "${links}" > links.md;
$pandoc -s -c ../assets/css/blog.css links.md -o links.html;