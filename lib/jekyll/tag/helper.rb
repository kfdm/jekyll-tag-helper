require "jekyll/tag/helper/version"

module Jekyll
  module Commands
    class Tags < Command
      class << self
        # Create the Mercenary command for the Jekyll CLI for this Command
        def init_with_program(prog)
          prog.command(:tags) do |c|
            c.syntax      "tags [options]"
            c.description "Update tags"

            add_build_options(c)
            
            c.action do |_, options|
              options = configuration_from_options(options)
              site = Jekyll::Site.new(options)
              site.read

              tag_dir = site.collections["tag_index"].collection_dir
              tag_files = Dir.entries(tag_dir)

              site.tags.keys.each do |tag|
                tag = tag.downcase
                fn = tag + ".md"

                if ! tag_files.include? fn
                  puts "Creating Tag #{tag}"
                  File.open(File.join(tag_dir, fn), "w") do |f|
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
end
