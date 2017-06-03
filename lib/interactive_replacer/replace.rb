require 'interactive_replacer/interface'

module InteractiveReplacer
  class Replace
    def initialize(search=nil)
      @results = search ? search.results : []
      @delimiter = "\n"
    end

    def replace_by_search_results(search_results, replace_text)
      # TODO: replace_by_search_results
    end

    def replace_by_search_results_interactively(search_results, replace_text)
      listened_results = listen_if_replace(search_results)
      # binding.pry
      replace_in_file_by_results listened_results.select { |r| r[:type] == 'in_file' }, replace_text
    end

    def rename_path(path, before, after='')
      File.rename path, path.gsub(before, after)
    end

    def rename_path_interactively(path, before, after='')
      # puts path, before, after
      # File.rename path, path.gsub(before, after)
    end

    def replace_in_file(file_path, before, after='')
      txt = File.read(file_path).gsub(before, after)
      File.write(file_path, txt)
    end

    def replace_in_file_by_results(search_results, replace_text)
      grouped_results = search_results.group_by { |r| r[:path] }
      grouped_results.each do |path, results|
        file_text = File.read(path)
        # 文字列を特定位置で分割して配列にできたらいいかも?
        search_text = results[0][:search_text]
        result_index = 0
        replaced_text = file_text.partition(search_text).map do |text|
          if text == search_text
            result = results[result_index]
            result_index += 1
            if result.fetch(:should_replace, nil)
              replace_text
            else
              text
            end
          else
            text
          end
        end.join('')
        File.write(path, replaced_text)
      end
    end

    def replace_in_file_interactive(file_path, before, after='')
      file_text = File.read(file_path)
      results = listen_if_replace @results
      # 文字列を特定位置で分割して配列にしたい
      result_index = 0
      replaced_text = file_text.partition(before).map do |text|
        if text == before
          result = results[result_index]
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
      File.write(file_path, replaced_text)
    end

    private

    def listen_if_replace(results)
      interface = Interface.new(message: 'Replace', cases: [{
        cmd: 'y',
        func: proc { |result|
          result[:should_replace] = true
        }
      }, {
        cmd: 'n'
      }, {
        cmd: 'q',
        func: proc {
          # TODO: quit
        }
      }])
      results.each do |result|
        interface.listen(
          path: result[:path],
          preview: result[:preview],
          proc_args: [result]
        )
      end
      results
    end
  end
end
