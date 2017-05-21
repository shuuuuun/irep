module InteractiveReplacer
  class Replace
    def initialize(search=nil)
      @results = search ? search.results : []
      @delimiter = "\n"
    end

    def replace_all(path, before, after='')
    end

    def replace_directory(path, before, after='')
      target_directory_paths(path).each do |dir_path|
        File.rename dir_path, dir_path.gsub(before, after)
      end
    end

    def replace_filename(path, before, after='')
      target_file_paths(path).each do |file_path|
        File.rename file_path, file_path.gsub(before, after)
      end
    end

    def replace_in_file_recursive(path, before, after='')
      target_file_paths(path).each do |file_path|
        replace_in_file(file_path, before, after)
      end
    end

    def replace_in_file(file_path, before, after='')
      txt = File.read(file_path).gsub(before, after)
      File.write(file_path, txt)
    end

    def replace_in_file_recursive_interactive(path, before, after='')
      target_file_paths(path).each do |file_path|
        replace_in_file_interactive(file_path, before, after)
      end
    end

    def replace_in_file_interactive(file_path, before, after='')
      file_text = File.read(file_path)
      # puts gets, file_path, before, after
      @results.each do |result|
        flag = true
        while flag
          puts result[:path]
          puts result[:preview]
          # print 'Replace [y,n,q,a,d,/,j,J,g,e,?]? '
          print 'Replace [y,n,q]? '
          cmd = STDIN.gets.chomp
          case cmd.downcase
          when 'y'
            result[:should_replace] = true
            flag = false
          when 'n'
            flag = false
          when 'q'
            flag = false
            return
          end
        end
      end
      # 文字列を特定位置で分割して配列にしたい
      replaced_text = file_text.split(before).map.with_index do |text, index|
        result = @results[index]
        if !result
          text
        elsif result.fetch(:should_replace, nil)
          text + after
        else
          text + before
        end
      end.join('')
      File.write(file_path, replaced_text)
    end

    private

    def target_file_paths(path)
      paths = Dir.glob "#{path}/**/*"
      paths.reject { |path| File.directory?(path) }
    end

    def target_directory_paths(path)
      paths = Dir.glob "#{path}/**/*"
      paths.select { |path| File.directory?(path) }
    end
  end
end
