class RecipientsController < ApplicationController
  #skip_forgery_protection

  before_action :authenticate
  before_action :load_recipient, only: [:show, :edit, :update, :destroy]

  def index
    @recipients = Recipient.all
  end

  # GET /recipients/1
  # GET /recipients/1.json
  def show
  end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
  end

  # GET /recipients/1/edit
  def edit
  end

  # POST /recipients
  # POST /recipients.json
  def create
    @recipient = Recipient.new(recipient_params)
    @recipient.user_id = current_user.id

    respond_to do |format|
      if @recipient.save
        format.html { redirect_to recipients_path, notice: 'Recipient was successfully created.' }
        format.json { render :show, status: :created, location: @recipient }
      else
        format.html { render :new }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipients/1
  # PATCH/PUT /recipients/1.json
  def update
    respond_to do |format|
      if @recipient.update(recipient_params)
        format.html { redirect_to recipients_path, notice: 'Recipient was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient }
      else
        format.html { render :edit }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipients/1
  # DELETE /recipients/1.json
  def destroy
    @recipient.destroy
    respond_to do |format|
      format.html { redirect_to recipients_url, notice: 'Recipient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def load_recipient
    @recipient = Recipient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipient_params
    params.require(:recipient).permit(:name, :title, :email, :phone, :organization)
  end
end
