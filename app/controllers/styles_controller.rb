class StylesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_style, only: %i[show edit update destroy]
  before_action :set_admin, only: %i[show destroy]

  def index
    @order = params[:order] || 'name'
    @styles = Style.includes(:beers, :ratings)

    @styles = case @order
              when "name" then @styles.sort_by(&:name)
              when "beers" then @styles.sort_by { |s| s.beers.count }.reverse
              when "rating" then @styles.sort_by(&:average_rating).reverse
              end
  end

  def about
    render partial: 'about'
  end

  def show
    return unless turbo_frame_request?

    render partial: 'details', locals: { style: @style }
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
        @styles = Style.includes(:beers, :ratings)
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
    return unless @admin

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
