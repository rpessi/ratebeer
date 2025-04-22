class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
    @confirmed_memberships = Membership.includes(:beer_club, :user).confirmed
    @pending_memberships = Membership.includes(:beer_club, :user).pending
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @memberships = Membership.all
    @membership = Membership.new
    @beer_clubs = BeerClub.all
    @user = current_user
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = BeerClub.all
    @user = current_user
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    respond_to do |format|
      if @membership.save
        @member = User.find(@membership.user_id).username
        @beer_club = BeerClub.find(@membership.beer_club_id)
        format.html { redirect_to @beer_club, notice: "Your membership is waiting for confirmation." }
      else
        @membership = Membership.find_by(membership_params)
        @beer_club = BeerClub.find(@membership.beer_club_id)
        format.html { redirect_to @beer_club, notice: "You are already a member." }
      end
      format.json { render :show, status: :created, location: @membership }
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

  def toggle_membership
    membership = Membership.find(params[:id])
    @beer_club = membership.beer_club
    @member = membership.user.username
    membership.update_attribute :confirmed, true
    redirect_to beer_club_path(@beer_club), notice: "Membership of #{@member} was confirmed."
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @beer_club = BeerClub.find(@membership.beer_club.id)
    @membership.destroy!

    respond_to do |format|
      format.html do
        redirect_to user_path(current_user),
                    status: :see_other,
                    notice: "Membership in #{@beer_club.name} ended."
      end
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
