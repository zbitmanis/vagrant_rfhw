require 'resolv'
 
Puppet::Functions.create_function(:'zbhelper::ns_resolve') do
  dispatch :nresolve do
    param 'String', :hostname
  end

  def nresolve(hostname)
    return Resolv.new.getaddress(hostname)
  end
end
