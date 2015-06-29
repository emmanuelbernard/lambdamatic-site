# dependencies for asciidoc support
require 'tilt'
require 'haml'
require 'asciidoctor'

# hack to add asciidoc support in HAML
# remove once haml_contrib has accepted the asciidoc registration patch
# :asciidoc
#   some block content
#
# :asciidoc
#   :doctype: inline
#   some inline content
#
if !Haml::Filters.constants.map(&:to_s).include?('AsciiDoc')
  Haml::Filters.register_tilt_filter 'AsciiDoc'
  Haml::Filters::AsciiDoc.options[:safe] = :safe
  Haml::Filters::AsciiDoc.options[:attributes] ||= {}
  Haml::Filters::AsciiDoc.options[:attributes]['notitle!'] = ''
  # copy attributes from site.yml
  attributes = site.asciidoctor[:attributes].each do |key, value|
  Haml::Filters::AsciiDoc.options[:attributes][key] = value
  end
end

# Proper pipeline
Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::Posts.new('/news', :posts)
  extension Awestruct::Extensions::Paginator.new( :posts, '/news/index', :per_page=>10 )
  extension Awestruct::Extensions::Indexifier.new
  # Indexifier *must* come before Atomizer
  # extension Awestruct::Extensions::Atomizer.new :posts, '/feed.atom'
  helper Awestruct::Extensions::GoogleAnalytics
end
