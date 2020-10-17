# MIT Music Production Collaborative

1. Test your changes locally
2. Commit changes to this repository `https://github.com/richardliutl/mpc.git`
3. Run `update.sh` to make http://mpc.mit.edu/ up-to-date with this repo.

```bash
echo MIT username:
read user
ssh -t $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    bash -l
'
```

## TODO
Pipeline for repo (travis-ci?)
* High
  * Figure out MIT hosting
  * Contact form
  * Mailing list signup
  * EP (tbd. soundcloud/spotify embed)
  * config file (webmoira link, mpc dir)
* Low
  * Exec page (headshots, socials embeds)


## Notes

To set this up (only needs to be done once at repository creation), associate the repo and the website directory this way:

```bash
cd  /mit/mpc/web_scripts/
svn checkout https://github.com/richardliutl/mpc/trunk/site
```