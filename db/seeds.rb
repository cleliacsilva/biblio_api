puts "Limpando banco de dados..."
Book.destroy_all

puts "Criando 100 livros para a BiblioAPI..."

100.times do |i|
  Book.create!(
    title: Faker::Book.unique.title,
    author: Faker::Book.author,
    isbn: Faker::Barcode.isbn,
    available: [ true, false ].sample,
    updated_at: Faker::Time.backward(days: 30)
  )
end

puts "Sucesso! #{Book.count} livros criados."
