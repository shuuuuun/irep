require 'optparse'
require 'irep/version'
require 'irep/search'
require 'irep/replace'
require 'irep/interface'

module Irep
  class CLI
    def self.execute(stdout, argv = [])
      opts, args = parse_options argv
      # TODO: implement log level
      # Interface.debug "argv: #{argv}"
      # Interface.debug "opts: #{opts}"
      # Interface.debug "args: #{args}"

      search_text = args[0]
      replace_text = args[1]
      unless search_text && !search_text.empty?
        display_error 'invalid args.'
      end

      search = Search.new path: opts[:path], search_text: search_text
      search.find_directory
      search.find_filename
      search.find_in_file_recursive

      unless opts[:replace]
        search.show_results
        exit
      end
      Replace.replace_interactively search.results, search_text, replace_text
    end

    private

    def self.parse_options(argv = [])
      options = {
        path: '.',
        replace: true
      }

      parser.version = Irep::VERSION

      parser.on('--[no-]replace') { |v| options[:replace] = v }
      parser.on('--path VAL') { |v| options[:path] = v }
      # parser.on('--only-search') { |v| options[:replace] = false }
      # parser.on('--search') { |v| options[:replace] = false }
      # parser.on('--interactive') { |v| options[:interactive] = v }
      # parser.on('--directory VAL') { |v| options[:directory] = v }
      # parser.on('--file VAL') { |v| options[:file] = v }
      # parser.on('--count') { |v| options[:count] = true }
      # parser.on('--files-without-matches') { |v| options[:files_without_matches] = true }
      # parser.on('--literal') { |v| options[:literal] = true }
      # parser.on('--regexp') { |v| options[:regexp] = true }
      # parser.on('--smart-case') { |v| options[:smart_case] = true }
      # parser.on('--ignore-case') { |v| options[:ignore_case] = true }
      # parser.on('--strict-case') { |v| options[:strict_case] = true }
      # parser.on('--show-hidden-files') { |v| options[:show_hidden_files] = true }
      # parser.on('--dry-run') { |v| options[:dry_run] = true }
      # parser.on('--verbose') { |v| options[:verbose] = true }
      # parser.on('--debug') { |v| options[:debug] = true }
      parser.on_tail('--version', 'Show version') do
        puts parser.version
        exit
      end
      parser.on_tail('-h', '--help', 'Show this message') do
        puts parser
        exit
      end

      begin
        # parser.parse!(argv)
        arguments = parser.parse(argv)
      rescue OptionParser::InvalidOption => e
        display_error e.message
      end

      [options, arguments]
    end

    def self.display_error(msg = nil)
      Interface.error "Error: #{msg}" if msg
      puts parser.help
      exit 1
    end

    def self.parser
      @@parser ||= OptionParser.new
    end
  end
end
