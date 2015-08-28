require 'hooks'

require 'chef_gen/flavor_base/copy_helpers'

class Foo
  include Hooks
  include ChefGen::FlavorBase::CopyHelpers

  def initialize
    @temp_path = '/nonexistent'
    @tocopy = [
      %w(foo),
      %w(bar/.),
      %w(baz gzonk)
    ]
  end
end

RSpec.describe ChefGen::FlavorBase do
  it 'should copy the members of the @tocopy array' do
    allow(FileUtils).to receive(:mkpath)
    expect(FileUtils).to receive(:cp_r).with('foo', '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with('bar/.', '/nonexistent')
    expect(FileUtils).to receive(:cp_r).with('baz', '/nonexistent/gzonk')
    f = Foo.new
    f.send(:copy_content)
  end
end
