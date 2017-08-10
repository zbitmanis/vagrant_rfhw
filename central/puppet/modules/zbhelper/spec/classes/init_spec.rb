require 'spec_helper'
describe 'zbhelper' do
  context 'with default values for all parameters' do
    it { should contain_class('zbhelper') }
  end
end
