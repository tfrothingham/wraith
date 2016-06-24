require 'yaml'
require 'csv'
require 'uri'
require 'pp'
require_relative 'yottaacname'

# start iterating over csv rows, first column is always customer name, second column is always the index for the site, all other columns are sub-pages to visit
# may need to enforce the need to strip the site index from the sub-pages as wraith does the concat.
class CreateYaml


  def historyyaml (sitefile = File.join(Dir.pwd, '/data/gold_copy_data.csv'))


    CSV.foreach(sitefile) do |row|

      $yaml_template = YAML.load_file(File.join(Dir.pwd, '/configs/template/historical_config.yaml'))

      cust = row[0]
      domain = row[1]

      msize = (row.size) -2

      $yaml_template['domains'][row[0]]= $yaml_template['domains']['customer'] = domain
      $yaml_template['domains'].delete('customer')

      $yaml_template['directory'] = File.join(Dir.pwd, '/UICompare/current/' + cust)
      $yaml_template['history_dir'] = File.join(Dir.pwd, '/UICompare/history/' + cust)
      $yaml_template['snap_file'] = File.join(Dir.pwd, '/javascript/snap.js')

      while msize > 0 do

        $yaml_template['paths']['childpage' + msize.to_s]= row[msize +1]
        msize -= 1
      end

      File.open(File.join(Dir.pwd, '/configs/'+ row[0] + '_historical.yaml'), 'w') { |f| YAML.dump($yaml_template, f) }

    end
  end

  # first column is always customer name, second is tpu1 ip, third is tpu2 ip, fourth is baseurl for site(home page) all other columns are sub pages to visit
  def sidebysidetpuyaml (sitefile = File.join(Dir.pwd, '/data/gold_copy_data_tpu.csv'))

    #puts sitefile
    CSV.foreach(sitefile) do |row|
      $yaml_template = YAML.load_file(File.join(Dir.pwd, '/configs/template/compare_config_tpu.yaml'))

      #mapping out required values that need to be inserted to the yaml file, purely a convenience
      cust = row[0]
      tpu1 = row[1]
      tpu2 = row[2]
      url = row[3]

      #counter for where child page values start
      msize = (row.size) -4

      #build out required values for yaml file
      $yaml_template['domains'][cust]= $yaml_template['domains']['tpu1'] = "http://#{tpu1}"
      $yaml_template['domains'][cust]= $yaml_template['domains']['tpu2'] = "http://#{tpu2}"
      $yaml_template['domains'].delete(cust)

      $yaml_template['directory'] = File.join(Dir.pwd, '/UICompare/current/' + cust)
      $yaml_template['snap_file'] = File.join(Dir.pwd, '/configs/' + cust + '_phantom.js')



      #build out child pages for the yaml file
      while msize > 0 do

        #setup to get the correct path
        i = msize + 3

        #build out child keys and values to merge into yaml hash
        chp = {"childpage_#{cust}#{msize}" => row[i]}

        #merge child pages into the yaml hash
        $yaml_template['paths'].merge!(chp)

        msize -= 1
      end

      #parse out host name, strip out rest of the url
      uri = URI.parse(url)

      #need to check the fourth column on for http(s) lead in, column after the last is a child page
      cname = YottaaCName.new.getdig(uri.host)
      createsnapjs(cust,cname)
      File.open(File.join(Dir.pwd, '/configs/'+ cust + '_tpu.yaml'), 'w') { |f| YAML.dump($yaml_template, f) }
    end

  end

  def createsnapjs (custName, cname)

    file_name =  File.join(Dir.pwd, '/configs/template/phantom.tmpl')

    text = File.read(file_name)
    new_contents = text.gsub("yottaaID:", "ycname: '#{cname}'")

    File.open(File.join(Dir.pwd, "/configs/#{custName}_phantom.js"), "w") {|file| file.puts new_contents }

  end

  def parseurlstring (url)

    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  return uri

  end

  def replacebaseurl (url, tpuip)

    uri = URI.parse(url)
    puts "pre change: #{uri}"
    uri.host = tpuip
    puts "post change: #{uri}"

  end


  #This is for casperjs work (WIP)
  def createheaderjs (custName, cname)

    file_name =  File.join(Dir.pwd, '/configs/template/headers.tmpl')

    text = File.read(file_name)
    new_contents = text.gsub("cname", "#{cname}")

    #puts new_contents

    File.open(File.join(Dir.pwd, "/configs/#{custName}_headers.js"), "w") {|file| file.puts new_contents }

  end

end


