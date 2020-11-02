cd "$(dirname "$0")"
pandoc="$(pwd)"/../../tools/bin/pandoc
unzip -o \*.zip;
links="Hi MPC!\n\nOn behalf of the exec board, we are super excited to announce the start of our club's very own Newsletter. This idea began with the goal of finding ways to engage and connect with the community remotely, as we continue to adapt to the challenges of online learning. For our first issue, we've put together a fun variety of articles. Some of which showcase student work, while others focus on exploring music at large, including a spotify playlist curated by exec. The articles have all been uploaded to our newly remodeled website. Below is a list of embedded links to the respective articles. We hope you enjoy this small taste of what the community has been up to so far this semester!\n\n"
for f in formatted\ for\ website/*.docx;
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
echo -e "${links}\nAs we continue to build on this new venture, the structure of future newsletters, as well as our website, are still works in progress. If you are interested in contributing, especially in the form writing any music-related content for future issues, let us know at mit-mpc-exec@mit.edu. If you have any feedback, comments, questions, suggestions etc, we would love to hear them as well.\n\nHave a great week!\n\n\- MPC exec"\
    > links.md;
$pandoc --lua-filter prepare_post.lua links.md -o NovemberNewsletter.html --metadata title="November Newsletter" --metadata header="links";


	# $pandoc --lua-filter prepare_post.lua "$f" -o "$fname".html \
    	# --extract-media="media-$fname" --metadata title="$title" --metadata author="$author";