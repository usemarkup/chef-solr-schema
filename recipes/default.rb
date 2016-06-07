directory node['solr_schema']['path'] do
  owner node['solr_schema']['user']
  mode '0666'
  action :create
end

solr_resource_not_found = false
begin
  resources('ruby_block[solr]')
rescue Chef::Exceptions::ResourceNotFound
  solr_resource_not_found = true
end

node['solr_schema']['schema'].each do |name, schema|
  cookbook_file "#{node['solr_schema']['path']}/#{schema['file']}" do
    cookbook schema['cookbook']
    source schema['file']
    owner node['solr_schema']['user']
    mode '0666'
    notifies :reload, resources(:service => 'solr'), :delayed unless solr_resource_not_found
    action :create
  end
end
