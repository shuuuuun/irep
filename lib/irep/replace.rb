require 'irep/interface'

module Irep
  module Replace
    extend self

    # TODO: replace_immediately
    # def replace_immediately(search_results, search_text, replace_text)
    # end

    def replace_interactively(search_results, search_text, replace_text)
      search_results.each do |result|
        next unless result[:preview]
        result[:result_preview] = result[:preview].gsub(search_text, replace_text)
      end
      listened_results = listen_if_replace(search_results)
      replace_in_file listened_results.select(&:in_file?), search_text, replace_text
      listened_results.select { |r| r.filename? || r.dIrectory? }.each do |result|
        next unless result.should_replace
        rename_path result[:path], search_text, replace_text
      end
    end

    # TODO: replace_in_file 消してもいいかも
    # def replace_in_file(file_path, before, after='')
    #   txt = File.read(file_path).gsub(before, after)
    #   File.write(file_path, txt)
    # end

    def replace_in_file(search_results, search_text, replace_text)
      grouped_results = search_results.group_by { |r| r[:path] }
      grouped_results.each do |path, results|
        file_text = File.read(path)
        # 文字列を特定位置で分割して配列にできたらいいかも?
        result_index = 0
        replaced_text = file_text.split(/(#{search_text})/).map do |text|
          next text if text != search_text
          result = results[result_index]
          result_index += 1
          if result.should_replace
            replace_text
          else
            text
          end
        end.join('')
        File.write(path, replaced_text)
      end
    end

    private

    def rename_path(path, before, after)
      File.rename path, path.gsub(before, after)
    end

    def listen_if_replace(results)
      interface = Interface.new(message: 'Replace', cases: [{
        cmd: 'y',
        help: 'yes, Replace it.',
        func: proc { |result|
          result.should_replace = true
        }
      }, {
        cmd: 'n',
        help: 'no, Don\'t replace it.',
      }, {
        cmd: 'q',
        help: 'quit, Don\'t apply any replacement after this.',
        func: proc {
          interface.quit
        }
      }, {
        cmd: 'a',
        help: 'all, Apply all replacement after this.',
        func: proc {
          interface.apply_all
        }
      # }, {
      #   cmd: 'h',
      #   help: 'help, Show this help.',
      #   func: proc {
      #     # TODO: help
      #   }
      # }, {
      #   cmd: '?',
      #   help: 'help, Show this help.',
      #   func: proc {
      #     # TODO: help
      #   }
      }])
      results.each do |result|
        interface.listen(
          path: result[:path],
          preview: result[:preview],
          result_preview: result[:result_preview],
          proc_args: [result]
        )
        result.should_replace = true if interface.apply_all_flag
      end
      results
    end
  end
end
