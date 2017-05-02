module InteractiveReplacer
  class Replace
    def initialize(search=nil)
      @results = search.results
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

    def replace_in_file_interactive(file_path, before, after='')
      file_text = File.read(file_path)
      # puts gets, file_path, before, after
      @results.each do |result|
        puts result[:preview]
        print 'Replace [y,n,q,a,d,/,j,J,g,e,?]? '
        cmd = gets.chomp
        case cmd
        when 'y'
          puts result
          result[:should_replace] = true
          # replace_one_word(file_text, result[:offset], before, after)
          # 文字列を特定位置で分割して配列にしたい
          # first_text = file_text.slice(0..(result[:offset] - 1))
          # last_text = file_text.slice(result[:offset]..file_text.size)
          # last_text.sub(before, after)
          # replaced_text = first_text + last_text
          # p first_text, last_text
          # File.write(file_path, replaced_text)
          # ２回めのreplaceで1回目のがなかったことになってしまう
        end
      end
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

    # def replace_one_word(text, offset, before, after='')
    #   text
    # end

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
