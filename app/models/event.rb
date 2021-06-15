class Event < ApplicationRecord
  # kuromoji を利用する設定
  searchkick language: "japanese"

  has_rich_text :content
  has_one_attached :image, dependent: false  #ActiveStorage の image 属性が使えるように
  has_many :tickets, dependent: :destroy
  # event.owner.name でownerの情報を参照できるようになる
  belongs_to :owner, class_name: "User"

  has_many :event_tags
  has_many :tags, through: :event_tags

  validates :image, content_type: [:png, :jpg, :jpeg], size: { less_than_or_equal_to: 10.megabytes }, dimension: { width: { max: 2000 } , height: { max: 2000 } }

  validates :name, length: { maximum: 50}, presence: true
  validates :place, length: { maximum: 100}, presence: true
  validates :content, length: { maximum: 2000}, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :start_at_should_be_before_end_at


  def search_data
    {
      name: name,
      place: place,
      content: content,
      owner_name: owner&.name,
      start_at: start_at
    }
  end
  
  def created_by?(user)
    return false unless user
    owner_id == user.id
  end

  def tags_save(tag_list)
    if self.tags != nil
      event_tags_records = EventTag.where(event_id: self.id)
      event_tags_records.destroy_all
    end
    tag_list.each do |tag|
      inspected_tag = Tag.where(tag_name: tag).first_or_create
      self.tags << inspected_tag
    end
  end

  attr_accessor :remove_image

  before_save :remove_image_if_user_accept

  private

  def remove_image_if_user_accept
    self.image = nil if ActiveRecord::Type::Boolean.new.cast(remove_image)
  end

  def start_at_should_be_before_end_at
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, "は終了時間よりも前に設定してください")
    end
  end

end
