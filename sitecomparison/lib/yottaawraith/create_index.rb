require 'fileutils'
require 'erb'


class CreateIndex
  include ERB::Util
  attr_accessor  :gallery

  begin
    def initialize()
      @gallery = []

    end

def getdirs(locale)

 your_dir = File.join(Dir.getwd, 'UICompare/current')

  toplvl = Dir.entries(your_dir).select { |entry| File.directory? File.join(your_dir, entry) and !(entry =='.' || entry == '..') }

  toplvl.each do |f|

    if locale == 'S3'
      #need to fork off for S3, local links are different
      localurl =  '/' + f + '/gallery.html'

    else
      localurl = '/sitecomparison/UICompare/current/' +  f + '/gallery.html'
    end
    @gallery << Galleries.new(f.capitalize,localurl)


  end
end


begin
  def getgallerylist

   @gallery = Dir.glob("../../UICompare/current/**/gallery.html")

    end

  end


end


  class Galleries
    attr_reader :cust, :url
    def initialize(cust, url)
      @cust = cust
      @url = url
    end

  end


  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end



  def convert_erb_html_file
    template_file = File.open('lib/yottaawraith/index_template/gallery_index.erb', 'r').read
    erb = ERB.new(template_file)
    File.open('UICompare/current/index.htm', 'w+') { |file| file.write(erb.result(binding)) }
  end


  def createindex(locale)
    things = CreateIndex.new
    things.getdirs(locale)
    things.convert_erb_html_file
  end


end



 # stuff =  CreateIndex.new
 # stuff.getdirs
  #stuff.convert_erb_html_file