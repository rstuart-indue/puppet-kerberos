require 'spec_helper'
describe 'kerberos', type: :class do
  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        concat_basedir: '/dne',
      }
    end

    describe 'with no parameters' do
      it {
        is_expected.to contain_package('krb5-user').with_ensure('installed')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'         => 'present',
          'path'           => '/etc/krb5.conf',
          'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
          'ensure_newline' => false,
          'owner'          => 'root',
          'group'          => 'root',
          'mode'           => '0644',
          'require'        => 'Package[krb5-user]',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with(
          'target' => 'krb5_config',
          'order'  => '00AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^\[libdefaults\]$},
        )
      }
      xit {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^# The following krb5.conf variables are only for MIT Kerberos.$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+default_realm[[:space:]]+= LOCAL$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+krb4_config[[:space:]]+= /etc/krb.conf$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+krb4_realms[[:space:]]+= /etc/krb.realms$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+kdc_timesync[[:space:]]+= 1$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+ccache_type[[:space:]]+= 4$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+forwardable[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+proxiable[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+rdns[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_logging').with(
          'target' => 'krb5_config',
          'order'  => '02AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_logging').with_content(
          %r{^\[logging\]$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with(
          'target' => 'krb5_config',
          'order'  => '03AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^\[login\]$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').without_content(
          %r{^[[:space:]]+aklog_path[[:space:]]+= .*$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb4_convert[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb4_get_tickets[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb5_get_tickets[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb_run_aklog[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_realms').with(
          'target' => 'krb5_config',
          'order'  => '04AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_realms').with_content(
          %r{^\[realms\]$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_domain_realm').with(
          'target' => 'krb5_config',
          'order'  => '05AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_domain_realm').with_content(
          %r{^\[domain_realm\]$},
        )
      }
    end
    describe 'when ensure is absent' do
      let :params do
        {
          ensure: 'absent',
        }
      end

      it {
        is_expected.to contain_package('krb5-user').with_ensure('absent')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'  => 'absent',
          'require' => 'Package[krb5-user]',
        )
      }
    end
    describe 'when ensure is latest' do
      let :params do
        {
          ensure: 'latest',
        }
      end

      it {
        is_expected.to contain_package('krb5-user').with_ensure('latest')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'  => 'present',
          'require' => 'Package[krb5-user]',
        )
      }
    end
    describe 'when customising the installation' do
      let :params do
        {
          package: 'magic-krb5',
          config_file: '/this/is/a/bad.idea',
        }
      end

      it {
        is_expected.to contain_package('magic-krb5')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'path'    => '/this/is/a/bad.idea',
          'require' => 'Package[magic-krb5]',
        )
      }
    end
    describe 'when customising the libdefaults settings' do
      let :params do
        {
          default_realm: 'example.org',
          krb4_config: '/this/is/a/bad.idea',
          krb4_realms: '/this/is/a/bad.idea.too',
          kdc_timesync: '66',
          ccache_type: '1',
          forwardable: true,
          proxiable: true,
          rdns: false,
        }
      end

      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+default_realm[[:space:]]+= example.org$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+krb4_config[[:space:]]+= /this/is/a/bad.idea$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+krb4_realms[[:space:]]+= /this/is/a/bad.idea.too$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+kdc_timesync[[:space:]]+= 66$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+ccache_type[[:space:]]+= 1$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+forwardable[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+proxiable[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+rdns[[:space:]]+= false$},
        )
      }
    end
    describe 'when customising the login settings' do
      let :params do
        {
          krb4_convert: true,
          krb4_get_tickets: true,
          krb5_get_tickets: false,
          krb_run_aklog: true,
          aklog_path: '/path/to/bin/aklog.sh',
        }
      end

      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+aklog_path[[:space:]]+= /path/to/bin/aklog.sh$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb4_convert[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb4_get_tickets[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb5_get_tickets[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb_run_aklog[[:space:]]+= true$},
        )
      }
    end
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        concat_basedir: '/dne',
      }
    end

    describe 'with no parameters' do
      it {
        is_expected.to contain_package('krb5-libs').with_ensure('installed')
      }
      it {
        is_expected.to contain_package('krb5-workstation').with_ensure('installed')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'         => 'present',
          'path'           => '/etc/krb5.conf',
          'warn'           => '# This file is managed by Puppet, changes may be overwritten.',
          'ensure_newline' => false,
          'owner'          => 'root',
          'group'          => 'root',
          'mode'           => '0644',
          'require'        => ['Package[krb5-libs]', 'Package[krb5-workstation]'],
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with(
          'target' => 'krb5_config',
          'order'  => '00AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^\[libdefaults\]$},
        )
      }
      xit {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^# The following krb5.conf variables are only for MIT Kerberos.$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+default_realm[[:space:]]+= LOCAL$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+krb4_config[[:space:]]+= /etc/krb.conf$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+krb4_realms[[:space:]]+= /etc/krb.realms$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+kdc_timesync[[:space:]]+= 1$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+ccache_type[[:space:]]+= 4$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+forwardable[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+proxiable[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{[[:space:]]+rdns[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_logging').with(
          'target' => 'krb5_config',
          'order'  => '02AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_logging').with_content(
          %r{^\[logging\]$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with(
          'target' => 'krb5_config',
          'order'  => '03AAA',
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^\[login\]$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').without_content(
          %r{[[:space:]]+aklog_path[[:space:]]+= .*$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb4_convert[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb4_get_tickets[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb5_get_tickets[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{[[:space:]]+krb_run_aklog[[:space:]]+= false$},
        )
      }
    end
    describe 'when ensure is absent' do
      let :params do
        {
          ensure: 'absent',
        }
      end

      it {
        is_expected.to contain_package('krb5-libs').with_ensure('absent')
      }
      it {
        is_expected.to contain_package('krb5-workstation').with_ensure('absent')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'  => 'absent',
          'require' => ['Package[krb5-libs]', 'Package[krb5-workstation]'],
        )
      }
    end
    describe 'when ensure is latest' do
      let :params do
        {
          ensure: 'latest',
        }
      end

      it {
        is_expected.to contain_package('krb5-libs').with_ensure('latest')
      }
      it {
        is_expected.to contain_package('krb5-workstation').with_ensure('latest')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'ensure'  => 'present',
          'require' => ['Package[krb5-libs]', 'Package[krb5-workstation]'],
        )
      }
    end
    describe 'when customising the installation' do
      let :params do
        {
          package: 'magic-krb5',
          config_file: '/this/is/a/bad.idea',
        }
      end

      it {
        is_expected.to contain_package('magic-krb5')
      }
      it {
        is_expected.to contain_concat('krb5_config').with(
          'path'    => '/this/is/a/bad.idea',
          'require' => 'Package[magic-krb5]',
        )
      }
    end
    describe 'when customising the libdefaults settings' do
      let :params do
        {
          default_realm: 'example.org',
          krb4_config: '/this/is/a/bad.idea',
          krb4_realms: '/this/is/a/bad.idea.too',
          kdc_timesync: '66',
          ccache_type: '1',
          forwardable: true,
          proxiable: true,
          rdns: false,
        }
      end

      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+default_realm[[:space:]]+= example.org$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+krb4_config[[:space:]]+= /this/is/a/bad.idea$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+krb4_realms[[:space:]]+= /this/is/a/bad.idea.too$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+kdc_timesync[[:space:]]+= 66$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+ccache_type[[:space:]]+= 1$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+forwardable[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+proxiable[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_libdefaults').with_content(
          %r{^[[:space:]]+rdns[[:space:]]+= false$},
        )
      }
    end
    describe 'when customising the login settings' do
      let :params do
        {
          krb4_convert: true,
          krb4_get_tickets: true,
          krb5_get_tickets: false,
          krb_run_aklog: true,
          aklog_path: '/path/to/bin/aklog.sh',
        }
      end

      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+aklog_path[[:space:]]+= /path/to/bin/aklog.sh$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb4_convert[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb4_get_tickets[[:space:]]+= true$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb5_get_tickets[[:space:]]+= false$},
        )
      }
      it {
        is_expected.to contain_concat__fragment('krb5_login').with_content(
          %r{^[[:space:]]+krb_run_aklog[[:space:]]+= true$},
        )
      }
    end
  end
end
