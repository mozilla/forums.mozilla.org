#!/usr/bin/env bash

PHPBB=3.0.12
THEME=121491
AUTH=134025
RELEASE=2

wget -c -O phpbb-release-$PHPBB.tar.gz https://github.com/phpbb/phpbb/archive/release-$PHPBB.tar.gz

svn export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/auth_amo.php -r $AUTH auth_amo-$AUTH.php

svn export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/ca_gen2 ca_gen2-$THEME -r $THEME
tar zcvf ca_gen2-$THEME.tar.gz ca_gen2-$THEME
rm -rf ca_gen2-$THEME

cat build/forums.mozilla.org.spec | \
  sed -e "s/%%PHPBB%%/$PHPBB/g" | \
  sed -e "s/%%THEME%%/$THEME/g" | \
  sed -e "s/%%RELEASE%%/$RELEASE/g" | \
  sed -e "s/%%AUTH%%/$AUTH/g" > \
  forums.mozilla.org.spec

tar zcvf forums.mozilla.org.tar.gz forums.mozilla.org.spec ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php

rpmbuild -ta forums.mozilla.org.tar.gz

rm ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php forums.mozilla.org.tar.gz forums.mozilla.org.spec
