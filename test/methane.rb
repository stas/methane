describe Methane do

  it '::VERSION' do
    Methane::VERSION.should.not.be.nil
  end

  it 'should have #options and #root' do
    Methane.options.should.be.nil
    Methane.root.should.be.nil
  end

  it 'should should start app and load options' do
    Methane.run
    Methane.options.should.not.be.nil
    Methane.root.should.not.be.nil
  end

end
