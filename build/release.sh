#!/usr/bin/env bash

BUILD_DIR=`dirname $0`
cd $BUILD_DIR/..

source ./package.rc

echo "Getting phpbb-$PHPBB"
 wget -q -c -O phpbb-release-$PHPBB.tar.gz https://github.com/phpbb/phpbb/archive/release-$PHPBB.tar.gz

echo "svn exporting auth_amo r$AUTH"
 svn -q export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/auth_amo.php -r $AUTH auth_amo-$AUTH.php

echo "svn exporting ca_gen2 theme r$THEME"
 svn -q export --force http://svn.mozilla.org/addons/trunk/site/vendors/phpbb/ca_gen2 ca_gen2-$THEME -r $THEME
 tar zcf ca_gen2-$THEME.tar.gz ca_gen2-$THEME
 rm -rf ca_gen2-$THEME

echo "generating spec file"
cat build/forums.mozilla.org.spec | \
  sed -e "s/%%PHPBB%%/$PHPBB/g" | \
  sed -e "s/%%THEME%%/$THEME/g" | \
  sed -e "s/%%RELEASE%%/$RELEASE/g" | \
  sed -e "s/%%AUTH%%/$AUTH/g" > \
  forums.mozilla.org.spec

tar zcf forums.mozilla.org.tar.gz forums.mozilla.org.spec ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php

echo "Building RPM with $*"
rpmbuild --quiet "$*" -ta forums.mozilla.org.tar.gz 

rm ca_gen2-$THEME.tar.gz phpbb-release-$PHPBB.tar.gz auth_amo-$AUTH.php forums.mozilla.org.tar.gz forums.mozilla.org.spec

mv $HOME/rpmbuild/SRPMS/$NAME*.rpm . 
mv $HOME/rpmbuild/RPMS/noarch/$NAME*.rpm .


