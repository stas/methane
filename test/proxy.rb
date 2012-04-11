describe Methane::Proxy do
  
  def get_config
    if File.exists? "#{ENV['HOME']}/.methane/config"
      Methane.config = Methane::Config.new
    end
  end
  
  it 'should not start without a config' do
    should.raise(NoMethodError) {
      Methane::Proxy.connect
    }
  end

  it '#methods' do
    %w(account rooms campfire listen speak).each do |m|
      Methane::Proxy.should.respond_to m
    end
  end

  if get_config
    it '#attributes' do
      Methane::Proxy.connect
      %w(account rooms campfire).each do |m|
        Methane::Proxy.send(m).should.not.be.nil
      end
    end
  end

end
