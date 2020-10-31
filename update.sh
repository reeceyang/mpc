echo MIT username:
read user
ssh -Kt $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    /mit/mpc/web_scripts/site/blog/blogger.sh;
    bash -l
'