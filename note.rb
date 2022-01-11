require 'net/http'
require 'uri'

html = Net::HTTP.get(URI("https://note.com"))
puts html