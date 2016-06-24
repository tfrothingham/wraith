require_relative '../../lib/yottaawraith.rb'
require 'thor'
require 'fileutils'
require 'yottaawraith/archive'
require 'yottaawraith/createYaml'
require 'yottaawraith/modify_hosts'
require 'yottaawraith/create_index'




$baseDir = Dir.pwd
$defaultHistoryList = File.join($baseDir, '/data/gold_copy_data.csv')  #TODO This needs to change dependant on the type of run
$defaultCaptureList = File.join($baseDir, '/data/gold_copy_data_tpu.csv')


class YottaaWraith::CLI < Thor
  include Thor::Actions


  method_option :archive, :type => :boolean, :default => true, :banner => "archive previous run", :aliases => '-a'

  attr_accessor :config_name



  desc 'getallconfig [SITEFILE]', 'get a list of all the sites to be used in this run, takes and optional parameter of csv config file.'

  def getallconfig (sitefile)

    sitelist = []
    CSV.foreach(sitefile) do |row|
      sitelist << row[0]

    end

    sitelist

  end


  desc 'getallbaseurl [SITEFILE]', 'get a list of all the sites index urls, takes and optional parameter of csv config file.'

  def getallbaseurl (sitefile)

    sitelist = []
    CSV.foreach(sitefile) do |row|
      sitelist << row[1]

    end

    sitelist

  end

  desc 'createindex [LOCALE]', 'create top level index for live site comparison galleries'

  def createindex (locale = 'local')
    puts 'Creating top level index.htm......'
    CreateIndex.new.createindex locale

  end

  desc 'runwraith [SITES][TYPE]', 'Run wraith using list of sites and type of run'

  def runwraith (sites, type)

    if caller[0][/`([^']*)'/, 1] == "capturetpu"
      yamlfile = '_tpu.yaml'
    else
      yamlfile = '_historical.yaml'
    end

    sites.each do |site|

      hconfig = '/configs/'+ site + yamlfile

      puts "using config #{hconfig}"
      mpath = File.join(Dir.pwd, hconfig)

      begin

        puts "Starting wraith for #{site} using #{type} mode"
        puts "config file: #{mpath}"
        system "wraith #{type} #{mpath}"


      rescue StandardError => error
        puts "not able to run wraith with #{mpath}"
        puts error.inspect

        next
      end

    end


  end


  desc 'history [SITEFILE]', 'run full history baseline, including archiving of previous run'

  method_option :archive, :type => :boolean, :default => true, :banner => "archive previous run", :aliases => '-a'
  def history (sitefile = $defaultHistoryList)
    sites = getallconfig sitefile
    CreateYaml.new.historyyaml sitefile
    if  options[:archive]
      archive sitefile, 'history'
    end

    puts 'Starting wraith'
    runwraith sites, 'history'

  end

  desc 'tpuhistory [SITEFILE]', 'run tpu history baseline, including archiving of previous run'
  method_option :archive, :type => :boolean, :default => true, :banner => "archive previous run", :aliases => '-a'
  def tpuhistory (sitefile = $defaultHistoryList)
    sites = getallconfig sitefile
    if options[:archive]
      archive sitefile, 'history'
    end
    puts 'Starting wraith'
    runwraith sites, 'history'

  end

  desc 'latest [SITEFILE]', 'run against the history baseline and compare against history'
  method_option :archive, :type => :boolean, :default => true, :banner => "archive previous run", :aliases => '-a'
  def latest (sitefile = $defaultHistoryList)

    sites = getallconfig sitefile
    if options[:archive]
      archive sitefile, 'latest'
    end
    runwraith sites, 'latest'


  end

  desc 'capturetpu [SITEFILE]', 'capture across two sites, such as two tpus'
  method_option :archive, :type => :boolean, :default => true, :banner => "archive previous run", :aliases => '-a'
  def capturetpu (sitefile = $defaultCaptureList)

    puts "starting capture with tpus"
    sites = getallconfig sitefile
    sites.each do |site|
      puts site
    end
    CreateYaml.new.sidebysidetpuyaml sitefile
    if options[:archive]
      archive sitefile, 'latest'
    end
    runwraith sites, 'capture'

  end

  desc 'showsites [SITEFILE]', 'show list of sites for a run, defaults to standard set or reads through provided site list csv'

  def showsites (sitefile = $defaultSitesList)
    puts getallconfig sitefile

  end

  desc 'showbaseurls [SITEFILE]', 'show list of base urls that would be used for a run, defaults to standard set or reads through provided site list csv'

  def showbaseurls (sitefile = $defaultSitesList)
    puts getallbaseurl sitefile

  end

  desc 'archive [SITEFILE] [RUN]', 'Archive the specific last run, either latest or history'

  def archive (sitefile, run)
    puts 'archiving....'
    sites = getallconfig sitefile
    Archive.new.archive sites, run
  end


end