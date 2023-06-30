require 'bundler/setup'
require 'stamp'

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done, :due_date

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_reader :todos, :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    if todo.class == Todo
      todos << todo
    else
      raise TypeError.new("Can only add Todo objects")
    end
  end

  alias_method :<<, :add

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos
  end

  def done?
    todos.all? { |todo| todo.done? }
  end

  def item_at(idx)
    if idx > (todos.size - 1)
      raise IndexError
    else
      todos[idx]
    end
  end

  def mark_done_at(idx)
    if idx > (todos.size - 1)
      raise IndexError
    else
      todos[idx].done!
    end
  end

  def mark_undone_at(idx)
    if idx > (todos.size - 1)
      raise IndexError
    else
      todos[idx].undone!
    end
  end
  
  def done!
    todos.each { |todo| todo.done! }
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(idx)
    if idx > (todos.size - 1)
      raise IndexError
    else
      todos.delete_at(idx)
    end
  end

  def to_s
    text = "---- #{title} ----\n"
    text << todos.map { |todo| todo.to_s }.join("\n")
    text
  end

  def each
    counter = 0
    while counter < todos.size
      yield(todos[counter])
      counter += 1
    end

    self
  end

  def select
    counter = 0
    result = []

    while counter < todos.size
      result << todos[counter] if yield(todos[counter])
      counter += 1
    end

    result
  end

  def find_by_title(title)
    result = todos.select { |todo| todo.title == title }
    result.empty? ? nil : result
  end

  def all_done
    result = TodoList.new("All done")
    result.todos = self.select { |todos| todos.done? }
  end

  def all_not_done
    result = TodoList.new("Not done")
    result.todos = self.select { |todos| todos.done? == false }
  end

  def mark_done(title)
    todos.each do |todo|
      if todo.done? == false && todo.title == title
        todo.done!
        break
      end
    end
  end

  def mark_all_done
    todos.each { |todo| todo.done! }
  end

  def mark_all_undone
    todos.each { |todo| todo.undone! }
  end

  protected

  attr_writer :title, :todos
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
todo4 = Todo.new("Study for exam")
todo5 = Todo.new("Take dog for walk")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)
list.add(todo4)
list.add(todo5)

p list.to_s