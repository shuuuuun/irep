require 'fileutils'
require 'interactive_replacer/cli'
require 'test_helper'

class TestCLI < Test::Unit::TestCase
  def setup
    # @before_dir = Dir.pwd
    @tmp_dir = File.join(File.dirname(__FILE__), '../', 'tmp', 'test')
    FileUtils.remove_dir @tmp_dir
    FileUtils.mkdir_p @tmp_dir
    Dir.chdir @tmp_dir
  end

  def teardown
    # Dir.chdir(@before_dir)
  end

  def test_simple
    create_test_data('simple.txt', 'aaa')
    # ユーザー入力をmock化したい
    execute('--directory . aaa bbb')
    assert_equal read_test_data('simple.txt'), 'bbb'
#     assert_equal <<EOF, execute('aaa')
# aaa.txt:1:aaa
# EOF
  end

  private

  # ファイルの読み書きもmock化したほうがいいかも
  def create_test_data(file, text)
    File.write(File.join(@tmp_dir, file), text)
  end

  def read_test_data(file)
    File.read(File.join(@tmp_dir, file))
  end

  def execute(arg)
    io = StringIO.new
    InteractiveReplacer::CLI.execute(io, arg.split)
    io.string
  end
end
