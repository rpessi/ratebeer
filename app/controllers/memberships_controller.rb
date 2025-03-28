class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
    @user = current_user
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership, notice: "Membership was successfully created." }
        format.json { render :show, status: :created, location: @membership }
      else
        # error handling not working properly, but at least double entries are blocked
        Rails.logger.debug "Membership save failed: #{@membership.errors.full_messages}"
        @beer_clubs = BeerClub.all # make available for re-rendering the options
        if @membership.errors[:base].include?("You are already a member of this beer club.")
          format.html { redirect_to @membership.beer_club, alert: "You are already a member of this beer club." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordNotUnique 
      redirect_to beer_clubs_path, alert: "You are already a member of this beer club."
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy!

    respond_to do |format|
      format.html { redirect_to memberships_path, status: :see_other, notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
