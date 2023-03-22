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
    params.require(:shift).permit(:date, :begin_at, :end_at)
  end

  def set_shift
    @shift = Shift.find(params[:id])
  end
end
