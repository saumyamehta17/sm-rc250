json.array!(@articles) do |article|
  json.extract! article, :id, :name, :desc
  json.url article_url(article, format: :json)
end
