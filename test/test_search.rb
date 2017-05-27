require 'test_helper'
require 'interactive_replacer/search'

class TestSearch < Test::Unit::TestCase
  def setup
    @tmp_dir = File.join(File.dirname(__FILE__), '../', 'tmp', 'test')
    FileUtils.remove_dir @tmp_dir
    FileUtils.mkdir_p @tmp_dir
    Dir.chdir @tmp_dir
  end

  def test_find_directory
    directory_1 = 'test_find_directory_1'
    directory_2 = 'test_find_directory_2'
    FileUtils.mkdir_p File.join(@tmp_dir, directory_1)
    FileUtils.mkdir_p File.join(@tmp_dir, directory_2)

    search = InteractiveReplacer::Search.new directory: @tmp_dir, search_text: 'test_find_directory'
    search.find_directory

    result = search.results[0]
    assert_equal search.results.size, 2
    assert_equal result[:type], 'directory'
    assert_equal result[:path], File.join(@tmp_dir, directory_1)
  end

  def test_find_filename
    filename_1 = 'test_find_filename_1.txt'
    filename_2 = 'test_find_filename_2.txt'
    create_test_data(filename_1, '')
    create_test_data(filename_2, '')

    search = InteractiveReplacer::Search.new directory: @tmp_dir, search_text: 'test_find_filename'
    search.find_filename

    result = search.results[0]
    assert_equal search.results.size, 2
    assert_equal result[:type], 'filename'
    assert_equal result[:path], File.join(@tmp_dir, filename_1)
  end

  def test_find_in_file
    filename = 'test_find_in_file.txt'
    file_path = File.join(@tmp_dir, filename)
    text = 'test text test'
    create_test_data(filename, text)

    search = InteractiveReplacer::Search.new directory: @tmp_dir, search_text: 'test'
    search.find_in_file(file_path)

    result = search.results[0]
    assert_equal search.results.size, 2
    assert_equal result[:type], 'in_file'
    assert_equal result[:path], file_path
    assert_equal result[:offset], 0
    assert_equal result[:line], 1
    assert_equal result[:colmun], 0
    assert_equal result[:preview], text
  end

  def test_find_in_file_recursive
    filename_1 = 'find_in_file_recursive_1.txt'
    filename_2 = 'find_in_file_recursive_2.txt'
    text = 'test text test'
    create_test_data(filename_1, text)
    create_test_data(filename_2, text)

    search = InteractiveReplacer::Search.new directory: @tmp_dir, search_text: 'test'
    search.find_in_file_recursive

    result = search.results[0]
    assert_equal search.results.size, 4
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
