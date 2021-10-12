require 'faker'

class DataController < ApplicationController
  def gen
    data = {}
    data["name"] = Faker::Name.name
    data["email"] = Faker::Internet.email(name: data["name"])
    data["address"] = Faker::Address.street_address
    data["phone"] = Faker::PhoneNumber.phone_number

    @message = data
  end
end
