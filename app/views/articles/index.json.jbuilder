json.array!(@articles) do |article|
  json.extract! article, :upc, :name, :description
  json.url article_url(article, format: :json)
end
