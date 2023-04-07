require_relative 'selectMenu/select'
require_relative 'selectMenu/menu_list'
require_relative 'classes/book'
require_relative 'classes/label'
require_relative 'data/preserve'
require_relative './musicAlbum/music_album'
require_relative './musicAlbum/genre'
require_relative './store'
require_relative './input'

class App
  attr_accessor :books, :label, :music_albums, :genres

  def initialize
    @books = []
    @label = []
    @music_albums = music_albums
    @genres = genres
    @labels ||= []
    @store = Store.new(self)
    @store.load_data
  end

  def colorize_output(color_code, statements)
    puts "\e[#{color_code}m#{statements}\e[0m"
  end

  def colorize_outprint(color_code, statements)
    print "\e[#{color_code}m#{statements}\e[0m"
  end

  def add_book
    puts '---------------------------------------'
    print 'Enter the name of the book: '
    name = gets.chomp
    print 'Enter the publisher: '
    publisher = gets.chomp
    print 'Please enter the author name: '
    author = gets.chomp
    print 'Please enter state of the book"(good/bad)": '
    cover_state = gets.chomp
    if cover_state != 'good' && cover_state != 'bad'
      colorize_output(31, 'Invalid state 🚫 ')
      return
    end
    print 'Enter the published date of the book(YY-MM-DD): '
    date = gets.chomp
    book = Book.new(name, publisher, cover_state, date, author)
    @books << book
    print 'Enter the title label of the book: '
    label_title = gets.chomp
    print 'Enter the label color of the book: '
    label_color = gets.chomp
    new_label = Label.new(label_title, label_color)
    @labels << new_label
    save_data(@labels, './data/label.json')
    save_data(@books, './data/book.json')
    colorize_output(32, "Book '#{name}' was added successfully 🤹‍♂️✅!")
    puts '---------------------------------------------------'
  end

  def list_all_books
    @books = read_data('./data/book.json')
    if @books.empty?
      colorize_output(31, 'No books found 🚫 ')
    else
      puts 'Book List:'
      @books.each_with_index do |book, index|
        print "#{index + 1}-Name: #{book['name']}, Publisher: #{book['publisher']},
       Cover state: #{book['cover_state']}, Published date: #{book['publish_date']}, Author: #{book['author']}\n\n"
      end
    end
    @music_albums = []
    @genres = []
    @store = Store.new(self)
    @store.load_data
  end

  def list_all_music_albums
    if @music_albums.empty?
      puts 'No music albums found'
    else
      puts '# Music Albums'
      @music_albums.each_with_index do |music_album, i|
        puts "#{i + 1}. #{music_album}"
      end
    end
  end

  def list_all_labels
    @labels = read_data('./data/label.json')
    if @labels.nil? || @labels.empty?
      colorize_output(31, 'No labels found')
    else
      puts "------------------------\n"
      @labels.each do |label|
        puts label.inspect
        print "ID: #{label['label_id']} , Label-Title: #{label['title']} , Color: #{label['color']}\n"
      end
      puts "--------------------------\n\n"
    end
  end

  def list_all_genres
    if @genres.empty?
      puts 'No music genres found'
    else
      puts '# Genres'
      @genres.each_with_index do |genre, i|
        puts "#{i + 1}. #{genre}"
      end
    end
  end

  def add_music_album
    puts '-------------------------'
    puts ' Create music album'
    puts 'Album name:'
    name = gets.chomp
    puts 'On Spotify (y/n)?: '
    on_spotify = gets.chomp.downcase == 'y'
    publish_date = Input.get_date('Published Date: ')

    music_album = MusicAlbum.new(name, publish_date, on_spotify)
    @music_albums << music_album
    puts '*New album added successfully!', music_album.to_s
    @store.save_data
  end

  def close
    @store.save_data
    puts '--------------------------------'
    puts 'DATA SAVED SUCCESSFULLY'
    puts '--------------------------------'
  end
end
