echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts;
    mkdir -p tools;
    wget -qO- https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-linux-amd64.tar.gz | tar xvzf - --strip-components 1 -C ./tools/;
    bash -l
'

# Use tar url from https://github.com/jgm/pandoc/releases/latest