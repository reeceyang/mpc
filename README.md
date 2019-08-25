# MIT Music Production Collaborative

```bash
echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
cd /mit/mpc/web_scripts/site;
svn update;
bash -l
'
```

## Past setup

```bash
svn checkout https://github.com/richardliutl/mpc/trunk/site
```