require 'optparse'

module InteractiveReplacer
  class CLI
    def self.execute(stdout, arguments = [])
      options = {}
      opt = OptionParser.new do |opt|
        opt.on('--interactive') { |v| options[:interactive] = v }
        opt.on('--directory VAL') { |v| options[:directory] = v }
        opt.on('--file VAL') { |v| options[:file] = v }
        opt.on('-m VAL') { |v| options[:method] = v }

        opt.parse!(ARGV)
      end

      stdout.print opt.help
    end
  end
end
