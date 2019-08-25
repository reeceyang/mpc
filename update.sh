echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    bash -l
'