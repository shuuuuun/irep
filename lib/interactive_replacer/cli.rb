require 'optparse'

module InteractiveReplacer
  class CLI
    def self.execute(stdout, arguments = [])
      options = {}
      opt = OptionParser.new do |opt|
        opt.on('--interactive') { |v| options[:interactive] = v }
        opt.on('--directory VAL') { |v| options[:directory] = v }
        opt.on('--file VAL') { |v| options[:file] = v }
        opt.on('--ignore-case') { |v| options[:ignore_case] = true }
        opt.on('--count') { |v| options[:count] = true }
        opt.on('--files-without-matches') { |v| options[:files_without_matches] = true }
        opt.on('--literal') { |v| options[:literal] = true }
        opt.on('--regexp') { |v| options[:regexp] = true }
        opt.on('--smart-case') { |v| options[:smart_case] = true }
        opt.on('--directory') { |v| options[:directory] = true }
        opt.on('--file') { |v| options[:file] = true }
        opt.on('--show-hidden-files') { |v| options[:show_hidden_files] = true }
        opt.on('--dry-run') { |v| options[:dry_run] = true }

        opt.parse!(ARGV)
      end

      stdout.print opt.help
    end
  end
end
