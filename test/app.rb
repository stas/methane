describe Methane::App do

  it '#start' do
    Methane::App.respond_to?(:start).should.be.true
  end

  it 'should have attributes' do
    Methane::App.instance_methods.should.include :app
  end

  it 'should start a QT Application' do
    qtapp = Methane::App.new
    app = qtapp.build_app
    app.class.should.equal Qt::Application
  end

end
