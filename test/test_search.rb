require 'test_helper'
require 'interactive_replacer/search'

class TestSearch < Test::Unit::TestCase
  def setup
    @tmp_dir = File.join(File.dirname(__FILE__), '../', 'tmp', 'test')
    FileUtils.remove_dir @tmp_dir
    FileUtils.mkdir_p @tmp_dir
    Dir.chdir @tmp_dir
  end

  def test_find_in_file
    file_path = 'simple.txt'
    create_test_data(file_path, 'text')

    search = InteractiveReplacer::Search.new
    search.find_in_file(file_path, 'text')

    result = search.results[0]
    assert_equal search.results.size, 1
    assert_equal result[:type], 'in_file'
    assert_equal result[:path], file_path
    assert_equal result[:offset], 0
    assert_equal result[:line], 1
    assert_equal result[:colmun], 0
    assert_equal result[:preview], 'text'
  end

  private

  # TODO: テストケースごとにディレクトリ切ったほうがいいかも
  # TODO: ファイルの読み書きもmock化したほうがいいかも？
  def create_test_data(file, text)
    File.write(File.join(@tmp_dir, file), text)
  end

  def read_test_data(file)
    File.read(File.join(@tmp_dir, file))
  end
end
