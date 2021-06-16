class EventsController < ApplicationController
  skip_before_action :authenticate, only: :show
  def show
    @event = Event.find(params[:id])
    @ticket = current_user && current_user.tickets.find_by(event: @event)
    @tickets = @event.tickets.includes(:user).order(:created_at)
    # binding.pry
  end
  def new
    @event = current_user.created_events.build
  end

  def create
    authorize! @event
    # create_events.build を使いたいが、userとtagの結びつけ方が不明のため一旦スルー
    # @event = current_user.created_events.build(event_params)

    # create_events.build をスルーするための代わりのコード
    @event = Event.new(event_params)
    @event.owner_id = current_user.id;

    tag_list = params[:event][:tag_names].split(",")

    @event.tags_save(tag_list)

    if @event.save
      redirect_to @event, notice: "作成しました"
    end
  end

  def edit
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id])
    tag_list = params[:event][:tag_names].split(",")
    # 空白文字の配列を取り除く https://qiita.com/ta1kt0me@github/items/33c4d37a65b69b75ee40
    tag_list.reject(&:blank?)
    # binding.pry
    @event.tags_save(tag_list)
    if @event.update(event_params)
      redirect_to @event, notice: "更新しました"
    end
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to root_path, notice: "削除しました"
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :place, :image, :remove_image, :content, :start_at, :end_at, :tag_name
    )
  end
end
