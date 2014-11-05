#XXX: Duplicated
%define 	theme_version 	%%THEME%%
%define		phpbb_version	%%PHPBB%%
%define		auth_version	%%AUTH%%
%define		build_release	%%RELEASE%%

Name:		forums.mozilla.org
Version:	%{phpbb_version}
Release:	%{?rpm_jenkins_job}theme.svn%{theme_version}.auth.svn%{auth_version}.%{build_release}
Summary:	test

Group:		Websites
License:	MPL
URL:		https://forums.mozilla.org/
Source0:	phpbb-release-%{phpbb_version}.tar.gz
Source1:	ca_gen2-%{theme_version}.tar.gz
Source2:	auth_amo-%{auth_version}.php
Source3:	config.php
Source4:	localconfig.php
Patch0:		phpbb-3.0.12.localconfig.patch
BuildArch:	noarch

BuildRequires:	rsync
Requires:	php, php-gd, php-mbstring

%description


%prep
%setup -q -n phpbb-release-%{phpbb_version}
%setup -q -T -D -a 1 -n phpbb-release-%{phpbb_version}
%patch -P 0 -p1

%build
# THis should still be included, but outside of the docroot
rm -rf phpBB/install

%install
%{__mkdir_p} %{buildroot}%{_localstatedir}/www/%{name}
rsync -av ./phpBB/ %{buildroot}%{_localstatedir}/www/%{name}/
rsync -av ./ca_gen2-%{theme_version}/ %{buildroot}%{_localstatedir}/www/%{name}/styles/ca_gen2/
cp %{SOURCE2} %{buildroot}%{_localstatedir}/www/%{name}/includes/auth/auth_amo.php
cp %{SOURCE3} %{buildroot}%{_localstatedir}/www/%{name}/config.php
cp %{SOURCE4} %{buildroot}%{_localstatedir}/www/%{name}/localconfig.php
mkdir %{buildroot}/etc
ln -s %{_localstatedir}/www/%{name}/localconfig.php %{buildroot}/etc/forums.mozilla.org.conf

%files
%doc README.md
%{_localstatedir}/www/%{name}
%attr(0750, apache, apache) %{_localstatedir}/www/%{name}/cache
%attr(0750, apache, apache) %{_localstatedir}/www/%{name}/files
%attr(0750, apache, apache) %{_localstatedir}/www/%{name}/store
%attr(0750, apache, apache) %{_localstatedir}/www/%{name}/images/avatars/upload
%config /etc/forums.mozilla.org.conf

%changelog

