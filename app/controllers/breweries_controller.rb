class BreweriesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :active, :retired]
  before_action :set_brewery, only: %i[show edit update destroy]
  before_action :set_admin, only: %i[index show destroy active retired]

  # GET /breweries or /breweries.json
  def index
    @breweries = Brewery.order(:name)
    @active_breweries = Brewery.includes(:beers, :ratings).active
    @retired_breweries = Brewery.includes(:beers, :ratings).retired
  end

  def list
  end

  def active
    active_breweries = Brewery.includes(:beers, :ratings).active
    render partial: 'brewery_list',
           locals: { breweries: active_breweries, status: "active" }
  end

  def retired
    retired_breweries = Brewery.includes(:beers, :ratings).retired
    render partial: 'brewery_list',
           locals: { breweries: retired_breweries, status: "retired" }
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active

    new_status = brewery.active? ? "active" : "retired"
    old_status = brewery.active? ? "retired" : "active"

    render turbo_stream: [turbo_stream.replace("#{new_status}_brewery_count", partial: "brewery_count", locals: { status: new_status }),
                          turbo_stream.replace("#{old_status}_brewery_count", partial: "brewery_count", locals: { status: old_status }),
                          turbo_stream.remove(brewery),
                          turbo_stream.append("#{new_status}_brewery_rows", partial: "brewery_row", locals: { brewery: brewery })]

    # redirect_to brewery, notice: "Brewery activity status changed to #{new_status}"; nil
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.turbo_stream {
          status = @brewery.active? ? "active" : "retired"
          render turbo_stream: [turbo_stream.append("#{status}_brewery_rows", partial: "brewery_row", locals: { brewery: @brewery }),
                                turbo_stream.replace("new_brewery", partial: "form", locals: { brewery: Brewery.new }),
                                turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status: status })]
        }
        format.html { redirect_to @brewery, notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    return unless @admin

    @brewery.destroy!

    respond_to do |format|
      format.turbo_stream {
        status = @brewery.active? ? "active" : "retired"
        render turbo_stream: [turbo_stream.remove(@brewery),
                              turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status: status })]
      }
      format.html { redirect_to breweries_path, status: :see_other, notice: "Brewery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end

  def set_admin
    @admin = current_user&.admin?
  end
end
