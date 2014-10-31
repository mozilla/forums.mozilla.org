#XXX: Duplicated
%define 	theme_version 	121491
%define		phpbb_version	3.0.12
%define		auth_version	134025

Name:		forums.mozilla.org
Version:	%{phpbb_version}
Release:	1%{?dist}.%{theme_version}.%{auth_version}
Summary:	test

Group:		Websites
License:	MPL
URL:		foo
Source0:	phpbb-release-%{phpbb_version}.tar.gz
Source1:	ca_gen2-%{theme_version}.tar.gz
Source2:	auth_amo-%{auth_version}.php

BuildRequires:	rsync
Requires:	php

%description


%prep
%setup -q -n phpbb-release-3.0.12
%setup -q -T -D -a 1 -n phpbb-release-3.0.12

%build

%install
%{__mkdir_p} %{buildroot}%{_localstatedir}/www/%{name}
rsync -av ./phpBB/ %{buildroot}%{_localstatedir}/www/%{name}/
rsync -av ./ca_gen2-%{theme_version}/ %{buildroot}%{_localstatedir}/www/%{name}/styles/ca_gen2/
cp %{SOURCE2} %{buildroot}%{_localstatedir}/www/%{name}/includes/auth/auth_amo.php
touch %{buildroot}%{_localstatedir}/www/%{name}/config.php
mkdir %{buildroot}/etc
ln -s %{_localstatedir}/www/%{name}/config.php %{buildroot}/etc/forums.mozilla.org.conf

%files
%doc README.md
%{_localstatedir}/www/%{name}
%config /etc/forums.mozilla.org.conf

%changelog

