require 'rainbow'

module Irep
  class Interface
    def initialize(cases: [], message:)
      @cases = cases
      @message = message
      @quit = false
    end

    def listen(opts = {})
      return if @quit
      listening = true
      while listening
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
          listening = false
        else
          msg = @cases.map { |c| "#{c[:cmd]} - #{c[:help]}" }.join("\n")
          puts Rainbow("#{msg}").bold.maroon
        end
      end
    end

    def quit
      @quit = true
    end

    def self.get_input
      STDIN.gets.chomp
    end

    def self.show_search_results(path:, line:, preview:)
      puts "\n"
      puts Rainbow("#{path}").lightgreen
      puts "#{Rainbow(line).darkgoldenrod}: #{preview}"
    end

    def self.error(text)
      puts Rainbow(text).red
    end

    def self.info(text)
      puts Rainbow(text).navajowhite
    end

    def self.debug(text)
      puts Rainbow(text).saddlebrown
    end
  end
end
