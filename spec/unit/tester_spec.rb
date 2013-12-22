require 'spec_helper'

describe 'line_test::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge 'line_test::default' }

  it 'creates dangerfile' do
    expect(chef_run).to create_cookbook_file('/tmp/dangerfile').with(
      :user => 'root',
      :mode => '00644'
      )
  end

  it 'creates if missing dangerfile2' do
    expect(chef_run).to create_cookbook_file_if_missing('/tmp/dangerfile2').with(
      :user => 'root',
      :mode => '00666'
      )
  end

  it 'creates serial.conf' do
    expect(chef_run).to create_cookbook_file('/tmp/serial.conf').with(
      :user => 'root',
      :mode => '00644'
      )
  end
  
end
