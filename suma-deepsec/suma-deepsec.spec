Name:           suma-deepsec-formula
Version:        0.1
Release:        1%{?dist}
Summary:        Deep Security Formula for SUSE Manager
Group:          System/Packages
License:        Apache-2.0
Url:            https://github.com/s-sys/suma_formulas
Source0:        %{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch

# This would be better with a macro that just strips "_formula" from %{name}
%define fname suma-deepsec
%define fdir  %{_datadir}/salt-formulas

%description
Deep Security Formula for SUSE Manager. Sets up Deep Security on the system.

%prep
%setup -q -n suma-deepsec

%build

%install
mkdir -p %{buildroot}%{fdir}/states/%{fname}
mkdir -p %{buildroot}%{fdir}/metadata/%{fname}
cp -R states/* %{buildroot}%{fdir}/states/%{fname}
cp -R metadata/* %{buildroot}%{fdir}/metadata/%{fname}

%files
%defattr(-,root,root,-)
%if 0%{?sle_version} < 120300
%doc README.md LICENSE
%else
%doc README.md
%license LICENSE
%endif

%dir %attr(0755, root, salt) %{fdir}
%dir %attr(0755, root, salt) %{fdir}/states
%dir %attr(0755, root, salt) %{fdir}/metadata

%attr(0644, root, salt) %{fdir}/states/%{fname}
%attr(0644, root, salt) %{fdir}/metadata/%{fname}

%changelog
