require 'test_helper'

DATE = Time.utc(2023, 3, 21, 0, 0, 0)

TIME1 = Time.utc(2023, 3, 21, 12, 0, 0)
TIME2 = Time.utc(2023, 3, 21, 20, 0, 0)
TIME3 = Time.utc(2023, 3, 21, 23, 0, 0)

class ShiftText < ActiveSupport::TestCase
  test 'should save valid shift' do
    shift = Shift.new(employee: employees(:e1), begin_at: TIME1, end_at: TIME2, date: DATE)
    assert shift.save
  end

  test 'should not save shift without employee' do
    shift = Shift.new(employee_id: 1, begin_at: TIME1, end_at: TIME2, date: DATE)
    assert_not shift.save
  end

  test 'should not save shift with begin_at == end_at' do
    shift = Shift.new(employee: employees(:e1), begin_at: TIME1, end_at: TIME1, date: DATE)
    assert_not shift.save
  end

  test 'should not save shift with begin_at < end_at' do
    shift = Shift.new(employee: employees(:e1), begin_at: TIME2, end_at: TIME1, date: DATE)
    assert_not shift.save
  end

  test 'should not save shift with invalid begin_at' do
    shift = Shift.new(employee: employees(:e1), begin_at: '', end_at: TIME1, date: DATE)
    assert_not shift.save
  end

  test 'should not save shift with invalid end_at' do
    shift = Shift.new(employee: employees(:e1), begin_at: TIME1, end_at: '', date: DATE)
    assert_not shift.save
  end

  test 'should save not overlapped shifts' do
    Shift.create!(employee: employees(:e1), begin_at: TIME1, end_at: TIME2, date: DATE)
    shift = Shift.new(employee: employees(:e1), begin_at: TIME2, end_at: TIME3, date: DATE)
    assert shift.save!
  end

  test 'should save overlapped shifts if they are for different employees' do
    Shift.create!(employee: employees(:e1), begin_at: TIME1, end_at: TIME3, date: DATE)
    shift = Shift.new(employee: employees(:e2), begin_at: TIME1, end_at: TIME3, date: DATE)
    assert shift.save
  end

  test 'should not save overlapped shifts' do
    Shift.create!(employee: employees(:e1), begin_at: TIME1, end_at: TIME3, date: DATE)
    shift = Shift.new(employee: employees(:e1), begin_at: TIME1, end_at: TIME3, date: DATE)
    assert_not shift.save
  end
end
