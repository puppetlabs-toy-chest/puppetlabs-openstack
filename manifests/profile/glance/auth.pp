# The profile to set up the endpoints, auth, and database for Glance
class havana::profile::glance::auth {
  havana::resources::controller { 'glance': }
  havana::resources::database { 'glance': }

  class  { '::glance::keystone::auth':
    password         => hiera('havana::glance::password'),
    public_address   => hiera('havana::storage::address::api'),
    admin_address    => hiera('havana::storage::address::management'),
    internal_address => hiera('havana::storage::address::management'),
    region           => hiera('havana::region'),
  }
}
