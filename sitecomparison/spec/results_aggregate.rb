require 'rspec'
require 'rspec/core'


  tolerance = 0.10
  RSpec.describe 'diffs' do

    mfiles = Dir.glob("UICompare/current/**/*_data.txt")


    mfiles.each {
        |t|
      base = File.dirname(t)
      custname = File.dirname(base)
      #size = File.basename(t).split('_')[0]
      diff = File.foreach(t).first.to_f
      page = t.split('/')[-2]



=begin
      puts "Customer: #{File.basename(custname)}"
      puts "Cust: #{custname}"
      puts "Screen Size: #{size}"
      puts "Percent Diff #{diff}"
      puts "Page: #{page}"
      puts "File parent: #{fname}"
=end
      per = tolerance*100
      it "#{File.basename(custname)} #{page} should be less than or equal to #{per}% difference, result was #{diff}% different" do
        expect(diff).to be <= (per), "#{custname}/gallery.html"
      end

    }
  end
