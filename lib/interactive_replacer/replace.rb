require 'interactive_replacer/interface'

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
      interface = Interface.new(message: 'Replace', cases: [{
        cmd: 'y',
        func: proc { |result|
          result[:should_replace] = true
        }
      }, {
        cmd: 'n'
      }, {
        cmd: 'q'
      }])
      @results.each do |result|
        interface.listen(
          path: result[:path],
          preview: result[:preview],
          proc_args: [result]
        )
      end
      # 文字列を特定位置で分割して配列にしたい
      # p file_text.split(before)
      # p file_text.partition(before)
      result_index = 0
      replaced_text = file_text.partition(before).map do |text|
        if text == before
          result = @results[result_index]
          result_index += 1
          if result.fetch(:should_replace, nil)
            after
          else
            text
          end
        else
          text
        end
      end.join('')
      # p replaced_text
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
