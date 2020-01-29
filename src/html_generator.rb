require 'erb'

class HtmlGenerator
  LAYOUT_PATH = 'templates/body_layout.html.erb'.freeze
  PAGES = {
    home:         'templates/index.html.erb',
    resume:       'templates/resume.html.erb',
    media:        'templates/media.html.erb',
    'demo reels': 'templates/demo_reels.html.erb',
    events:       'templates/events.html.erb'
  }

  def self.generate
    new.generate
  end

  def generate
    PAGES.each do |name, page|
      @current_page_name = name

      body = generate_html("#{current_dir}/#{LAYOUT_PATH}") do
        generate_html("#{current_dir}/#{page}")
      end

      b = binding
      b.local_variable_set(:body, body)
      file = File.read("#{current_dir}/templates/wrapper.html.erb")
      html = ERB.new(file).result(b)

      html_name = erb_name_to_html_name(page)
      File.write("#{current_dir}/../build/#{html_name}", html)
    end
  end

  def erb_name_to_html_name(erb_name)
    *_dirs, file_name = erb_name.split('/')
    file_name, *_extension = file_name.split('.')

    "#{file_name}.html"
  end

  def resource_url(resource_name)
    "./resources/#{resource_name}"
  end

  private

  attr_reader :current_page_name

  def initialize
    @current_page_name = nil
    @location_event_map = nil
    @head = nil
  end

  def head
    return @head unless @head.nil?

    @head = generate_html("#{current_dir}/templates/head.html.erb")
  end

  def generate_html(path)
    page_data = File.read(path)

    ::ERB.new(page_data).result(binding)
  end

  def current_dir
    @current_dir ||= File.dirname(__FILE__)
  end

  def locations
    {
      'Seattle, Washington': { lat: 47.601833, long: -122.329023 },
      'Bellevue, Washington': { lat: 47.616846, long: -122.194735 },
      'Gibraltar': { lat: 36.130548, long: -5.347979 },
      'Santo Domingo, Dominican Republic': { lat: 18.467004, long: -69.931776 },
      'Rio de Janeiro, Brazil': { lat: -22.968793, long: -43.355465 },
      'São Paulo, Brazil': { lat: -23.557594, long: -46.570609 },
      'Viborg, Denmark': { lat: 56.461003, long: 9.396907 },
      'Copenhagen, Denmark': { lat: 55.688996, long: 12.578713 },
      'Fullerton, California': { lat: 33.865999, long: -117.924220 },
      'San Francisco, California': { lat: 37.757074, long: -122.432113 },
      'San Luis Obispo, California': { lat: 35.273036, long: -120.664551 },
      'Laguna Beach, California': { lat: 33.541207, long: -117.772257 },
      'Valencia, California': { lat: 34.456647, long: -118.571651 },
      'San Diego, California': { lat: 32.798848, long: -117.074673 },
      'Los Angeles, California': { lat: 34.063403, long: -118.264816 },
      'Burbank, California': { lat: 34.186181, long: -118.310135 },
      'Hollywood, California': { lat: 34.092309, long: -118.327510 },
      'London, England': { lat: 51.493266, long: -0.133203 },
      'New Orleans, Louisiana': { lat: 30.041022, long: -89.903190 },
      'Frankfurt, Germany': { lat: 50.134961, long: 8.673623 },
      'Litomysl, Czech Republic': { lat: 49.872603, long: 16.315034 },
      'Ottawa, Canada': { lat: 45.410983, long: -75.577867 },
      'Halifax, Nova Scotia': { lat: 44.897408, long: -63.279645 },
      'Kalamazoo, Michigan': { lat: 42.287345, long: -85.590970 },
      'Madison, Wisconsin': { lat: 43.064589, long: -89.410563 },
      'Orlando, Florida': { lat: 28.525750, long: -81.377683 },
      'Guadalajara, Mexico': { lat: 20.668638, long: -103.335415 },
      'North Adams, Massachusetts': { lat: 42.697620, long: -73.107307 }
    }
  end

  def events
    [
      { name: "ACM Siggraph",
        date: "",
        location: "New Orleans, Louisiana",
        type: "Lecture" },
      { name: "ASIFA-Hollywood (Woodbury University)",
        date: "2008",
        location: "Burbank, California",
        type: "Book Signing, Panel",
        link: "http://jimhillmedia.com/columnists1/b/shelly_valladolid/archive/2008/10/23/asifa-hollywood-animation-archive-fundraiser-shines-spotlight-on-how-modern-animated-features-are-made.aspx" },
      { name: "Academy of Interactive Entertainment (AIE)",
        date: "2018",
        location: "Seattle, Washington",
        type: "Lecture" },
      { name: "Anima Mundi",
        date: "",
        location: "Rio de Janeiro, Brazil",
        type: "Lecture, Workshop" },
      { name: "Anima Mundi",
        date: "",
        location: "São Paulo, Brazil",
        type: "Lecture, Workshop" },
      { name: "Animation Festival",
        date: "",
        location: "Madison, Wisconsin",
        type: "Lecture" },
      { name: "Animation Mentor",
        date: "2018",
        location: "San Francisco, California",
        type: "Lecture" },
      { name: "Animation Mentor",
        date: "2019",
        location: "San Francisco, California",
        type: "Lecture" },
      { name: "Anomalia",
        date: "",
        location: "Litomysl, Czech Republic",
        type: "Lecture, Workshop" },
      { name: "Bellevue Community College",
        date: "2018",
        location: "Bellevue, Washington",
        type: "Lecture" },
      { name: "CREANIMAX Festival",
        date: "",
        location: "Guadalajara, Mexico",
        type: "Lecture" },
      { name: "Cal Poly",
        date: "",
        location: "San Luis Obispo, California",
        type: "Lecture" },
      { name: "Cal State University of Fullerton",
        date: "",
        location: "Fullerton, California",
        type: "Lecture" },
      { name: "California Institute of the Arts",
        date: "",
        location: "Valencia, California",
        type: "Lecture" },
      { name: "ComicCon",
        date: "",
        location: "Gibraltar",
        type: "Lecture" },
      { name: "Disney Studios",
        date: "",
        location: "Orlando, Florida",
        type: "Lecture" },
      { name: "Disney Studios",
        date: "",
        location: "Burbank, California",
        type: "Lecture" },
      { name: "eDIT",
        date: "",
        location: "Frankfurt, Germany",
        type: "Lecture" },
      { name: "El Capitan Theater",
        date: "2007",
        location: "Hollywood, California",
        type: "Panel",
        link: "https://www.youtube.com/watch?v=M4g3A-zkgx4&feature=youtu.be&t=1" },
      { name: "El Capitan Theater",
        date: "2018",
        location: "Hollywood, California",
        type: "Panel",
        link: "https://www.youtube.com/watch?v=oG0IsVQtOIM" },
      { name: "Freddy Beras",
        date: "",
        location: "Santo Domingo, Dominican Republic",
        type: "Workshop" },
      { name: "Kalamazoo International Animation Festival",
        date: "",
        location: "Kalamazoo, Michigan",
        type: "Lecture" },
      { name: "Laguna College of Art and Design",
        date: "",
        location: "Laguna Beach, California",
        type: "Lecture" },
      { name: "Massachusetts Museum of Contemporary Art",
        date: "",
        location: "North Adams, Massachusetts",
        type: "Lecture, Stop Motion Animation performance",
        link: "https://www.youtube.com/watch?v=0Vv20WN0dnU" },
      { name: "Ottawa International Animation Festival",
        date: "",
        location: "Ottawa, Canada",
        type: "Lecture" },
      { name: "Promise Keepers",
        date: "",
        location: "San Diego, California",
        type: "Lecture" },
      { name: "RGB Studio",
        date: "",
        location: "Copenhagen, Denmark",
        type: "Lecture" },
      { name: "Rhythm and Hues Studio",
        date: "",
        location: "Los Angeles, California",
        type: "Lecture" },
      { name: "The Animation Workshop",
        date: "",
        location: "Viborg, Denmark",
        type: "Workshop" },
      { name: "The Art Institute of California",
        date: "",
        location: "San Francisco, California",
        type: "Lecture" },
      { name: "VES",
        date: "",
        location: "Los Angeles, California",
        type: "Lecture" },
      { name: "VES Society",
        date: "",
        location: "London, England",
        type: "Lecture" },
      { name: "Valve Software",
        date: "2018",
        location: "Bellevue, Washington",
        type: "Lecture" },
      { name: "ViewFinders Atlantic Film Festival",
        date: "",
        location: "Halifax, Nova Scotia",
        type: "Lecture" },
      { name: "Visual Effects Society",
        date: "2018",
        location: "Seattle, Washington",
        type: "Lecture" }
    ]
  end

  def location_event_map
    return @location_event_map unless @location_event_map.nil?

    @location_event_map = {}
    events.each_with_index do |event, index|
      location_name = event[:location].to_sym
      if @location_event_map.key?(location_name)
        @location_event_map[location_name] << index
      else
        @location_event_map[location_name] = [index]
      end
    end

    @location_event_map
  end
end
