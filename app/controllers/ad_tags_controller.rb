class AdTagsController < ApplicationController
  # GET /ad_tags
  # GET /ad_tags.json
  def index
    @ad_tags = AdTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ad_tags }
    end
  end

  # GET /ad_tags/1
  # GET /ad_tags/1.json
  def show
    @ad_tag = AdTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ad_tag }
    end
  end

  # GET /ad_tags/new
  # GET /ad_tags/new.json
  def new
    @ad_tag = AdTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ad_tag }
    end
  end

  # GET /ad_tags/1/edit
  def edit
    @ad_tag = AdTag.find(params[:id])
  end

  # POST /ad_tags
  # POST /ad_tags.json
  def create
    @ad_tag = AdTag.new(params[:ad_tag])

    respond_to do |format|
      if @ad_tag.save
        format.html { redirect_to @ad_tag, notice: 'Ad tag was successfully created.' }
        format.json { render json: @ad_tag, status: :created, location: @ad_tag }
      else
        format.html { render action: "new" }
        format.json { render json: @ad_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ad_tags/1
  # PUT /ad_tags/1.json
  def update
    @ad_tag = AdTag.find(params[:id])

    respond_to do |format|
      if @ad_tag.update_attributes(params[:ad_tag])
        format.html { redirect_to @ad_tag, notice: 'Ad tag was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ad_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_tags/1
  # DELETE /ad_tags/1.json
  def destroy
    @ad_tag = AdTag.find(params[:id])
    @ad_tag.destroy

    respond_to do |format|
      format.html { redirect_to ad_tags_url }
      format.json { head :ok }
    end
  end
  
  # GET /ad_tags/all
  def all
    @ad_tags = AdTag.where(['tag LIKE ?', "#{params[:term]}%"]).select(:tag).collect{|u|u.tag.to_s}

    respond_to do |format|
      format.json { render json: @ad_tags.uniq }
    end
  end
  
end
