require 'httparty'
require 'json'

class ApiHelper
  def initialize
    @repo_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop")
    @contributor_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop/contributors")
    @pull_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop/pulls?state=closed&per_page=100")
    @holidata = get_parsed_data("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def get_parsed_data(url)
    parse(get_data(url))
  end
  
  def get_data(url)
    HTTParty.get(url)
  end
  
  def parse(data)
    JSON.parse(data.body, symbolize_names: true)
  end
  
  def holidays
    @holidata[0..2].map do |holiday|
      holiday[:name] + " " + holiday[:date]
    end
  end

  def repo_name
    @repo_data[:name]
  end

  def repo_name_test
    "little-esty-shop"
  end
  
  def contributors_array
    skip = ["BrianZanti","timomitchel","scottalexandra","cjsim89","jamisonordway","mikedao"]
    @contributor_data.map do |contributor_hash|
      
      if skip.include?(contributor_hash[:login])
        nil
      else
        [ contributor_hash[:login], contributor_hash[:contributions] ]
      end
    end.compact
  end

  def contributors_array_test
    [["kaylahrose",78],
    ["dlayton66",62],
    ["Kledin85",55],
    ["WilliamLampke",20]]
  end

  def num_prs
    @pull_data.map do |pull|
      pull[:merged_at]
    end.compact.count
  end

  def num_prs_test
    41
  end
end