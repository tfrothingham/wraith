require 'rspec'
require_relative '../lib/yottaawraith/createYaml'

describe 'Side By Side' do

  it 'should write a new yaml template for tpus' do

    CreateYaml.new.createheaderjs("testheader", "testcname_1234_foo_bar")
    File.exist?(File.join(Dir.pwd, '/configs/testheader_headers.js'))

  end

  it 'should write out the yaml template for tpu side by side' do
    CreateYaml.new.sidebysidetpuyaml
    File.exist?(File.join(Dir.pwd, '/configs/ebags_tpu.yaml'))
  end
end


describe 'testing dirs to objects' do

  xit 'should give me the top level directory names' do
    your_dir = File.join(Dir.pwd, '/UICompare/')
    toplvl = Dir.entries(your_dir).select { |entry| File.directory? File.join(your_dir, entry) and !(entry =='.' || entry == '..') }


    toplvl.each do |f|

      if f == "current"

        custlvl = Dir.entries(File.join(your_dir, f)).select { |entry| File.directory? File.join(File.join(your_dir, f), entry) and !(entry =='.' || entry == '..') }


        custlvl.each do |m|

          if  File.exist? gallery == (File.join(File.join(your_dir, File.join(f, m)), "gallery.html"))


            puts "#{m.capitalize} \t \t Gallery: #{gallery}"

          end


        end

      end

    end
  end
end