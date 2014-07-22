# Ubuntu Cloud Archive repo
class openstack::resources::repo::uca(
  $release = 'icehouse',
  $repo    = 'updates'
) {
  if ($::operatingsystem == 'Ubuntu' and
      $::lsbdistdescription =~ /^.*12\.04.*LTS.*$/) {
    include apt::update

    apt::source { 'ubuntu-cloud-archive':
      location          => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
      release           => "${::lsbdistcodename}-${repo}/${release}",
      repos             => 'main',
      required_packages => 'ubuntu-cloud-keyring',
    }

    Exec['apt_update'] -> Package<||>
  }
}
