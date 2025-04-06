class StylesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_style, only: %i[show edit update destroy]

  def index
    @styles = Style.all
  end

  def show
  end

  def new
    @style = Style.new
  end

  def edit
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to @style, notice: "Style was successfully created" }
        format.json { render :show, status: :created, location: @style }
      else
        @styles = Style.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @style.update(style_params)
        format.html { redirect_to @style, notice: "Style was succesfully updated" }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style.destroy!

    respond_to do |format|
      format.html { redirect_to styles_path, status: :see_other, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end
end
