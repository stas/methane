describe Methane::Notification do
  
  it 'should respond to show' do
    Methane::Notification.respond_to?(:show).should.be.true
  end

  it 'should have class methods' do
    Methane::Notification.instance_methods.should.include :libnotify
  end

  it 'should work as a singleton' do
    instance = Methane::Notification.instance_variable_get('@instance')
    instance.class.should.equal NilClass

    Methane::Notification.show 'Title', 'Body'
    
    instance = Methane::Notification.instance_variable_get('@instance')
    instance.class.should.equal Methane::Notification
  end

end
