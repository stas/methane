describe Methane do

  it '::VERSION' do
    Methane::VERSION.should.not.be.nil
  end

  it 'should have #config, #debug and #root' do
    Methane.config.should.be.nil
    Methane.debug.should.be.nil
    Methane.root.should.be.nil
  end

  it 'should start app and the server' do
    Methane::Server.stubs(:new)
    Methane::App.expects(:start)

    # It should pass
    
    lambda { Methane.run }.should.not.raise(NoMethodError)

    Methane::Server.unstub(:new)
    Methane::App.unstub(:start)

  end

end
