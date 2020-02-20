require 'erb'
require 'fileutils'

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

    FileUtils.copy_entry "#{current_dir}/resources", "#{current_dir}/../build/resources"
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
    @locations ||= YAML.load_file('./src/templates/data/event_locations.yml')
  end

  def events
    @events ||= YAML.load_file('./src/templates/data/events.yml')
  end

  def location_event_map
    return @location_event_map unless @location_event_map.nil?

    @location_event_map = {}
    events.each_with_index do |event, index|
      location_name = event['location']
      if @location_event_map.key?(location_name)
        @location_event_map[location_name] << index
      else
        @location_event_map[location_name] = [index]
      end
    end

    @location_event_map
  end
end
