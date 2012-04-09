describe Methane do

  it '::VERSION' do
    Methane::VERSION.should.not.be.nil
  end

  it 'should have #config, #debug and #root' do
    Methane.config.should.be.nil
    Methane.debug.should.be.nil
    Methane.root.should.be.nil
  end

end
