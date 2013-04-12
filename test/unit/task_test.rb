require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "task attributes must not be empty" do
  		task = Task.new
  		assert task.invalid?
  		assert task.errors[:name].any?
  		assert task.errors[:description].any?
  		assert task.errors[:effort].any?
  		assert task.errors[:project_id].any?
  end
end
