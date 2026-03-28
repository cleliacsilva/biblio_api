class BookSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :author, :isbn, :links

  def links
    {
      self: api_nivel3_book_url(object),
      update: { href: api_nivel3_book_url(object), method: "PATCH" },
      delete: { href: api_nivel3_book_url(object), method: "DELETE" }
    }
  end

  def default_url_options
    Rails.application.config.action_controller.default_url_options || { host: "localhost:3000" }
  end
end
