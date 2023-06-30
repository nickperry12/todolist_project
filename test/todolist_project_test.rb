require 'bundler/setup'
require 'minitest/autorun'
require "minitest/reporters"
require 'date'
Minitest::Reporters.use!

require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"

  def test_no_due_date
    assert_nil(@todo1.due_date)
  end

  def test_due_date
    due_date = Date.today + 3
    @todo2.due_date = due_date
    assert_equal(due_date, @todo2.due_date)
  end

  def test_to_s_with_due_date
    @todo2.due_date = Date.civil(2017, 4, 15)
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room (Due: Saturday April 15)
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(@todos.size, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    @list.mark_all_done
    assert_equal(true, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list << 1 }
    assert_raises(TypeError) { @list << 'hi' }
  end

  def test_shovel
    todo = Todo.new("make a test suite")
    @list << todo
    assert_equal(todo, @list.last)
  end

  def test_add_alias
    assert_equal(@list.method(:add), @list.method(:<<))
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) do
      @list.item_at(7)
    end
  end

  def test_mark_done
    @list.mark_done_at(0)
    assert_equal(true, @list.to_a[0].done?)
    assert_equal(false, @list.to_a[1].done?)
    assert_equal(false, @list.to_a[2].done?)
    assert_raises(IndexError) { @list.mark_done_at(1000) }
  end

  def test_mark_undone
    @list.mark_all_done
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_raises(IndexError) { @list.mark_undone_at(100) }
  end

  def test_done!
    @list.done!
    assert_equal(true, @list.to_a.all? { |todo| todo.done? })
  end

  def test_remove_at
    removed = @list.remove_at(0)
    assert_equal([@todo2, @todo3], @list.to_a)
    assert_raises(IndexError) { @list.remove_at(100) }
    assert_equal(removed, @todo1)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_two
    @list.mark_done_at(0)
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_two
    assert_equal(@list, @list.each { |todo| todo })
  end

  def test_select
    @list.mark_done_at(1)
    @list.mark_done_at(2)
    result = @list.select { |todo| todo.done? }

    assert_equal([@todo2, @todo3], result)
  end
end
