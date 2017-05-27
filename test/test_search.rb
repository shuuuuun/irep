require 'test_helper'
require 'interactive_replacer/search'

class TestSearch < Test::Unit::TestCase
  def setup
    @tmp_dir = File.join(File.dirname(__FILE__), '../', 'tmp', 'test')
    FileUtils.remove_dir @tmp_dir
    FileUtils.mkdir_p @tmp_dir
    Dir.chdir @tmp_dir
  end

  def test_find_filename
    filename = 'test_find_filename.txt'
    create_test_data(filename, '')

    search = InteractiveReplacer::Search.new directory: @tmp_dir
    search.find_filename('test_find_filename')

    result = search.results[0]
    assert_equal search.results.size, 1
    assert_equal result[:type], 'filename'
    assert_equal result[:path], File.join(@tmp_dir, filename)
  end

  def test_find_in_file
    filename = 'test_find_in_file.txt'
    text = 'test text'
    create_test_data(filename, text)

    search = InteractiveReplacer::Search.new directory: @tmp_dir
    search.find_in_file(filename, text)

    result = search.results[0]
    assert_equal search.results.size, 1
    assert_equal result[:type], 'in_file'
    assert_equal result[:path], filename
    assert_equal result[:offset], 0
    assert_equal result[:line], 1
    assert_equal result[:colmun], 0
    assert_equal result[:preview], text
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
