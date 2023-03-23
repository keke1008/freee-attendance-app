class Managers::Employees::ShiftsController < ApplicationController
  before_action :set_manager_and_employee
  before_action :set_shift, only: %i[show edit update destroy detail]

  def show; end

  def new
    @shift = Shift.new
  end

  def edit; end

  def create
    @shift = Shift.new(shift_params)
    @shift.employee = @employee
    if @shift.save
      @shift = Shift.eager_find(@shift.id)
      return
    end

    render :new, status: :unprocessable_entity
  end

  def update
    if @shift.update(shift_params)
      @shift = Shift.eager_find(@shift.id)
      return
    end

    render :edit, status: :unprocessable_entity
  end

  def detail; end

  def destroy
    @shift.destroy
  end

  private

  def shift_params
    params.require(:shift).permit(:date, :begin_at, :end_at)
  end

  def set_shift
    @shift = Shift.eager_find(params[:id])
  end
end
