# Class: kerberos::params
#
# This class manages shared prameters and variables for the kerberos module
#
# [Remember: No empty lines between comments and class definition]
class kerberos::params {

# Common values
  $default_realm = 'LOCAL'
  $krb4_config   = '/etc/krb.conf'
  $krb4_realms   = '/etc/krb.realms'

# OS specific values
  case $::osfamily {
    'Debian': {
      $package     = 'krb5-user'
      $config_file   = '/etc/krb5.conf'
    }
    'RedHat': {
      $package     = [
        'krb5-libs',
        'krb5-workstation'
      ]
      $config_file   = '/etc/krb5.conf'
    }
    'Solaris': {
      $package = [
        'SUNWkrbr',
        'SUNWkrbu',
      ]
      $config_file   = '/etc/krb5/krb5.conf'
    }
    default:{
      fail("The kerberos Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}

