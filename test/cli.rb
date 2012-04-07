describe 'CLI binary' do

  @file = File.expand_path('bin/methane')

  it 'should exist' do
    File.exists?(@file).should.be.true
  end

  it 'should be executable' do
    File.executable?(@file).should.be.true
  end
end
