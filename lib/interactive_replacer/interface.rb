require 'rainbow'

module InteractiveReplacer
  class Interface
    def initialize(cases: [], message:)
      @cases = cases
      @message = message
    end

    def listen(opts = {})
      flag = true
      while flag
        puts "\n"
        puts "path: #{opts[:path]}"
        puts Rainbow("- #{opts[:preview]}").red if opts[:preview]
        puts Rainbow("+ #{opts[:result_preview]}").green if opts[:result_preview]
        # print 'Replace [y,n,q,a,d,/,j,J,g,e,?]? '
        print Rainbow("#{@message} [#{@cases.map {|c| c[:cmd]}.join(',')}]? ").bold.lightskyblue
        cmd = self.class.get_input
        match_case = @cases.select {|c| c[:cmd] == cmd.downcase }.first
        if match_case
          match_case[:func].call(*opts[:proc_args]) if match_case[:func]
          flag = false
        else
          msg = @cases.map { |c| "#{c[:cmd]} - #{c[:help]}" }.join("\n")
          puts Rainbow("#{msg}").bold.maroon
        end
      end
    end

    def self.get_input
      STDIN.gets.chomp
    end
  end
end
