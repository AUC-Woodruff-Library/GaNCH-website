class QueriesController < ApplicationController
  #skip_forgery_protection

  before_action :authenticate, except: [:show]
  before_action :load_query, only: [:show, :edit, :update, :destroy]
  after_action :get_recipients, only: [:update]

  # GET /queries
  # GET /queries.json
  def index
    @queries = Query.all
  end

  # GET /state
  # GET /queries.json
  def state
    @query = Query.where(scope: 'state').first

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @query.errors, status: :unprocessable_entity }
    end
  end

  # GET /queries/1
  # GET /queries/1.json
  def show
    @url = Rails.configuration.wikidata_url
  end

  def show_by_title
    @title = from_kebab_case(params[:title]).titleize
    @query = Query.where("lower(title) = ?", @title.downcase).first
    render :show
  end

  # GET /queries/new
  def new
    @query = Query.new
  end

  # GET /queries/1/edit
  def edit
  end

  # POST /queries
  # POST /queries.json
  def create
    @query = Query.new(query_params)
    @query.user = current_user

    respond_to do |format|
      if @query.save
        WikidataQueryJob.perform_later(@query, current_user)
        format.html { redirect_to queries_path, notice: 'Query was successfully created. Allow 30 seconds for Wikidata to run your query.' }
        format.json { render :show, status: :created, location: @query }
      else
        format.html { render :new }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /queries/1
  # PATCH/PUT /queries/1.json
  def update
    respond_to do |format|
      if @query.update(query_params)
        WikidataQueryJob.perform_later(@query, current_user)
        format.html { redirect_to queries_path, notice: 'Query was successfully updated. Allow 30 seconds for Wikidata to run your query.' }
        format.json { render :show, status: :ok, location: @query }
      else
        format.html { render :edit }
        format.json { render json: @query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /queries/1
  # DELETE /queries/1.json
  def destroy
    @query.destroy
    respond_to do |format|
      format.html { redirect_to queries_url, notice: 'Query was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def load_query
    @query = Query.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def query_params
    params.require(:query).permit(:title, :scope, :request, :response)
  end

  # build recipient list from query response
  def get_recipients
    logger.debug("Sending response for recipient processing.")
    Recipient.scrape(@query) if (@query.response)
  end
end
