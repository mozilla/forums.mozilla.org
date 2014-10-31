#!/usr/bin/env bash

PHPBB=3.0.12
THEME=121491
AUTH=134025

wget -O phpbb-release-$PHPBB.tar.gz https://github.com/phpbb/phpbb/archive/release-$PHPBB.tar.gz

svn export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/auth_amo.php -r $AUTH auth_amo-$AUTH.php

svn export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/ca_gen2 ca_gen2-$THEME -r $THEME
tar zcvf ca_gen2-$THEME.tar.gz ca_gen2-$THEME
rm -rf ca_gen2-$THEME

tar zcvf forums.mozilla.org.tar.gz build/*.spec ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php

rpmbuild -ta forums.mozilla.org.tar.gz

#rm ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php
#
