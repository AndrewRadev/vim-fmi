class AnnouncementsController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @announcements = Announcement.page(params[:page])

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)

    if @announcement.save
      redirect_to @announcement, notice: 'Новината е създадена.'
    else
      render :new
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])

    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: 'Новината е обновена.'
    else
      render :edit
    end
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :body)
  end
end
