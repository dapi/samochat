# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Посещение сайта
#
class Visit < ApplicationRecord
  TELEGRAM_KEY_PREFIX = 'v_'

  LOCATION_FIELDS = %i[city region country timezone].freeze
  CHAT_FIELDS = %i[first_name last_name username].freeze

  belongs_to :visitor_session
  has_one :visitor, through: :visitor_session
  has_one :project, through: :visitor

  scope :with_visitor, -> { joins(:visitor_session).where.not(visitor_sessions: { visitor_id: nil }) }
  scope :without_visitor, -> { joins(:visitor_session).where(visitor_sessions: { visitor_id: nil }) }
  scope :by_project, ->(project_id) { joins(:visitor_session).where(visitor_sessions: { project_id: }) }
  scope :by_visitor, ->(visitor_id) { joins(:visitor_session).where(visitor_sessions: { visitor_id: }) }

  before_create do
    self.key = Nanoid.generate
  end

  delegate(*CHAT_FIELDS, to: :chat_object)
  delegate(*LOCATION_FIELDS, to: :location_object)

  after_create do
    if visitor.present?
      visitor.update_columns(
        user_data: visitor.user_data.merge(user_data),
        last_visit_at: created_at
      )
    end
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[by_visitor with_visitor without_visitor]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[project visitor]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[chat created_at data id key location referrer registered_at remote_ip updated_at visitor_id]
  end

  def self.find_by_telegram_key(visit_key)
    if visit_key.start_with? TELEGRAM_KEY_PREFIX
      find_by key: visit_key.sub(/^#{TELEGRAM_KEY_PREFIX}/, '')
    else
      none
    end
  end

  def host
    Addressable.new(referrer).host if referrer.present?
  end

  def to_s
    to_json
  end

  def chat_object
    OpenStruct.new(chat).freeze
  end

  def location_object
    OpenStruct.new(location).freeze
  end

  def geo
    [city.presence, "(#{region_and_country.presence || remote_ip})"].compact.join(' ')
  end

  def region_and_country
    [region.presence, country.presence].compact.join('/').presence
  end

  # chat =>
  # {"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"}
  #
  # location =>
  # {"ip"=>"94.232.57.6",
  # "hostname"=>"6.57.232.94.static.infanet.ru",
  # "city"=>"Cheboksary",
  # "region"=>"Chuvashia",
  # "country"=>"RU",
  # "loc"=>"56.1322,47.2519",
  # "org"=>"AS48089 Infanet Ltd.",
  # "postal"=>"428000",
  # "timezone"=>"Europe/Moscow",
  # "readme"=>"https://ipinfo.io/missingauth"}>

  # Ключ через который ссылаемся на этот визит в ссылке на телеграм
  #
  def telegram_key
    TELEGRAM_KEY_PREFIX + key
  end
end
