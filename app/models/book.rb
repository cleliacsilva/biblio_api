class Book < ApplicationRecord
  def self.to_csv
    attributes = %w[id title author isbn available]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |book|
        csv << attributes.map { |attr| book.send(attr) }
      end
    end
  end
end
