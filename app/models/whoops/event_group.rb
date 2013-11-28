class Whoops::EventGroup
  # notifier responsible for creating identifier from notice details
  include Mongoid::Document
  include FieldNames

  [
    :service,
    :environment,
    :event_type,
    :message,
    :event_group_identifier,
    :logging_strategy_name
  ].each do |string_field|
    field string_field, :type => String
  end

  index :service
  index :environment
  index :event_type
  index [[:service,Mongo::ASCENDING], [:environment,Mongo::ASCENDING], [:event_type,Mongo::ASCENDING], [:event_group_identifier,Mongo::ASCENDING]]

  field :last_recorded_at, :type => DateTime
  field :archived, :type => Boolean, :default => false
  field :event_count, :type => Integer, :default => 0

  has_many :events, :class_name => "Whoops::Event"

  validates_presence_of :event_group_identifier, :event_type, :service, :message

  def self.identifying_fields
    field_names - ["message", "last_recorded_at"]
  end

  # @return sorted set of all applicable namespaces
  def self.services
    all.distinct(:service).sort
  end
end
