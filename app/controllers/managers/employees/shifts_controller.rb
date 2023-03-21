class Managers::Employees::ShiftsController < ApplicationController
  before_action :set_manager_and_employee
  before_action :set_shift, only: %i[show edit update destroy]

  def show; end

  def new
    @shift = Shift.new
  end

  def edit; end

  def create
    @shift = Shift.new(shift_params)
    @shift.employee = @employee
    return if @shift.save

    render :new, status: :unprocessable_entity
  end

  def update
    return if @shift.update(shift_params)

    render :edit, status: :unprocessable_entity
  end

  def destroy
    @shift.destroy
  end

  private

  def shift_params
    params.require(:shift).permit(:begin_at, :end_at)
  end

  def set_manager_and_employee
    if current_manager.nil?
      redirect_to root_path
      return
    end

    @manager = current_manager
    employee_id = params[:employee_id]
    @employee = current_manager.employee.find(employee_id)
  end

  def set_shift
    @shift = Shift.find(params[:id])
  end
end
