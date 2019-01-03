require 'jekyll/tag/helper/version'

module Jekyll
  module Commands
    class Tags < Command
      class << self
        # Create the Mercenary command for the Jekyll CLI for this Command
        def init_with_program(prog)
          prog.command(:tags) do |c|
            c.syntax      'tags [options]'
            c.description 'Update tags'

            c.option 'collection', '--collection TAG', 'Name of tag collection'

            c.action do |_, _options|
              # Initialize our Jekyll Site
              site = Jekyll::Site.new(configuration_from_options({}))
              site.read

              site.tags.keys.each do |tag|
                fn = File.join(site.collections['tag_index'].collection_dir, tag.downcase + '.md')

                # Skip if we already have an existing Tag
                next if File.exist? fn

                puts "Creating Tag #{tag}"
                File.open(fn, 'w') do |f|
                  f.write("---\n")
                  f.write("tag: #{tag}\n")
                  f.write("layout: tag\n")
                  f.write("---\n")
                end
              end
            end
          end
        end
      end
    end
  end
end
