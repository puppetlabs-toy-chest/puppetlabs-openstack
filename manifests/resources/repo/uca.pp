# Ubuntu Cloud Archive repo
class openstack::resources::repo::uca(
  $release = 'juno',
  $repo    = 'updates'
) {
  if ($::operatingsystem == 'Ubuntu') {
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
