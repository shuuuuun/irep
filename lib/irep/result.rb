module Irep
  class Result
    module MatchType
      DIRECTORY = 0
      FILENAME = 1
      IN_FILE = 2
    end

    class << self
      def initialize_by_directory(path:, preview:)
        new(type: MatchType::DIRECTORY, path: path, preview: preview)
      end

      def initialize_by_filename(path:, preview:)
        new(type: MatchType::FILENAME, path: path, preview: preview)
      end

      def initialize_by_in_file(path:, preview:)
        new(type: MatchType::IN_FILE, path: path, preview: preview)
      end
    end

    attr_reader :type, :path, :preview

    def initialize(type:, path:, preview:)
      @type = type
      @path = path
      @preview = preview

      # @match_data = match_data
      # @offset = match_data.begin(0) # x 全体の何文字目か
      # @line = line_num # y, row 行数
      # @colmun = match_colmun_num(file_text, match_data) # x, colmun その行の何文字目か
      # @should_replace
    end

    def directory?
      type == MatchType::DIRECTORY
    end

    def filename?
      type == MatchType::FILENAME
    end

    def in_file?
      type == MatchType::IN_FILE
    end
  end
end
