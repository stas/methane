require 'bacon'
require 'methane'

Dir.glob('test/**/*.rb').each do |file|
  load File.expand_path(file) unless file == __FILE__
end
