module InteractiveReplacer
  class Interface
    def initialize(cases: [], message:)
      @cases = cases
      @message = message
    end

    def listen(opts = {})
      flag = true
      while flag
        puts opts[:path]
        puts opts[:preview]
        # print 'Replace [y,n,q,a,d,/,j,J,g,e,?]? '
        print "#{@message} [#{@cases.map {|c| c[:cmd]}.join(',')}]? "
        cmd = STDIN.gets.chomp
        match_case = @cases.select {|c| c[:cmd] == cmd.downcase }.first
        if match_case
          match_case[:func].call(*opts[:proc_args]) if match_case[:func]
          flag = false
        end
      end
    end
  end
end
