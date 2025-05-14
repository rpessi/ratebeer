class MessagesController < ApplicationController
  before_action :set_message, only: %i[destroy]
  before_action :ensure_that_signed_in, only: %i[create]

  # GET /messages or /messages.json
  def index
    @messages = Message.order(created_at: :desc)&.limit(5)
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  def show
  end

  def list
    messages = Message.order(created_at: :desc)&.limit(5)
    render partial: 'message_list',
           locals: { messages: messages }
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    respond_to do |format|
      if @message.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("message_list", partial: "message_row", locals: { message: @message }),
            turbo_stream.replace("new_message", partial: "form", locals: { message: Message.new })
          ]
        }
        format.html { redirect_to @message, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:content, :author_id)
  end
end
