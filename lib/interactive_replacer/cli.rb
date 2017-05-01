require 'optparse'

module InteractiveReplacer
  class CLI
    def self.execute(stdout, argv = [])
      # puts "argv: #{argv}"
      opts, args = parse_options argv
      # stdout.print parser.help
      puts "opts: #{opts}"
      puts "args: #{args}"
    end

    def self.parse_options(argv = [])
      options = {}

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
