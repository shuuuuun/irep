module InteractiveReplacer
  class Replace
    def initialize(search=nil)
      @search = search
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
