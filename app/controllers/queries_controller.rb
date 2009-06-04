require 'tem_mr_search'

class QueriesController < ApplicationController
  # GET /queries
  # GET /queries.xml
  def index
    @queries = Query.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  end

  # GET /queries/1
  # GET /queries/1.xml
  def show
    @query = Query.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @query }
    end
  end

  # GET /queries/new
  # GET /queries/new.xml
  def new
    @query = Query.new
    new_edit
  end

  # GET /queries/1/edit
  def edit
    @query = Query.find(params[:id])
    new_edit
  end
  
  def new_edit
    respond_to do |format|
      format.html { render :action => :new_edit }
      format.xml  { render :xml => @query }
    end  
  end
  private :new_edit

  # POST /queries
  # POST /queries.xml
  def create
    @query = Query.new(params[:query])

    respond_to do |format|
      if @query.save
        run_query
        @results = @query.results
        
        flash[:notice] = 'Query was successfully created.'
        format.html { redirect_to(@query) }
        format.xml  { render :xml => @query, :status => :created, :location => @query }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @query.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def run_query
    builder_params = { :layovers_cost => @query.layover_cost,
                       :start_time_cost => @query.time_cost,
                       :duration_cost => @query.duration_cost }
    client_query = Tem::Mr::Search::WebClientQueryBuilder.query builder_params
    summary = Tem::Mr::Search::Client.search mr_server_addr, client_query
    # summary = { :id => 20 } # HACK: remove this when the MR scheduler stops deadlocking

    details = Tem::Mr::Search::Client.fetch_item mr_server_addr, summary[:id]
    
    result = result_from_server_response details, summary
    result.save!
  end
  
  # Yes I know this belongs in a model.
  def result_from_server_response(details, summary = nil)
    p details
    summary ||= {}
    summary[:id] ||= details['flight']
    summary[:score] ||= details_score(details)
    Result.new :query => @query, :record_id => summary[:id],
                            :score => summary[:score],
                            :start_time => details['start_time'],
                            :end_time => details['end_time'],
                            :price => details['price'],
                            :layovers => details['layovers'],
                            :start_city => details['from'],
                            :end_city => details['to']    
  end
  
  def details_score(result)
    20000 - result['price'] - @query.layover_cost * result['layovers'] -
            @query.time_cost * result['start_time'] -
            @query.duration_cost * (result['end_time'] - result['start_time'])
  end
  
  def database
    @query = Query.new :layover_cost => 100, :time_cost => -10,
                       :duration_cost => 1
    @results = Tem::Mr::Search::Client.dump_database(mr_server_addr).
        map { |details| result_from_server_response details }
  end

  # PUT /queries/1
  # PUT /queries/1.xml
  def update
    @query = Query.find(params[:id])

    respond_to do |format|
      if @query.update_attributes(params[:query])
        flash[:notice] = 'Query was successfully updated.'
        format.html { redirect_to(@query) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @query.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /queries/1
  # DELETE /queries/1.xml
  def destroy
    @query = Query.find(params[:id])
    @query.destroy

    respond_to do |format|
      format.html { redirect_to(queries_url) }
      format.xml  { head :ok }
    end
  end
end
