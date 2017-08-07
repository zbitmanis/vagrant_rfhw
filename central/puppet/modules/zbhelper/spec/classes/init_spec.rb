require 'spec_helper'
describe 'zbxhelper' do
  context 'with default values for all parameters' do
    it { should contain_class('zbxhelper') }
  end
end
