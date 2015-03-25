require 'spec_helper'

common_facts = {
  :concat_basedir => '/tmp',
  :memorysize => '2 GB',
  :processorcount => '2',
}

supported_os = [
  {
    :kernel => 'Linux',
    :osfamily => 'RedHat',
    :operatingsystem => 'redhat',
    :operatingsystemrelease => '7.0',
  }
]

describe '::user_group', :type => :define do
  let :default_resource_title do 'rspec_user' end
  let :default_params do {} end
  supported_os.each do |os|
    let :facts do os.merge(common_facts) end
    let :title do default_resource_title end
    describe "::user_group define with no parameters on #{os[:operatingsystem]} #{os[:operatingsystemrelease]}" do
      let :params do default_params end

      it { should compile.with_all_deps }
      it { should contain_class('user_group::params') }
      it { should contain_user_group(default_resource_title) }
      it { should contain_user(default_resource_title) }
      it { should contain_group(default_resource_title) }
    end
  end
end
