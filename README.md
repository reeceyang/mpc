# MIT Music Production Collaborative

1. Test your changes locally
2. Commit and push changes to this repository `https://github.com/richardliutl/mpc.git`
3. Run `update.sh` to make http://mpc.mit.edu/ up-to-date with this repo.

```bash
echo MIT username:
read user
ssh -Kt $user@athena.dialup.mit.edu '
    cd /mit/mpc/web_scripts/site;
    svn update;
    /mit/mpc/web_scripts/site/blog/blogger.sh;
    bash -l
'
```

## TODO
Pipeline for repo (travis-ci?)
* High
  * Contact form
  * EP (tbd. soundcloud/spotify embed)
  * config file (webmoira link, mpc dir)
* Low
  * Replace all python with lua filter
  * Exec page (headshots, socials embeds)
* Done
  * Figure out MIT hosting
  * Mailing list signup (manually)


## Notes

To set this up (only needs to be done once at repository creation), associate the repo and the website directory this way:

```bash
cd  /mit/mpc/web_scripts/
svn checkout https://github.com/richardliutl/mpc/trunk/site
```

To set up tooling (pandoc) run tools.sh

```bash
cd /mit/mpc/web_scripts;
mkdir -p tools;
wget -qO- https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-linux-amd64.tar.gz | tar xvzf - --strip-components 1 -C ./tools/;
bash -l
```