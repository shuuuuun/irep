require 'fileutils'
require 'test/unit/rr'
require 'test_helper'
require 'interactive_replacer/cli'
require 'interactive_replacer/interface'

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

  def test_simple_y
    stub(InteractiveReplacer::Interface).get_input { 'y' }
    create_test_data('simple_y.txt', 'aaa')
    execute('aaa bbb')
    assert_equal read_test_data('simple_y.txt'), 'bbb'
#     assert_equal <<EOF, execute('aaa')
# aaa.txt:1:aaa
# EOF
  end

  def test_simple_n
    stub(InteractiveReplacer::Interface).get_input { 'n' }
    create_test_data('simple_n.txt', 'aaa')
    execute('aaa bbb')
    assert_equal read_test_data('simple_n.txt'), 'aaa'
  end

  def test_simple_no_replace
    create_test_data('simple_no_replace.txt', 'aaa')
    execute('--no-replace aaa bbb')
    assert_equal read_test_data('simple_no_replace.txt'), 'aaa'
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

  def execute(arg)
    io = StringIO.new
    InteractiveReplacer::CLI.execute(io, arg.split)
    io.string
  end
end
