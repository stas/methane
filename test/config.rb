describe Methane::Config do

  config_name = File.expand_path 'test_config_file'

  example_config = <<-EOS
campfire:
  account: suscovs
  token: 1a2b3c
EOS

  invalid_config = <<-EOS
campfire:
  account: suscovs
EOS

  bad_config = "wut"

  before do
    @config_file = File.new(config_name, 'w+')
  end

  after do
    File.delete(config_name)
  end

  %w(account token raw location messages).each do |method|
    it "#{method}" do
      Methane::Config.instance_methods.should.include method.to_sym
    end
  end

  it 'should not load config file' do
    config = Methane::Config.new File.expand_path "/tmp/#{config_name}"
    config.should.not.be.nil
    config.account.should.be.nil
    config.token.should.be.nil
    config.messages.size.should.equal 1
  end

  it 'should parse config file' do
    @config_file.puts example_config
    @config_file.close
    config = Methane::Config.new config_name
    config.should.not.be.nil
    config.account.should.equal 'suscovs'
    config.token.should.equal '1a2b3c'
    config.messages.size.should.equal 1
  end

  it 'should not parse invalid config file' do
    @config_file.puts invalid_config
    @config_file.close
    config = Methane::Config.new config_name
    config.should.not.be.nil
    config.account.should.be.nil
    config.token.should.be.nil
    config.messages.size.should.equal 1
  end

end
