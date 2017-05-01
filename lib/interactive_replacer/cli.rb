require 'optparse'

module InteractiveReplacer
  class CLI
    def self.execute(stdout, argv = [])
      # puts "argv: #{argv}"
      opts, args = parse_options argv
      # stdout.print op.help
      puts "opts: #{opts}"
      puts "args: #{args}"
    end

    def self.parse_options(argv = [])
      options = {}

      op = OptionParser.new
      op.on('--interactive') { |v| options[:interactive] = v }
      op.on('--directory VAL') { |v| options[:directory] = v }
      op.on('--file VAL') { |v| options[:file] = v }
      op.on('--ignore-case') { |v| options[:ignore_case] = true }
      op.on('--count') { |v| options[:count] = true }
      op.on('--files-without-matches') { |v| options[:files_without_matches] = true }
      op.on('--literal') { |v| options[:literal] = true }
      op.on('--regexp') { |v| options[:regexp] = true }
      op.on('--smart-case') { |v| options[:smart_case] = true }
      op.on('--show-hidden-files') { |v| options[:show_hidden_files] = true }
      op.on('--dry-run') { |v| options[:dry_run] = true }

      begin
        # op.parse!(argv)
        arguments = op.parse(argv)
      rescue OptionParser::InvalidOption => e
        # usage e.message
        puts "error: #{e.message}"
      end

      [options, arguments]
    end
  end
end
