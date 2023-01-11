require 'httparty'
require 'json'

class ApiHelper
  attr_reader :repo_data, :contributor_data, :pull_data

  def initialize
    @repo_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop")
    @contributor_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop/contributors")
    @pull_data = get_parsed_data("https://api.github.com/repos/kaylahrose/little-esty-shop/pulls?state=closed&per_page=100")
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
  
  def repo_name
    @repo_data[:name]
  end
  
  def contributors_hash
    @contributor_data.map do |contributor_hash|
      { contributor_hash[:login] => contributor_hash[:contributions] }
    end
  end

  

  def num_prs
    @pull_data.map do |pull|
      pull[:merged_at]
    end.compact.count
  end
end