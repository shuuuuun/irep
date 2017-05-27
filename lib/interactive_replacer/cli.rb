require 'optparse'
require 'interactive_replacer/search'
require 'interactive_replacer/replace'

module InteractiveReplacer
  class CLI
    def self.execute(stdout, argv = [])
      # puts "argv: #{argv}"
      opts, args = parse_options argv
      # stdout.print parser.help
      puts "opts: #{opts}"
      puts "args: #{args}"

      # File.directory?(args[0])
      # puts('file or directory required.') && return unless opts[:file] or opts[:directory]
      # puts('invalid args.') && return unless args[0] or args[1]
      puts('invalid args.') && return unless args[0]

      search = InteractiveReplacer::Search.new
      # search.find_in_file(opts[:file], args[0])
      search.find_in_file_recursive(opts[:directory], args[0])

      unless opts[:replace]
        search.show_results
        return
      end
      replace = InteractiveReplacer::Replace.new search
      # replace.replace_in_file_interactive(opts[:file], args[0], args[1])
      replace.replace_in_file_recursive_interactive(opts[:directory], args[0], args[1])
      # replace.replace_filename('tmp', 'README', 'HOGE')
      # replace.replace_directory('tmp', 'db', 'hoge')
    end

    def self.parse_options(argv = [])
      options = {
        directory: '.',
        replace: true
      }

      parser.on('--[no-]replace') { |v| options[:replace] = v }
      parser.on('--only-search') { |v| options[:only_search] = true }
      parser.on('--interactive') { |v| options[:interactive] = v }
      parser.on('--directory VAL') { |v| options[:directory] = v }
      parser.on('--file VAL') { |v| options[:file] = v }
      parser.on('--ignore-case') { |v| options[:ignore_case] = true }
      parser.on('--count') { |v| options[:count] = true }
      parser.on('--files-without-matches') { |v| options[:files_without_matches] = true }
      parser.on('--literal') { |v| options[:literal] = true }
      parser.on('--regexp') { |v| options[:regexp] = true }
      parser.on('--smart-case') { |v| options[:smart_case] = true }
      parser.on('--show-hidden-files') { |v| options[:show_hidden_files] = true }
      parser.on('--dry-run') { |v| options[:dry_run] = true }

      begin
        # parser.parse!(argv)
        arguments = parser.parse(argv)
      rescue OptionParser::InvalidOption => e
        usage e.message
      end

      [options, arguments]
    end

    def self.usage(msg = nil)
      puts parser.help
      puts "error: #{msg}" if msg
      exit 1
    end

    def self.parser
      @@parser ||= OptionParser.new
    end
  end
end
