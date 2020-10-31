mkdir -p tools;
wget -qO- https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-linux-amd64.tar.gz | tar xvzf - --strip-components 1 -C ./tools/;

# Use tar url from https://github.com/jgm/pandoc/releases/latest