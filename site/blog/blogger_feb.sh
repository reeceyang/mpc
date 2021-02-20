cd "$(dirname "$0")"
pandoc="$(pwd)"/../../tools/bin/pandoc
# unzip -o \*.zip; # Already unzipped in blogger.sh
links="Hi MPC!\n\nThis is the second issue of our newsletter! Below is a list of embedded links to the respective articles.\n\n"
for f in February\ 2021/*.docx;
    do basefname=$(basename "$f" .docx);
    title=$(python3 blog.py lt -t "$basefname");
    author=$(python3 blog.py la -t "$basefname");
    echo $title " " $author;
    fname="${basefname// /}"
	$pandoc --lua-filter prepare_post.lua "$f" -o "$fname".md --extract-media="media-$fname";
	$pandoc --lua-filter prepare_post.lua "$fname".md -o "$fname".html \
    	--data-dir="media-$fname" --metadata title="$title" --metadata author="$author";
    links="${links} * [$title](http://mpc.mit.edu/blog/$fname.html) by $author\n";
done;
echo -e "${links}\nAs we continue to build on this new venture, the structure of future newsletters, as well as our website, are still works in progress. If you are interested in contributing, especially in the form of writing any music-related content for future issues, let us know at mit-mpc-exec@mit.edu. If you have any feedback, comments, questions, suggestions etc, we would love to hear them as well.\n\nHave a great week!\n\n\- MPC exec"\
    > links.md;
$pandoc --lua-filter prepare_post.lua links.md -o FebruaryNewsletter.html --metadata title="February Newsletter" --metadata header="links";


	# $pandoc --lua-filter prepare_post.lua "$f" -o "$fname".html \
    	# --extract-media="media-$fname" --metadata title="$title" --metadata author="$author";