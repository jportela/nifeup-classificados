class BlockLogsController < ApplicationController
  # GET /block_logs
  # GET /block_logs.json
  def index
    @block_logs = BlockLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @block_logs }
    end
  end

  # GET /block_logs/1
  # GET /block_logs/1.json
  def show
    @block_log = BlockLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @block_log }
    end
  end

  # GET /block_logs/new
  # GET /block_logs/new.json
  def new
    @block_log = BlockLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @block_log }
    end
  end

  # GET /block_logs/1/edit
  def edit
    @block_log = BlockLog.find(params[:id])
  end

  # POST /block_logs
  # POST /block_logs.json
  def create
    @block_log = BlockLog.new(params[:block_log])

    respond_to do |format|
      if @block_log.save
        format.html { redirect_to @block_log, notice: 'Block log was successfully created.' }
        format.json { render json: @block_log, status: :created, location: @block_log }
      else
        format.html { render action: "new" }
        format.json { render json: @block_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /block_logs/1
  # PUT /block_logs/1.json
  def update
    @block_log = BlockLog.find(params[:id])

    respond_to do |format|
      if @block_log.update_attributes(params[:block_log])
        format.html { redirect_to @block_log, notice: 'Block log was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @block_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /block_logs/1
  # DELETE /block_logs/1.json
  def destroy
    @block_log = BlockLog.find(params[:id])
    @block_log.destroy

    respond_to do |format|
      format.html { redirect_to block_logs_url }
      format.json { head :ok }
    end
  end
end
