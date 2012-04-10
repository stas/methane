describe Methane::Proxy do
  
  def get_config
    if File.exists? "#{ENV['HOME']}/.methane/config"
      Methane.config = Methane::Config.new
    end
  end
  
  it 'should not start without a config' do
    Methane::Proxy.should.respond_to 'start'
    should.raise(NoMethodError) {
      Methane::Proxy.start
    }
  end

  if get_config
    it '#methods' do
      proxy = Methane::Proxy.new

      proxy.should.not.be.nil

      proxy.should.respond_to :listen
      %w(account rooms campfire).each do |m|
        proxy.send(m).should.not.be.nil
      end

    end
  end

end
