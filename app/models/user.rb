class User < ApplicationRecord
  EMAIL_REGEX  = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  NAME_REGEX   = /\A[a-zA-Zа-яА-Я]+[\w\-.]*\z/i

  validates_presence_of :email, :name

  validates :email, format: { with: EMAIL_REGEX }
  validates :email, length: 5..255
  validates :email, uniqueness: { case_sensitive: false }

  validates :name,  format: { with: NAME_REGEX }
  validates :name,  length: 2..32

  geocoded_by :get_geocode_string do |obj, results|
    if geo = results.first
      obj.latitude  = geo.latitude
      obj.longitude = geo.longitude
      obj.city      = geo.city || geo.province
      obj.zipcode   = geo.postal_code
    end
  end

  before_validation do
    self.email.downcase! if attribute_present?('email')
  end

  after_validation :geocode, if: ->(obj){ (obj.zipcode.present? and obj.zipcode_changed?) or (obj.address.present? and obj.address_changed?) }

  def get_geocode_string
    ret = 'Russia'

    ret << ", #{self.zipcode}" if zipcode_changed?
    ret << ", #{self.address}" if address_changed?

    ret
  end
end
