require 'spec_helper'
describe 'plostest' do

  context 'with defaults for all parameters' do
    it { should contain_class('plostest') }
  end
end
