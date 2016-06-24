require 'rspec'
require_relative '../lib/yottaawraith/createYaml'
require_relative '../lib/yottaawraith/yottaacname'

require 'rspec/core'


RSpec.describe "url checks" do

  it 'should be a valid url' do
    test = CreateYaml.new.parseurlstring("http://www.toast.com")
    expect(test).to eq true
  end

  it 'should be valid https url' do
    test = CreateYaml.new.parseurlstring("https://www.bread.com")
    expect(test).to eq true
  end

  it 'should not be a valid url' do
    test = CreateYaml.new.parseurlstring("butter")
    expect(test).to eq  false
  end

  it 'should match with no www in url' do
    test= CreateYaml.new.parseurlstring("http://diettoast.gov")
    expect(test).to eq true
  end

  it 'should replace host info in url' do
    test = CreateYaml.new.replacebaseurl("http://www.items.com", "123.0.0.23")
    expect(test).not_to eq "http://www.items.com"
  end

  it 'should replace host info in url with extended url' do
    test = CreateYaml.new.replacebaseurl("http://www.items.com/index.html", "123.0.0.23")
    expect(test).not_to eq "http://www.items.com/index.html"
  end

end

RSpec.describe "dig it" do
  it 'should return something' do
    test = YottaaCName.new.getdig("www.moosejaw.com")
    expect(test).to be_truthy
  end
end