###
# Page options, layouts, aliases and proxies
###

# Global site settings (not shown here)
set :site_url, "http://sivetur.guayo.me/"

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

helpers do

  def pages_by_category(category)
    sitemap.resources.select do |resource|
      resource.data.category == category
    end.sort_by { |resource| resource.data.destino }
  end

  # Returns all pages under a certain directory.
  def sub_pages(dir)
    sitemap.resources.select do |resource|
      resource.path.start_with?(dir) && resource.path.split("/").last != 'index.html'
    end
  end

  def nav_active(path)
    current_page.path == path ? {:class => "type-1 active"} : {:class => "type-1"}
  end

  def dato_image_path(path)
    "http://dato-images.imgix.net" + path
    #'/images/test' + path
  end

end

activate :dato,
  domain: 'http://rough-snowflake-5071.admin.datocms.com/',
  token: 'dce7cfa980e218f6d5bf337a50ae1470bdb9f717b9cab2c675',
  base_url: 'https://sivetur.netlify.com/'

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#page "paquetes/*", :layout => :paquete

# General configuration
dato.paquetes.each do |paquete|
  proxy "/paquetes/#{paquete.destino.code}/#{paquete.slug}.html", "/paquetes/template.html", :locals => { :paquete => paquete }, :ignore => true
end

dato.circuitos.each do |circuito|
  proxy "/circuitos/#{circuito.slug}.html", "/circuitos/template.html", :locals => { :circuito => circuito }, :ignore => true
end

##index files for destino folders
destinos = dato.paquetes.collect{ |e| e.destino }.uniq
destinos_circuitos = dato.circuitos.collect{ |e| e.destinos }.flatten.uniq

destinos.each do |destino|
  proxy "/paquetes/#{destino.code}.html", "/paquetes/template-destinos.html", :locals => { :destino => destino }, :ignore => true
end

destinos_circuitos.each do |destino|
  proxy "/circuirtos/#{destino.code}.html", "/circuitos/template-destinos.html", :locals => { :destino => destino }, :ignore => true
end

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload

  config[:images_path] = 'source/images/'

end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  set :build_dir, 'public'
  activate :relative_assets
  set :site_url, "/sivetur"
  #set :http_prefix, '/sivetur'
  config[:images_path] = 'images/'
end
