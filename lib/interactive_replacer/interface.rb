module InteractiveReplacer
  class Interface
    def self.exec(opts = {})
      flag = true
      while flag
        puts opts[:path]
        puts opts[:preview]
        # print 'Replace [y,n,q,a,d,/,j,J,g,e,?]? '
        print "#{opts[:message]} [#{opts[:cases].map {|c| c[:cmd]}.join(',')}]? "
        cmd = STDIN.gets.chomp
        match_case = opts[:cases].select {|c| c[:cmd] == cmd.downcase }.first
        if match_case
          match_case[:func].call if match_case[:func]
          flag = false
        end
      end
    end
  end
end

# Interface.exec({
#   path: './simple.txt',
#   preview: 'aaa',
#   message: 'Replace',
#   cases: [{
#     cmd: 'y',
#     func: proc {}
#   }]
# })
