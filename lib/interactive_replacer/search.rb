module InteractiveReplacer
  class Search
    attr_reader :results

    def initialize(opts = {})
      @results = []
      @directory = opts[:directory]
    end

    def find_all(search_text)
    end

    def find_directory(search_text)
    end

    def find_filename(search_text)
      match_file_list = target_file_paths.select do |file_path|
        file_path.include?(search_text)
      end
      current_results = match_file_list.map do |file_path|
        {
          type: 'filename',
          path: file_path,
        }
      end
      @results.concat current_results
    end

    def find_in_file_recursive(search_text)
      target_file_paths.each do |file_path|
        find_in_file(file_path, search_text)
      end
    end

    def find_in_file(file_path, search_text)
      file_text = File.read(file_path)
      # 配列にしてeachだと遅そうな気がする。あとで確認してもいいかも。
      # file_lines = file_text.split("\n")
      # file_lines.each do |line|
      # end
      match_data_list = match_global(file_text, search_text)
      current_results = match_data_list.map do |match_data|
        line_num = match_line_num(file_text, match_data)
        {
          match_data: match_data,
          type: 'in_file', # in_file, directory, filename
          path: file_path, # 'path/to/file_or_directory'
          offset: match_data.begin(0), # x 全体の何文字目か
          line: line_num, # y, row 行数
          colmun: match_colmun_num(file_text, match_data), # x, colmun その行の何文字目か
          preview: extract_line(file_text, line_num, 1), # プレビュー表示するテキスト（マッチした行+数行）
        }
      end
      @results.concat current_results
      # @results.concat(current_results).uniq!
      # show_results
      # @results
    end

    def show_results
      puts('no search results.') && return if @results.empty?
      @results.each do |result|
        p result
      end
    end

    private

    def target_file_paths
      # TODO: ignore
      paths = Dir.glob "#{@directory}/**/*"
      paths.reject { |path| File.directory?(path) }
    end

    def target_directory_paths
      # TODO: ignore
      paths = Dir.glob "#{@directory}/**/*"
      paths.select { |path| File.directory?(path) }
    end

    def extract_line(text, line_num, size)
      text.split("\n")[line_num - 1]
    end

    def match_line_num(text, match_data)
      offset = match_data.begin(0)
      text.slice(0..offset).count("\n") + 1
    end

    def match_colmun_num(text, match_data)
      offset = match_data.begin(0)
      text.slice(0..offset).split("\n").last.size - 1
    end

    def match_global(str, regexp)
      match_data_list = []
      match_data = str.match(regexp)
      until match_data.nil?
        match_data_list << match_data
        offset = match_data.end(0)
        match_data = str.match(regexp, offset)
      end
      match_data_list
    end
  end
end
