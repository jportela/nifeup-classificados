require 'rubygems'
require 'net/ldap'

class Ldap

  # SIFEUP Ldap method listing
  # Ldap.auth('ei04027', 'password-for-ei04027')
  # returns nil if the pair username/password is invalid,
  # and a hash of ldap attributes otherwise.

  # Ldap.attributes('ei04027')
  # returns nil if the username is invalid, and a hash
  # of public ldap attributes otherwise.

  # LDAP server values
  @@Host = "192.168.50.163"
  @@Treebase = "ou=users,dc=fe,dc=up,dc=pt"
  @@CourseTreebase = "ou=funcionarios,ou=staff,ou=users,dc=fe,dc=up,dc=pt"

  ## set to false to use an unsecure connection
  @@Secure = true

  def self.properties
    props = @@Secure ? { :port => 636, :encryption => :simple_tls} : {}
    props.merge :host => @@Host, :base => @@Treebase
  end

  def self.auth username, password
    ldap = Net::LDAP.new self.properties

    # do the magic search
    result = Ldap.attributes username, ldap
    return nil if result.nil?

    # now, lets validate the thing.
    ldap.auth result.dn, password
    return nil if [nil, ""].include?(password) or not ldap.bind

    # return the array of attributes
    a = Hash.new
    result.each { |key, value| a[key] = "#{value}" }
    return a
  end

  def self.attributes username, ldap = nil
    # validate the username
    return nil unless valid_username? username

    ldap = Net::LDAP.new self.properties

    # search for the username's DN for validation
    filter = Net::LDAP::Filter.eq("uid", username)

    results = ldap.search :base => @@Treebase, :filter => filter, :attributes => []
    return nil unless results and results.size == 1

    return results[0]
  end

  def self.valid_username? username
    /^[a-zA-Z0-9]*$/ =~ username
  end

  def self.course uid
    ldap = Net::LDAP.new self.properties
    filter = Net::LDAP::Filter.eq("uid", uid)
    results = ldap.search :base => @@CourseTreebase, :filter => filter, :attributes => []

    return nil if results.size != 1
    return results[0]
  end
end
