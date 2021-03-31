cd "$(dirname "$0")"
pandoc="$(pwd)"/../../tools/bin/pandoc
# unzip -o \*.zip; # Already unzipped in blogger.sh
links="Hi MPC!\n\nWelcome to our March newsletter. For this issue, we’ve answered a lot of the awesome questions submitted to us by some of you earlier this month. If you’re seeking advice on a particular topic, or just have any questions that you’d like to see answered in a future newsletter, ask them anonymously [here](https://docs.google.com/forms/d/e/1FAIpQLScn6SljlVo-juUKYFvcssG8-8tXYiLI2yhE1M-38cCN2hAK8w/viewform), or email us at [mit-mpc-exec@mit.edu](mailto:mit-mpc-exec@mit.edu).\nAnother exciting development in this month’s issue is the first of our new series of video tutorials on the MPC youtube channel! Below is a list of embedded links to this month’s content:\n\n * [VIDEO TUTORIAL: DAW Basics](https://www.youtube.com/watch?v=hCe1qO9OVk8) by Willy Wu\n"
for f in March\ 2021/*.docx;
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
echo -e "${links}\nYou can also check out our previous issues [here](http://mpc.mit.edu/news.html)!\nAs we continue to build on this new venture, the structure of future newsletters, as well as our website, are still works in progress. If you are interested in contributing, especially in the form of writing any music-related content for future issues, let us know at [mit-mpc-exec@mit.edu](mailto:mit-mpc-exec@mit.edu). If you have any feedback, comments, [questions](https://docs.google.com/forms/d/e/1FAIpQLScn6SljlVo-juUKYFvcssG8-8tXYiLI2yhE1M-38cCN2hAK8w/viewform), suggestions etc, we would love to hear them as well!\n\nThanks for reading, and have a great week.\n\n\- MPC exec"\
    > links.md;
$pandoc --lua-filter prepare_post.lua links.md -o MarchNewsletter.html --metadata title="March Newsletter" --metadata header="links";


	# $pandoc --lua-filter prepare_post.lua "$f" -o "$fname".html \
    	# --extract-media="media-$fname" --metadata title="$title" --metadata author="$author";